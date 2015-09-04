@RestResource(urlMapping='/test')
global class RestTestController {
    @HttpPost
    global static void getTestAccount() {
 
       /* RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        String jsonResponse = '';
        String smsName = req.params.get('Name');
 
// No account_name parameter was found; return status 400
        if(smsName == null) {
            res.statusCode = 400;
            jsonResponse = '{"response": {"status": "Failure", "message": "MissingRequiredQueryParameter Name"}}';
            res.responseBody = blob.valueOf(jsonResponse);
            return;
        }
 
// Get the list of accounts that match the account_name sent in the request.
        List<Setupsms__c> smses = [SELECT Id 
                                  FROM Setupsms__c
                                  WHERE Name =: smsName];
 
// No accounts with matching account_name
        if( smses.isEmpty()) {
        
            try { 
            
            Setupsms__c newSms = new Setupsms__c( Name = smsName );
            insert newSms;
            res.statusCode = 200;
            jsonResponse = '{"response": {"status": "Success", "message": "SMS Inserted, Hurray !"}}';
            res.responseBody = blob.valueOf(jsonResponse);
            return;
                
            } catch ( Exception ex ) {
                res.statusCode = 500;
                jsonResponse = '{"response": {"status": "Failure", "message": "' + ex + '"}}';
                res.responseBody = blob.valueOf(jsonResponse);
                return;
            }

        }
        else{
            res.statusCode = 200;
            jsonResponse = '{"response": {"status": "Alert !", "message": "SMS Record already present."}}';
            res.responseBody = blob.valueOf(jsonResponse);
            return;
            
        }
 */

    }
}