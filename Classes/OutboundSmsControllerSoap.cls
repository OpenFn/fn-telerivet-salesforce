@RestResource(urlMapping='/soapsms')
global class OutboundSmsControllerSoap{
    @HttpPost
    global static  Telerivet_Tracking__c  Insertsms() {
    
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;
    res.statusCode = 401;
    //res.addHeader('Content-Type', 'application/json'); 
    system.debug('==========READING REQUEST');
    //System.debug('==========  :   ' + req.requestbody.tostring());
    
    
    
    //string text = string.valueof(req.requestbody.tostring());
    
        
  //Dom.Document doc = new Dom.Document();
  //doc.load(text);
  //Dom.XMLNode root = doc.getRootElement();  
  //string idval = root.getChildElement('sf:Id', null).getText();
  //string nameval = root.getChildElement('sf:Name', null).getText();
  
  //system.debug('========== VALUES : ID :' + idval );
  //system.debug('========== VALUES : ID :' + nameval );
  Telerivet_Tracking__c sms = new Telerivet_Tracking__c(Name = 'testing from api' , Error_message__c=req.params.get('ids') );
  insert sms;
  
  
  return sms; 
    
    
        
    }
}  



/*global class OutboundSmsControllerSoap{

    webService static Id sendSms(String nName, Account a) {
        Setupsms__c sms = new Setupsms__c(Name = nName + 'SOAPER' );
        insert sms;
        return sms.id;
        
    }
}*/