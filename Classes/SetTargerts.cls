/********************************
Name: SetResults
Created Date: 06-03-2014
Purpose: User will Create/Edit Result records and Submit this Reporting Period record for Approval.*/

Public class SetTargerts{
    
    Public Id idReportingPeriod {get;set;}
    Public List<wrpIndicatorResult> lstWrpIndicatorResult {get;set;} 
    Public id idOfProject {get;set;}
    Public List<SelectOption> lstRegion {get;set;}
    public String SelectedArea{get;set;}
    public Reporting_Period__c objReportPeriod {get;set;}
    public Set<String> setRegion = new Set<String>();
    public List<String> lstAgeCategory = new List<String>();
    Public map<String,String> MapProjectArea = new Map<String,String>();
    //Default Constructor
    Public SetTargerts(ApexPages.StandardController controller) {
        if(ApexPages.currentPage().getParameters().get('id') != null){
            idReportingPeriod = ApexPages.currentPage().getParameters().get('id');
            
            
            objReportPeriod = (Reporting_Period__c)controller.getRecord();
            idOfProject = [select Project__c from Reporting_Period__c where id=: idReportingPeriod].Project__c;
            
            SelectedArea = '';            
            lstRegion = new List<SelectOption>();
            lstRegion.add(new SelectOption('','-None-'));
            
            if(idOfProject != null){
                 for(Area__c objArea : [Select id,Type__c,Geographical_Area_Name__c  from Area__c where Project_Grant__c =: idOfProject]){
                    if(!setRegion.contains(objArea.Geographical_Area_Name__c)){
                        lstRegion.add(new SelectOption(objArea.id ,objArea.Geographical_Area_Name__c));
                        setRegion.add(objArea.Geographical_Area_Name__c);
                        MapProjectArea.put(objArea.Id,objArea.Type__c);
                    }
                }
            }
            
            Schema.DescribeFieldResult fieldResult = Result__c.Age_Category__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
            for( Schema.PicklistEntry f : ple)
            {
              lstAgeCategory.add(f.getLabel());
            }       
   
   
            fillIndicatiorAndResult();
        }
    }
    
    public void fillIndicatiorAndResult(){
        System.debug('###################' + SelectedArea);
        
        lstWrpIndicatorResult = new List<wrpIndicatorResult>();
        
        if(SelectedArea == null || SelectedArea =='') return;
        
        String strQuery = '';
        strQuery = 'Select id,name,Description__c,Technical_Area_s__c,Parent_Indicator__c,Data_Type__c,Aim__c,Indicator_Source__c,Pillar__c,Indicator_Level__c ,Age_Disaggregation__c,Reporting_Frequency__c,Notes__c,Gender_Disaggregation__c,Geographical_Disaggregation__c,(select id,Age_Category__c ,Area__c,Area__r.Name,Comments__c,Geographical_Area__c,Target__c,Male_Target__c,Female_Target__c,Male_Target_Denominator__c,Male_Target_Percent__c,Female_Target_Denominator__c,Female_Target_Percent__c,Total_Target_Denominator__c,Total_Target_Percent__c,Qualitative_Target__c ,Indicator__c,Project_Name__c,Reporting_Period__c,Result__c,Area__r.Type__c,Area__r.Use_For_Reporting__c,Area__r.Geographical_Area__r.Name,Area__r.Project_Grant__c from Project_Results__r where Reporting_Period__c = \''+  idReportingPeriod + '\' and Area__c =: SelectedArea) from Indicator__c where Project__c= \'' + idOfProject + '\' and Reporting_Frequency__c  = \''+ objReportPeriod.Report_Type__c +'\'';
        
        
        if(SelectedArea != null && SelectedArea !=''){        
           strQuery += ' And Geographical_Disaggregation__c = \'' + MapProjectArea.get(SelectedArea) +'\'';
        }
        
        System.debug(strQuery );
        List<Indicator__c> lstIndicator = database.query(strQuery);
        /*List<Indicator__c> lstIndicator = new List<Indicator__c>();
                
        if(SelectedArea != null && SelectedArea !=''){        
            lstIndicator = [Select id,name,Description__c,Technical_Area_s__c,Data_Type__c,Aim__c,Indicator_Source__c,Pillar__c,Indicator_Level__c,Parent_Indicator__c  
                                                                         ,Age_Disaggregation__c,Reporting_Frequency__c,Notes__c,Gender_Disaggregation__c,Geographical_Disaggregation__c,(select id,Age_Category__c ,Area__c,Area__r.Name,Comments__c,
                                                                         Geographical_Area__c,
                                                                         Target__c,Male_Target__c,Female_Target__c,Male_Target_Denominator__c,Male_Target_Percent__c,
                                                                         Female_Target_Denominator__c,Female_Target_Percent__c,Total_Target_Denominator__c,
                                                                         Total_Target_Percent__c,Qualitative_Target__c ,
                                                                         Indicator__c,Project_Name__c,
                                                                         Reporting_Period__c,Result__c,Area__r.Type__c,
                                                                         Area__r.Use_For_Reporting__c,Area__r.Geographical_Area__r.Name,Area__r.Project_Grant__c
                                                                         from Project_Results__r where Reporting_Period__c =:idReportingPeriod  
                                                                         )
                                                                         from Indicator__c 
                                                                         where Project__c=: idOfProject and Reporting_Frequency__c =: objReportPeriod.Report_Type__c And Geographical_Disaggregation__c =:SelectedArea];
        }else{
            lstIndicator = [Select id,name,Description__c,Technical_Area_s__c,Data_Type__c,Aim__c,Indicator_Source__c,Pillar__c,Indicator_Level__c ,Parent_Indicator__c 
                                                                         ,Age_Disaggregation__c,Reporting_Frequency__c,Notes__c,Gender_Disaggregation__c,Geographical_Disaggregation__c,(select id,Age_Category__c ,Area__c,Area__r.Name,Comments__c,
                                                                         Geographical_Area__c,
                                                                         Target__c,Male_Target__c,Female_Target__c,Male_Target_Denominator__c,Male_Target_Percent__c,
                                                                         Female_Target_Denominator__c,Female_Target_Percent__c,Total_Target_Denominator__c,
                                                                         Total_Target_Percent__c,Qualitative_Target__c ,
                                                                         Indicator__c,Project_Name__c,
                                                                         Reporting_Period__c,Result__c,Area__r.Type__c,
                                                                         Area__r.Use_For_Reporting__c,Area__r.Geographical_Area__r.Name,Area__r.Project_Grant__c
                                                                         from Project_Results__r where Reporting_Period__c =:idReportingPeriod  
                                                                         )
                                                                         from Indicator__c 
                                                                         where Project__c=: idOfProject and Reporting_Frequency__c =: objReportPeriod.Report_Type__c];

        
        }*/
                                                                                                                                                 
        if(lstIndicator.size() > 0) {
            List<Indicator__feed> lstIndicatorfeed= [select id,ParentID from Indicator__feed where parentId IN: lstIndicator];
            Map<ID,Integer> IndicatorsWithFeedItem = new Map<ID,Integer>();
            for(Indicator__feed objIndiWithFeed: lstIndicatorfeed){
                if(IndicatorsWithFeedItem.get(objIndiWithFeed.ParentID)==null){
                    IndicatorsWithFeedItem.Put(objIndiWithFeed.ParentID,1);
                }else{
                    IndicatorsWithFeedItem.Put(objIndiWithFeed.ParentID,IndicatorsWithFeedItem.get(objIndiWithFeed.ParentID)+1);
                }
            }
            
            Map<Id,List<wrpResults>> mapIndicatorResults = new Map<Id,List<wrpResults>>();
            Boolean blnAddNewRow = false;
            for(Indicator__c objIndicator :lstIndicator){
                /*if(((objIndicator.Data_Type__c == 'Percent' && objIndicator.Gender_Disaggregation__c == TRUE && objIndicator.Age_Disaggregation__c == TRUE) ||
                    (objIndicator.Data_Type__c == 'Percent' && objIndicator.Gender_Disaggregation__c == TRUE && objIndicator.Age_Disaggregation__c == False) || 
                    (objIndicator.Data_Type__c == 'Percent' && objIndicator.Gender_Disaggregation__c == FALSE && objIndicator.Age_Disaggregation__c == TRUE) ||
                    (objIndicator.Data_Type__c == 'Qualitative' && objIndicator.Gender_Disaggregation__c == FALSE && objIndicator.Age_Disaggregation__c == FALSE) ||
                    (objIndicator.Data_Type__c == 'Number' && objIndicator.Gender_Disaggregation__c == TRUE && objIndicator.Age_Disaggregation__c == TRUE))
                    && (setRegion.Contains(objIndicator.Geographical_Disaggregation__c)))
                {*/
                //if(setRegion.Contains(objIndicator.Geographical_Disaggregation__c)){
                    List<wrpResults> lstwrpResults = new List<wrpResults>();
                    if(objIndicator.Project_Results__r.size() > 0) {  
                        if(objIndicator.Age_Disaggregation__c == true){
                            //Set<String> SetAgeCategory_Clone = new Set<String>();
                            //SetAgeCategory_Clone = SetAgeCategory;
                            for(String strAgeCategory: lstAgeCategory) {
                                boolean blnflag = false;
        
                                for(Result__c objRes : objIndicator.Project_Results__r){
                                    if(strAgeCategory == objRes.Age_Category__c){
                                        wrpResults objWrpRes = new wrpResults();
                                        objWrpRes.objResult = objRes;
                                        lstwrpResults.add(objWrpRes); 
                                        blnflag = true;
                                        break;
                                    }
                                }
                                
                                if(blnflag == false){
                                    Result__c objRes = new Result__c();
                                    objRes.Reporting_Period__c = idReportingPeriod;
                                    objRes.Indicator__c = objIndicator.id;
                                    objRes.Age_Category__c = strAgeCategory;
                                    wrpResults objWrpRes = new wrpResults();
                                    objWrpRes.objResult = objRes;
                                    objWrpRes.objResult.Area__C = SelectedArea;
                                    objWrpRes.strAreaName = '';
                                    lstwrpResults.add(objWrpRes);
                                }
                            }
                        }else{
                            for(Result__c objRes : objIndicator.Project_Results__r){
                                wrpResults objWrpRes = new wrpResults();
                                objWrpRes.objResult = objRes;
                                lstwrpResults.add(objWrpRes); 
                            }
                        }                        
                    }else{
                        if(objIndicator.Age_Disaggregation__c == true){
                            for(String strAgeCategory: lstAgeCategory) {
                                Result__c objRes = new Result__c();
                                objRes.Reporting_Period__c = idReportingPeriod;
                                objRes.Indicator__c = objIndicator.id;
                                objRes.Age_Category__c = strAgeCategory;
                                wrpResults objWrpRes = new wrpResults();
                                objWrpRes.objResult = objRes;
                                objWrpRes.objResult.Area__C = SelectedArea;
                                objWrpRes.strAreaName = '';
                                lstwrpResults.add(objWrpRes);
                            }
                        }else{
                            Result__c objRes = new Result__c();
                            objRes.Reporting_Period__c = idReportingPeriod;
                            objRes.Indicator__c = objIndicator.id;
                            wrpResults objWrpRes = new wrpResults();
                            objWrpRes.objResult = objRes;
                            objWrpRes.objResult.Area__C = SelectedArea;
                            objWrpRes.strAreaName = '';
                            lstwrpResults.add(objWrpRes);
                        }
                        
                    }
                    
                    if(lstwrpResults.size() > 0){
                        mapIndicatorResults.put(objIndicator.id,lstwrpResults);
                    }
                //}
            }
               
            
            wrpIndicatorResult objWrpIndRes;
            for(Indicator__c objIndicator:lstIndicator){
                /*if(((objIndicator.Data_Type__c == 'Percent' && objIndicator.Gender_Disaggregation__c == TRUE && objIndicator.Age_Disaggregation__c == TRUE) ||
                    (objIndicator.Data_Type__c == 'Percent' && objIndicator.Gender_Disaggregation__c == TRUE && objIndicator.Age_Disaggregation__c == False) || 
                    (objIndicator.Data_Type__c == 'Percent' && objIndicator.Gender_Disaggregation__c == FALSE && objIndicator.Age_Disaggregation__c == TRUE) ||
                    (objIndicator.Data_Type__c == 'Qualitative' && objIndicator.Gender_Disaggregation__c == FALSE && objIndicator.Age_Disaggregation__c == FALSE) ||
                    (objIndicator.Data_Type__c == 'Number' && objIndicator.Gender_Disaggregation__c == TRUE && objIndicator.Age_Disaggregation__c == TRUE))
                    && (setRegion.Contains(objIndicator.Geographical_Disaggregation__c))) 
                {*/
                //if(setRegion.Contains(objIndicator.Geographical_Disaggregation__c)){
                    objWrpIndRes = new wrpIndicatorResult();
                    objWrpIndRes.objIndicator = objIndicator;
                   
                    if(mapIndicatorResults.get(objIndicator.id) != null) {
                        objWrpIndRes.lstwrpResult =mapIndicatorResults.get(objIndicator.id);
                    }
                    else {
                        objWrpIndRes.lstwrpResult = null;
                    }
                    
                    if(IndicatorsWithFeedItem.get(objIndicator.ID)!=null){
                        objWrpIndRes.blnHasPost = true;                     
                        objWrpIndRes.intPostCount = IndicatorsWithFeedItem.get(objIndicator.ID);                     
                    }
                   lstWrpIndicatorResult.add(objWrpIndRes);
                //}
            }  
        }
        System.debug('lstWrpIndicatorResult##########' + lstWrpIndicatorResult);  
    }
    Public PageReference saveResults() {
        try {
            //save all the results.
            saveAllResults();
            return new PageReference('/'+idReportingPeriod);
        }catch(Exception ex) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());  
            ApexPages.addMessage(myMsg);
            return null;
        }
    }
    
    Public void quickSaveResults() {
        try {
            //save all the results.
            saveAllResults();
        }catch(Exception ex) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());  
            ApexPages.addMessage(myMsg);
        }
    }
    
    //Method for save Results.
    Private void saveAllResults(){
        if(lstWrpIndicatorResult != null && lstWrpIndicatorResult.size() > 0) {
            List<Result__c> lstResToSave = new List<Result__c>();
        
                if(lstWrpIndicatorResult != null && lstWrpIndicatorResult.size() > 0){
                    for(wrpIndicatorResult objwrp: lstWrpIndicatorResult) {
        
                        if(objwrp.lstwrpResult!= null && objwrp.lstwrpResult.size() > 0){
                            for(wrpResults objwrpRes : objwrp.lstwrpResult) {
                                lstResToSave.add(objwrpRes.objResult);
                            }
                        }
                    }
                }
            if(lstResToSave.size() > 0){
                upsert lstResToSave;
            } 
            system.debug('lstResToSave:'+lstResToSave);
        }
        
    }
    
    public PageReference cancel() {
        return new PageReference('/'+idReportingPeriod);
    }
    
    //wrapper class for indicators results.
    Public class wrpIndicatorResult {
        Public Indicator__c objIndicator{get;set;}
        Public List<wrpResults> lstwrpResult {get;set;}
        Public Boolean blnHasPost {get;set;}
        Public Integer intPostCount {get;set;}
        Public wrpIndicatorResult(){
            lstwrpResult = new List<wrpResults>();
        }
    }
    
    //wrapper class for Results
    Public class wrpResults {
        Public Result__c objResult {get;set;}
        Public string strAreaName {get;set;}
    }
    
}