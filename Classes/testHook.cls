@RestResource(urlMapping='/submission')
global class testHook {
   

    @HttpPost
    global static void testHookPost() {
      
    
     system.debug('==================BEGIN REST POST CALL.');
     
     RestRequest req = RestContext.request;
     RestResponse res = RestContext.response;
     res.addHeader('Content-Type', 'text/xml'); 
     res.statusCode = 204;
     String jsonResponse = '{"response": {"status": "Success", "message": Data Received "}}';
     res.responseBody = blob.valueOf(jsonResponse);
        
     Map<String, String> mpHeader = (Map<string, String>)req.headers;
     Map<String, String> mpParams = (Map<String, String>)req.params ;

     System.debug( '=========== DISPLAYING HEADERS');
     for( String key : mpHeader.keyset()){
        System.debug( '=========== HEADER KEY : ' +key+ ' VALUE : '+ mpHeader.get(key));
     }
     
     System.debug( '=========== DISPLAYING PARAMETERS');
     for( String key : mpParams.keyset()){
        System.debug( '=========== PARAMS KEY : ' +key+ ' VALUE : '+ mpParams.get(key));
     }
     
     System.debug( '=========== DISPLAYING BODY');
     system.debug('================== BODY   : ' + req.requestBody.toString() );     
     
     Contact inCon = new Contact();
     inCon.LastName = mpParams.get('Name');
     inCon.Email= mpParams.get('Email');
     inCon.Phone= mpParams.get('Phone');
     //insert inCon;
     
          
     return;
       
    
     system.debug('==================END REST CALL.');
    }


   @HttpGet
    global static void testHookGet() {
      
     system.debug('==================BEGIN REST PEST CALL.');
     
     String formURL = '<forms><form url="http://quanquad-developer-edition.na15.force.com/servlet/servlet.FileDownload?file=015i0000006WkUb">Daily Meeting Attendance</form></forms>';
     RestRequest req = RestContext.request;
     RestResponse res = RestContext.response;
     res.addHeader('Content-Type', 'text/xml'); 
     res.statusCode = 204;
     String jsonResponse = formURL ; //'{"response": {"status": "Success", "message": Data Received "}}';
     res.responseBody = blob.valueOf(jsonResponse);
        
     Map<String, String> mpHeader = (Map<string, String>)req.headers;
     Map<String, String> mpParams = (Map<String, String>)req.params ;

     System.debug( '=========== DISPLAYING HEADERS');
     for( String key : mpHeader.keyset()){
        System.debug( '=========== HEADER KEY : ' +key+ ' VALUE : '+ mpHeader.get(key));
     }
     
     System.debug( '=========== DISPLAYING PARAMETERS');
     for( String key : mpParams.keyset()){
        System.debug( '=========== PARAMS KEY : ' +key+ ' VALUE : '+ mpParams.get(key));
     }
     
     System.debug( '=========== DISPLAYING BODY');
     system.debug('================== BODY   : ' + req.requestBody.toString() );     
     
     Contact inCon = new Contact();
     inCon.LastName = mpParams.get('Name');
     inCon.Email= mpParams.get('Email');
     inCon.Phone= mpParams.get('Phone');
     //insert inCon;
     
          
     return;
       
    
     system.debug('==================END REST CALL.');
    }




}