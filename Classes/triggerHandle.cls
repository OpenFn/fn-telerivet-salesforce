Public class triggerHandle{


            public String endpoint ; // = 'https://na15.salesforce.com/services/data/v29.0/sobjects'; 
            public String oid ;
            public String cid ;
            public String apmid ;
            public String carid ;
            Public String objName ;
            Public String trgName ;
            Public String trgBody ;
            Public String statusMessage;
            Public Boolean error ;
            
            //public static string globalObjectName{get;set;}


            
            public triggerHandle()
            {    
                   endpoint = 'https://' + currentPod() + '.salesforce.com/services/data/v29.0/sobjects';                                                              
            }
            
            
       
            public triggerHandle( String objectName , String NameTrigger, String BodyTrigger )
            {
    

                   endpoint = 'https://' + currentPod() + '.salesforce.com/services/data/v29.0/sobjects';
                   trgBody =  BodyTrigger ;
                   trgName =  NameTrigger;
                   objName =  objectName ;
                   
                System.debug( '{"TableEnumOrId":"'+objName+'","Name":"'+trgName+'","Body":"'+trgBody+'"}');
                                                                    
            }
         
            public triggerHandle( String objectName , String trgname, String trgbody , String URL )
            {

                   endpoint = 'https://' + currentPod() + '.salesforce.com/services/data/v29.0/sobjects';    
                   trgBody =  trgbody ;
                   trgName =  trgname;
                   objName =  objectName ;
                   endpoint = URL ;                   
            
            }         
         
            // used receive response by sending a http request
            private String getResponse(HttpRequest req)
            {
                try
                {
                    Http httpreq = new Http();
                    HttpResponse res ;
                    
                    if(!Test.isRunningTest())
                    {
                         res = httpreq.send(req);
                    }
                    else
                    {    
                        MockHttpResponseGenerator tmpResp = new MockHttpResponseGenerator();
                         res = tmpResp.respondTrgCreate(req);
                    }
                    
                    System.debug('RESPONSE FROM TRIGGER HANDEL : ' + res);
                    
                    String reqresponse = res.getBody();
                    return reqresponse;
                }
                catch (Exception e){return
                'Error:' +e.getMessage();}
            }
         
            // create a http request with required endpoint and request method
            private HttpRequest createHttpRequest(String endpoint, String method)
            {
                HttpRequest req = new HttpRequest();
                endpoint += '';
                req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
                req.setHeader('Content-Type', 'application/json');
                req.setEndpoint(endpoint);
                req.setMethod(method);
                return req;
            }
            
            public HttpRequest createHttpRequest(String endpoint, String method , String sessionId)
            {
                HttpRequest req = new HttpRequest();
                endpoint += '';
                req.setHeader('Authorization', 'Bearer ' + sessionId);
                req.setHeader('Content-Type', 'application/json');
                req.setEndpoint(endpoint);
                req.setMethod(method);
                return req;
            }
            
            
            public Boolean createApexTrigger()
            {
                
                // create a Http request with post method
                HttpRequest req = createHttpRequest(endpoint+'/ApexTrigger','POST'); //changed
                System.debug('============TRIGGER CONTENT : '+ '{"TableEnumOrId":"'+objName+'","Name":"'+trgName+'","Body":"'+trgBody+'"}');
                req.setBody( '{"TableEnumOrId":"'+objName+'","Name":"'+trgName+'","Body":"'+trgBody+'"}');
                // send request and receive response
                
                
                String response ;
                response = getResponse(req);

                
                // These two lines have no role in creating apex class. So they can be ignored for now.
                //Map<String,Object> rmp = (Map<String,Object>)JSON.deserializeuntyped(response);
                //oid = (String)rmp.get('id');
                
                /*statusMessage = '';
                statusMessage = response.replace('"' , '');
                statusMessage = statusMessage.replace('{' , '');
                statusMessage = statusMessage.replace('}', '');
                statusMessage = statusMessage.replace('[' , '');
                statusMessage = statusMessage.replace(']', '');
                
                list<string> statusList = statusMessage.split('\\,');    

                statusMessage = '';

                for (string tmp: statusList){
                    statusMessage = statusMessage + '#' + tmp;
                }*/
                statusMessage = response ;
                system.debug('RESPONSE ON TRIGGER CREATION : ' + response  );
                if(response.contains('success') && response.contains('true') ){
                    Map<String,Object> rmp = (Map<String,Object>)JSON.deserializeuntyped(response);
                    oid = (String)rmp.get('id');
                    error = false;
                }
                else{
                    error = true;
                }
                
                return error;
                
            }
        
            public Boolean deleteApexTrigger(String trgId, String sessionId )
            {
                HttpRequest req = createHttpRequest(endpoint+'/ApexTrigger/'+trgId,'DELETE' , sessionId );
                String responseJson ;// Store the result to do something
                responseJson = getResponse(req); 

                
                system.debug('RESPONSE ON TRIGGER DELETE : ' + responseJson );
                if(responseJson == '' || responseJson == null ){
                    statusMessage = responseJson;
                    error = false;
                }
                else{
                    statusMessage = responseJson;
                    error = true;
                }
                
                //return responseJson;
                return error;
            }
            

            public boolean createApexClass()
            {
                // create a Http request with post method
                HttpRequest req = createHttpRequest(endpoint+'/ApexClass','POST');
                req.setBody( '{"Name":"'+trgName+'","Body":"'+trgBody+'"}');
                // send request and receive response
                String response ;
                response = getResponse(req);

                
                // These two lines have no role in creating apex class. So they can be ignored for now.
                //Map<String,Object> rmp = (Map<String,Object>)JSON.deserializeuntyped(response);
                //oid = (String)rmp.get('id');
                
                statusMessage = response ;
                
                system.debug('RESPONSE ON TRIGGER CREATION : ' + response  );
                
                if(response.contains('success') && response.contains('true') ){
                    Map<String,Object> rmp = (Map<String,Object>)JSON.deserializeuntyped(response);
                    cid = (String)rmp.get('id');
                    error = false;
                }
                else{
                    error = true;
                }
                
                return error;
            }

            public Boolean deleteApexClass(string cid , String sessionId )
            {
                HttpRequest req = createHttpRequest(endpoint+'/ApexClass/'+cid,'DELETE', sessionId );
                String responseJson; // Store the result to do something  
                responseJson = getResponse(req);

                
                
                system.debug('RESPONSE ON CLASS DELETE : ' + responseJson );
                if(responseJson == '' || responseJson == null ){
                    statusMessage = responseJson;
                    error = false;
                }
                else{
                    statusMessage = responseJson;
                    error = true;
                }
                
                //return responseJson;
                return error;          
                
            }
            
                // Method to check for sandbox and production
                public Boolean isSandbox() {
                      String pod = currentPod();
                      if (pod != null && pod.length() > 0 && pod.toUpperCase().startsWith('C')){
                          return true;
                      }
                      return false;
                 }
                
            

    // Finding URL pod
    public String currentPod() { 
    
          String server;           
          if (ApexPages.currentPage() != null){ //called from VF page
                  server = ApexPages.currentPage().getHeaders().get('X-Salesforce-Forwarded-To');
          } else { //called via standard class
                  server = URL.getSalesforceBaseUrl().getHost();
          }
           
          if ( server != null && server.length() > 0){
              server = server.substring(0 ,server.indexOf('.'));
               
          }
          return server ; 
     }
     
     /*
     Public List<String> pullMap(String Pattern,String strSeparator){
           
                     List<String> lstStrreturn = new List<String>(); 
                     string strInputText = Pattern;
                   //  string strInputText = 'Farm__c.Street__c#smagicinteract__Incoming_SMS__c.Status__c';
                     
                     
                     List<String> col = strInputText.split(strSeparator);
                                                
                     for (String tmp : col)
                     {
                         List<string> objClass = tmp.split('\\.');
                         
                         for(String grain : objClass){
                             
                             lstStrreturn.add(grain);
                         }
                     } 
                     
                                         
                     return lstStrreturn;
                   
      }
      */
 


}