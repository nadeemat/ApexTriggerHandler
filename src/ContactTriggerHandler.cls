/**********************************IMPORTANT**************************************
* Class: ContactTriggerHandler 
* Created by : Nadeem Shaikh
----------------------------------------------------------------------------------
* Purpose/Methods: Central trigger logic for the Contact object in the system.
----------------------------------------------------------------------------------
* Utility Test Data: Test_trgContact
----------------------------------------------------------------------------------
* Version History: (All changes and TA reworks should be entered as new row )

* VERSION    DEVELOPER NAME    DATE            DETAIL FEATURES
    1.0      Nadeem Shaikh     21/10/2014      INITIAL DEVELOPMENT
*********************************************************************************/

Public with sharing class ContactTriggerHandler extends TriggerHandler{ // class_begin
  
  public ContactTriggerHandler() {    
  }

/****************************************************
   Trigger context for all BEFORE events 
****************************************************/
  
  protected override void beforeInsert() {
    // All code logic for BEFORE INSERT Trigger context for trgLease should go here.
  }
  
  protected override void beforeUpdate() {
    // All code logic for BEFORE UPDATE Trigger context for trgLease should go here.    
  }  

  protected override void beforeDelete() {
     // All code logic for BEFORE DELETE Trigger context for trgLease should go here.        
  }

/****************************************************
   Trigger context for all AFTER events 
****************************************************/

  protected override void afterInsert() {
    // All code logic for AFTER INSERT Trigger context for trgLease should go here.   
  }

  protected override void afterUpdate() {    
    // All code logic for AFTER INSERT Trigger context for trgLease should go here.  
  }
  
  protected override void afterDelete() {
     // All code logic for AFTER INSERT Trigger context for trgLease should go here.        
  }
  
  protected override void afterUndelete() {
     // All code logic for AFTER INSERT Trigger context for trgLease should go here.        
  }
  
  
  
/****************************************************
   Method definition used in trigger context 
****************************************************/

  
    
} // class_end