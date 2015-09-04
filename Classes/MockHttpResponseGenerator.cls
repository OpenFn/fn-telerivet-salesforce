@isTest
                        
global class MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
       Global static boolean errCount = false ;
    global HTTPResponse respond(HTTPRequest req) {


        HttpResponse res = new HttpResponse();

            
        if(req.getEndpoint() == 'http://api.telerivet.com/success1' )
        {

            // Create a fake response
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{ "id":"SM48369718522c36b40803b73de16fa435", "phone_id":"PNb2e668a97cf384fd69fc6c8115c78429", "contact_id":"CTd8c05859c4cb941200be8bd821a63c59", "direction":"outgoing", "status":"queued", "message_type":"sms", "from_number":"16505551212", "to_number":"16505551212", "content":"Hello World"}');
            res.setStatusCode(200);            
        
        }
        else if(req.getEndpoint() == 'http://api.telerivet.com/success2')
        {

            // Create a fake response
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{ "id":"SM48369718522c36b40803b73de16fa435", "phone_id":"PNb2e668a97cf384fd69fc6c8115c78429", "contact_id":"CTd8c05859c4cb941200be8bd821a63c59", "direction":"outgoing", "status":"queued", "message_type":"sms", "time_created":1328586969, "from_number":"16505551212", "to_number":"16505551212", "content":"Hello World"}');
            res.setStatusCode(200);            
        
        }
        else if(req.getEndpoint() == 'http://api.telerivet.com/fail')
        {

            // Create a fake response
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"foo":"bar"}');
            res.setStatusCode(400);
     
        } 
        else if(req.getEndpoint().contains('https://api.telerivet.com/v1/projects'))
        {
        
            res.setHeader('Content-Type', 'application/json');
            //res.setBody('{ "id":"PN4d246818d0ecd1fa", "name":"Android Phone 1", "phone_number":"+16505550001", "phone_type":"android", "time_created":1390343779, "last_active_time":1390353800, "vars":{  "foo":42 }, "project_id":"PJ2ad0100821a98bea", "battery":95, "charging":false, "app_version":"3.1.17", "android_sdk":17, "mccmnc":"23203", "manufacturer":"LGE", "model":"Nexus 4", "send_limit":900}');
            res.setBodY( '"data":[  {   "id":"PN54ca6d23138a5bb6",   "name":"9867962927",   "phone_number":"9867962927",   "phone_type":"android",   "time_created":1399450098,   "last_active_time":1403592340,   "vars":{   },   "project_id":"PJ731a879b5e2d5ba6",   "battery":50,   "charging":false,   "app_version":"3.7.18",   "android_sdk":19,   "mccmnc":"40492",   "manufacturer":"LGE",   "model":"Nexus 4",   "send_limit":60  } ], "page_size":50, "sort_dir":"asc", "truncated":false, "next_marker":null, "resources":[]}');
            res.setStatusCode(200);  

        }  
        else if(req.getEndpoint().contains('/ApexTrigger') )
        {
            
             res.setHeader('Content-Type', 'application/json');
             res.setBodY( '{"id":"01qi0000000P1GLAA0","success":true,"errors":[]}');
             res.setStatusCode(200);  
    
        }           
        else
        {
            if(errCount == false ){
                // Create a fake response
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{ "id":"SM48369718522c36b40803b73de16fa435", "phone_id":"PNb2e668a97cf384fd69fc6c8115c78429", "contact_id":"CTd8c05859c4cb941200be8bd821a63c59", "direction":"outgoing", "status":"queued", "message_type":"sms", "from_number":"16505551212", "to_number":"16505551212", "content":"Hello World"}');
                res.setStatusCode(200); 
            }   
            else{
                res.setHeader('Content-Type', 'application/json');                
                res.setBody('{ "id":"SM48369718522c36b40803b73de16fa435", "phone_id":"PNb2e668a97cf384fd69fc6c8115c78429", "contact_id":"CTd8c05859c4cb941200be8bd821a63c59", "direction":"outgoing", "status":"queued", "message_type":"sms", "from_number":"16505551212", "to_number":"16505551212", "content":"Hello World"}');
                res.setStatusCode(200);              
            }     
        
        }
         
        return res;
    }
    
    global static HTTPResponse mockRespond(HTTPRequest req){
    
        HttpResponse res = new HttpResponse();
        
            if(errCount == false ){
                // Create a fake response
                res.setHeader('Content-Type', 'application/json');                
                res.setBody('{ "id":"SM48369718522c36b40803b73de16fa435", "phone_id":"PNb2e668a97cf384fd69fc6c8115c78429", "contact_id":"CTd8c05859c4cb941200be8bd821a63c59", "direction":"outgoing", "status":"queued", "message_type":"sms", "from_number":"16505551212", "to_number":"16505551212", "content":"Hello World"}');
                res.setStatusCode(200); 
            } 
            else if(req.getEndpoint().contains('/ApexTrigger'))
            {
            
                res.setHeader('Content-Type', 'application/json');
                res.setBodY( '{"id":"01qi0000000P1GLAA0","success":true,"errors":[]}');
                res.setStatusCode(200);  
    
            }    
            else{
                res.setHeader('Content-Type', 'application/json');                
                res.setBody('{ "id":"SM48369718522c36b40803b73de16fa435", "phone_id":"PNb2e668a97cf384fd69fc6c8115c78429", "contact_id":"CTd8c05859c4cb941200be8bd821a63c59", "direction":"outgoing", "status":"queued", "message_type":"sms", "from_number":"16505551212", "to_number":"16505551212", "content":"Hello World"}');
                res.setStatusCode(200);              
            }     
            
         return res;
    }
    
    global HTTPResponse respondOutBound(HTTPRequest req){
    
                HttpResponse res = new HttpResponse();
                
            // Create a fake response
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{ "id":"SM48369718522c36b40803b73de16fa435", "phone_id":"PNb2e668a97cf384fd69fc6c8115c78429", "contact_id":"CTd8c05859c4cb941200be8bd821a63c59", "direction":"outgoing", "status":"queued", "message_type":"sms", "time_created":1328586969, "from_number":"16505551212", "to_number":"16505551212", "content":"Hello World"}');
            res.setStatusCode(200);         
            return res;    
        
    }
    
    global HTTPResponse respondTrgCreate(HTTPRequest req){
        {
             HttpResponse res = new HttpResponse();
             res.setHeader('Content-Type', 'application/json');
             res.setBodY( '{"id":"01qi0000000P1GLAA0","success":true,"errors":[]}');
             res.setStatusCode(200);  
             return res;
    
        }   
    }
}