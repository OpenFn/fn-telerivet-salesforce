@isTest
public class Test_CECR 
{
    testMethod static void Test_Controller() {
    
        Account objAcc = new Account( name = 'Test account');
        insert objAcc;
        
        system.debug('======= ACCOUNT ID : ' + objAcc.id);
        //SETUP PAGE OBJECT
        Page__c objPage = new Page__c();
        
        objPage.Child_Object_API_Name__c = 'Account' ; 
        objPage.Record_Type__c = '';
        objPage.Parent_Record_Name__c = 'Name' ;
        objPage.Parent_Object_API_Name__c = 'Account' ;
        objPage.Page_Mode__c  = 'Create new child records' ; 
        objPage.Order_By_Null_Handling__c='Nulls first';
        objPage.Order_By_Field__c = 'Name' ; 
        objPage.Order_By_Direction__c = 'ASC' ; 
        objPage.Lookup_Field_API_Name__c = 'Parentid' ; 
        
        //INSERT PAGE OBJECT        
        insert objPage ;                
        
        //SETUP LIST OF FIELD OBJECTS
        List<Field__c> objField = new List<Field__c>();
        
        objField.add( new Field__c(
        Name = 'Name',
        Column_Header_Override__c = 'Enter Name',
        Field_Order__c = 1,
        Required__c = True,
        Page__c = objPage.Id ,
        Input_or_Output__c = 'Input')
        );
        
        objField.add( new Field__c(
        Name = 'Description',
        Column_Header_Override__c = 'Enter Description',
        Field_Order__c = 2,
        Required__c = True,
        Page__c = objPage.Id ,
        Input_or_Output__c = 'Input')
        );
        
        //INSERT FIELD LIST
        insert objField ;
        
        Test.startTest();
        
        system.debug('======= TEST : PAGE NAME : ' + objPage );
        
        Test.setCurrentPage(Page.CECR_STD);
        ApexPages.currentPage().getParameters().put('PageId',String.valueOf(objPage.Id));      
        ApexPages.currentPage().getParameters().put('Id',String.valueOf(objAcc.Id));              
        ApexPages.currentPage().getParameters().put('delIndex',String.valueOf('1'));              
        ApexPages.StandardController ctrl = new ApexPages.StandardController(objPage);
        CECR objCtrl = new CECR();
        

        objCtrl.addMultipleRows(1);
        objCtrl.removeRow();               
        objCtrl.QuickSave();  
        objCtrl.SaveClose();
        objCtrl.Cancel();
        
        
    
        Test.stopTest();
        
    
    }
    
}