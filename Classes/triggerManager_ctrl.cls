public class triggerManager_ctrl {
    
    Public List<TriggerHandler__c> lstTriggers {get;set;}
    Public Boolean notificationDisp {get;set;}
    
    public triggerManager_ctrl() {        
        lstTriggers = pullAllSettings();
        notificationDisp = false;
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
        notificationDisp = true; 
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
    
            notificationDisp = false;
            system.debug('###--intIndex--Call--');
            integer intIndex = integer.ValueOf(ApexPages.CurrentPage().GetParameters().Get('indexDelete'));
            system.debug('###--intIndex--'+intIndex + ' : list size : ' + lstTriggers .size());
            

        try{                
            if(intIndex != null) {                
                                
                if(lstTriggers[intIndex].Name != null && TriggerHandler__c.getValues(lstTriggers[intIndex].Name) != null){
                    delete lstTriggers[intIndex];
                }                
                lstTriggers.remove(intIndex);
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Setting deleted successfully!') );  
                notificationDisp = true;      
            }else{
                system.debug('###--intIndex--is null : '+intIndex);
            }
            return null;
        }
        catch(Exception ex){
             ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR,'Oops! We encountered an error, the administrator has been notified. Description : ' + ex) );
             notificationDisp = true;
             lstTriggers.remove(intIndex);
             return null ; 
         }
    
    }

    
    // Pull all the Custom settings records and return a list
    public List<TriggerHandler__c> pullAllSettings(){    
        return TriggerHandler__c.getAll().values();        
    }
    
}