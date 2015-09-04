global class NetworkAccess implements Process.Plugin
{    
    global Process.PluginResult invoke(Process.PluginRequest request)
    {   
        Map<String, Object> result = new Map<String, Object>();  
        boolean isTrustedIP = false;
        
        String sourceIp = (String)request.inputParameters.get('IP');
        
        //IP not provided, use the current session IP address
        if(sourceIP == null || sourceIP == '')
        {
            Map<String,String> sessionAttributes;
            try 
            {
                sessionAttributes = Auth.SessionManagement.getCurrentSession();
            }
            catch(Exception e)
            {
                result.put('IsTrusted', false);
        
                return new Process.PluginResult(result);
            }
            
            for(string key : sessionAttributes.keySet())
            {
                system.debug('key: ' + key + ' value: ' + sessionAttributes.get(key));
            }
    
            sourceIP = sessionAttributes.get('SourceIp');
        }
        
        system.debug('SourceIP: ' + sourceIp);
        
        if(sourceIp != null)
            isTrustedIP = Auth.SessionManagement.inOrgNetworkRange(sourceIP);
         
        result.put('IsTrusted', isTrustedIP);
        
        return new Process.PluginResult(result);
    }

    global Process.PluginDescribeResult describe()
    {
        Process.PluginDescribeResult result = new Process.PluginDescribeResult();
        result.description='This plug-in verifies if the input IP address is in your organization trusted IP range';
        result.tag='Identity';
        
        result.inputParameters = new List<Process.PluginDescribeResult.InputParameter> {
            new Process.PluginDescribeResult.InputParameter('IP', Process.PluginDescribeResult.ParameterType.STRING, true)
        };
        
        result.outputParameters = new List<Process.PluginDescribeResult.OutputParameter> {
            new Process.PluginDescribeResult.OutputParameter('IsTrusted',
                Process.PluginDescribeResult.ParameterType.Boolean)
        };
           
        return result;
    }
}