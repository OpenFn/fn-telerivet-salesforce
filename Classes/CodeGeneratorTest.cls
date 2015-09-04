@isTest
private class CodeGeneratorTest
{
    static testMethod void getCode() {
     
        CodeGenerator generator = new CodeGenerator();
        Map<String,Object> inputParams = new Map<String,Object>();
        Map<String,Object> outputParams = new Map<String,Object>();
         
        Process.PluginRequest request = new Process.PluginRequest(inputParams);
        Process.PluginResult result;
        result = generator.invoke(request);
        
        System.AssertEquals(1,1);
    }

    static testMethod void describeTest() {

        CodeGenerator generator = new CodeGenerator();
        Process.PluginDescribeResult result = generator.describe();
       
        System.AssertEquals(result.OutputParameters.size(), 1);
     }
}