@isTest(SeeAllData=false)
private class Test_packageClasses {
   
   @isTest
   private static void Test_packageClasses() {
     Test.StartTest();
     map<string, String> mapRT = new Map<string, string>();
     
     for(RecordType rt : [ Select DeveloperName , Id from RecordType where sObjectType ='Basic_sms_object__c']){
         mapRT.put(rt.DeveloperName , rt.Id);
     }
     
     Account_Settings__c setRec = new Account_Settings__c(Active__c = true , Is_Inbound_Record_Typed__c = true,
     Inbound_Msg_Text_Field__c = 'Sms_Text__c' ,Inbound_Time_Field__c = 'Date_Time__c' , 
     Inbound_Out_Number_Field__c  ='Sender_Number__c' , Inbound_Record_Type__c = mapRT.get('Inbound'),
     Inbound_Number_Field__c = 'Phone_Number__c' , Inbound_Object_Name__c   = 'Basic_sms_object__c' , Secret_key__c='786testing',
     Outbound_Out_Number_Field__c ='Sender_Number__c' ,Outbound_Object_Name__c ='Basic_sms_object__c',
     Outbound_Number_Field__c = 'Phone_Number__c'  ,Outbound_Time_Field__c='Date_Time__c' , 
     Outbound_Msg_Text_Field__c = 'Sms_Text__c' , Is_Outbound_Record_Typed__c = true , Outbound_Record_Type__c = mapRT.get('Outbox'),

     Site_URL__c ='http://salesforce.com/' , Phone_Route_Id__c ='testRouteId', Project_Id__c ='testProjectId', 
     Phone_type__c  ='phone', API_key__c ='testApiKey'  );
     Insert setRec;   
     
     
     Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
     telerivetSmsSending.sendResponse('+9812367890' , 'Test msg', 'http://api.telerivet.com/success1' , '786testing' , 'phoneId' , 'https://api.slaesforce.com' , 'Basic_sms_object' , 'testId');     
     telerivetSmsSending.sendResponse('+9812367890' , 'Test msg', 'http://api.telerivet.com/success2' , '786testing' , 'phoneId' , 'https://api.slaesforce.com' , 'Basic_sms_object' , 'testId');     
          
      
     List<Basic_sms_object__c> smsList = new List<Basic_sms_object__c>();
     
     smsList.add(new Basic_sms_object__c(  Sms_Text__c = 'Test786' , Sender_Number__c='+9812345678', recordTypeID = mapRT.get('Outbound'),
                              Date_Time__c = datetime.now(), Phone_Number__c='+9981234553'  ));

     smsList.add(new Basic_sms_object__c(  Sms_Text__c = 'Test786' , Sender_Number__c='9812345678', recordTypeID = mapRT.get('Outbound'),
                              Date_Time__c = datetime.now(), Phone_Number__c='9981234553'   ));

     smsList.add(new Basic_sms_object__c(  Sms_Text__c = 'Test786' , Sender_Number__c='', recordTypeID = mapRT.get('Outbound'),
                              Date_Time__c = datetime.now(), Phone_Number__c=''   ));
     
     for(integer i = 1 ; i<=6 ; i++){
     
       smsList.add(new Basic_sms_object__c(  Sms_Text__c = 'Test786' , Sender_Number__c='9812345678', recordTypeID = mapRT.get('Outbound'),
                                           Date_Time__c = datetime.now(), Phone_Number__c=''   ));
     }                         

     insert smslist;
     
     String query ='';
     for(Basic_sms_object__c sms :smslist){
         query =  query + 'Id = \'' + sms.Id + '\' or '; 
     }

     Id batchInstanceId = Database.executeBatch(new telerivetOutboundSmsController(query , setRec ), 10);                
     
     //Second batch with error
     MockHttpResponseGenerator.errCount = true ; 
     Id batchInstanceId2 = Database.executeBatch(new telerivetOutboundSmsController(query , setRec ), 10);   
     
  
     
     Telerivet_Tracking__c tracker = new Telerivet_Tracking__c(Name='fffffffffff');
     Insert tracker ;          
     
     
    
     //INCOMING SMS TESTING
     try{
     
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/inboundsms';  
        req.addParameter('id', setRec.Id);
        req.addParameter('event', 'incoming_message');
        req.addParameter('from_number', '');  
        req.addParameter('to_number', '+9022805941');
        req.addParameter('time_created', '1403501126'); 
        req.addParameter('message_type', 'sms');
        req.addParameter('secret', '786testing');


        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        telerivetInboundSmsController.getSms();
       
         
      }         
      catch (Exception ex){
         
      }  
      
      //TIME NULL
           try{
     
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/inboundsms';  
        req.addParameter('id', setRec.Id);
        req.addParameter('event', 'incoming_message');
        req.addParameter('from_number', '');  
        req.addParameter('to_number', '+9022805941');
        req.addParameter('time_created', '1403501126'); 
        req.addParameter('message_type', 'sms');
        req.addParameter('secret', '786testing');


        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        telerivetInboundSmsController.getSms();
       
         
      }         
      catch (Exception ex){
         
      }  
      
      //FROM NOT NULL 
      try{
     
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/inboundsms';  
        req.addParameter('id', setRec.Id);
        req.addParameter('event', 'incoming_message');
        req.addParameter('from_number', '+9867962927');  
        req.addParameter('to_number', '+9022805941');
        req.addParameter('time_created', ''); 
        req.addParameter('message_type', 'sms');
        req.addParameter('secret', '786testing');


        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        telerivetInboundSmsController.getSms();
       
         
      }         
      catch (Exception ex){
         
      }    
      
      //KEY ERROR 
      try{
     
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/inboundsms';  
        req.addParameter('id', setRec.Id);
        req.addParameter('event', 'incoming_message');
        req.addParameter('from_number', '');  
        req.addParameter('to_number', '+9022805941');
        req.addParameter('time_created', '1403501126'); 
        req.addParameter('message_type', 'sms');
        req.addParameter('secret', 'testing786');


        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        telerivetInboundSmsController.getSms();
       
         
      }         
      catch (Exception ex){
         
      }   
     
     //SMS REPORT CHECKS
     try{
     
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/inboundsms';  
        req.addParameter('id', tracker.Name);
        req.addParameter('event', 'send_status');
        req.addParameter('status', 'sent');  
        req.addParameter('project_id', 'dstsrsdf');
        req.addParameter('error_message', 'Success'); 
        req.addParameter('time_sent', '1403501126');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        telerivetInboundSmsController.getSms();
       
         
      }         
      catch (Exception ex){
         
      }

         
      try{         
         
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/inboundsms';  
        req.addParameter('id', tracker.Name);
        req.addParameter('event', 'send_status');
        req.addParameter('status', 'sent');  
        req.addParameter('project_id', 'dstsrsdf');
        req.addParameter('error_message', 'Success'); 
        req.addParameter('time_sent', '');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        telerivetInboundSmsController.getSms();
       
       
      }
      catch (Exception ex){
         
      }

      //ELSE 1
      try{         
         
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/inboundsms';  
        req.addParameter('id', tracker.Name);
        req.addParameter('event', 'incoming_message');
        req.addParameter('status', 'sent');  
        req.addParameter('project_id', 'dstsrsdf');
        req.addParameter('error_message', 'Success'); 
        req.addParameter('time_sent', '1403501126');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        telerivetInboundSmsController.getSms();
       
      }
      catch (Exception ex){
         
      }
      
      //ELSE 2
     try{         
         
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/inboundsms';  
        req.addParameter('id', '786');
        req.addParameter('event', 'checking_status');
        req.addParameter('status', 'sent');  
        req.addParameter('project_id', 'dstsrsdf');
        req.addParameter('error_message', 'Success'); 
        req.addParameter('time_sent', '1403501126');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        telerivetInboundSmsController.getSms();
         
       
      }
      catch (Exception ex){
         
      }
      
     //INCOMING SMS CHECKS
     try{         
         
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/inboundsms';  
        req.addParameter('id', '786');
        req.addParameter('event', 'checking_status');
        req.addParameter('status', 'sent');  
        req.addParameter('project_id', 'dstsrsdf');
        req.addParameter('error_message', 'Success'); 
        req.addParameter('time_sent', '1403501126');

        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        telerivetInboundSmsController.getSms();
         
       
      }
      catch (Exception ex){
         
      }
      delete setRec ;
      Test.StopTest();
      
   }
   
}