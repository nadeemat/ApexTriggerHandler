/**********************************IMPORTANT**************************************
* Class: ContactTriggerHandler 
* Created by : Jason Lima
----------------------------------------------------------------------------------
* Purpose/Methods: Central trigger logic for the Contact object in the system.
----------------------------------------------------------------------------------
* Utility Test Data: Test_trgContact
----------------------------------------------------------------------------------
* Version History: (All changes and TA reworks should be entered as new row )

* VERSION    DEVELOPER NAME    DATE            DETAIL FEATURES
    1.0      JASON LIMA     21/10/2014      INITIAL DEVELOPMENT
*********************************************************************************/

Public with sharing class ContactTriggerHandler extends TriggerHandler{ // class_begin

  public static boolean isMultipleRun = false ;
  public ContactTriggerHandler() {
    // Recurssion stop : run once
    this.setMaxLoopCount(2);
  }

/****************************************************
   Trigger context for all BEFORE events 
****************************************************/
  
  protected override void beforeInsert() {
    // All code logic for BEFORE INSERT Trigger context for trgLease should go here.
    setDelayedFlag((List<Contact>) Trigger.new);


  }
  
  protected override void beforeUpdate() {
    // All code logic for BEFORE UPDATE Trigger context for trgLease should go here. 
    setDelayedFlag((List<Contact>) Trigger.new);
    
  }  

  /*
  protected override void beforeDelete() {
     // All code logic for BEFORE DELETE Trigger context for trgLease should go here.        
  }
  */

/****************************************************
   Trigger context for all AFTER events 
****************************************************/

  protected override void afterInsert() {

    // All code logic for AFTER INSERT Trigger context for trgLease should go here.
    updContactOwner((List<Contact>) Trigger.new, (Map<Id,Contact>) Trigger.oldMap);  
    syncData( (List<Contact>) Trigger.new , (Map<Id,Contact>) Trigger.oldMap );

  }

  protected override void afterUpdate() {
    
    // All code logic for AFTER INSERT Trigger context for trgLease should go here.
    this.setMaxLoopCount(1);

    if( isMultipleRun == false ){
      updContactOwner((List<Contact>) Trigger.new, (Map<Id,Contact>) Trigger.oldMap); 
      updRelatedTransaction((List<Contact>) Trigger.new, (Map<Id,Contact>) Trigger.oldMap);  
      syncData( (List<Contact>) Trigger.new , (Map<Id,Contact>) Trigger.oldMap );    
    

    }
       
  }
  /*
  protected override void afterDelete() {
     // All code logic for AFTER INSERT Trigger context for trgLease should go here.        
  }
  
  protected override void afterUndelete() {
     // All code logic for AFTER INSERT Trigger context for trgLease should go here.        
  }
  */
  
  
/****************************************************
   Method definition used in trigger context 
****************************************************/

  //Setting the Delayed flag to queue the record incase of Time Zone conflict
  private void setDelayedFlag(List<Contact> TrgNew){

    if(betweenBufferZone()){    
      Map<String, RecordType> mapRT = new Map<String, RecordType>();    
      for( RecordType rt : [SELECT DeveloperName, Id from RecordType where sObjectType='Contact']){
          mapRT.put(rt.DeveloperName , rt);
      }

      for( Contact  objCon : TrgNew){
        if( objCon.RecordTypeId == mapRT.get('Client').id ){
          objCon.Delayed__c = true;
          System.debug('========= SETTING DELAYED TRUE' );
        }
      }
    }
  }

  //Between Time Function
  public static boolean betweenBufferZone(){

    List<string> lstTime = new List<string>();
    lstTime =Label.MusoniBufferStartTime.trim().split(':');
    Time startTime = Time.newInstance( Integer.valueOf(lstTime[0]) , Integer.valueOf(lstTime[1]) , 0, 0 );
    
    lstTime = new List<string>();
    lstTime =Label.MusoniBufferEndTime.trim().split(':');
    Time endTime = Time.newInstance( Integer.valueOf(lstTime[0]) , Integer.valueOf(lstTime[1]) , 0, 0 );
    Time currentTime = Datetime.now().time();

    System.debug('========= TIME ZONE CHECK : ' + startTime + ' <= ' + currentTime + ' <= '  + endTime  );
    System.debug('========= TIME ZONE CHECK RETURN : ' + string.valueOf(currentTime >= startTime && currentTime <= endTime ) );

    return (currentTime >= startTime && currentTime <= endTime );
    
  }

  // update Contact(Driver) Client Status field based on lease
  private void updContactOwner(List<Contact> TrgNew, Map<Id,Contact> OldMap){

    List<Id> lstContId = new List<Id>();

    for(contact cont : TrgNew)
    {
      if(cont.Field_Officer__c != null){        
          lstContId.add(cont.id);          
      }    
    }
      
    List<Contact> lstContact = [Select id, ownerId,Musoni_Sync_Status__c,Field_Officer__c,Field_Officer__r.OwnerId from Contact where Id in :lstContId and RecordType.DeveloperName = 'Client'];
    List<Contact> lstUpdater = new List<Contact>();

    for(Contact con : lstContact)
    {
      if( con.ownerId != con.Field_Officer__r.OwnerId ){
        con.ownerId = con.Field_Officer__r.OwnerId;
        lstUpdater.add(con);
      }
      
      if(con.Musoni_Sync_Status__c == 'Sync in progress..'){
        //con.Musoni_Sync_Status__c = 'UPDATED';
      }
      
    }
      
      
    if(!lstUpdater.isEmpty() ){        
      update lstUpdater; 
      isMultipleRun = true ;
    }

  }

  // update Transaction so that the owner of Transaction is same as that of its contact owner
  private void updRelatedTransaction(List<Contact> TrgNew, Map<Id,Contact> OldMap){

      List<Id> lstContId = new List<Id>();
      for(contact cont : TrgNew)
      {
            if(Trigger.isUpdate)
              if(cont.OwnerId== oldMap.get(cont.Id).OwnerId)
               continue;
               
              lstContId.add(cont.id);
              
      }
      
      List<Transaction__c> lstTrans = [Select Id, Name,OwnerId,Driver__r.OwnerId  from Transaction__c where Driver__c in :lstContId];
     
      for(Transaction__c trans : lstTrans)
      {
        trans.OwnerId = trans.Driver__r.OwnerId; 
      }
      
      if(!lstTrans.isEmpty())
        update lstTrans;     
  
  }

  // Method to sync on Insert/Update of Contact to Musoni
  
  private void syncData( List<Contact> TrgNew , Map<Id,Contact> OldMap ){
    
    Set<Id> tranId = new Set<Id>(); 
    Map<String, RecordType> mapRT = new Map<String, RecordType>();    
    for( RecordType rt : [SELECT DeveloperName, Id from RecordType where sObjectType='Contact']){
        mapRT.put(rt.DeveloperName , rt);
    }

    System.debug('====== MAP ' + mapRT);

    if(Trigger.isInsert){
      for( Contact obj : TrgNew ){

        if(obj.Delayed__c == false && mapRT.containsKey('Client') && mapRT.get('Client').Id == obj.RecordTypeId  ){
          tranId.add(obj.Id);
        }        
      }
    }
    else if( Trigger.isUpdate){
      for( Contact obj : TrgNew ){

          // If client name , phone no, status changes update in musoni
          if(obj.Musoni_Field_Officer_Id__c != OldMap.get(obj.Id).Musoni_Field_Officer_Id__c || obj.PayWay_ID_Number__c != OldMap.get(obj.Id).PayWay_ID_Number__c || obj.ID_Number__c != OldMap.get(obj.Id).ID_Number__c || obj.MiddleName != OldMap.get(obj.Id).MiddleName || obj.LastName != OldMap.get(obj.Id).LastName || obj.FirstName != OldMap.get(obj.Id).FirstName || obj.Phone_Number__c != OldMap.get(obj.Id).Phone_Number__c || obj.Client_Status__c != OldMap.get(obj.Id).Client_Status__c ){
            system.debug('======= CONDITION ' + String.valueOf(mapRT.containsKey('Client') && mapRT.get('Client').Id == obj.RecordTypeId ) );
            System.debug('========= CHECK FLAG BEFORE ADDING CONTACT : ' + obj.Delayed__c );
            if( obj.Delayed__c == false && mapRT.containsKey('Client') && mapRT.get('Client').Id == obj.RecordTypeId ){
              tranId.add(obj.Id);
            }
          }
      }      
    }

    if(!tranId.isEmpty() && !Test.isRunningTest()){
      id batjobId = Database.executebatch(new syncClients(tranId), 1 ); 
    }

  }
  

    
} // class_end