global class telerivetOutboundSmsController implements Database.Batchable<sObject>, Database.AllowsCallouts{



 
Public Account_Settings__c accountSet = new Account_Settings__c();
public List<Telerivet_Tracking__c> smsTracker = new List<Telerivet_Tracking__c>();

/* = [ Select Name , Active__c , API_key__c , Phone_type__c  , Secret_key__c , Project_Id__c ,  Phone_Route_Id__c ,
            Inbound_Object_Name__c  ,Inbound_Number_Field__c , Inbound_Time_Field__c ,Inbound_Msg_Text_Field__c  ,
            Outbound_Object_Name__c ,Outbound_Number_Field__c  , Outbound_Time_Field__c ,Outbound_Msg_Text_Field__c ,
            Outbound_Record_Type__c ,Is_Outbound_Record_Typed__c
            from Account_Settings__c where Active__c = true LIMIT 1];*/
    
String query {get;set;}

Public String apiKey = accountSet.API_key__c ;
Public String projectId = accountSet.Project_Id__c ;  // 'PJ731a879b5e2d5ba6';
Public String phoneId = accountSet.Phone_Route_Id__c ;
Public String urlPost = 'https://api.telerivet.com/v1/projects/'+projectId+'/messages/outgoing';
public string StatusUrl =  accountSet.Site_URL__c ;

  /*global telerivetOutboundSmsController (String Ids ){
        
        
       query  = query + Ids;
       query = query.substring(0 , query.Length() - 3);
       System.Debug( 'QUERRY TEXT : ' + query);       
   }*/

  global telerivetOutboundSmsController (String Ids ,Account_Settings__c  accountS  ){
       System.Debug('==================BATCH : INITIALIZED.');   
       accountSet = accountS ; 
       apiKey = accountSet.API_key__c ;
       projectId = accountSet.Project_Id__c ;  
       phoneId = accountSet.Phone_Route_Id__c ;
       StatusUrl =  accountSet.Site_URL__c ;
       
       if(StatusUrl.endsWith('/') ){
           StatusUrl = StatusUrl + 'services/apexrest/inboundsms';
       }
       else{
           StatusUrl = StatusUrl + '/services/apexrest/inboundsms';
       }
       system.debug('==================VALUE : STATUS URL : '+ StatusUrl);  
            
       
       urlPost = 'https://api.telerivet.com/v1/projects/'+projectId+'/messages/outgoing';
       
       query = 'Select Id , '+ accountSet.Outbound_Msg_Text_Field__c +' , '+ accountSet.Outbound_Number_Field__c  +' from '+accountSet.Outbound_Object_Name__c + ' where '  ; 
       query  = query + Ids;
       query = query.substring(0 , query.Length() - 3);
       System.Debug( 'QUERRY TEXT : ' + query);       
       
   }

   
   /*global telerivetOutboundSmsController (String Ids , string phoneIdMet){
        
       if(phoneIdMet != null || phoneIdMet != ''){
           phoneId  = phoneIdMet ;
       }
       
       query  = query + Ids;
       query = query.substring(0 , query.Length() - 3);
       System.Debug( 'QUERRY TEXT : ' + query);       
   }*/


   global Database.QueryLocator start(Database.BatchableContext info){  
       system.debug('==================DATABASE QUERY : COMPLETE.');        
       return Database.getQueryLocator(query); 
       
   }     
   
   global void execute(Database.BatchableContext info, List<sObject> smsList){
       
       system.Debug('=========== BATCH :  EXECUTING.');
       for(sObject smsTmp : smsList){ 
                      
                      
         String phoneNo ;
         
         if(smsTmp.get(accountSet.Outbound_Number_Field__c ) != '' && smsTmp.get(accountSet.Outbound_Number_Field__c ) !=Null){
          System.debug('Testing Check:-' + smsTmp.get(accountSet.Outbound_Number_Field__c ));
             If(string.valueof(smsTmp.get(accountSet.Outbound_Number_Field__c )).substring(0,1) == '+'){
                 phoneNo = string.valueof(smsTmp.get(accountSet.Outbound_Number_Field__c ));
             }
             else{
                 phoneNo = '+' + string.valueof(smsTmp.get(accountSet.Outbound_Number_Field__c ));
             }
         }
              
        if(phoneNo != null && phoneId != null){ 
        

            HTTPResponse resp ;
            
             try{ 
                
                  resp = sendResponse(phoneNo , string.valueof(smsTmp.get(accountSet.Outbound_Msg_Text_Field__c )) , urlPost , apiKey , phoneId , StatusUrl  );
                  
                    system.debug('==================DISPLAY RESPONSE : ' + resp); 
                    if(resp.getStatusCode() == 200 && resp != null )
                    {
                        system.debug('==================TRACKER INSERTION : START.');  
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
                        
                                   
                        smsTracker.add( new Telerivet_Tracking__c( Name = String.valueof(m.get('id')), 
                             Phone_ID__c = String.valueof(m.get('phone_id')),
                             Contact_ID__c  = String.valueof(m.get('contact_id')),
                             Direction__c = String.valueof(m.get('direction')),
                             Status__c = String.valueof(m.get('status'))  ,
                             Message_Type__c = String.valueof(m.get('message_type')),
                             Time_Created__c = finaldate,
                             From_Number__c = String.valueof(m.get('from_number')),
                             To_Number__c = String.valueof(m.get('to_number')) ,
                             Content__c = String.valueof(m.get('content')),
                             Object_Name__c = accountSet.Outbound_Object_Name__c ,
                             Sms_Id__c = String.valueof(smsTmp.get('id'))
                         ) );
                    }
                  
             }
             catch (exception ex){
                 system.debug('EXCEPTION :' + ex);
                smsTracker.add ( new Telerivet_Tracking__c( 
                                 Phone_ID__c = phoneId ,
                                 Direction__c = 'Outgoing',
                                 Status__c = 'Susyem',
                                 Message_Type__c = 'sms',
                                 Time_Created__c = datetime.now(),
                                 From_Number__c = phoneId ,
                                 To_Number__c = phoneNo ,
                                 Content__c =  string.valueof(smsTmp.get(accountSet.Outbound_Msg_Text_Field__c )),
                                 Object_Name__c = accountSet.Outbound_Object_Name__c  ,
                                 Sms_Id__c = String.valueof(smsTmp.get('id')),
                                 Error_message__c = String.valueOf(ex)) 
                               );
                            
             }
            //Insert sms report                                    
             
             system.debug('==================TRACKER INSERTION : END.');  
            //End SMS report insert
             system.debug('============== RESPONSE : '+resp);
         }
           
       } 
       insert smsTracker;
       system.debug('==================TRACKER INSERTION : COMPLETED || SIZE : ' + smsTracker.size());  
   }     
   global void finish(Database.BatchableContext info){  
       //insert smsTracker ;            
       //system.debug('==================TRACKER INSERTION :  COMPLETED-FINISH || SIZE : ' + smsTracker.size());  

   } 
   
   
   public HTTPResponse sendResponse(String pNo , String textM , String urlPost , String apiKey , String phoneId , string statusUrl   ){
   
         system.debug('==================SENDING SMS TO TELERIVER : START.');                     
         HttpRequest req = new HttpRequest();
         req.setEndpoint(urlPost);
         req.setTimeout(1000) ;
         req.setMethod('POST');
         req.setHeader('Content-Type','application/x-www-form-urlencoded') ;
         //req.setCompressed(true); 
         
         Blob headerValue = Blob.valueOf(apiKey);
         String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
         req.setHeader('Authorization', authorizationHeader);

         if(phoneId != null && pNo != null)
         req.setBody('phone_id=' + EncodingUtil.urlEncode(phoneId , 'UTF-8') + 
                     '&to_number=' + EncodingUtil.urlEncode(pNo, 'UTF-8') +
                     '&content=' + EncodingUtil.urlEncode(textM, 'UTF-8') +
                     '&status_url=' +  EncodingUtil.urlEncode(statusUrl , 'UTF-8'));
                     
         

         Http http = new Http();
         
         try{
             
            system.Debug('+++++++++++++ Sending Request BATCH+++++++++++++');
            HTTPResponse res ;
            
            if(!Test.isRunningTest())
            {
                 res = http.send(req);
            }
            else
            {    MockHttpResponseGenerator tmpResp = new MockHttpResponseGenerator();
                 res  = tmpResp.respondOutBound(req);
            }
            

            
            
            System.debug('STATUSCODE : '+ res.getStatusCode()+ ' : BODY : '+res.getBody());
            system.debug('==================SENDING SMS TO TELERIVER : END.');    
            
            if(String.valueof(res.getStatusCode()) == '200'){
                system.debug('==================SENDING SUCCESSFULL : STATUS : 200.');                    
            }
            else{
                system.debug('==================SENDING DONE WITH ERROR : STATUS : '+String.valueof(res.getStatusCode()) +'.');                    
            }
            
            Return res; 
         }
         catch(Exception ex){
                 system.debug(ex); 
                 return null ; 
         }
         
       
   }
   
   
}