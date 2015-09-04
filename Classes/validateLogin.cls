Global class validateLogin {
    
           
    @InvocableMethod(label='Terms Accepted?' description='Returns the if the user has accepted the terms and conditions.')    
    global static List<AcceptedUser> getUserTermsAccepted(){
        
        List<AcceptedUser> returnVal = new List<AcceptedUser>();
        Map<String , Terms_Accepted__c> mpUsrToTerms = new Map<String , Terms_Accepted__c>();
        
        AcceptedUser tmp = new AcceptedUser();
        tmp.OneTimeAccepted = pullAllTerms();
        returnVal.add( tmp ) ;
        return returnVal ;
        
    }
    
    public static Boolean pullAllTerms(){    
        
        Map<String , Terms_Accepted__c> mpRet = new Map<String , Terms_Accepted__c>();
        
        for(Terms_Accepted__c obj : Terms_Accepted__c.getAll().values()){
            mpRet.put(obj.Name , obj);
        }
        
        String strUID = Userinfo.getUserId();                
        
        if(!mpRet.isEmpty() && mpRet.containsKey(strUID) && mpRet.get(strUID).Accepted_Terms__c){
           return true;
        }
        else{
            return false;
        }
                        
    }

    global class AcceptedUser{
        @InvocableVariable
    	public Boolean OneTimeAccepted;

    }

}