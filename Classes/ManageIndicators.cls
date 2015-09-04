Public class ManageIndicators{
    
    Public Id ProjectId {get;set;}
    public Set<Id> setCatalogIndicatorIDs {get;set;}
    Public String IndicatorsToDisplay{get;set;}
    Public Catalog_Indicator__c objCatalogIndicator {get;set;}
    Public Indicator__c objIndicatorNew {get;set;}
    Public List<Catalog_Indicator__c> lstCatalogIndicator {get;set;}
    Public List<Indicator__c> lstIndicator {get;set;}
    Public List<WrpIndicators> lstWrpIndicators {get;set;}
    Public string StrIndicatorId {get;set;}
    Public Boolean blnAddIndicatorDisplay {get;set;}
    Public String strGeoType{get;set;}
    
    Public List<SelectOption> lstAvailable{get;set;}
    Public List<SelectOption> lstThematicAreaAvailable{get;set;}
    Public List<SelectOption> lstSelected{get;set;}
    Public List<SelectOption> lstThematicAreaSelected{get;set;}
    Public String strPillar{get;set;}
    
    Public String strThematic{get;set;}
    Public List<SelectOption> lstThematic{get;set;}
    public list<Log_Item__c> lstLog_Item{get;set;}
   
    public boolean blnShowPopup{get;set;}
    public Log_Item__c objLogItem {get;set;}
    public List<Indicator__c> lstRelatedIndicator{get;set;}    
    Set<String> originalvalues = new Set<String>();
    public string searchString{get;set;}
    public boolean blnShowRelatedIndicatorPopup {get;set;}
    public String IndicatorID  = '';
    //Default Constructor
    Public ManageIndicators(ApexPages.StandardController controller) {
        if(ApexPages.currentPage().getParameters().get('id') != null){
            ProjectId = ApexPages.currentPage().getParameters().get('id');
        }
        lstLog_Item = new List<Log_Item__c>();
        strPillar = '';
        strThematic = '';
        searchString = '';
        blnShowRelatedIndicatorPopup  = false;
        lstAvailable= new List<SelectOption>();
        lstThematicAreaAvailable = new List<SelectOption>();
        lstSelected= new List<SelectOption>();
        lstThematicAreaSelected = new List<SelectOption>();
        objLogItem = new Log_Item__c();
        objLogItem.Indicator_Level__c = null;
        
        
        blnAddIndicatorDisplay = false;
        objCatalogIndicator = new Catalog_Indicator__c();
        lstCatalogIndicator = new List<Catalog_Indicator__c>();
        lstIndicator = new List<Indicator__c>();
        
        StrIndicatorId = '';
        
        Schema.DescribeFieldResult fieldResult = Catalog_Indicator__c.Pillar__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            lstAvailable.add(new SelectOption(f.getLabel(),f.getLabel()));
        }  
        
        Schema.DescribeFieldResult fieldResult1 = Catalog_Indicator__c.Technical_Area_s__c.getDescribe();
        List<Schema.PicklistEntry> ple1 = fieldResult1.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple1)
        {
            lstThematicAreaAvailable.add(new SelectOption(f.getLabel(),f.getLabel()));
        }      
            
                 
        
        
        BindIndicatorData();
        CatalogItem();
        lstCatalogIndicator = new List<Catalog_Indicator__c>();
        blnShowPopup = false;
        System.debug('lstWrpIndicators+' +lstWrpIndicators);
        
        //SearchCatalogIndicator();
        //SortType();
    }
    
    Public void CatalogItem(){
        lstLog_Item = new List<Log_Item__c>();
        
        String SelectedLogLevel = '';
        
        if(ApexPages.currentPage().getParameters().get('SelectedLogLevel') != null){
            SelectedLogLevel = ApexPages.currentPage().getParameters().get('SelectedLogLevel');
        }
        
        if(ProjectId != null){
            String strQuery = 'Select id,Name,Description__c,Indicator_Level__c,Code__c from Log_Item__c where Project__c =:ProjectId';
            
            if(SelectedLogLevel != '' && SelectedLogLevel != null){
                objLogItem.Indicator_Level__c = SelectedLogLevel;
            }
            
            if(objLogItem.Indicator_Level__c != null  && objLogItem.Indicator_Level__c != ''  && objLogItem.Indicator_Level__c !='--None--'){
                strQuery += ' and Indicator_Level__c = \'' + objLogItem.Indicator_Level__c + '\'';
            }

            if(objLogItem.Description__c != null &&  objLogItem.Description__c  !=''){
                strQuery += ' and Description__c like \'%'+ objLogItem.Description__c +'%\'';
            }
            
            System.debug(strQuery);
            lstLog_Item =  Database.Query(strQuery);           
            blnShowPopup = true;
        }
    }
    
    Public void RelatedIndicatorItem(){
        searchString = System.currentPageReference().getParameters().get('searchString');
        IndicatorID = System.currentPageReference().getParameters().get('IndicatorID');
        bindRelatedIndicatorItem();
    }
    
    public void bindRelatedIndicatorItem(){
        lstRelatedIndicator = new List<Indicator__c>(); 
        String soql = 'select id, Name, Indicator_Level__c,Description__c from Indicator__c where Project__c =: ProjectId';
        
        if (!String.Isblank(IndicatorID)){
            soql = soql +  ' And id !=: IndicatorID '; 
        }
        if(searchString != '' && searchString != null)
          soql = soql +  ' And name LIKE \'%' + searchString +'%\'';
          
        soql += ' order by Name';
        lstRelatedIndicator = database.query(soql); 
        blnShowRelatedIndicatorPopup  = true;
    }
    
    public List<SelectOption> getLoglevel(){
        List<SelectOption> lstLoglevel = new List<SelectOption>(); 
        
        Set<String> setLog = new Set<string>();
        lstLoglevel.add(new SelectOption('','--None--'));
        for(Log_Item__c  f : [Select Indicator_Level__c ,id,Code__c,Name from Log_Item__c where Project__c =: ProjectId])
        {    
            if(!setLog.contains(f.Indicator_Level__c)){
                lstLoglevel.add(new SelectOption(f.Indicator_Level__c ,f.Indicator_Level__c ));
                setLog.add(f.Indicator_Level__c);
            }
        }
        return lstLoglevel;
    }
    
    public List<SelectOption> getThematic(){
        Schema.DescribeFieldResult fieldResult1 = Indicator__c.Technical_Area_s__c.getDescribe();
        List<Schema.PicklistEntry> ple1 = fieldResult1.getPicklistValues();
        lstThematic = new List<SelectOption>(); 
        lstThematic.add(new SelectOption('','--None--'));
        
        for( Schema.PicklistEntry f : ple1)
        {
            lstThematic.add(new SelectOption(f.getLabel(),f.getLabel()));
        }
        return lstThematic;
    }
    
    /********************************************************************
        Name :  SearchCatalogIndicator
        Purpose : Used for Search Catalog Indicator Records.
    ********************************************************************/
    Public void SearchCatalogIndicator() {
        String searchString = ' where ';
        lstCatalogIndicator = new List<Catalog_Indicator__c>();
        System.debug('@@@objCatalogIndicator='+objCatalogIndicator);
       
        if(objCatalogIndicator.Data_Type__c != null) {
             if(searchString != ' where ')
                searchString += ' and ';
            searchString += 'Data_Type__c = \''+objCatalogIndicator.Data_Type__c +'\'';
        }
        
        
        if(strPillar != ''){
            string[] splittedStr = strPillar.split('#');
            if(searchString != ' where ')
                searchString += ' and ';
            searchString += 'Pillar__c in : splittedStr';
        }


        if(strThematic != null && strThematic != '')
        {
            if(searchString != ' where ')
                searchString += ' and ';
    
            String strOfAreas = strThematic ;
            string[] splittedStr = strOfAreas.split(';');
            System.debug('splittedStr ' + splittedStr );
            searchString += ' (';
            
            for(String strObj : splittedStr){
                searchString += 'Technical_Area_s__c includes (\''+strObj+'\') Or ';
            }
            searchString = searchString.removeEnd('Or ');
            searchString += ') ';
            //searchString += 'Technical_Area_s__c includes (\''+objCatalogIndicator.Technical_Area_s__c+'\')';
        }
        
        if(objCatalogIndicator.Description__c != null)
        {
            if(searchString != ' where ')
                searchString += ' and ';
            searchString += 'Description__c like \'%'+objCatalogIndicator.Description__c+'%\'';
        }
        if(objCatalogIndicator.Indicator_Level__c != null)
        {
             if(searchString != ' where ')
                searchString += ' and ';
            searchString += 'Indicator_Level__c = \''+objCatalogIndicator.Indicator_Level__c +'\'';
        }
        
        if(objCatalogIndicator.Project_That_Created_This_Indicator__c != null)
        {
             if(searchString != ' where ')
                searchString += ' and ';
            searchString += 'Project_That_Created_This_Indicator__c = \''+objCatalogIndicator.Project_That_Created_This_Indicator__c +'\'';
        }
        
        if(strPillar != ''){
            string[] splittedStr = strPillar.split('#');
            if(searchString != ' where ')
                searchString += ' and ';
            searchString += 'Pillar__c in : splittedStr';
        }
        
        if(searchString == ' where ')
            searchString += 'Active__c = true and id not in:setCatalogIndicatorIDs';
        else
            searchString += ' and Active__c = true and id not in:setCatalogIndicatorIDs';
            
       
       System.debug('hdnPillerToAdd@@@@@@@@@@' + strPillar);
        string strQuery = 'select Name,Type__c,Pillar__c ,Indicator_Level__c ,Project_That_Created_This_Indicator__c , Indicator_Source__c, Description__c,Technical_Area_s__c, Data_Type__c, Aim__c, Notes__c from Catalog_Indicator__c'+ searchString;
        System.debug('!@##@$strQuery =='+strQuery);
        lstCatalogIndicator = (List<Catalog_Indicator__c>)Database.Query(strQuery);
        //blnSort = true;
        
    }
    
    /********************************************************************
        Name :  BindIndicatorData
        Purpose : Used for Bind Catalog Indicator and Indicator Records.
    ********************************************************************/
    Public void BindIndicatorData(){
        //blnSort = true;
        lstIndicator = [select Indicator_Source__c,Catalog_Indicator__c,Parent_Indicator__r.name,Parent_Indicator__r.Code__c,Name,Pillar__c ,Indicator_Level__c ,Age_Disaggregation__c ,Geographical_Disaggregation__c,Parent_Indicator__c , Description__c, Reporting_Frequency__c,Technical_Area_s__c, Project__c, Project__r.name,
                            Data_Type__c, Aim__c, Notes__c, Gender_Disaggregation__c,Related_Indicator__c,Related_Indicator__r.Name from Indicator__c where Project__c = : ProjectId];
        
        lstWrpIndicators = new List<WrpIndicators>();
        setCatalogIndicatorIDs = new Set<Id>();
        for(Indicator__c objIndicator : lstIndicator ) {
            system.debug('GeoGrphic:'+objIndicator.Geographical_Disaggregation__c);
            WrpIndicators objWrp = new WrpIndicators();
            objWrp.objIndicator = new Indicator__c();
            objWrp.objIndicator = objIndicator;
            objWrp.blnEdit = false;
            objWrp.strType = 'Custom';
            lstWrpIndicators.add(objWrp);
            if(objIndicator.Catalog_Indicator__c != null)
                setCatalogIndicatorIDs.add(objIndicator.Catalog_Indicator__c);
        }
        
        
        lstCatalogIndicator = [select Type__c,Name, Indicator_Source__c, Description__c, Pillar__c ,Indicator_Level__c,Project_That_Created_This_Indicator__c ,
                                                                Technical_Area_s__c, Data_Type__c, Aim__c, Notes__c from Catalog_Indicator__c where Active__c = true and id not in:setCatalogIndicatorIDs];
        System.debug('lstCatalogIndicator ' + lstCatalogIndicator );
        SortType();
        System.debug('lstCatalogIndicator123 ' + lstCatalogIndicator );        
             
    }
    
    /********************************************************************
        Name :  AddIndicators
        Purpose : Used for create Indicator Records from Catalog Indicator.
    ********************************************************************/
    Public void AddIndicators(){
        system.debug('IndicatorsToDisplay:'+IndicatorsToDisplay);
        Set<String> setCatalogIndicatorId = new Set<String>();
        
        for(string str : IndicatorsToDisplay.split('#'))
        {
             setCatalogIndicatorId.add(str);
        }
        
        List<Catalog_Indicator__c> lstCatalogSelected = new List<Catalog_Indicator__c>([select Type__c,Name,Pillar__c, Indicator_Level__c ,Indicator_Source__c, Description__c, 
                                                            Technical_Area_s__c, Data_Type__c, Aim__c, Notes__c from Catalog_Indicator__c
                                                            where id in : setCatalogIndicatorId]);
        List<Indicator__c> lstIndicatorTemp = new List<Indicator__c>();
        Map<id,String> mapOfType = new Map<id,String>();
        if(lstCatalogSelected != null && lstCatalogSelected.size() > 0){
            for( Catalog_Indicator__c objCatalogSel : lstCatalogSelected){
                Indicator__c objNewIndicator = new Indicator__c(); 
                objNewIndicator.Catalog_Indicator__c = objCatalogSel.id;   
                objNewIndicator.Description__c = objCatalogSel.Description__c;
                objNewIndicator.Notes__c = objCatalogSel.Notes__c  ;
                objNewIndicator.Technical_Area_s__c = objCatalogSel.Technical_Area_s__c;
                objNewIndicator.Data_Type__c = objCatalogSel.Data_Type__c;
                objNewIndicator.Aim__c = objCatalogSel.Aim__c;
                objNewIndicator.Indicator_Source__c = objCatalogSel.Indicator_Source__c;
                objNewIndicator.Project__c = ProjectId;
                objNewIndicator.Pillar__c = objCatalogSel.Pillar__c;
                objNewIndicator.Indicator_Level__c = objCatalogSel.Indicator_Level__c ;
                lstIndicatorTemp.add(objNewIndicator);
                mapOfType.put(objCatalogSel.id,objCatalogSel.Type__c);
            }
        }
        
        if(lstIndicatorTemp.size() > 0) insert lstIndicatorTemp;
        system.debug('lstIndicatorTemp:'+lstIndicatorTemp);
        
        
        List<selectOption> lstop = getArea();
        
        for(Indicator__c objIndicator : lstIndicatorTemp ) {
            WrpIndicators objWrp = new WrpIndicators();
            objWrp.objIndicator =objIndicator;
            if(lstop.size() == 1){
                objWrp.objIndicator.Geographical_Disaggregation__c = '';
            }else{
                objWrp.objIndicator.Geographical_Disaggregation__c = 'Country';
            }
            objWrp.objIndicator.Reporting_Frequency__c = 'Quarterly';
            objWrp.blnEdit = false;
            //objWrp.blnEditUnable = false;
            objWrp.strType = mapOfType.get(objIndicator.Catalog_Indicator__c);
            lstWrpIndicators.add(objWrp);            
            if(objIndicator.Catalog_Indicator__c != null)
                setCatalogIndicatorIDs.add(objIndicator.Catalog_Indicator__c);
        }
        
        //BindIndicatorData();
        SearchCatalogIndicator();
        //SortType();
        system.debug('lstWrpIndicators:'+lstWrpIndicators);
    }
    
    /********************************************************************
        Name :  getArea
        Purpose : Used for create picklist of Geographical Disaggregation for Indicator.
    ********************************************************************/
    Public List<selectOption> getArea(){
        set<String> setOfType = new set<string>();
        List<SelectOption> options = new List<SelectOption>();
        List<Area__c> lstArea = new List<Area__c>([select id,Type__c,Project_Grant__c,Use_For_Reporting__c from Area__c where Project_Grant__c = : ProjectId and Use_For_Reporting__c=: true ]);
       
        options.add(new SelectOption('','--None--'));
        for(Area__c obj: lstArea ){
            if(!setOfType.contains(obj.Type__c)){
                options.add(new SelectOption(obj.Type__c,obj.Type__c));
                setOfType.add(obj.Type__c);
            }
        }
        return options ;
    }
    
    Public Class WrpIndicators{
        Public Indicator__c objIndicator {get;set;}
        Public Boolean blnEdit {get;set;}
        Public String strType {get;set;}
        Public Boolean blnAddIndicator {get;set;}
        Public Boolean blnEditUnable {get;set;}
        Public WrpIndicators(){
            objIndicator = new Indicator__c();
            blnEdit = false;
            blnAddIndicator = false;
            strType = '';
            //blnEditUnable = false;
        }
    }
    
    /********************************************************************
        Name :  EditIndicator
        Purpose : Used for Edit Indicator.
    ********************************************************************/
    Public void EditIndicator(){
        Integer Index = integer.valueOf(ApexPages.currentPage().getParameters().get('EditIndex'));
        system.debug('Index:'+Index);
        lstWrpIndicators[Index].blnEdit = true;
      
        /*blnSort = false;
        integer indexbln=0;
        for(WrpIndicators obj:lstWrpIndicators){
            if(indexbln == Index){
                obj.blnEditUnable = false;
            }else{
                obj.blnEditUnable = true;
            }
            indexbln++;
        }*/
        
    }
    
    /********************************************************************
        Name :  AddNewIndicator
        Purpose : Used for add new row for new Indicator.
    ********************************************************************/
    Public void AddNewIndicator(){
        objIndicatorNew = new Indicator__c(Project__c = ProjectId);      
        
        /*for(WrpIndicators obj:lstWrpIndicators){
            if(obj.blnEdit == false)
                obj.blnEditUnable = true;
        }*/
        
        WrpIndicators objWrp = new WrpIndicators();
        objWrp.strType = 'Custom';
        objWrp.blnEdit = true;
        //objWrp.blnEditUnable = false;
        objWrp.blnAddIndicator = true;
        objWrp.objIndicator=objIndicatorNew;
        lstWrpIndicators.add(objWrp);
        blnAddIndicatorDisplay = true;
       
    }
    
    /********************************************************************
        Name :  MakeStandardIndicator
        Purpose : Used for Make Selected Custom Record of Indicator as Standard and add new Catalog Indicator.
    ********************************************************************/
    /*Public void MakeStandardIndicator(){
        Integer IntIndex = integer.valueOf(ApexPages.currentPage().getParameters().get('CreateIndex'));
        //if(lstWrpIndicators[IntIndex].objIndicator.Parent_Indicator__c == null){
            Catalog_Indicator__c objCatalogIndicator = new Catalog_Indicator__c(Id = lstWrpIndicators[IntIndex].objIndicator.Parent_Indicator__c);
            objCatalogIndicator.Description__c = lstWrpIndicators[IntIndex].objIndicator.Description__c ;
            objCatalogIndicator.Notes__c = lstWrpIndicators[IntIndex].objIndicator.Notes__c ;
            objCatalogIndicator.Technical_Area_s__c = lstWrpIndicators[IntIndex].objIndicator.Technical_Area_s__c ;
            objCatalogIndicator.Project_That_Created_This_Indicator__c = lstWrpIndicators[IntIndex].objIndicator.Project__c ;
            objCatalogIndicator.Data_Type__c= lstWrpIndicators[IntIndex].objIndicator.Data_Type__c;
            objCatalogIndicator.Aim__c= lstWrpIndicators[IntIndex].objIndicator.Aim__c;
            objCatalogIndicator.Indicator_Source__c= lstWrpIndicators[IntIndex].objIndicator.Indicator_Source__c;
            objCatalogIndicator.Type__c = 'Custom';
            objCatalogIndicator.Active__c= true;
            
            upsert objCatalogIndicator;
            lstCatalogIndicator.add(objCatalogIndicator);
        //}
        lstWrpIndicators[IntIndex].objIndicator.Parent_Indicator__c = objCatalogIndicator.id;
        update lstWrpIndicators[IntIndex].objIndicator;
        
        lstWrpIndicators[IntIndex].strType = objCatalogIndicator.Type__c;
        lstWrpIndicators[IntIndex].blnEdit = false;
        lstWrpIndicators[IntIndex].blnAddIndicator = false;
        
        blnAddIndicatorDisplay = false;
        system.debug('objIndicatorNew:'+objIndicatorNew);
        //SearchCatalogIndicator();
        //BindIndicatorData();
    }*/
    
    /********************************************************************
        Name :  SaveIndicator
        Purpose : Used for Create new Indicator or edit existing Indicator.
    ********************************************************************/
    Public void SaveIndicator(){
        Integer IntIndex = null;
        Integer IntIndex1 = null;
        String ParentIndicator = '';
        String SaveRelatedIndicator = '';
        if(ApexPages.currentPage().getParameters().get('SaveIndex') != null)
            IntIndex = integer.valueOf(ApexPages.currentPage().getParameters().get('SaveIndex'));
        if(ApexPages.currentPage().getParameters().get('SaveIndex1') != null)
            IntIndex1 = integer.valueOf(ApexPages.currentPage().getParameters().get('SaveIndex1'));
        if(ApexPages.currentPage().getParameters().get('SaveParentIndicator') != null)
            ParentIndicator = String.valueOf(ApexPages.currentPage().getParameters().get('SaveParentIndicator'));
        if(ApexPages.currentPage().getParameters().get('SaveRelatedIndicator') != null)
            SaveRelatedIndicator = String.valueOf(ApexPages.currentPage().getParameters().get('SaveRelatedIndicator'));
        
        System.debug('ParentIndicator ' + ParentIndicator );
        System.debug('SaveRelatedIndicator ' + SaveRelatedIndicator );
        if(IntIndex != null){
            if(ParentIndicator != ''){
                lstWrpIndicators[IntIndex].objIndicator.Parent_Indicator__c = ParentIndicator;                
            }
            if(SaveRelatedIndicator != ''){
                lstWrpIndicators[IntIndex].objIndicator.Related_Indicator__c = SaveRelatedIndicator ;                
            } 
            if(lstWrpIndicators[IntIndex].objIndicator.Data_Type__c =='Qualitative'){
                lstWrpIndicators[IntIndex].objIndicator.Gender_Disaggregation__c = false;
                lstWrpIndicators[IntIndex].objIndicator.Age_Disaggregation__c = false;
            }
        
            upsert lstWrpIndicators[IntIndex].objIndicator ;
            lstWrpIndicators[IntIndex].blnEdit = false;
            lstWrpIndicators[IntIndex].blnEditUnable = false;
            lstWrpIndicators[IntIndex].blnAddIndicator = false;
            blnAddIndicatorDisplay = false;
        }
        
        if(IntIndex1 != null){
            if(lstWrpIndicators[IntIndex1].objIndicator.id != null) {                
                upsert lstWrpIndicators[IntIndex1].objIndicator ;
            }
            lstWrpIndicators[IntIndex1].blnEdit = true;
        }
        BindIndicatorData();
        SortType();

    }
    
    /********************************************************************
        Name :  DeleteData
        Purpose : Used for Delete Selected Record of Indicator.
    ********************************************************************/
    Public void DeleteIndicator(){
        Integer IntIndex = integer.valueOf(ApexPages.currentPage().getParameters().get('DeleteIndex'));
        
        if(lstWrpIndicators[IntIndex].objIndicator != null){
            if(lstWrpIndicators[IntIndex].objIndicator.id != null ){
                Catalog_Indicator__c objCatalogIndicator = new Catalog_Indicator__c(Id = lstWrpIndicators[IntIndex].objIndicator.Catalog_Indicator__c);
                objCatalogIndicator.Description__c = lstWrpIndicators[IntIndex].objIndicator.Description__c ;
                objCatalogIndicator.Notes__c = lstWrpIndicators[IntIndex].objIndicator.Notes__c ;
                objCatalogIndicator.Technical_Area_s__c = lstWrpIndicators[IntIndex].objIndicator.Technical_Area_s__c ;
                objCatalogIndicator.Data_Type__c= lstWrpIndicators[IntIndex].objIndicator.Data_Type__c;
                objCatalogIndicator.Aim__c= lstWrpIndicators[IntIndex].objIndicator.Aim__c;
                objCatalogIndicator.Indicator_Source__c= lstWrpIndicators[IntIndex].objIndicator.Indicator_Source__c;
                objCatalogIndicator.Type__c = 'Custom';
                objCatalogIndicator.Active__c= true;
                lstCatalogIndicator.add(objCatalogIndicator);
                if(lstWrpIndicators[IntIndex].objIndicator.Catalog_Indicator__c== null){
                   // insert objCatalogIndicator;
                }
                Delete lstWrpIndicators[IntIndex].objIndicator;
            }           
            lstWrpIndicators.remove(IntIndex);
            
        } 
        BindIndicatorData();
        SearchCatalogIndicator();
        
    }
   
    /********************************************************************
        Name :  CancelIndicator
        Purpose : Used for Cancel Editing.
    ********************************************************************/
    Public void CancelIndicator(){
        system.debug('@@@Cancle');
        Integer Index = integer.valueOf(ApexPages.currentPage().getParameters().get('CancelIndex'));
        System.debug('$$$$$$$$$$$$' + Index );
        if(lstWrpIndicators[Index].objIndicator.id != null) lstWrpIndicators[Index].blnEdit = false;
        else lstWrpIndicators.remove(Index);
        //objWrp.blnAddIndicator = false;
        blnAddIndicatorDisplay = false;
        //blnSort = true;
       
        /*integer indexbln=0;
        
        
        integer cnt=0;
        for(WrpIndicators obj:lstWrpIndicators){
            if(obj.blnEdit == true){
                cnt++;
            }
        }
        if(cnt == 0){
            for(WrpIndicators obj:lstWrpIndicators){
                obj.blnEditUnable = false;
            }
        }else{
            if(Index != null){
                lstWrpIndicators[Index].blnEditUnable = true;
            }
        }*/
        BindIndicatorData();
    }
    
    //////////////////////////////     Sorting          ////////////////////////////////
    public String sortDirection;
    public String sortExp;
    public String sortDirectionMainGrid;
    public String sortExpMainGrid;
    Public String Query;
    
    Public Void LoadMainData(String strOrderByText){
        if(strOrderByText==''){
            sortExpMainGrid = 'name';
            sortDirectionMainGrid = 'ASC';            
            strOrderByText = + sortExpMainGrid +' ' +sortDirectionMainGrid;
        }
        lstWrpIndicators = new List<WrpIndicators>();
        //WrpIndicators objw = new WrpIndicators();
        
        List<Indicator__c> lstIndicator  = new List<Indicator__c>();
        String query = 'select Name ,Gender_Disaggregation__c,Pillar__c,Parent_Indicator__c,Parent_Indicator__r.Name, Parent_Indicator__r.Code__c,Age_Disaggregation__c ,Indicator_Level__c ,Catalog_Indicator__r.Type__c,Geographical_Disaggregation__c,Indicator_Source__c, Description__c, Reporting_Frequency__c,Technical_Area_s__c, Project__c, Project__r.name, Data_Type__c, Aim__c, Notes__c,Related_Indicator__c,Related_Indicator__r.Name  from Indicator__c where Project__c = : ProjectId ';
        Query += ' Order By  ' + strOrderByText;
        
        system.debug('Query:'+Query);
        lstIndicator = Database.Query(Query);
        system.debug('lstIndicator :'+lstIndicator );
        
        /*lstWrpIndicators = new List<WrpIndicators>();
        for(Indicator__c objIndicator : lstIndicator) {
            objw  = new WrpIndicators();
            objw.objIndicator =objIndicator;
            if(objw.blnEdit == true)
                objw.blnEdit = true;
            else
                objw.blnEdit = false;
            //objw.blnEdit = false;
            lstWrpIndicators.add(objw);
        }*/
        lstWrpIndicators = new List<WrpIndicators>();
        for(Indicator__c objIndicator : lstIndicator) {
            WrpIndicators objWrp = new WrpIndicators();
            objWrp.objIndicator = new Indicator__c();
            objWrp.objIndicator = objIndicator;
            objWrp.blnEdit = false;
            
            objWrp.strType = 'Custom';
           
            lstWrpIndicators.add(objWrp);
        }
    }
   
    /********************************************************************
        Name :  sortExpression
        Purpose : Used for get set sort expression.
    ********************************************************************/
    
    public String sortExpression{
        get{
            return sortExp;
        }
        set{
            if (value == sortExp)
                sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
            else
                sortDirection = 'ASC';
            sortExp = value;
        }
    }
    
    /********************************************************************
        Name :  getSortDirection
        Purpose : Used for get sort direction
    ********************************************************************/
    
    public String getSortDirection(){
        if (sortExpression == null || sortExpression == '')
            return 'ASC';
        else
            return sortDirection;
    }    
    
    /********************************************************************
        Name :  setSortDirection
        Purpose : Used for set sort direction
    ********************************************************************/
    
    public void setSortDirection(String value){  
        sortDirection = value;
    }
    
    /********************************************************************
        Name :  sortData
        Purpose : Used for sort data.
    ********************************************************************/
    
    Public void sortData(){
        List<Indicator__c> lstIndicatorTemp = new List<Indicator__c>();
        if(String.IsBlank(Query) == false){
            String sortedQuery = '';
            system.debug('$$$$$'+Query);
            if(sortDirection == 'ASC')
                sortedQuery = Query + ' Order By ' + sortExpression  + ' ' + sortDirection;
            else
                sortedQuery = Query + ' Order By ' + sortExpression  + ' ' + sortDirection + ' NULLS LAST';
            lstIndicatorTemp = Database.Query(sortedQuery); 
        }
    }
    
    /********************************************************************
        Name :  sortExpressionMainGrid
        Purpose : Used for get set sort expression.
    ********************************************************************/
    
    public String sortExpressionMainGrid{
        get{
            return sortExpMainGrid;
        }
        set{
            if (value == sortExpMainGrid)
                sortDirectionMainGrid = (sortDirectionMainGrid == 'ASC')? 'DESC' : 'ASC';
            else
                sortDirectionMainGrid = 'ASC';
            sortExpMainGrid = value;
        }
    }
    /********************************************************************
        Name :  getSortDirectionMainGrid
        Purpose : Used for get sort direction
    ********************************************************************/
    
    public String getSortDirectionMainGrid(){
        if (sortExpressionMainGrid == null || sortExpressionMainGrid  == '')
            return 'ASC';
        else
            return sortDirectionMainGrid;
    }    
    
    /********************************************************************
        Name :  setSortDirectionMainGrid
        Purpose : Used for set sort direction
    ********************************************************************/
    
    public void setSortDirectionMainGrid(String value){  
        sortDirectionMainGrid = value;
    }
    
    /********************************************************************
        Name :  sortData
        Purpose : Used for sort data.
    ********************************************************************/
    
    Public void sortDataMainGrid(){
        String strOrderBy = '';
        if(sortDirectionMainGrid == 'ASC')
            strOrderBy = +sortExpressionMainGrid  + ' ' + sortDirectionMainGrid;
        else
            strOrderBy = +sortExpressionMainGrid  + ' ' + sortDirectionMainGrid + ' NULLS LAST';
         
        LoadMainData(strOrderBy);
    }
    
    Public void SortType(){
        
        List<WrpIndicators> lstWrpIndicatorsTemp = new List<WrpIndicators>();
        lstWrpIndicatorsTemp.addall(lstWrpIndicators);
        lstWrpIndicators = new List<WrpIndicators>();
        if(sortDirectionMainGrid == 'ASC'){
            FillSortedData('Custom',lstWrpIndicatorsTemp);
            FillSortedData('Core',lstWrpIndicatorsTemp);
            FillSortedData('Standard',lstWrpIndicatorsTemp);
        }else if (sortDirectionMainGrid == 'DESC'){
            FillSortedData('Standard',lstWrpIndicatorsTemp);
            FillSortedData('Core',lstWrpIndicatorsTemp);
            FillSortedData('Custom',lstWrpIndicatorsTemp);
        }else{
            FillSortedData('Core',lstWrpIndicatorsTemp);
            FillSortedData('Standard',lstWrpIndicatorsTemp);
            FillSortedData('Custom',lstWrpIndicatorsTemp);
        }
        
    }
    Public void FillSortedData(String Type,List<WrpIndicators> lstWrpIndicatorsNew){
        
        if(lstWrpIndicatorsNew != null && lstWrpIndicatorsNew.size() > 0){
            for(WrpIndicators objW : lstWrpIndicatorsNew){
                if(objW.strType == Type){
                    lstWrpIndicators.add(objW);
                }
            }
        }
    }
     //////////////////////////////     Sorting          ////////////////////////////////
}