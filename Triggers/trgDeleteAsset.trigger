trigger trgDeleteAsset on Account_Settings__c ( before delete ) {

    
    for( Account_Settings__c accSet : trigger.old){
        
        if(accSet.T_Asset__c != '' || accSet.T_Asset__c != null ){
            try{
                telerivetTriggerClass.triggerDelete(accSet.T_Asset__c , UserInfo.getSessionId()); 

            }     
            catch (Exception ex){
                System.debug('==========ERROR OCCURRED WHILE T-ASSET DELETION : ' +ex);
            }
              
        }
        if( accSet.C_Asset__c != '' || accSet.C_Asset__c != null ){
            try{
                telerivetTriggerClass.classDelete(accSet.C_Asset__c , UserInfo.getSessionId());
            }
            catch (Exception ex){
                System.debug('==========ERROR OCCURRED WHILE C-ASSET DELETION : ' +ex);
            }            
        }
    
    }
    
}