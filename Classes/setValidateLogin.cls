Global class setValidateLogin {
    
    
    @InvocableMethod(label='Set Accepted' description='Sets the User has accepted the terms and conditions.')    
    global static void setUserTermsAccepted(){
        
    	String strUID = Userinfo.getUserId();
        
        Map<String , Terms_Accepted__c> tmp = new Map<String , Terms_Accepted__c>();
        tmp = pullAllSettings();
        
        if(!tmp.isEmpty() && tmp.containsKey(strUID)){
            Terms_Accepted__c updater = tmp.get(strUID);
            updater.Accepted_Terms__c = true ;
            update updater;
        }
        else{
            Terms_Accepted__c updater = new Terms_Accepted__c();
            updater.Accepted_Terms__c = true ;
            updater.Name = strUID;
            insert updater;
        }              
    }
    
    public static Map<String , Terms_Accepted__c> pullAllSettings(){    
        
        Map<String , Terms_Accepted__c> tmp = new Map<String , Terms_Accepted__c>();
        
        for(Terms_Accepted__c obj :  Terms_Accepted__c.getAll().values()){
            tmp.put(obj.Name , obj);
        }        
        
        return tmp;
    }

}