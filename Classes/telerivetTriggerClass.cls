Global class telerivetTriggerClass {

    @future(callout= true)
    public static void triggerDelete(string Id , string sessionId){
        
        triggerHandle trg = new triggerHandle();
        trg.deleteApexTrigger( Id , sessionId);
       
    }

    @future(callout= true)
    public static void classDelete(string Id , string sessionId){
    
        triggerHandle trg = new triggerHandle();
        trg.deleteApexClass( Id , sessionId );
    }
}