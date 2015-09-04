@isTest
private class Test_CECR_Edit {
    
    /*private Test_CECR_Edit(){
        //ctrl_cecr_edit cecr_edit = new ctrl_cecr_edit();
        //ApexPages.StandardController controller = new ApexPages.StandardController(); 
    }*/
    
//===================================================================================================//
    @isTest static void test_method_one() {
        // Implement test code

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
        //insert objPage ;                
        
        //SETUP LIST OF FIELD OBJECTS
        List<Field__c> objField = new List<Field__c>();
        
        //objField.add(new Field__c(Page__c = objPage.Id ));
        
        //INSERT FIELD LIST
        insert objField ;

        Test.startTest();
        
        system.debug('======= TEST : PAGE NAME : ' + objPage );
        
        Test.setCurrentPage(Page.CECR_EDIT);
        //ApexPages.currentPage().getParameters().put('PageId','');      
        //ApexPages.currentPage().getParameters().put('Id','');              
        //ApexPages.currentPage().getParameters().put('indexDelete',String.valueOf('0'));    
        //objPage = new Page__c();
        ApexPages.StandardController ctrl23 = new ApexPages.StandardController(new Page__c());
        ctrl_cecr_edit objCtrl23 = new ctrl_cecr_edit(ctrl23);
        //objCtrl.lstFields = new List<Field__c>();
        
        //objCtrl.addRow();
        //objCtrl.deleteRow();
        //objCtrl.save();               
        
        
        
    
        Test.stopTest();

    }
    //===============================================================================//
    @isTest static void test_method_two() {
        // Implement test code

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
        
        objField.add(new Field__c(Page__c = objPage.Id ));
        
        //INSERT FIELD LIST
        insert objField ;

        Test.startTest();
        
        system.debug('======= TEST : PAGE NAME : ' + objPage );
        
        Test.setCurrentPage(Page.CECR_EDIT);
        ApexPages.currentPage().getParameters().put('PageId','');      
        ApexPages.currentPage().getParameters().put('Id',''); 
        ApexPages.currentPage().getParameters().put('indexDelete',String.valueOf('0'));
        //objPage = new Page__c();
        ApexPages.StandardController ctrl235 = new ApexPages.StandardController(objPage);
        ctrl_cecr_edit objCtrl235 = new ctrl_cecr_edit(ctrl235);
        objCtrl235.lstFields.add( new Field__c(
        Name = 'Name',
        Column_Header_Override__c = 'Enter Name',
        Field_Order__c = 1,
        Required__c = True,
        Page__c = objPage.Id ,
        Input_or_Output__c = 'Input')
        ); 
        //insert objCtrl235.lstFields;
        //objCtrl235.addRow();
        //objCtrl235.deleteRow();
        System.debug('=====================Save for method two begins===================');
        objCtrl235.save();               
        
        Test.stopTest();

    }
//=====================================================================================// 
    @isTest static void test_method_three() {
        // Implement test code

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
        Field_Order__c = 0,
        Required__c = True,
        Page__c = objPage.Id ,
        Input_or_Output__c = 'Input')
        );
        
        objField.add( new Field__c(
        Name = 'Description',
        Column_Header_Override__c = 'Enter Description',
        Field_Order__c = 1,
        Required__c = True,
        Page__c = objPage.Id ,
        Input_or_Output__c = 'Input')
        );
        
        //INSERT FIELD LIST
        insert objField ;
        
        Test.startTest();
        
        system.debug('======= TEST : PAGE NAME : ' + objPage );
        
        Test.setCurrentPage(Page.CECR_EDIT);
        ApexPages.currentPage().getParameters().put('PageId',String.valueOf(objPage.Id));      
        ApexPages.currentPage().getParameters().put('Id',String.valueOf(objAcc.Id));              
        ApexPages.currentPage().getParameters().put('indexDelete',String.valueOf('0'));              
        ApexPages.StandardController ctrl = new ApexPages.StandardController(objPage);
        ctrl_cecr_edit objCtrl = new ctrl_cecr_edit(ctrl);
        objCtrl.lstFields.add( new Field__c(
        Name = 'Name',
        Column_Header_Override__c = 'Enter Name',
        Field_Order__c = 1,
        Required__c = True,
        Page__c = objPage.Id ,
        Input_or_Output__c = 'Input')
        ); 
        Page__c objPageSample = new Page__c ();
        objPageSample = [ SELECT Id, Page_Mode__c , Parent_Object_API_Name__c , Record_Type__c , Lookup_Field_API_Name__c, Custom_Button_URL__c, Child_Object_API_Name__c , Order_By_Field__c , Order_By_Null_Handling__c , Order_By_Direction__c ,  ( SELECT Id , Name , Column_Header_Override__c , Input_or_Output__c , Required__c, Field_Order__c   FROM Fields__r  order by Field_Order__c    asc ) FROM Page__c WHERE id = : ctrl.getId() ];
        System.debug('============================objPageSample====================================='+objPageSample);
        objCtrl.save();
        objCtrl.addRow();
        objCtrl.deleteRow();
                       
        
        
        
    
        Test.stopTest();

    }
    
    
}