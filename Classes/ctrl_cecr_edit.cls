public with sharing class ctrl_cecr_edit {

    Public Page__c objPage {get;set;}
    Public List<Field__c> lstFields {get;set;}
    public string cancelURL {get;set;}
    public string errorText {get;set;}
    public boolean isError {get;set;}
    public boolean isEditing {get;set;}
    public string varDNDOrder {get;set;}
    
    public ctrl_cecr_edit(ApexPages.StandardController controller) {
    
        isEditing = false;     
        
        if( controller.getId() != null ){
            objPage = new Page__c ();
            objPage = [ SELECT Id, Page_Mode__c , Parent_Object_API_Name__c , Record_Type__c , Lookup_Field_API_Name__c, Custom_Button_URL__c, Child_Object_API_Name__c , Order_By_Field__c , Order_By_Null_Handling__c , Order_By_Direction__c ,  ( SELECT Id , Name , Column_Header_Override__c , Input_or_Output__c , Required__c, Field_Order__c   FROM Fields__r  order by Field_Order__c    asc ) FROM Page__c WHERE id = : controller.getId() ];
            
            if(objPage.Fields__r.size() > 0){
                lstFields = new List<Field__c>();
                lstFields = objPage.Fields__r;                
                
            }else{
                lstFields.add( new Field__c());
            }
            

            getlstPageModes();
            getlstSobjectName();
            getlstRecordTypes();
            
            getlstSobjectFields();
            getlstIO();
                            
            getlstDir();
            getlstNullHandle();        
            
            Schema.DescribeSObjectResult result  = Schema.getGlobalDescribe().get('Page__c').getDescribe(); 
            cancelURL = '/' + result.getKeyPrefix() + objPage.id; 
        }
        else{
        
            objPage = new Page__c ();
            lstFields = new List<Field__c>();
            lstFields.add( new Field__c());            
                    
            Schema.DescribeSObjectResult result  = Schema.getGlobalDescribe().get('Page__c').getDescribe(); 
            cancelURL = '/' + result.getKeyPrefix();  
        }      
    }
    
    public List<selectOption> getlstDir(){
    
        List<selectOption> lstTmp = new List<selectOption>();         
        lstTmp.add( new SelectOption('ASC' , 'ASC'));
        lstTmp.add( new SelectOption('DESC' , 'DESC'));
        return lstTmp;    
    }
    
    public List<selectOption> getlstNullHandle(){
        
        List<selectOption> lstTmp = new List<selectOption>(); 
        
        lstTmp.add( new SelectOption('Nulls first' , 'Nulls first'));
        lstTmp.add( new SelectOption('Nulls last' , 'Nulls last'));
        return lstTmp;
    }
    
    public List<selectOption> getlstPageModes(){
    
        List<selectOption> lstTmp = new List<selectOption>(); 
        
        lstTmp.add( new SelectOption('Create new child records' , 'Create new child records'));
        lstTmp.add( new SelectOption('Edit existing child records' , 'Edit existing child records'));
        lstTmp.add( new SelectOption('Create records with no common parent' , 'Create records with no common parent'));
        return lstTmp;
        
   } 
    
   public List<selectOption> getlstIO(){
   
       List<selectOption> lstTmp = new List<selectOption>(); 
        
       lstTmp.add( new SelectOption('Input' , 'Input'));
       lstTmp.add( new SelectOption('Output' , 'Output'));
       
       return lstTmp;
        
   } 
    
    
   public List<SelectOption> getlstSobjectFields(){
         
         try{
                                
                List<SelectOption> options = new List<SelectOption>();
                List<Schema.SObjectField> sss=new list<Schema.SObjectField>();
                if(objPage.Child_Object_API_Name__c != null && objPage.Child_Object_API_Name__c != '' ){
                    Schema.SObjectType gd = Schema.getGlobalDescribe().get(objPage.Child_Object_API_Name__c); 
                    
                    if( gd != null ){
                        Schema.DescribeSobjectResult a11=gd.getDescribe();
                                                  
                        System.debug('all fields'+a11);
                        Map<String, Schema.SObjectField> M = a11.fields.getMap();        
                        
                        for(Schema.SObjectField s1:m.values()){                            
                            Schema.DescribeFieldResult f = M.get(s1.getDescribe().getName()).getDescribe();
                            system.debug('======= TYPE : '+s1+'\n' + f.getType());
                
                            if(f.isUpdateable()){
                                options.add(new SelectOption(s1.getDescribe().getName() ,s1.getDescribe().getLabel()));
                            }
                                            //sss.add(s1);                                    
                        }
                    }
                 }
                 
                 options  = SortSelectOptions.selectOptionSortByLabel(options);
                 if(!options.isEmpty()){
                     options.add( 0 , new SelectOption('' , '--None--'));
                 }else{
                     options.add( new SelectOption('' , '--None--'));
                 }    
                 return options;
         
         }     
         catch(Exception ex){
            errorText = string.valueof(ex) + ex.getStackTraceString();
            isError = true;
             return null ; 
         }
        
    }     
        
    
    
    // GET RECORD TYPES     
    public List<SelectOption> getlstRecordTypes(){
    
        List<SelectOption> options = new List<SelectOption>();
        if(objPage != null && objPage.Parent_Object_API_Name__c != '') {            
            
            Schema.SObjectType gd = Schema.getGlobalDescribe().get(objPage.Parent_Object_API_Name__c); 
            
            if( gd != null){
                Schema.DescribeSobjectResult R = gd.getDescribe();            
                List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
                            
                for(Schema.RecordTypeInfo rtInfo : RT){
                    options.add(new SelectOption( rtInfo.getRecordTypeId() , rtInfo.getName()  ));
                }
            }
        }                
        options  = SortSelectOptions.selectOptionSortByLabel(options);
        if(!options.isEmpty()){
            options.add( 0 , new SelectOption('' , '--None--'));
        }else{
            options.add( new SelectOption('' , '--None--'));
        } 
        return options; 
    }    
    
    // GET ALL SOBJECT IN TE SYSTEM 
    public List<SelectOption> getlstSobjectName(){
        try{  
            List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();   
             
            List<SelectOption> options = new List<SelectOption>();
            //options.add(new SelectOption('','--None--'));   
          
            map<string , string> mapTemp = SortSelectOptions.fillNotNeededObj();
            
            for(Schema.SObjectType f : gd)
            {
                Schema.DescribeSObjectResult d = f.getDescribe();
                system.debug('======= MAP VALUES : ' +  d.fields.getmap() );
                
                string apiNameObj = f.getDescribe().getName();
                String labelNameObj = f.getDescribe().getLabel();
                
                if( !mapTemp.containsKey(apiNameObj) ){  
                    options.add(new SelectOption( apiNameObj ,labelNameObj + '  (' + apiNameObj  + ')' ));
                }
            }
            
             options  = SortSelectOptions.selectOptionSortByLabel(options);
             if(!options.isEmpty()){
                 options.add( 0 , new SelectOption('' , '--None--'));
             }else{
                 options.add( new SelectOption('' , '--None--'));
             }    
             return options;
             
         }
         catch(Exception ex){
             errorText = string.valueof(ex);
             isError = true;
             return null ;
         }
          
    } 
    
    public List<Field__c> reOrderList(){
    
        List<Field__c> lstRet = new List<Field__c>();
        
        system.debug('=========== Main List size ' + lstFields + ' ' + lstFields.size());
        
        for(integer i = 1 ; i <= lstFields.size() ; i++){
            lstRet.add( new Field__c()); 
        }
        
        system.debug('=========== Temp List size BS ' + lstRet.size());
        
        for( integer i = 0 ; i < lstFields.size() ; i++){
            system.debug('=========== Setting For at ' + lstFields[i].Field_Order__c);
            lstRet.set( integer.valueOf(lstFields[i].Field_Order__c) , lstFields[i]);
        }
        
        system.debug('=========== Temp List size AS ' + lstRet.size());
        return lstRet;
        
    }
        
    public Map<string,Decimal> saveOrder(){
        Map<string , Decimal> mpRet = new Map<string, Decimal>();
        Decimal counterC = 1 ; 
        
        for( string objStr : varDNDOrder.split('#')){ 
            system.debug('======== Key : ' + objStr + '  Value : '+ counterC);
            mpRet.put(objStr , counterC);
            counterC++;
        }    
        return mpRet;
    } 
    
    public pagereference save(){
    
        try{                   
            upsert objPage ;
             
            Map<string, Decimal> mpSaveOrder = new Map<string, Decimal>();
            mpSaveOrder = saveOrder();            
            for(Field__c objField : lstFields ){
                objField.Page__c = objPage.id;      
                integer tmpV = integer.valueof(objField.Field_Order__c);
                system.debug('========= FIELD ORDER VALUE = ' + tmpV);
                objField.Field_Order__c = mpSaveOrder.get(string.valueof(tmpV));
                system.debug('========= FIELD ORDER VALUE = ' + objField.Field_Order__c);
                system.debug('========= FIELD LABEL = ' + objField.Column_Header_Override__c);                
            }
            
            upsert lstFields ;
            
            Schema.DescribeSObjectResult result  = Schema.getGlobalDescribe().get('Page__c').getDescribe(); 
            PageReference pageRef = new PageReference('/' + objPage.id);
            pageRef.setRedirect(true);
            
            return pageRef;  
            
                  
        }
        catch(exception ex){
            errorText = string.valueof(ex) + ex.getStacktracestring();
            isError = true;
            
        }
        
        return null;
        
    }
        
    public pagereference addRow(){   
    
        List<Field__c> lstFields2 = reOrderList();
        lstFields = new List<Field__c>();
        lstFields = lstFields2 ;
        lstFields.add( new Field__c());
        return null;    
    }
        
    public pagereference deleteRow(){
    
        try{
            decimal tmpOrderDel ;
            system.debug('###--intIndex--Call--');
            integer intIndex = integer.ValueOf(ApexPages.CurrentPage().GetParameters().Get('indexDelete'));
            system.debug('###--intIndex--'+intIndex + ' : list size : ' + lstFields.size());
                
            if(intIndex != null) {
                tmpOrderDel = lstFields[intIndex].Field_Order__c ;
                //lstFields.remove(intIndex);
                List<Field__c> lstFields2 = reOrderList();
                lstFields = new List<Field__c>();
                lstFields = lstFields2 ;
                
                for(integer i = 0 ; i < lstFields.size() ; i++){
                    
                    if(tmpOrderDel  == lstFields[i].Field_Order__c ){
                        lstFields.remove(i);
                    }
                }
                
            }else{
                system.debug('###--intIndex--is null : '+intIndex);
            }
            return null;
        }
        catch(Exception ex){
             errorText = string.valueof(ex);
             isError = true;
             return null ; 
        }
    
    }
    
    

}