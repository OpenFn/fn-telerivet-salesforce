public with sharing class ctrlMobileTest {

    public pageReference redirect(){
        //PageReference pageRef ; 
        //pageRef = new PageReference('/001i000000qBxt2' ); 
        //pageRef.setRedirect(true);
        //return pageRef;
        
        Listing__c  senObject = [Select id , website__c ,  description__c, name from Listing__c limit 1];
        
        if(senObject  != null ){
            postListing objPost = new postListing(senObject );
            postListing.calloutMethod();
        }
        return null ; 
    }
    
}