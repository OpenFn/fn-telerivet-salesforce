global class IdentityContextPlugin implements Process.Plugin {
    
    global Process.PluginDescribeResult describe() {
        Process.PluginDescribeResult result = new Process.PluginDescribeResult(); 
           result.Tag = 'Identity';
           result.Name = 'Identity Context Builder';
           result.description = 'Establishes Context for the current user to be used in Login Flows';
           result.inputParameters = new List<Process.PluginDescribeResult.InputParameter> {
              new Process.PluginDescribeResult.InputParameter('LoginFlow_UserAgent', Process.PluginDescribeResult.ParameterType.STRING, false),
              new Process.PluginDescribeResult.InputParameter('LoginFlow_LoginIpAddress', Process.PluginDescribeResult.ParameterType.STRING, false)
           };
       
           result.outputParameters = new List<Process.PluginDescribeResult.OutputParameter> {
               new Process.PluginDescribeResult.OutputParameter('User Id', Process.PluginDescribeResult.ParameterType.String),
               new Process.PluginDescribeResult.OutputParameter('User Type', Process.PluginDescribeResult.ParameterType.String),
               new Process.PluginDescribeResult.OutputParameter('AuthSession Id', Process.PluginDescribeResult.ParameterType.String),
               new Process.PluginDescribeResult.OutputParameter('IP Changed Since Login', Process.PluginDescribeResult.ParameterType.Boolean),
               new Process.PluginDescribeResult.OutputParameter('Is Trusted IP Address', Process.PluginDescribeResult.ParameterType.Boolean),
               new Process.PluginDescribeResult.OutputParameter('Has Registered Token', Process.PluginDescribeResult.ParameterType.Boolean),
               new Process.PluginDescribeResult.OutputParameter('Is iPhone', Process.PluginDescribeResult.ParameterType.Boolean),
               new Process.PluginDescribeResult.OutputParameter('Is iPad', Process.PluginDescribeResult.ParameterType.Boolean),
               new Process.PluginDescribeResult.OutputParameter('Is Android', Process.PluginDescribeResult.ParameterType.Boolean)
           };
           return result; 
    }
    
    global Process.PluginResult invoke(Process.PluginRequest request) {  
    
        
        Map<String, Object> result = new Map<String, Object>();
        Map<String,String> sessionAttributes;
        
        String userId =  UserInfo.getUserId();
        result.put('User Id', userId);
        
        List<TwoFactorInfo> twoFactors = [SELECT UserId, Type FROM TwoFactorInfo where userID = :userid];
        result.put('Has Registered Token', !TwoFactors.isEmpty());
        
        String userAgent = (String)request.inputParameters.get('LoginFlow_UserAgent');
        if (userAgent != null) {
            if (userAgent.contains('iPhone')) {
                result.put('Is iPhone', true);
            } else {
                result.put('Is iPhone', false);
            }
            if (userAgent.contains('iPad')) { 
                result.put('Is iPad', true);
            } else {
                result.put('Is iPad', false);
            }
            if (userAgent.contains('Android')) { 
                result.put('Is Android', true);
            } else {
                result.put('Is Android', false);
            }
        }

        if(!Test.isRunningTest())
            sessionAttributes = Auth.SessionManagement.getCurrentSession();
   
        if(sessionAttributes == null)
            return new Process.PluginResult(result);
            
        result.put('User Type', sessionAttributes.get('UserType'));
        result.put('AuthSession Id', sessionAttributes.get('SessionId'));
        String sourceIP = sessionAttributes.get('SourceIP');
        if(sourceIP != null)
        {
            result.put('Is Trusted IP Address', Auth.SessionManagement.inOrgNetworkRange(sourceIP));
            String loginIpAddress = (String)request.inputParameters.get('LoginFlow_LoginIpAddress');
            if ((sourceIP != null) && (loginIpAddress != null)) result.put('IP Changed Since Login', (sourceIP == loginIpAddress));
        }
       
        System.debug('Session Attributes: ' + sessionAttributes);
        System.debug('Context Builder Results: ' + result);
        
        return new Process.PluginResult(result);
    }
    
}