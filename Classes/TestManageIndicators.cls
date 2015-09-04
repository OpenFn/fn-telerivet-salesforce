@IsTest
Private Class TestManageIndicators{
    Static testmethod void TestManageIndicators(){
        
        Project__c objProj = new Project__c (Name = 'test1');
        insert objProj;
        
        Catalog_Indicator__c objCatIndicator = new Catalog_Indicator__c();
        objCatIndicator.Active__c = true ;
        objCatIndicator.Type__c = 'Custom';
        objCatIndicator.Aim__c = 'increase';
        objCatIndicator.Data_Type__c = 'Number';
        objCatIndicator.Technical_Area_s__c = 'Child Health';
        objCatIndicator.Description__c = 'abc';
        objCatIndicator.Indicator_Source__c = 'MICS';
        insert objCatIndicator;
        
        Indicator__c objIndicator = new Indicator__c();
        objIndicator.Project__c = objProj.id;
        objIndicator.Catalog_Indicator__c = objCatIndicator.id;
        insert objIndicator;
        
        Reporting_Period__c objReport = new Reporting_Period__c();
        objReport.Project__c = objProj.id;
        objReport.Report_on_Indicators__c = true;
        insert objReport;
        
        Geographical_Area__c objGArea = new Geographical_Area__c(Type__c = 'Country');
        insert objGArea;
        
        Area__c objArea = new Area__c();
        objArea.Project_Grant__c = objProj.id;
        objArea.Geographical_Area__c = objGArea.id;
        objArea.Use_For_Reporting__c= true;
        insert objArea;
        
        ApexPages.currentPage().getParameters().put('id',objProj.id);
         
        ApexPages.StandardController controller = new ApexPages.StandardController(objProj); 
        ManageIndicators objManageIndicators = New ManageIndicators(controller);
        objManageIndicators.objCatalogIndicator.Type__c = 'Custom';
        objManageIndicators.objCatalogIndicator.Aim__c = 'increase';
        objManageIndicators.objCatalogIndicator.Data_Type__c = 'Number';
        objManageIndicators.objCatalogIndicator.Technical_Area_s__c = 'Child Health';
        objManageIndicators.objCatalogIndicator.Description__c = 'abc';
        objManageIndicators.objCatalogIndicator.Indicator_Source__c = 'MICS';
        
        objManageIndicators.blnAddIndicatorDisplay = true;
        objManageIndicators.IndicatorsToDisplay = objCatIndicator.id;
        objManageIndicators.getArea();
        objManageIndicators.SearchCatalogIndicator();
        objManageIndicators.AddIndicators();
        objManageIndicators.AddNewIndicator();
        
        /*ApexPages.currentPage().getParameters().put('CreateIndex','0');
        objManageIndicators.AddNewCatalogIndicator();*/
        
        String strOrderByText = '';
        objManageIndicators.LoadMainData(strOrderByText);
        objManageIndicators.sortDirection = 'ASC';
        objManageIndicators.sortExpression = 'ASC';
        objManageIndicators.sortExpressionMainGrid= 'ASC';
        objManageIndicators.setSortDirection('ASC');
        objManageIndicators.setSortDirectionMainGrid('ASC');
        String str1 = objManageIndicators.getSortDirectionMainGrid();
        String str2 = objManageIndicators.getSortDirection();
        //objManageIndicators.sortDataMainGrid();
        objManageIndicators.sortData();
        
        ManageIndicators.WrpIndicators objWrp = new ManageIndicators.WrpIndicators();
        objWrp.objIndicator = objIndicator;
        objWrp.blnEdit = true;
        objWrp.blnAddIndicator = true;
        objWrp.strType = 'Custom';
        
        objManageIndicators.lstWrpIndicators.add(objWrp);
        
        ApexPages.currentPage().getParameters().put('EditIndex','0');
        objManageIndicators.EditIndicator();
        
        ApexPages.currentPage().getParameters().put('CreateIndex','0');
        //objManageIndicators.MakeStandardIndicator();
        
        ApexPages.currentPage().getParameters().put('SaveIndex','0');
        ApexPages.currentPage().getParameters().put('SaveIndex1','0');
        objManageIndicators.SaveIndicator();
        
        ApexPages.currentPage().getParameters().put('CancelIndex','0');
        objManageIndicators.CancelIndicator();
        
        ApexPages.currentPage().getParameters().put('searchString','');
        objManageIndicators.RelatedIndicatorItem();
        
        objManageIndicators.getLoglevel();
        objManageIndicators.getThematic();
        ApexPages.currentPage().getParameters().put('DeleteIndex','0');
        objManageIndicators.DeleteIndicator();
        
        objManageIndicators.SortType();
        objManageIndicators.sortDirectionMainGrid = 'DESC';
        objManageIndicators.SortType();
    }
}