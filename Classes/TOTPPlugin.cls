global class TOTPPlugin implements Process.Plugin
{    
    global Process.PluginDescribeResult describe()
    {
        Process.PluginDescribeResult result = new Process.PluginDescribeResult();
        result.description='This plug-in handles salesforce standard two factor authentication methods.';
        result.tag='Identity';
        
        result.inputParameters = new List<Process.PluginDescribeResult.InputParameter> {
                new Process.PluginDescribeResult.InputParameter('OTP_INPUT', Process.PluginDescribeResult.ParameterType.STRING, true),
                new Process.PluginDescribeResult.InputParameter('OTP_REGISTRATION_INPUT', Process.PluginDescribeResult.ParameterType.STRING, true),
                new Process.PluginDescribeResult.InputParameter('SECRET_INPUT', Process.PluginDescribeResult.ParameterType.STRING, true)      
            };
        
        result.outputParameters = new List<Process.PluginDescribeResult.OutputParameter> {
            new Process.PluginDescribeResult.OutputParameter('QR_URL_OUTPUT',
                Process.PluginDescribeResult.ParameterType.STRING),
            new Process.PluginDescribeResult.OutputParameter('SECRET_OUTPUT',
                Process.PluginDescribeResult.ParameterType.STRING),
            new Process.PluginDescribeResult.OutputParameter('IsValid_OUTPUT',
                Process.PluginDescribeResult.ParameterType.Boolean)
        };
        
        return result;
    }
    
    global Process.PluginResult invoke(Process.PluginRequest request)
    {   
        Map<String,String> QR;
        String URL; 
        String otp;
        String secret;
        Boolean status = false;
        
        String userid   = UserInfo.getUserId();  
        
        Map<String, Object> result = new Map<String, Object>();
        
        List<TwoFactorInfo> twoFactors = [SELECT UserId, Type FROM TwoFactorInfo where userID = :userid];
        
        secret = (String)request.inputParameters.get('SECRET_INPUT');
        
        if(twoFactors.isEmpty() && secret == null)
        {
            QR = Auth.SessionManagement.getQrCode();      
            URL = QR.get('qrCodeUrl');
            Secret = QR.get('secret');
            
            result.put('QR_URL_OUTPUT', URL);
            result.put('SECRET_OUTPUT', Secret);
            
            return new Process.PluginResult(result);
        }
         
        
        otp = (String)request.inputParameters.get('OTP_REGISTRATION_INPUT');
        
        if(otp == null)
            otp = (String)request.inputParameters.get('OTP_INPUT');
        
        result.put('IsValid_OUTPUT', validate(otp, secret));
           
        return new Process.PluginResult(result);
    }
      
    
    private Boolean validate(String otp, String secret)
    {
        String userid   = UserInfo.getUserId();   
        Boolean status = false;
        
         
        if(secret == null)
        {
            try {
                status = Auth.SessionManagement.validateTotpTokenForUser(otp);
            } 
            catch(Exception e)
            {
                system.debug('The key is invalid or the current user has attempted too many validations');
            } 
            
            return status;
        }
        
        status = Auth.SessionManagement.validateTotpTokenForKey(secret, otp);
        if(status == true)
        {
           TwoFactorInfo TwoFactor = new TwoFactorInfo(UserId=userid, Type='TOTP', SharedKey=secret);

           insert(TwoFactor);
        }
       
        return status;
    }    
}