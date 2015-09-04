global class telerivetSmsSending{

     @future (callout=true)
   public static void sendResponse(String pNo , String textM , String urlPost , String apiKey , String phoneId , string statusUrl ,string outBoundObjName, string smsIdVal ){
   
         System.debug('==============FUTURE METHOD : BEGIN');                    
         HttpRequest req = new HttpRequest();
         req.setEndpoint(urlPost);
         req.setTimeout(1000) ;
         req.setMethod('POST');
         req.setHeader('Content-Type','application/x-www-form-urlencoded') ;
         //req.setCompressed(true); 
         
         Blob headerValue = Blob.valueOf(apiKey);
         String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
         req.setHeader('Authorization', authorizationHeader);

         if(phoneId != null && pNo != null){
             req.setBody('phone_id=' + EncodingUtil.urlEncode(phoneId , 'UTF-8') + 
                         '&to_number=' + EncodingUtil.urlEncode(pNo, 'UTF-8') +
                         '&content=' + EncodingUtil.urlEncode(textM, 'UTF-8') +
                         '&status_url=' +  EncodingUtil.urlEncode(statusUrl , 'UTF-8') );
          }           
         

         Http http = new Http();
         
         try{
             
            system.Debug('+++++++++++++ Sending Request +++++++++++++');
            HTTPResponse resp;
            
            if(!Test.isRunningTest())
            {
                 resp = http.send(req);
            }
            else
            {    MockHttpResponseGenerator tmpResp = new MockHttpResponseGenerator();
                 resp  = tmpResp.respond(req);
            }
            
            System.debug(resp.getBody());
            
                                    //Inserting Report
                        if(String.valueof(resp.getStatusCode()) == '200' )
                        {
                            Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(resp.getbody()); 
                            DateTime finaldate ;
                            
                            if(String.valueof(m.get('time_created')) == null || String.valueof(m.get('time_created'))== ''){                    
                                finalDate = datetime.now();
                            }
                            else{
                                Integer unixTime = Integer.valueOf(m.get('time_created')) ;
                                DateTime dateInstance = datetime.newInstanceGmt(1970, 1, 1, 0, 0, 0);
                                finalDate = dateInstance.addSeconds(unixTime);                
                            }
                            
                                       
                            Telerivet_Tracking__c temp =  new Telerivet_Tracking__c( Name = String.valueof(m.get('id')), 
                                 Phone_ID__c = String.valueof(m.get('phone_id')),
                                 Contact_ID__c  = String.valueof(m.get('contact_id')),
                                 Direction__c = String.valueof(m.get('direction')),
                                 Status__c = String.valueof(m.get('status'))  ,
                                 Message_Type__c = String.valueof(m.get('message_type')),
                                 Time_Created__c = finaldate,
                                 From_Number__c = String.valueof(m.get('from_number')),
                                 To_Number__c = String.valueof(m.get('to_number')) ,
                                 Content__c = String.valueof(m.get('content')),
                                 Object_Name__c = outBoundObjName ,
                                 Sms_Id__c = smsIdVal);
                          
                          insert temp;      
                        } 
            
            
            //Return resp; 
         }
         catch(Exception ex){
                 system.debug(ex);
                 Telerivet_Tracking__c temp =  new Telerivet_Tracking__c( 
                                 Phone_ID__c = phoneId ,
                                 Direction__c = 'Outgoing',
                                 Status__c = 'Susyem',
                                 Message_Type__c = 'sms',
                                 Time_Created__c = Datetime.now(),
                                 From_Number__c = phoneId ,
                                 To_Number__c = pNo ,
                                 Content__c = textM ,
                                 Object_Name__c = outBoundObjName ,
                                 Sms_Id__c = smsIdVal,
                                 Error_message__c = String.Valueof(ex));
                          
                          insert temp;      
                 //return null;
         }
      
   }

}