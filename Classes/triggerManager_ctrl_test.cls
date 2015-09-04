@isTest
private class triggerManager_ctrl_test
{
  @isTest
  static void itShould()
  {
    
    TriggerHandler__c settingss = new TriggerHandler__c();
    settingss.Name = 'Test';
    settingss.Active__c = true;
    
    Test.setCurrentPage(Page.triggerManager);
    ApexPages.currentPage().getParameters().put('count','0');      
    ApexPages.currentPage().getParameters().put('indexDelete', '0');                         
    //ApexPages.StandardController ctrl = new ApexPages.StandardController();
    triggerManager_ctrl objCtrl = new triggerManager_ctrl();
    objCtrl.addRow();
    objCtrl.lstTriggers[0].Name = 'Test Value';
    objCtrl.save();
    objCtrl.cancel();
    objCtrl.deleteRow();
    
  }
}