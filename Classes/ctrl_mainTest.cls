public with sharing class ctrl_mainTest {

    triggerHandle tg {get;set;}
    Public String errorStatus {get; set;}
    
    public void run(){
            
            tg = new triggerHandle('Setupsms__c' , 'Test' , 'trigger Test on Setupsms__c(after insert){ List<Id> lstsmsId = new List<Id>(); for(Setupsms__c  trg : Trigger.new){lstsmsId.add(trg.Id);} }' );
            tg.createApexTrigger();
            errorStatus = tg.statusMessage;
           
    }

     public void deleteTrg(){
            
            tg.deleteApexTrigger(tg.oid);
            errorStatus = tg.statusMessage;
    }
    
}