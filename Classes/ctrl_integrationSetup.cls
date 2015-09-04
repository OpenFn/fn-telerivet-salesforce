public  class ctrl_integrationSetup {

public string phoneType {get;set;} 
public string phoneOption {get;set;} 
public String apikey  {get;set;} 
public String projId  {get;set;}
public String phoneId {get;set;}
public string routeId {get;set;}
public string secret {get;set;}
public string siteUrl {get;set;}

public string outsmsObj {get;set;}
public string outsmsText {get;set;}
public string outsmsNum {get;set;}
public string outsmsTime {get;set;}
public string outsmsRT {get;set;}
public string outsmsONum {get;set;}
public boolean outsmsisRT {get;set;}

public string insmsObj {get;set;}
public string insmsText {get;set;}
public string insmsNum {get;set;}
public string insmsTime {get;set;}
public string insmsRT {get;set;}
public string insmsONum {get;set;}
public boolean insmsisRT {get;set;}
public boolean isEditing {get; set;}

public List<Account_Settings__c> accountSet {get;set;}
public String actionRecord {get;set;}
public Account_Settings__c acc {get;set;}

public Account_Settings__c editAcc {get; set;}
public String strEditRecordId {get;set;}

public integer step {get;set;} 
public List<selectOption> TrPhoneIds {get;set;}

//Constructor
public ctrl_integrationSetup(ApexPages.StandardController controller){
    

    //Site site = [SELECT Subdomain, UrlPathPrefix FROM Site];
    //tempVariable  = 'https://' + site.Subdomain + '.secure.force.com/' + site.UrlPathPrefix;

    String q = (string) ApexPages.currentPage().getParameters().get('q');
    TrPhoneIds = new List<SelectOption>();
    //insmsisRT = false ; 
    //outsmsisRT = false ; 
    
    isEditing = false;
    
    if(controller.getId() != null){
        isEditing = True;     
        strEditRecordId = controller.getId();
        
        try{
            editAcc =  [ Select Name , Site_URL__c , Active__c , API_key__c , Phone_type__c  , Secret_key__c , Project_Id__c ,  Phone_Route_Id__c ,
                Inbound_Record_Type__c,Inbound_Object_Name__c  ,Inbound_Number_Field__c , Inbound_Time_Field__c ,Inbound_Msg_Text_Field__c  , Inbound_Out_Number_Field__c , Is_Inbound_Record_Typed__c,
                Outbound_Record_Type__c,Outbound_Object_Name__c ,Outbound_Number_Field__c  , Outbound_Time_Field__c ,Outbound_Msg_Text_Field__c ,Outbound_Out_Number_Field__c, Is_Outbound_Record_Typed__c
                , UID__c , T_Asset__c from Account_Settings__c  where id = :strEditRecordId  ];
                
                
            phoneType  = editAcc.Phone_type__c  ;
            //phoneOption = 
            apikey  = editAcc.API_key__c ;
            projId  = editAcc.Project_Id__c ;
            
            if(phoneType == 'phone'){
                phoneandroute();
                phoneId  = editAcc.Phone_Route_Id__c ; 
            }
            else{
                routeId = editAcc.Phone_Route_Id__c ;
            }
            secret = editAcc.Secret_key__c ;
            siteUrl  = editAcc.Site_URL__c ;
            
            getName();
            outsmsObj = editAcc.Outbound_Object_Name__c ;
            
            getObFields();
            outsmsText = editAcc.Outbound_Msg_Text_Field__c ;
            outsmsNum = editAcc.Outbound_Number_Field__c  ;
            outsmsTime = editAcc.Outbound_Time_Field__c ;        
            outsmsONum = editAcc.Outbound_Out_Number_Field__c;
            
            outsmsisRT = false;
            
            if(editAcc.Is_Outbound_Record_Typed__c == true){
                
                getOutRecordTypes();
                outsmsRT = editAcc.Outbound_Record_Type__c;
                outsmsisRT = true;
            }
    
            
           
            insmsObj = editAcc.Inbound_Object_Name__c   ;
            insmsText = editAcc.Inbound_Msg_Text_Field__c  ;
            insmsNum = editAcc.Inbound_Out_Number_Field__c ;
            insmsTime = editAcc.Inbound_Time_Field__c ;
            insmsONum = editAcc.Inbound_Number_Field__c ;
            
            insmsisRT = false ;
            
            if(editAcc.Is_Inbound_Record_Typed__c == true){
                
                getInRecordTypes();
                insmsRT = editAcc.Inbound_Record_Type__c ;    
                insmsisRT  = true ;
            }
        }
        catch(Exception ex){
            isEditing = false;
        }
        
    }
    else{
            Map<string , String> mapSmsRecordTypesAdd = new Map<String , String>();
            
            for(RecordType  rct : [Select DeveloperName, Id from RecordType Where sObjectType = 'Basic_sms_object__c']){
                mapSmsRecordTypesAdd.put(rct.DeveloperName , rct.Id);
            }
            
            getName();
            outsmsObj = 'Basic_sms_object__c' ;
            
            getObFields();
            outsmsText = 'Sms_Text__c';
            outsmsNum = 'Phone_Number__c';
            outsmsTime = 'Date_Time__c' ;        
            outsmsONum = 'Sender_Number__c';
            
            outsmsisRT = True;
            getOutRecordTypes();
            outsmsRT = mapSmsRecordTypesAdd.get('Outbound');
            
           
            insmsObj = 'Basic_sms_object__c';
            insmsText = 'Sms_Text__c';
            insmsNum = 'Phone_Number__c';
            insmsTime = 'Date_Time__c';
            insmsONum = 'Sender_Number__c';
            
            insmsisRT = True;
            
            getInRecordTypes();
            insmsRT = mapSmsRecordTypesAdd.get('Inbound');
    
    }

    
    accountSet  = new List<Account_Settings__c>();
    accountSet = [ Select Name , Active__c , API_key__c , Phone_type__c  , Secret_key__c , Project_Id__c ,  Phone_Route_Id__c ,
            Inbound_Object_Name__c  ,Inbound_Number_Field__c , Inbound_Time_Field__c ,Inbound_Msg_Text_Field__c  ,
            Outbound_Object_Name__c ,Outbound_Number_Field__c  , Outbound_Time_Field__c ,Outbound_Msg_Text_Field__c from Account_Settings__c  ];
            
    if(accountSet.size() >= 1){        
        step= 1; 
       
    }
    else if (q =='1'){
        step = 1 ; 
    }
    else{
        step = 1; 
    }
    //step = 3 ; 
}

//Radio button click support
Public pagereference phoneandroute(){
    
    
        List<SelectOption> options = new List<SelectOption>();
        TrPhoneIds = new List<SelectOption>();
        TrPhoneIds.Clear();
        
        if( apiKey != '' &&  projId != '' && phoneType == 'phone'){
            
            String apiKey = apikey;
            String projectId =projId;
            string urlpost = 'https://api.telerivet.com/v1/projects/'+projectId+'/phones';
             HttpRequest req = new HttpRequest();
             req.setEndpoint(urlPost);
             req.setTimeout(1000) ;
             req.setMethod('GET');
             req.setHeader('Content-Type','application/x-www-form-urlencoded') ;
           
            Blob headerValue = Blob.valueOf(apiKey);
             String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
             req.setHeader('Authorization', authorizationHeader);
             Http http = new Http();
             
             try{
                 
                system.Debug('+++++++++++++ Sending Request FROM PAGE +++++++++++++');
                
                HttpResponse resp ;
                

                
                if(!Test.isRunningTest())
                {
                     resp = http.send(req);
                }
                else
                {    MockHttpResponseGenerator tmpResp = new MockHttpResponseGenerator();
                     resp  = tmpResp.respond(req);
                }
                

                System.debug('RESPONSE BODY : ' +resp.getBody());    
                 
                if(String.valueof(resp.getStatusCode()) == '200'  ){
                     
                    //Converting JSON response to objects 
                    Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(resp.getbody());
                    List<Object> a = (List<Object>)m.get('data');
                     
                    List<Map<string, Object>> listofmap = new List<Map<string , Object>>();
                     
                     for(Object a1 : a ){
                        listofmap.add((Map<String, Object>)a1);
                     }            
                     
                     for(Map<string, Object> mapper : listofmap){
                        System.Debug('The Id value is : ' +mapper.get('id'));
                        options.add( new SelectOption( String.valueof(mapper.get('id')), String.valueof(mapper.get('id')) + ' - ' +String.valueof(mapper.get('phone_number'))));
                     }
                     TrPhoneIds = options;
                 }
                 else{
                     ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.Error,'An error occured while fetching Phone IDs, Please verify your API Key and/or Project ID.'));        
                     phoneType = null ; 
                     return null;
                 }
             }
             catch(Exception ex){
                     system.debug(ex);
             }
         }
         else if( apiKey == '' &&  projId == '' && phoneType == 'phone'  ){
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.Warning,'Please Enter API Key and Project ID!'));             
            phoneType = null ; 
            return null ; 
         }
         return null;



}

//Get Phone Ids from Telerivet
/*Public List<SelectOption> getTrPhoneId(){
    
        List<SelectOption> options = new List<SelectOption>();
        
        if(apikey != null && projId != null){
            
            String apiKey = apikey;
            String projectId =projId;
            string urlpost = 'https://api.telerivet.com/v1/projects/'+projectId+'/phones';
             HttpRequest req = new HttpRequest();
             req.setEndpoint(urlPost);
             req.setTimeout(1000) ;
             req.setMethod('GET');
             req.setHeader('Content-Type','application/x-www-form-urlencoded') ;
           
             Blob headerValue = Blob.valueOf(apiKey);
             String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
             req.setHeader('Authorization', authorizationHeader);
             Http http = new Http();
             
             try{
                 
                system.Debug('+++++++++++++ Sending Request +++++++++++++');
                HttpResponse resp =http.send(req);
                System.debug(resp.getBody());    
                 
                if(String.valueof(resp.getStatusCode()) == '200'  ){
                     
                    Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(resp.getbody());
                    List<Object> a = (List<Object>)m.get('data');
                     
                    List<Map<string, Object>> listofmap = new List<Map<string , Object>>();
                     
                     for(Object a1 : a ){
                        listofmap.add((Map<String, Object>)a1);
                     }            
                     
                     for(Map<string, Object> mapper : listofmap){
                        System.Debug('The Id value is : ' +mapper.get('id'));
                        options.add( new SelectOption( String.valueof(mapper.get('id')), String.valueof(mapper.get('id'))));
                     }
                 }
                 else{
                     ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.Info,'An error occured while fetching Phone IDs, Please verify your API Key and/or Project ID.'));        
                 }
             }
             catch(Exception ex){
                     system.debug(ex);
             }
         }
         return options;

}
*/

//Get list of objects 
public List<SelectOption> getName()
{
 
    List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();   
     
    List<SelectOption> options = new List<SelectOption>();
    //options.add(new SelectOption('','--None--'));   
 
    for(Schema.SObjectType f : gd)
    {
        options.add(new SelectOption(f.getDescribe().getName(),f.getDescribe().getLabel()));
    }
    //options.sort();
    //return options;
    return SortSelectOptions.selectOptionSortByLabel(options);
}    

//Get list of record types in an object Inbound and Outbound

public List<SelectOption> getOutRecordTypes(){

    List<SelectOption> options = new List<SelectOption>();
    if(outsmsObj != null) {
        Schema.DescribeSObjectResult R = Schema.getGlobalDescribe().get( outsmsObj ).getDescribe(); 
        List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
        
        for(Schema.RecordTypeInfo rtInfo : RT){
            options.add(new SelectOption( rtInfo.getRecordTypeId() , rtInfo.getName()  ));
        }
    }
    
    if(options.size()>= 2){
        outsmsisRT = true;
    }
    else{
        outsmsisRT =  false ; 
    }
    
    //Schema.DescribeSObjectResult R = Account.SObjectType.getDescribe();
    //options.sort();
    //return options ;
    return SortSelectOptions.selectOptionSortByLabel(options);
}

public List<SelectOption> getInRecordTypes(){

    List<SelectOption> options = new List<SelectOption>();
    if(insmsObj != null){
        Schema.DescribeSObjectResult R = Schema.getGlobalDescribe().get( insmsObj ).getDescribe(); 
        List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
        
        for(Schema.RecordTypeInfo rtInfo : RT){
            options.add(new SelectOption( rtInfo.getRecordTypeId() , rtInfo.getName()  ));
        }
    }
    //Schema.DescribeSObjectResult R = Account.SObjectType.getDescribe();
    if(options.size()>= 2){
        insmsisRT = true;
    }
    else{
        insmsisRT =  false ; 
    }
    
    //options.sort();
    return SortSelectOptions.selectOptionSortByLabel(options);
    //return options ;
}


//Get list of Fields in object 
public List<SelectOption> getObFields(){
     
System.debug(outsmsObj );
    List<SelectOption> options = new List<SelectOption>();
    List<Schema.SObjectField> sss=new list<Schema.SObjectField>();
    if(outsmsObj !=null){
        Schema.SObjectType gd = Schema.getGlobalDescribe().get(outsmsObj ); 
        Schema.DescribeSobjectResult a11=gd.getDescribe();
                                  
        System.debug('all fields'+a11);
        Map<String, Schema.SObjectField> M = a11.fields.getMap();
        for(Schema.SObjectField s1:m.values()){              
            Schema.DescribeFieldResult f = M.get(s1.getDescribe().getName()).getDescribe();
            system.debug('----'+s1+'\n' + f.getType());
            if(f.isUpdateable())
                options.add(new SelectOption(s1.getDescribe().getName(),s1.getDescribe().getLabel()));
                        //sss.add(s1);
        }
     }
     //options.sort();
     //return options;
    return SortSelectOptions.selectOptionSortByLabel(options);
    
}     
public List<SelectOption> getIbFields(){
     
System.debug(insmsObj );
    List<SelectOption> options = new List<SelectOption>();
    List<Schema.SObjectField> sss=new list<Schema.SObjectField>();
    if(insmsObj !=null){
        Schema.SObjectType gd = Schema.getGlobalDescribe().get(insmsObj ); 
        Schema.DescribeSobjectResult a11=gd.getDescribe();
                                  
        System.debug('all fields'+a11);
        Map<String, Schema.SObjectField> M = a11.fields.getMap();
        for(Schema.SObjectField s1:m.values()){              
            Schema.DescribeFieldResult f = M.get(s1.getDescribe().getName()).getDescribe();
            system.debug('----'+s1+'\n' + f.getType());
            if(f.isUpdateable())
                options.add(new SelectOption(s1.getDescribe().getName(),s1.getDescribe().getLabel()));
                        //sss.add(s1);
        }
     }
     //options.sort();
     //return options;
     return SortSelectOptions.selectOptionSortByLabel(options);
    
}     
  
public pagereference setAllObSelect(){

    getObFields();
    return null;
}      

public pagereference setAllIbSelect(){
    getIbFields();
    return null;
}


// Action methods
/*
Public pagereference saveEdit(){

        if(insmsObj  == '' || insmsObj  == '--None--'){
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.Warning,'Please select a valid Inbound SMS object!'));  
            return null;          
        }
        else if( ( insmsRT == '' || insmsRT == null ) && insmsisRT == true){
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.Warning,'Please select a valid RecordType for the object!')); 
            return null;           
        }
        else if( insmsObj == outsmsObj && insmsisRT == false && outsmsisRT == false ){
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.Warning,'You have selected the same Object for Inbound and Outbound Sms, we recommend you to use a RecordType for any one or distinct RecordTypes for both.'));        
            return null;
        }
        else if( insmsObj == outsmsObj && insmsisRT == true && outsmsisRT == true && insmsRT == outsmsRT ){
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.Warning,'You have selected the same Object and RecordType for Inbound and Outbound Sms, we recommend you to seperate them with different RecordType.'));        
            return null;
        }
        else if(insmsTime == insmsNum || insmsTime ==  insmsText || insmsText == insmsNum || insmsONum == insmsTime || insmsONum == insmsNum || insmsONum ==insmsText  ){
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.Warning,'Two field values cannot be the same!'));        
            return null;
        }
        else{    
        
            String senderPhoneRouteId ; 
            String inRt;
            String outRt ; 
            
            if(insmsisRT){
                inRt = insmsRT ;
            }
            if(outsmsisRT ){
                outRt = outsmsRT ; 
            }
            
            if(phoneType =='phone'){
                senderPhoneRouteId = phoneId;
            }    
            else{
                senderPhoneRouteId = routeid;    
            }
                                  
                        
            editAcc.API_key__c = apikey ; 
            editAcc.Phone_type__c = phoneType ; 
            editAcc.Secret_key__c = secret  ;
            editAcc.Project_Id__c = projId  ; 
            editAcc.Is_Inbound_Record_Typed__c = insmsisRT ;
            editAcc.Inbound_Record_Type__c = inRt ;
            editAcc.Inbound_Object_Name__c = insmsObj ;
            editAcc.Inbound_Number_Field__c = insmsNum ;
            editAcc.Inbound_Time_Field__c = insmsTime ;
            editAcc.Inbound_Msg_Text_Field__c = insmsText ;
            editAcc.Inbound_Out_Number_Field__c = insmsONum ;
            
            editAcc.Is_Outbound_Record_Typed__c = outsmsisRT ; 
            editAcc.Outbound_Record_Type__c = outRt ;
            editAcc.Outbound_Object_Name__c = outsmsObj ;
            editAcc.Outbound_Number_Field__c = outsmsNum ; 
            editAcc.Outbound_Time_Field__c =outsmsTime  ;
            editAcc.Outbound_Msg_Text_Field__c =outsmsText ;
            editAcc.Outbound_Out_Number_Field__c = outsmsONum;
            editAcc.Phone_Route_Id__c = senderPhoneRouteId ;


            
            database.update( acc , false);                      
            
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.confirm,'Settings have been Saved!')); 
            step = 0;            
            return null ; 
            
        }  
        
   
}
*/

Public pagereference save(){

        if(insmsObj  == '' || insmsObj  == '--None--'){
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.Warning,'Please select a valid Inbound SMS object!'));  
            return null;          
        }
        else if( ( insmsRT == '' || insmsRT == null ) && insmsisRT == true){
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.Warning,'Please select a valid RecordType for the object!')); 
            return null;           
        }
        else if( insmsObj == outsmsObj && insmsisRT == false && outsmsisRT == false ){
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.Warning,'You have selected the same Object for Inbound and Outbound Sms, we recommend you to use a RecordType for any one or distinct RecordTypes for both.'));        
            return null;
        }
        else if( insmsObj == outsmsObj && insmsisRT == true && outsmsisRT == true && insmsRT == outsmsRT ){
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.Warning,'You have selected the same Object and RecordType for Inbound and Outbound Sms, we recommend you to seperate them with different RecordType.'));        
            return null;
        }
        else if(insmsTime == insmsNum || insmsTime ==  insmsText || insmsText == insmsNum || insmsONum == insmsTime || insmsONum == insmsNum || insmsONum ==insmsText  ){
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.Warning,'Two field values cannot be the same!'));        
            return null;
        }
        else{    
        
            String senderPhoneRouteId ; 
            String inRt;
            String outRt ; 
            
            if(insmsisRT){
                inRt = insmsRT ;
            }
            if(outsmsisRT ){
                outRt = outsmsRT ; 
            }
            
            if(phoneType =='phone'){
                senderPhoneRouteId = phoneId;
            }    
            else{
                senderPhoneRouteId = routeid;    
            }
            
            if(isEditing == true){
            
                    triggerHandle delTrg = new triggerHandle();
                    delTrg.deleteApexTrigger( editAcc.T_Asset__c  , UserInfo.getSessionId());    
                    
                    if(delTrg.error == true){
                        ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.Error,'An error occourred during setup, please contact Support for more information.' + delTrg.statusMessage));        
                        return null;
                    }                    
            
                }                              
                string triggerId ='';
                
                string uniqTime = String.valueof(datetime.now().day()) + String.valueof(datetime.now().Month()) + String.valueof(datetime.now().Year()) + String.valueof(datetime.now().Hour()) + String.valueof(datetime.now().Minute()+ String.valueof(datetime.now().Second()));
                string timestamp = 'trgSendSms' +  uniqTime ;
                string body = 'trigger '+timestamp+' on '+ outsmsObj  +' (after insert) {  Integer count = 0;  string query = \'\';  Map<string, string> mapRecordTypeId = new Map<string, string>();  boolean error = false;  public List<Telerivet_Tracking__c> smsTracker = new List<Telerivet_Tracking__c>();  String outObjectName = \'' + outsmsObj + '\';  string smsSettId = \'' + uniqTime +'\'; Account_Settings__c accountSet = null;  try{ accountSet = [ Select Name , Active__c , API_key__c , Phone_type__c  , Secret_key__c , Project_Id__c ,  Phone_Route_Id__c ,Inbound_Object_Name__c  ,Inbound_Number_Field__c , Inbound_Time_Field__c ,Inbound_Msg_Text_Field__c  ,Outbound_Object_Name__c ,Outbound_Number_Field__c  , Outbound_Time_Field__c ,Outbound_Msg_Text_Field__c , Outbound_Record_Type__c ,Is_Outbound_Record_Typed__c , Site_URL__c from Account_Settings__c where UID__c = :smsSettId and Outbound_Object_Name__c =:outObjectName LIMIT 1];} catch(exception ex){} String smsApiKey = accountSet.API_key__c ; String smsProjectId = accountSet.Project_Id__c ; string smsPhoneId = accountSet.Phone_Route_Id__c ;string smsUrlPost = \'https://api.telerivet.com/v1/projects/\'+smsProjectId+\'/messages/outgoing\'; string smsStatusUrl =  accountSet.Site_URL__c ; if(accountSet != null  && accountSet.Active__c == true){ system.debug(\'================SITE URL : \' + smsStatusUrl ); if(smsStatusUrl.endsWith(\'/\') ){smsStatusUrl = smsStatusUrl + \'services/apexrest/inboundsms\';}else{smsStatusUrl = smsStatusUrl + \'/services/apexrest/inboundsms\';} if(accountSet.Is_Outbound_Record_Typed__c== true){for(recordType rt : [Select Id , DeveloperName , Name from RecordType where sObjectType = :outObjectName  ]){mapRecordTypeId.put(rt.Id, rt.DeveloperName);} }system.debug(\'================SITE URL : \' + smsStatusUrl );for(' + outsmsObj + '  sms : Trigger.new){if(accountSet.Is_Outbound_Record_Typed__c == false ){if(error == false && Trigger.New.size() <= 10 ){String phoneNo ; if(sms.get(accountSet.Outbound_Number_Field__c ) != \'\' && sms.get(accountSet.Outbound_Number_Field__c ) !=Null){System.debug(\'Testing Check:-\' + sms.get(accountSet.Outbound_Number_Field__c )); If(string.valueof(sms.get(accountSet.Outbound_Number_Field__c )).substring(0,1) == \'+\'){phoneNo = string.valueof(sms.get(accountSet.Outbound_Number_Field__c )); }else{phoneNo = \'+\' + string.valueof(sms.get(accountSet.Outbound_Number_Field__c ));}}if(phoneNo != null && smsPhoneId != null){try{  telerivetSmsSending.sendResponse(phoneNo , string.valueof(sms.get(accountSet.Outbound_Msg_Text_Field__c )) , smsUrlPost , smsApiKey , smsPhoneId , smsStatusUrl , accountSet.Outbound_Object_Name__c , sms.Id  );  system.debug(\'=================Sending Message : FROM CODE A\');}catch(Exception ex){System.debug(ex); error = true ;query = query + \'Id = \\\\\'\' + sms.Id + \'\\\\\' or \';}} }else{System.debug(\'==================BATCHING SMSES.\');system.Debug(\'==================The query is : \' +query); query = query + \'Id = \\\\\'\' + sms.Id + \'\\\\\' or \';}}}system.debug(\'The query is : \' + query);if (query !=\'\'){ system.debug(\'=================Sending Message testing : \' + query);Id batchInstanceId = Database.executeBatch(new telerivetOutboundSmsController(query , accountSet ), 10); }}}' ;           
                
                if(outsmsisRT == true ){
                    
                    body ='';
                    body = 'trigger '+timestamp+' on '+ outsmsObj  +' (after insert) {  Integer count = 0;  string query = \'\';  Map<string, string> mapRecordTypeId = new Map<string, string>();  boolean error = false;  public List<Telerivet_Tracking__c> smsTracker = new List<Telerivet_Tracking__c>();  String outObjectName = \'' + outsmsObj + '\';  string smsSettId = \'' + uniqTime  +'\'; Account_Settings__c accountSet = null;  try{ accountSet = [ Select Name , Active__c , API_key__c , Phone_type__c  , Secret_key__c , Project_Id__c ,  Phone_Route_Id__c ,Inbound_Object_Name__c  ,Inbound_Number_Field__c , Inbound_Time_Field__c ,Inbound_Msg_Text_Field__c  ,Outbound_Object_Name__c ,Outbound_Number_Field__c  , Outbound_Time_Field__c ,Outbound_Msg_Text_Field__c , Outbound_Record_Type__c ,Is_Outbound_Record_Typed__c , Site_URL__c from Account_Settings__c where UID__c = :smsSettId and Outbound_Object_Name__c =:outObjectName LIMIT 1];} catch(exception ex){} String smsApiKey = accountSet.API_key__c ; String smsProjectId = accountSet.Project_Id__c ; string smsPhoneId = accountSet.Phone_Route_Id__c ;string smsUrlPost = \'https://api.telerivet.com/v1/projects/\'+smsProjectId+\'/messages/outgoing\'; string smsStatusUrl =  accountSet.Site_URL__c ; if(accountSet != null  && accountSet.Active__c == true){ system.debug(\'================SITE URL : \' + smsStatusUrl ); if(smsStatusUrl.endsWith(\'/\') ){smsStatusUrl = smsStatusUrl + \'services/apexrest/inboundsms\';}else{smsStatusUrl = smsStatusUrl + \'/services/apexrest/inboundsms\';} if(accountSet.Is_Outbound_Record_Typed__c== true){for(recordType rt : [Select Id , DeveloperName , Name from RecordType where sObjectType = :outObjectName  ]){mapRecordTypeId.put(rt.Id, rt.DeveloperName);} }system.debug(\'================SITE URL : \' + smsStatusUrl );for(' + outsmsObj + '  sms : Trigger.new){if(accountSet.Is_Outbound_Record_Typed__c == true && sms.RecordTypeId == accountSet.Outbound_Record_Type__c ){if(error == false && Trigger.New.size() <= 10 ){String phoneNo ; if(sms.get(accountSet.Outbound_Number_Field__c ) != \'\' && sms.get(accountSet.Outbound_Number_Field__c ) !=Null){System.debug(\'Testing Check:-\' + sms.get(accountSet.Outbound_Number_Field__c )); If(string.valueof(sms.get(accountSet.Outbound_Number_Field__c )).substring(0,1) == \'+\'){phoneNo = string.valueof(sms.get(accountSet.Outbound_Number_Field__c )); }else{phoneNo = \'+\' + string.valueof(sms.get(accountSet.Outbound_Number_Field__c ));}}if(phoneNo != null && smsPhoneId != null){try{  telerivetSmsSending.sendResponse(phoneNo , string.valueof(sms.get(accountSet.Outbound_Msg_Text_Field__c )) , smsUrlPost , smsApiKey , smsPhoneId , smsStatusUrl , accountSet.Outbound_Object_Name__c , sms.Id  );  system.debug(\'=================Sending Message : FROM CODE A\');}catch(Exception ex){System.debug(ex); error = true ;query = query + \'Id = \\\\\'\' + sms.Id + \'\\\\\' or \';}} }else{System.debug(\'==================BATCHING SMSES.\');system.Debug(\'==================The query is : \' +query); query = query + \'Id = \\\\\'\' + sms.Id + \'\\\\\' or \';}}}system.debug(\'The query is : \' + query);if (query !=\'\'){ system.debug(\'=================Sending Message testing : \' + query);Id batchInstanceId = Database.executeBatch(new telerivetOutboundSmsController(query , accountSet ), 10); }}}' ;           
                }
                triggerHandle trg = new triggerHandle( outsmsObj , timestamp , body );
                trg.createApexTrigger();
                
                
                if(trg.error == false){
                    triggerId = trg.oid ;
                    
                }
                else{
                    ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.Error,'An error occourred during setup, please contact Support for more information.' + trg.statusMessage));        
                    return null;
                }
                
                if(isEditing == true){
                                    
                editAcc.API_key__c = apikey ; 
                editAcc.Phone_type__c = phoneType ; 
                editAcc.Secret_key__c = secret  ;
                editAcc.Project_Id__c = projId  ; 
                editAcc.Is_Inbound_Record_Typed__c = insmsisRT ;
                editAcc.Inbound_Record_Type__c = inRt ;
                editAcc.Inbound_Object_Name__c = insmsObj ;
                editAcc.Inbound_Number_Field__c = insmsNum ;
                editAcc.Inbound_Time_Field__c = insmsTime ;
                editAcc.Inbound_Msg_Text_Field__c = insmsText ;
                editAcc.Inbound_Out_Number_Field__c = insmsONum ;
                
                editAcc.Is_Outbound_Record_Typed__c = outsmsisRT ; 
                editAcc.Outbound_Record_Type__c = outRt ;
                editAcc.Outbound_Object_Name__c = outsmsObj ;
                editAcc.Outbound_Number_Field__c = outsmsNum ; 
                editAcc.Outbound_Time_Field__c =outsmsTime  ;
                editAcc.Outbound_Msg_Text_Field__c =outsmsText ;
                editAcc.Outbound_Out_Number_Field__c = outsmsONum;
                editAcc.Phone_Route_Id__c = senderPhoneRouteId ;
                editAcc.UID__c = uniqTime   ;
                editAcc.T_Asset__c = triggerId ;
    
                
                database.update( editAcc, false);   
                acc = editAcc;                
                

           }
           else{     
                acc = new Account_Settings__c(Active__c = False, API_key__c = apikey , Phone_type__c = phoneType , Secret_key__c = secret  , Project_Id__c= projId   , 
                Is_Inbound_Record_Typed__c = insmsisRT ,Inbound_Record_Type__c = inRt ,  Inbound_Object_Name__c = insmsObj ,Inbound_Number_Field__c = insmsNum , 
                Inbound_Time_Field__c = insmsTime ,Inbound_Msg_Text_Field__c = insmsText ,Inbound_Out_Number_Field__c = insmsONum,
                
                Is_Outbound_Record_Typed__c = outsmsisRT , Outbound_Record_Type__c = outRt , Outbound_Object_Name__c = outsmsObj ,
                Outbound_Number_Field__c = outsmsNum, Outbound_Time_Field__c =outsmsTime  ,Outbound_Msg_Text_Field__c =outsmsText ,Outbound_Out_Number_Field__c = outsmsONum,
                Phone_Route_Id__c = senderPhoneRouteId , T_Asset__c = triggerId , C_Asset__c = '' , Site_URL__c =siteUrl , UID__c = uniqTime   );
                
                database.insert( acc , false);
           }
                
                
                ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.confirm,'Settings have been Saved!')); 
    
                step = 0;
                
                return null ; 
         
                
        }  
        
   
}


Public pagereference saveActivate(){

        if(insmsObj  == '' || insmsObj  == '--None--'){
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.Warning,'Please select a valid Inbound SMS object!'));  
            return null ;                            
        }
        else if( ( insmsRT == '' || insmsRT == null ) && insmsisRT == true){
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.Warning,'Please select a valid RecordType for the object!'));  
            return null ;                            
        }
        else if( insmsObj == outsmsObj && insmsisRT == false && outsmsisRT == false ){
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.Warning,'You have selected the same Object for Inbound and Outbound Sms, we recommend you to use a RecordType for any one or distinct RecordTypes for both.'));        
            return null ;      
        }
        else if( insmsObj == outsmsObj && insmsisRT == true && outsmsisRT == true && insmsRT == outsmsRT ){
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.Warning,'You have selected the same Object and RecordType for Inbound and Outbound Sms, we recommend you to seperate them with different RecordType.'));        
            return null ;      
        }
        else if(insmsTime == insmsNum || insmsTime ==  insmsText || insmsText == insmsNum || insmsONum == insmsTime || insmsONum == insmsNum || insmsONum ==insmsText  ){
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.Warning,'Two field values cannot be the same!'));   
            return null ;      
        }
        else{    
        
            String senderPhoneRouteId ; 
            String inRt;
            String outRt ; 
            
            if(insmsisRT){
                inRt = insmsRT ;
            }
            if(outsmsisRT ){
                outRt = outsmsRT ; 
            }
            
            if(phoneType =='phone'){
                senderPhoneRouteId = phoneId;
            }    
            else{
                senderPhoneRouteId = routeid;    
            }
            
            
           if(isEditing == true){
                
                    triggerHandle delTrg = new triggerHandle();
                    delTrg.deleteApexTrigger( editAcc.T_Asset__c  , UserInfo.getSessionId());    
                    
                    if(delTrg.error == true){
                        ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.Error,'An error occourred during setup, please contact Support for more information.' + delTrg.statusMessage));        
                        return null;
                    }                    
                }
                                              
                string triggerId ='';
                
                string uniqTime = String.valueof(datetime.now().day()) + String.valueof(datetime.now().Month()) + String.valueof(datetime.now().Year()) + String.valueof(datetime.now().Hour()) + String.valueof(datetime.now().Minute()+ String.valueof(datetime.now().Second()));
                string timestamp = 'trgSendSms' +  uniqTime ;
                string body = 'trigger '+timestamp+' on '+ outsmsObj  +' (after insert) {  Integer count = 0;  string query = \'\';  Map<string, string> mapRecordTypeId = new Map<string, string>();  boolean error = false;  public List<Telerivet_Tracking__c> smsTracker = new List<Telerivet_Tracking__c>();  String outObjectName = \'' + outsmsObj + '\';  string smsSettId = \'' + uniqTime +'\'; Account_Settings__c accountSet = null;  try{ accountSet = [ Select Name , Active__c , API_key__c , Phone_type__c  , Secret_key__c , Project_Id__c ,  Phone_Route_Id__c ,Inbound_Object_Name__c  ,Inbound_Number_Field__c , Inbound_Time_Field__c ,Inbound_Msg_Text_Field__c  ,Outbound_Object_Name__c ,Outbound_Number_Field__c  , Outbound_Time_Field__c ,Outbound_Msg_Text_Field__c , Outbound_Record_Type__c ,Is_Outbound_Record_Typed__c , Site_URL__c from Account_Settings__c where UID__c = :smsSettId and Outbound_Object_Name__c =:outObjectName LIMIT 1];} catch(exception ex){} String smsApiKey = accountSet.API_key__c ; String smsProjectId = accountSet.Project_Id__c ; string smsPhoneId = accountSet.Phone_Route_Id__c ;string smsUrlPost = \'https://api.telerivet.com/v1/projects/\'+smsProjectId+\'/messages/outgoing\'; string smsStatusUrl =  accountSet.Site_URL__c ; if(accountSet != null  && accountSet.Active__c == true){ system.debug(\'================SITE URL : \' + smsStatusUrl ); if(smsStatusUrl.endsWith(\'/\') ){smsStatusUrl = smsStatusUrl + \'services/apexrest/inboundsms\';}else{smsStatusUrl = smsStatusUrl + \'/services/apexrest/inboundsms\';} if(accountSet.Is_Outbound_Record_Typed__c== true){for(recordType rt : [Select Id , DeveloperName , Name from RecordType where sObjectType = :outObjectName  ]){mapRecordTypeId.put(rt.Id, rt.DeveloperName);} }system.debug(\'================SITE URL : \' + smsStatusUrl );for(' + outsmsObj + '  sms : Trigger.new){if(accountSet.Is_Outbound_Record_Typed__c == false ){if(error == false && Trigger.New.size() <= 10 ){String phoneNo ; if(sms.get(accountSet.Outbound_Number_Field__c ) != \'\' && sms.get(accountSet.Outbound_Number_Field__c ) !=Null){System.debug(\'Testing Check:-\' + sms.get(accountSet.Outbound_Number_Field__c )); If(string.valueof(sms.get(accountSet.Outbound_Number_Field__c )).substring(0,1) == \'+\'){phoneNo = string.valueof(sms.get(accountSet.Outbound_Number_Field__c )); }else{phoneNo = \'+\' + string.valueof(sms.get(accountSet.Outbound_Number_Field__c ));}}if(phoneNo != null && smsPhoneId != null){try{  telerivetSmsSending.sendResponse(phoneNo , string.valueof(sms.get(accountSet.Outbound_Msg_Text_Field__c )) , smsUrlPost , smsApiKey , smsPhoneId , smsStatusUrl , accountSet.Outbound_Object_Name__c , sms.Id  );  system.debug(\'=================Sending Message : FROM CODE A\');}catch(Exception ex){System.debug(ex); error = true ;query = query + \'Id = \\\\\'\' + sms.Id + \'\\\\\' or \';}} }else{System.debug(\'==================BATCHING SMSES.\');system.Debug(\'==================The query is : \' +query); query = query + \'Id = \\\\\'\' + sms.Id + \'\\\\\' or \';}}}system.debug(\'The query is : \' + query);if (query !=\'\'){ system.debug(\'=================Sending Message testing : \' + query);Id batchInstanceId = Database.executeBatch(new telerivetOutboundSmsController(query , accountSet ), 10); }}}' ;           
                
                if(outsmsisRT == true ){
                    
                    body ='';
                    body = 'trigger '+timestamp+' on '+ outsmsObj  +' (after insert) {  Integer count = 0;  string query = \'\';  Map<string, string> mapRecordTypeId = new Map<string, string>();  boolean error = false;  public List<Telerivet_Tracking__c> smsTracker = new List<Telerivet_Tracking__c>();  String outObjectName = \'' + outsmsObj + '\';  string smsSettId = \'' + uniqTime  +'\'; Account_Settings__c accountSet = null;  try{ accountSet = [ Select Name , Active__c , API_key__c , Phone_type__c  , Secret_key__c , Project_Id__c ,  Phone_Route_Id__c ,Inbound_Object_Name__c  ,Inbound_Number_Field__c , Inbound_Time_Field__c ,Inbound_Msg_Text_Field__c  ,Outbound_Object_Name__c ,Outbound_Number_Field__c  , Outbound_Time_Field__c ,Outbound_Msg_Text_Field__c , Outbound_Record_Type__c ,Is_Outbound_Record_Typed__c , Site_URL__c from Account_Settings__c where UID__c = :smsSettId and Outbound_Object_Name__c =:outObjectName LIMIT 1];} catch(exception ex){} String smsApiKey = accountSet.API_key__c ; String smsProjectId = accountSet.Project_Id__c ; string smsPhoneId = accountSet.Phone_Route_Id__c ;string smsUrlPost = \'https://api.telerivet.com/v1/projects/\'+smsProjectId+\'/messages/outgoing\'; string smsStatusUrl =  accountSet.Site_URL__c ; if(accountSet != null  && accountSet.Active__c == true){ system.debug(\'================SITE URL : \' + smsStatusUrl ); if(smsStatusUrl.endsWith(\'/\') ){smsStatusUrl = smsStatusUrl + \'services/apexrest/inboundsms\';}else{smsStatusUrl = smsStatusUrl + \'/services/apexrest/inboundsms\';} if(accountSet.Is_Outbound_Record_Typed__c== true){for(recordType rt : [Select Id , DeveloperName , Name from RecordType where sObjectType = :outObjectName  ]){mapRecordTypeId.put(rt.Id, rt.DeveloperName);} }system.debug(\'================SITE URL : \' + smsStatusUrl );for(' + outsmsObj + '  sms : Trigger.new){if(accountSet.Is_Outbound_Record_Typed__c == true && sms.RecordTypeId == accountSet.Outbound_Record_Type__c ){if(error == false && Trigger.New.size() <= 10 ){String phoneNo ; if(sms.get(accountSet.Outbound_Number_Field__c ) != \'\' && sms.get(accountSet.Outbound_Number_Field__c ) !=Null){System.debug(\'Testing Check:-\' + sms.get(accountSet.Outbound_Number_Field__c )); If(string.valueof(sms.get(accountSet.Outbound_Number_Field__c )).substring(0,1) == \'+\'){phoneNo = string.valueof(sms.get(accountSet.Outbound_Number_Field__c )); }else{phoneNo = \'+\' + string.valueof(sms.get(accountSet.Outbound_Number_Field__c ));}}if(phoneNo != null && smsPhoneId != null){try{  telerivetSmsSending.sendResponse(phoneNo , string.valueof(sms.get(accountSet.Outbound_Msg_Text_Field__c )) , smsUrlPost , smsApiKey , smsPhoneId , smsStatusUrl , accountSet.Outbound_Object_Name__c , sms.Id  );  system.debug(\'=================Sending Message : FROM CODE A\');}catch(Exception ex){System.debug(ex); error = true ;query = query + \'Id = \\\\\'\' + sms.Id + \'\\\\\' or \';}} }else{System.debug(\'==================BATCHING SMSES.\');system.Debug(\'==================The query is : \' +query); query = query + \'Id = \\\\\'\' + sms.Id + \'\\\\\' or \';}}}system.debug(\'The query is : \' + query);if (query !=\'\'){ system.debug(\'=================Sending Message testing : \' + query);Id batchInstanceId = Database.executeBatch(new telerivetOutboundSmsController(query , accountSet ), 10); }}}' ;           
                }
                triggerHandle trg = new triggerHandle( outsmsObj , timestamp , body );
                trg.createApexTrigger();
                
                
                if(trg.error == false){
                    triggerId = trg.oid ;
                    
                }
                else{
                    ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.Error,'An error occourred during setup, please contact Support for more information.' + trg.statusMessage));        
                    return null;
                }
                
                if(isEditing == true){
                          
        
                        
                        if(editAcc.Active__c == true)
                        {
                           editAcc.Active__c = false ; 
                        }
                        else {
                            editAcc.Active__c = true ; 
                        }
                               
                                                    
                        editAcc.API_key__c = apikey ; 
                        editAcc.Phone_type__c = phoneType ; 
                        editAcc.Secret_key__c = secret  ;
                        editAcc.Project_Id__c = projId  ; 
                        editAcc.Is_Inbound_Record_Typed__c = insmsisRT ;
                        editAcc.Inbound_Record_Type__c = inRt ;
                        editAcc.Inbound_Object_Name__c = insmsObj ;
                        editAcc.Inbound_Number_Field__c = insmsNum ;
                        editAcc.Inbound_Time_Field__c = insmsTime ;
                        editAcc.Inbound_Msg_Text_Field__c = insmsText ;
                        editAcc.Inbound_Out_Number_Field__c = insmsONum ;
                        
                        editAcc.Is_Outbound_Record_Typed__c = outsmsisRT ; 
                        editAcc.Outbound_Record_Type__c = outRt ;
                        editAcc.Outbound_Object_Name__c = outsmsObj ;
                        editAcc.Outbound_Number_Field__c = outsmsNum ; 
                        editAcc.Outbound_Time_Field__c =outsmsTime  ;
                        editAcc.Outbound_Msg_Text_Field__c =outsmsText ;
                        editAcc.Outbound_Out_Number_Field__c = outsmsONum;
                        editAcc.Phone_Route_Id__c = senderPhoneRouteId ;
                        editAcc.UID__c = uniqTime   ;
                        editAcc.T_Asset__c = triggerId ;
            
                        
                        database.update( editAcc, false);   
                        acc = editAcc;                
                        
        
                   }
                   else{     
                        acc = new Account_Settings__c(Active__c = true, API_key__c = apikey , Phone_type__c = phoneType , Secret_key__c = secret  , Project_Id__c= projId   , 
                        Is_Inbound_Record_Typed__c = insmsisRT ,Inbound_Record_Type__c = inRt ,  Inbound_Object_Name__c = insmsObj ,Inbound_Number_Field__c = insmsNum , 
                        Inbound_Time_Field__c = insmsTime ,Inbound_Msg_Text_Field__c = insmsText ,Inbound_Out_Number_Field__c = insmsONum,
                        
                        Is_Outbound_Record_Typed__c = outsmsisRT , Outbound_Record_Type__c = outRt , Outbound_Object_Name__c = outsmsObj ,
                        Outbound_Number_Field__c = outsmsNum, Outbound_Time_Field__c =outsmsTime  ,Outbound_Msg_Text_Field__c =outsmsText ,Outbound_Out_Number_Field__c = outsmsONum,
                        Phone_Route_Id__c = senderPhoneRouteId , T_Asset__c = triggerId , C_Asset__c = '' , Site_URL__c =siteUrl , UID__c = uniqTime   );
                        
                        database.insert( acc , false);
                   }
                        
                        
                        ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.confirm,'Settings have been Saved!')); 
            
                        step = 0;
                        
                        return null ; 
            }
        }  



public pagereference okaygotit(){
       Schema.DescribeSObjectResult result  = Schema.getGlobalDescribe().get('Account_Settings__c').getDescribe(); 
            PageReference pageRef = new PageReference('/' + result.getKeyPrefix());
            pageRef.setRedirect(true);
            return pageRef;

}

public pagereference next(){

    if(step == 1 ){
    
        if(siteUrl =='' ){
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.Warning,'Salesforce site URL cannot be empty!')); 
        }
        else if( siteUrl !='' && (!siteUrl.contains('https://') || !siteUrl.contains('.') || !siteUrl.endsWith('/')) ){
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.Warning,'Salesforce site URL is Invalid, use https and enter the complete URL!')); 
        }
        else if(apikey =='' ){
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.Warning,'API Key cannot be empty!')); 
        }
        else if(projId == ''){
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.Warning,'Project Id cannot be empty!'));                      
        }
        else if( secret == '' ){
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.Warning,'Telerivet secret cannot be empty!'));
                   
     
        }        
        else if(phoneType == '' || phoneType == null){
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.Warning,'Please select sending type Route or Phone!'));
                       
              
        }
        else if(phoneType=='route' && routeId =='') {
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.Warning,'Route Id cannot be empty!'));                    
            
        }
        else if(phoneType=='phone' && phoneId ==''){
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.Warning,'Phone Id cannot be empty!'));
                       
             
        }
        else /*if(projId != '' && secret != '' && apikey  != '' && (phoneType=='route' && routeId !='') && (phoneType=='phone' && phoneId !='') ) */{
            step++;
            
        }       
    }
    else if(step == 2 ){
    
        //outsmsTime outsmsNum outsmsText outsmsObj 
        if(outsmsObj == '' || outsmsObj == '--None--'){
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.Warning,'Please select a valid Outbound SMS object!'));     
                            
        }
        else if( ( outsmsRT == '' || outsmsRT == null ) && outsmsisRT == true){
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.Warning,'Please select a valid RecordType for the object!'));    
                              
        }
        else if(outsmsTime == outsmsNum || outsmsTime ==  outsmsText || outsmsText == outsmsNum || outsmsONum  == outsmsTime || outsmsONum == outsmsNum || outsmsONum == outsmsText  ){
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.Warning,'Two field values cannot be the same!'));  
                        
        }
        else{    
            step++;
        }
    }
    return null ; 
}

public pagereference prev(){

    if(step >1){
        step--;        
    }
    return null;
}

/*
public pagereference deleteSet(){

    Account_Settings__c acc = [select id from Account_Settings__c where Name = :actionRecord ];
    delete acc;
    refreshValues();
    return null;

}*/
public void refreshValues(){
    accountSet  = new List<Account_Settings__c>();
    accountSet = [ Select Name , Active__c , API_key__c , Phone_type__c  , Secret_key__c , Project_Id__c ,  Phone_Route_Id__c ,
            Inbound_Object_Name__c  ,Inbound_Number_Field__c , Inbound_Time_Field__c ,Inbound_Msg_Text_Field__c  ,
            Outbound_Object_Name__c ,Outbound_Number_Field__c  , Outbound_Time_Field__c ,Outbound_Msg_Text_Field__c from Account_Settings__c  ];
            
    if(accountSet.size() >= 1){        
        step = 0; 
    }
    else{
        step = 1 ; 
    }
}

}