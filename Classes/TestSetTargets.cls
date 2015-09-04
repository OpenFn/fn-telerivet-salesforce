@IsTest
Private Class TestSetTargets{
    Static testmethod void TestSetTargets(){
        
        Project__c objProj = new Project__c (Name = 'test1');
        insert objProj;
        
        Reporting_Period__c objRPeriod = new Reporting_Period__c(Project__c=objProj.id);
        objRPeriod.Report_Type__c = 'Monthly';
        insert objRPeriod;
       
        Geographical_Area__c objGArea = new Geographical_Area__c(Type__c='Province');
        insert objGArea;
        
        Area__c objArea = new Area__c(Project_Grant__c= objProj.id,Use_For_Reporting__c= true,Geographical_Area__c=objGArea.id);
        insert objArea;
        
        Indicator__c objIndicator = new Indicator__c();
        objIndicator.Project__c = objProj.id;
        objIndicator.Reporting_Frequency__c = 'Monthly';
        objIndicator.Geographical_Disaggregation__c = 'Province';
        objIndicator.Age_Disaggregation__c = true;
        insert objIndicator;
        
        FeedItem objFeedItem = new FeedItem(ParentId=objIndicator.id,Body='abc');
        insert objFeedItem;
        
        Result__c objResult = new Result__c(Indicator__c=objIndicator.id, Reporting_Period__c=objRPeriod.id, Area__c=objArea.id, Age_Category__c = 'Children');
        insert objResult;
        
        ApexPages.currentPage().getParameters().put('id',objRPeriod.id);
         
        ApexPages.StandardController controller = new ApexPages.StandardController(objRPeriod); 
        SetTargerts objAddResults = New SetTargerts(controller);
        
        objAddResults.SelectedArea = objArea.id;
        objAddResults.fillIndicatiorAndResult();
        delete objResult;
        objAddResults.saveResults();
        objAddResults.quickSaveResults();
        
        objAddResults.cancel();
    }
}