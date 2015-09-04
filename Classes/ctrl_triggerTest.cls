public class ctrl_triggerTest {
    
   public string strParseText {get; set;}
   

    
    public ctrl_triggerTest()
    {
      string strInputText = '*nadeem*shaikh*m*good*excellent#';
      string temp = strInputText.substring( strInputText.indexOf('*') , strInputText.indexOf('*') + 1 );
      
      if(temp.equals('*'))
      {
          strInputText = strInputText.substring( strInputText.indexOf('*'));
      }
      
      temp = strInputText.substring(strInputText.lastIndexOf('#'));
      
      if(temp.equals('#'))
      {
          strInputText = strInputText.substring( 1 , strInputText.lastIndexOf('#'));
      }
      
      List<String> col = strInputText.split('\\*');
              
              strParseText = '';
      
      System.debug ('The string is ' + strParseText);      
      for (integer i = 0 ; i < col.size() ; i++)
      {
          strParseText = strParseText + ' Value ' + i + '  ' + col[i] + '\r\n';
      } 
      strParseText = '';
      pullMap('test');
      
    }
    
      Public List<String> pullMap(String Pattern){
            
                      List<String> lstStrreturn = new List<String>(); 
                      //string strInputText = Pattern;
                      string strInputText = 'Farm__c.Street__c#smagicinteract__Incoming_SMS__c.Status__c';
                      
                      
                      List<String> col = strInputText.split('\\#');
                                                 
                      for (String tmp : col)
                      {
                          List<string> objClass = tmp.split('\\.');
                          
                          for(String grain : objClass){
                              
                              lstStrreturn.add(grain);
                          }
                      } 
                      
                      for(integer i = 0 ; i < lstStrreturn.size() ; i++)
                      {
                          strParseText = strParseText + ' Value ' + i + '  ' + lstStrreturn[i] + '\r\n';
                      }
                      
                      return lstStrreturn;
                    
       }

    //Method for Creating trigger
    public PageReference createTrigger() {
        
        String ServerString;
        ServerString = currentPod();
        
        System.debug('The string for server is ' +ServerString);
        
        Boolean SandboxIs;
        SandboxIs = isSandbox();
        
        System.debug('Is this Sandbox? ' + SandboxIs);
        
        SalesforceTool test = new SalesforceTool();
        test.createApexClass();
        
        return null;
    }
    
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
 
 
    public Boolean isSandbox() {
          String pod = currentPod();
          if (pod != null && pod.length() > 0 && pod.toUpperCase().startsWith('C')){
              return true;
          }
          return false;
     }
    
    
    //Supporter class start
    public with sharing class SalesforceTool
    {
            //final String endpoint = 'https://na15.salesforce.com/services/data/v29.0/sObjects';
              final String endpoint = 'https://na15.salesforce.com/services/data/v29.0/sobjects';   
            // SomeValues to be store
            public String oid ;
            public String cid ;
            public String apmid ;
            public String carid ;
            
            public String TestString;
            public String TestBody;

         
            public SalesforceTool()
            {
    
                   TestString = 'Setupsms__c';
                   TestBody = 'trigger TestTrigger on '+TestString+ '(after insert){String TestingString;}';
            
            }
         
            // used receive response by sending a http request
            private String getResponse(HttpRequest req)
            {
                try
                {
                    Http
                    httpreq = new Http();
                    HttpResponse
                    res = httpreq.send(req);
                    String reqresponse = res.getBody();
                    return
                    reqresponse;
                }
                catch (Exception e){return
                'Error:' +e.getMessage();}
            }
         
            // create a http request with required endpoint and request method
            private HttpRequest createHttpRequest(String endpoint, String method)
            {
                HttpRequest req = new
                HttpRequest();
                endpoint += '';
                req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
                req.setHeader('Content-Type', 'application/json');
                req.setEndpoint(endpoint);
                req.setMethod(method);
                return req;
            }
            
                        
            
            public void createApexClass()
            {
                // create a Http request with post method
                HttpRequest req = createHttpRequest(endpoint+'/ApexTrigger','POST'); //changed
                
                System.debug('The testbody is ' + TestBody);
                
                req.setBody( '{"TableEnumOrId":"Setupsms__c","Name":"TestTrigger","Body":"'+TestBody+'"}');
                // send request and receive response
                String response = getResponse(req);
                // These two lines have no role in creating apex class. So they can be ignored for now.
                //Map<String,Object> rmp = (Map<String,Object>)JSON.deserializeuntyped(response);
                //oid = (String)rmp.get('id');
            }
        }
        //Supporter class end           

}