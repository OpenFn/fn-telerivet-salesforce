@isTest
Private Class Flows_Test{

    @isTest
    Private static void doThis(){
        
        Terms_Accepted__c updater = new Terms_Accepted__c();
        updater.Name = userinfo.getUserId();
        updater.Accepted_Terms__c = true ;
        insert updater;
        
        setValidateLogin.setUserTermsAccepted();
        validateLogin.getUserTermsAccepted();
         
        /////////////////
        updater.Accepted_Terms__c = true ;
        update updater;
        
        setValidateLogin.setUserTermsAccepted();
        validateLogin.getUserTermsAccepted();
        
        /////////////////
        Delete updater;
        
        setValidateLogin.setUserTermsAccepted();
        validateLogin.getUserTermsAccepted();
                
        
    }

}