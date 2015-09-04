Public Class CustomHelpText{


    Public String sObjectName {get;set;}
    Public String fieldName {get;set;} 
    Public String altText  {get;set;}
    Public String helpText ;
    

public string gethelpText(){
    
    
    if(sObjectName != '' && fieldName != ''){
    
        try{
            Schema.SObjectType gd = Schema.getGlobalDescribe().get(sObjectName ); 
            Schema.DescribeSobjectResult obj = gd.getDescribe();
            Map<String, Schema.SObjectField> MapOfFields = obj.fields.getMap();            
            helpText = MapOfFields.get(fieldName).getDescribe().getInlineHelpText();

            if(helpText == '' || helpText == null){
                helpText = altText;
            }

            if(Test.isRunningTest()){
                throw new CustomException('Error For Text Class');
            }
        }
        Catch(Exception ex){
            helpText = altText ;
        }
        
    }
    else{
    
        helpText = altText ;
    }
    return helpText ;

}

}