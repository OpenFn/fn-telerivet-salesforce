/*
Copyright (c) 2012, Ardent Software, LLC.
All rights reserved.
 
Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:
 
* Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.
* Neither the name of the Ardent Software, LLC. nor the names of its contributors
may be used to endorse or promote products derived from this software
without specific prior written permission.
 
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
OF THE POSSIBILITY OF SUCH DAMAGE.
 
****
Note that this code may require some work before you can deploy it to a standard org.
*/
 public class OAuth_2_0{
private String OAUTH_CONSUMER_KEY;
private String OAUTH_CONSUMER_SECRET;
public static final String OAUTH_SIG_METHOD='HMAC-SHA1'; //Required for OAuth 1.0
public static final String OAUTH_VERSION='2.0';
public String OAUTH_NONCE;
public String API_URL = '';
public String AUTH_URL = '';
public String ACCESS_TOKEN_URL = '';
public String OAUTH_CALLBACK_URL;
public String serviceId;
public String serviceName;
private String clientId;
private String clientSecret;
//Constructor.
//Accepts Service name as a parameter and populates consumer key, consumer secret and call back url.
public OAuth_2_0(String serviceName){
 OAuth_Service__c authServ = [select Id,Name,AccessTokenUrl__c,AuthUrl__c,CallBackURL__c,ConsumerKey__c,
                             ConsumerSecretKey__c,ReqTokenUrl__c from OAuth_Service__c where Name = :serviceName LIMIT 1];
 this.clientId = authServ.ConsumerKey__c;
 this.clientSecret = authServ.ConsumerSecretKey__c;
 this.OAUTH_CALLBACK_URL = authServ.CallBackURL__c;
 this.AUTH_URL = authServ.ReqTokenUrl__c;
 this.ACCESS_TOKEN_URL = authServ.AccessTokenUrl__c;
 this.serviceId = authServ.Id;
 this.serviceName = serviceName;
}
 
//This method creates and returns a URL to get a temporary token
public String getUnauthorizedReqToken(){
 
  String vf_url=this.OAUTH_CALLBACK_URL; //Visual Force Page used for Authentication
  String state = getRandomNonce(); //Random String
  String body='client_id='+this.clientId+'&redirect_uri='+this.OAUTH_CALLBACK_URL+'&state='+state;
 
  String retUrl=this.AUTH_URL+'?'+body;
  return retUrl;
}
//Generates Nonce Randomly
public static String getRandomNonce(){
   String allChars='ABCDEFGHIJKLMNOPQRSTUVWXYZ';
   String nonce='';
   for(integer cnt=0; cnt<=9;cnt++)   {
       Integer i = 1+Math.Round(700.0*Math.random()/26);
       if (i<=26)
       {
          i--;
          String newStr=allChars.substring(i,i+1);
          nonce=nonce+newStr;
      }else{
        cnt--;
      }
  }
  return nonce;
}
 
//This Method get Authorized Token
public String getAuthorizedReqToken(String code){
 
String body='client_id='+this.clientId+'&redirect_uri='+this.OAUTH_CALLBACK_URL+'&client_secret='+this.clientSecret+'&code='+code;
 
String tokenResponse = basicAuthCallout(this.ACCESS_TOKEN_URL,'',body,'GET');
 
System.debug('=========================== RESPONSE:'+tokenResponse);
 
String authReqToken = tokenResponse;
return authReqToken;
}
 
//This method makes API calls
//e.g. https://graph.facebook.com/me?access_token=YOUR_USER_ACCESS_TOKEN
public String makeAPICall(String apiUrl,Map<String,String> paramMap){
Long milliTime=System.currentTimeMillis();
String params = getSortedParams(paramMap); //Sort parametrs in ascending order
milliTime=milliTime/1000;
Integer secTime = (Integer)milliTime;
String strTime = String.valueOf(secTime);
String token=null; //Member token
String secretToken=null;//Member secret token
UserTokens__c userToken = [select Id,OAuth_Service__c,Token__c,secretToken__c from UserTokens__c where isAuthorized__c = true
and CreatedBy.Name=:userInfo.getName() and OAuth_Service__c = :this.serviceId];
token = userToken.Token__c;
String body='access_token='+token+'&'+params;
 
String qryResponse = basicAuthCallout(apiURL,'',body,'GET');
System.debug('====================== QRY RESP:'+qryResponse);
return qryResponse;
}
 
//Sort the map to return sorted parameters
public static String getSortedParams(Map<String,String> paramMap){
String sortedParams='';
List<String> keys = new List<String>(paramMap.keySet());
keys.sort();
for(String key : keys){
String value=paramMap.get(key);
if (sortedParams == '')
sortedParams=key+'='+value;
else
sortedParams=sortedParams+'&'+key+'='+value;
}
return sortedParams;
}
 
public String basicAuthCallout(String endPoint,String header, String body,String method){
HttpRequest req = new HttpRequest();
//endPoint = EncodingUtil.urlEncode(endPoint,'UTF-8');
endpoint=endpoint+'?'+body;
req.setEndpoint(endPoint);
req.setMethod(method);
Http http = new Http();
System.debug('=========== REQ BODY:'+endPoint);
HTTPResponse res = http.send(req);
return res.getBody();
}
}