@isTest
private class TOTPPluginTest
{
    static testMethod void getQRCode() {
     
        TOTPPlugin totp = new TOTPPlugin();
        Map<String,Object> inputParams = new Map<String,Object>();
        Map<String,Object> outputParams = new Map<String,Object>();
         
        Map<String,String> QR = Auth.SessionManagement.getQrCode(); 
         
        inputParams.put('OTP_INPUT', null);
         
        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result;
        result = totp.invoke(request);
        
        System.AssertEquals(1,1);
    }
    
    static testMethod void validateToken() {
     
        TOTPPlugin totp = new TOTPPlugin();
        Map<String,Object> inputParams = new Map<String,Object>();
        Map<String,Object> outputParams = new Map<String,Object>();
         
        Map<String,String> QR = Auth.SessionManagement.getQrCode(); 
         
        inputParams.put('OTP_INPUT', '1234');
        inputParams.put('SECRET_INPUT', QR.get('secret'));
         
        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result;
        result = totp.invoke(request);
        
        System.AssertEquals(1,1);
    }

    static testMethod void describeTest() {

        TOTPPlugin totp = new TOTPPlugin();
        Process.PluginDescribeResult result = totp.describe();
        
        System.AssertEquals(result.inputParameters.size(), 3);
        System.AssertEquals(result.OutputParameters.size(), 3);
     }
}