public class postListing{

    public static Listing__c objListing {get;set;}
    
    public postListing(Listing__c obj){    
        objListing = obj;    
    }

@future 
Public static void calloutMethod(){

         HttpRequest req = new HttpRequest();
         req.setEndpoint('https://www.openfn.org/listingsapi/');
         req.setTimeout(1000);
         req.setMethod('PUT');
         req.setHeader('Content-Type','application/json') ;
         
  Blob headerValue = Blob.valueOf('demo' + ':' + 'demo123');
         String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
         req.setHeader('Authorization', authorizationHeader);
         
         req.setBody('param1=' + EncodingUtil.urlEncode(objListing.name, 'UTF-8') + 
                         '&param2=' + EncodingUtil.urlEncode(objListing.description__c, 'UTF-8') +
                         '&param3=' + EncodingUtil.urlEncode(objListing.website__c, 'UTF-8') );
           
         
         Http http = new Http();         
             
         system.Debug('+++++++++++++ Sending Request +++++++++++++');
         HTTPResponse resp;
         resp = http.send(req);
         system.Debug('+++++++++++++ Request Sent +++++++++++++ : ' + resp );

}

}