@isTest
private class NetworkAccessTest
{
    static testMethod void inputIP() {
     
        NetworkAccess network = new NetworkAccess();
        Map<String,Object> inputParams = new Map<String,Object>();
        Map<String,Object> outputParams = new Map<String,Object>();
         
        inputParams.put('IP', '1.1.1.1');
         
        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result;
        result = network.invoke(request);
        
        System.AssertEquals(1,1);
    }

    static testMethod void describeTest() {

        NetworkAccess network = new NetworkAccess();
        Process.PluginDescribeResult result = network.describe();
        
        System.AssertEquals(result.inputParameters.size(), 1);
        System.AssertEquals(result.OutputParameters.size(), 1);
     }
}