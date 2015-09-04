@RestResource(urlMapping='/inboundsms')
global class telerivetInboundSmsController {        
     
    @HttpPost
    global static void getSms() {
      
     system.debug('==================BEGIN REST CALL.');
     
     RestRequest req = RestContext.request;
     RestResponse res = RestContext.response;
     res.addHeader('Content-Type', 'application/json'); 
     String jsonResponse = '';
     String getId = String.valueof(req.params.get('id'));
     String mode ;
     Account_Settings__c accountSet ;
     
     if( req.params.get('event') != null || req.params.get('event') != '' ){
         mode = req.params.get('event');
     }
          
     system.debug( '=================='+'Event : ' + req.params.get('event') + ' Id : ' + getId);
     

     if( mode == 'incoming_message' ){
     
     try{  
            accountSet = [ Select Name , Active__c , API_key__c , Phone_type__c  , Secret_key__c , 
            Project_Id__c ,  Phone_Route_Id__c ,Inbound_Record_Type__c,Is_Inbound_Record_Typed__c,Inbound_Object_Name__c  ,
            Inbound_Number_Field__c ,Inbound_Out_Number_Field__c , Inbound_Time_Field__c ,
            Inbound_Msg_Text_Field__c  , Outbound_Out_Number_Field__c,Outbound_Object_Name__c ,Outbound_Number_Field__c  ,
            Outbound_Time_Field__c , Outbound_Msg_Text_Field__c 
            from Account_Settings__c where Active__c = true and Id = :getId  LIMIT 1];
        }
        catch (Exception ex){
        
            accountSet = null;
            /*
            res.statusCode = 500;
            jsonResponse = '{"response": {"status": "Failure", "message": "' + ex + '==='+ getId + '"}}';
            res.responseBody = blob.valueOf(jsonResponse);
            return;
            */
        }
     
     }

           
     if(accountSet != null && mode == 'incoming_message' ){
     
        system.debug('==================INSERTING INBOUND SMS : START. || ID : ' + accountSet.Id);
        

        String smsEvent = req.params.get('Event');
        String smsType = req.params.get('message_type');
        String smsFrmNo = req.params.get('from_number');
        String smsToNo = req.params.get('to_number');
        String smsTime = req.params.get('time_created');                                
        String smsContent = req.params.get('content');      
        String smsSecret = req.params.get('secret');  
        String secretKey = accountSet.Secret_key__c ;     
        Datetime finalDate ;    
        Map<string , string> mapRecordTypeId  = new Map<String , String>();
        
        if(accountSet.Is_Inbound_Record_Typed__c == true){
            
            for(recordType rt : [Select Id , DeveloperName , Name from RecordType where sObjectType = :accountSet.Inbound_Object_Name__c  ]){
                mapRecordTypeId.put(rt.Id , rt.DeveloperName);
            }
            
        }
 
        // CHECK FOR REQUIRED PARAMETERS ELSE RETURN STATUS 400
        /*if( smsFrmNo  == null || smsFrmNo  == '' || smsSecret == null|| smsSecret == '') {
            res.statusCode = 400;
            jsonResponse = '{"response": {"status": "Failure", "message": "MissingRequiredQueryParameter : From Number or Secret Key"}}';
            res.responseBody = blob.valueOf(jsonResponse);
            system.debug('==================PARAMETERS ERROR : 400.');            
            return;
        }
        */
 
        // CHECK IF SMS TYPE AND SECRET KET MATCH ELSE RETURN 
         if(  smsSecret == secretKey ) { //smsEvent== 'incoming_message' &&
        
        system.debug('==================KEY MATCH.');        

            try { 
            
            if(smsTime == null || smsTime == ''){
                smsTime = string.valueOf(datetime.now());
                finalDate = datetime.now();
            }
            else{
                Integer unixTime = Integer.valueOf(smsTime) ;
                DateTime dateInstance = datetime.newInstanceGmt(1970, 1, 1, 0, 0, 0);
                finalDate = dateInstance.addSeconds(unixTime);
                
            }
            
            
            sObject newSms = Schema.getGlobalDescribe().get(accountSet.Inbound_Object_Name__c ).newSObject(); 
            newSms.put(accountSet.Inbound_Number_Field__c , smsToNo  );
            newSms.put(accountSet.Inbound_Time_Field__c , finalDate );
            newSms.put(accountSet.Inbound_Msg_Text_Field__c  , smsContent);
            newSms.put(accountSet.Inbound_Out_Number_Field__c, smsFrmNo);
            
            if(accountSet.Is_Inbound_Record_Typed__c == true && mapRecordTypeId.containsKey(accountSet.Inbound_Record_Type__c)){
                newSms.put('RecordTypeId' , accountSet.Inbound_Record_Type__c);
            }    

            //SMS__c newSms = new SMS__c( Date_Sent__c = finalDate , Message_Text__c = smsContent, Recipient__c = smsFrmNo );
                                        
            insert newSms;
            system.debug('==================INSERTING INBOUND SMS : DONE.');
            res.statusCode = 200;
            jsonResponse = '{"response": {"status": "Success", "message": "SMS Inserted, Hurray !"}}';
            res.responseBody = blob.valueOf(jsonResponse);
            return;
                
            } catch ( Exception ex ) {
                res.statusCode = 500;jsonResponse = '{"response": {"status": "Failure", "message": "' + ex + '"}}';
                res.responseBody = blob.valueOf(jsonResponse);
                system.debug('==================ERROR : ' + ex);return;
            }

        }
        else{
            res.statusCode = 401;
            jsonResponse = '{"response": {"status": "Failed", "message": "Unauthorized request, Check key."}}';
            res.responseBody = blob.valueOf(jsonResponse);
            system.debug('==================SECRET KEY MISS-MATCH.');
            return;
            
        }
     }
     else if( mode == 'send_status' ){    
          
             system.debug('==================UPDATING SEND SMS STATUS : START.');
      try{
             
             List<Telerivet_Tracking__c> rpt = [Select Id,Error_message__c,Status__c,Time_sent__c,Project_id__c ,SMS_ID__c from Telerivet_Tracking__c     
                 where Name = :getId Limit 1];
                 
                 datetime finalDate ;
                                         
             if(String.valueof(req.params.get('time_sent')) == null || String.valueof(req.params.get('time_sent'))== ''){                    
                finalDate = null;
             }
             else{
                Integer unixTime = Integer.valueOf(req.params.get('time_sent')) ;
                DateTime dateInstance = datetime.newInstanceGmt(1970, 1, 1, 0, 0, 0);
                finalDate = dateInstance.addSeconds(unixTime);                
             }
       
             if(!rpt.isempty()){
                 rpt[0].Status__c = req.params.get('status');
                 rpt[0].Error_message__c = req.params.get('error_message');
                 rpt[0].Time_sent__c = finalDate ;
                 rpt[0].Project_id__c = req.params.get('project_id');                                  
                 update rpt ; 
                 system.debug('==================UPDATING SEND SMS STATUS : DONE.');
             }
             
      }
      catch(exception ex){
                res.statusCode = 500;
                jsonResponse = '{"response": {"status": "Failure", "message": "' + ex +' ID VALUE : '+getId  + '"}}';
                res.responseBody = blob.valueOf(jsonResponse);return;
      }
            

           
     }
     else if(accountSet == null && mode == 'incoming_message' ){
            res.statusCode = 400;
            jsonResponse = '{"response": {"status": "No settings found.", "message": "Could not find settings for incoming sms."}}';
            res.responseBody = blob.valueOf(jsonResponse);return;
     
     }
     else{
            res.statusCode = 501;
            jsonResponse = '{"response": {"status": "Unknown Request", "message": "Could not identify request type."}}';
            res.responseBody = blob.valueOf(jsonResponse);
            return;
     }
     

     system.debug('==================END REST CALL.');
    }
}