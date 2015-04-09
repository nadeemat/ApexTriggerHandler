public class triggerManager_ctrl {
    
    Public List<TriggerHandler__c> lstTriggers {get;set;}
    
    public triggerManager_ctrl() {        
        lstTriggers = pullAllSettings();
    }
    
    
    /**
            HELPER METHODS
    **/
    public pagereference addRow(){    
        TriggerHandler__c temp = new TriggerHandler__c();  
        lstTriggers.add( temp );
        return null;    
    }
    
    Public pagereference save(){
        ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Settings saved successfully!') );        
        upsert lstTriggers ;
        return null;
        
    }
    
    public pagereference  cancel(){
        PageReference pageRef ; 
        pageRef = new PageReference('/home'  );  //result.getKeyPrefix());        
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public pagereference deleteRow(){

        try{
            system.debug('###--intIndex--Call--');
            integer intIndex = integer.ValueOf(ApexPages.CurrentPage().GetParameters().Get('indexDelete'));
            system.debug('###--intIndex--'+intIndex + ' : list size : ' + lstTriggers .size());
                
            if(intIndex != null) {                
                delete lstTriggers[intIndex];
                lstTriggers.remove(intIndex);
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Setting deleted successfully!') );        
            }else{
                system.debug('###--intIndex--is null : '+intIndex);
            }
            return null;
        }
        catch(Exception ex){
             ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR,'Oops! We encountered an error, the administrator has been notified. Description : ' + ex) );
             return null ; 
         }
    
    }

    
    // Pull all the Custom settings records and return a list
    public List<TriggerHandler__c> pullAllSettings(){    
        return TriggerHandler__c.getAll().values();        
    }
    
}