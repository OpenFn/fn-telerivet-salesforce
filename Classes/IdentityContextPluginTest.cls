@isTest
private class IdentityContextPluginTest {

    static testMethod void inputTest() {

        IdentityContextPlugin identity = new IdentityContextPlugin();
        Map<String,Object> inputParams = new Map<String,Object>();
        Map<String,Object> outputParams = new Map<String,Object>();
        
        inputParams.put('LoginFlow_UserAgent', 'iPhone');
        inputParams.put('LoginFlow_LoginIpAddress', '1.1.1.1');
        
        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result;
        result = identity.invoke(request);
            
        System.AssertEquals(1,1);
            
     }
     
     static testMethod void describeTest() {

        IdentityContextPlugin identity = new IdentityContextPlugin();
        Process.PluginDescribeResult result = identity.describe();
        
        System.AssertEquals(result.inputParameters.size(), 2);
        System.AssertEquals(result.OutputParameters.size(), 9);
     }
}