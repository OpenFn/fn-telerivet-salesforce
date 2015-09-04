@isTest (seeAllData=false)
Private Class Test_ctrl_integrationSetup{

    @isTest
    Private static void Test_ctrl_integrationSetup(){
        Test.StartTest();
        Account_Settings__c acc = new Account_Settings__c();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        ctrl_integrationSetup ctrl = new ctrl_integrationSetup (sc);

        PageReference pageRef = Page.integrationSetup;
        pageRef.getParameters().put('q', '1');
        Test.setCurrentPage(pageRef);
        
        ctrl.phoneType = '';
        ctrl.apikey = '';
        ctrl.projId = '' ;
        ctrl.phoneId ='' ;
        ctrl.routeId = '' ;
        ctrl.secret = '' ;
        ctrl.siteUrl = '';
        ctrl.next();
        ctrl.siteUrl = 'http://helloworld.com' ;
        ctrl.next();
        
        ctrl.siteUrl = 'https://helloworld.com/' ;
        ctrl.next();     
        
        ctrl.apikey = 'CCAvfEyUEBwsD33m3OiHa17mvA4UcKDp';
        ctrl.next();  
        
        ctrl.phoneandroute();
        
        ctrl.projId = 'PJ731a879b5e2d5ba6' ;
        ctrl.next();   
        
        ctrl.secret = 'secretTest' ;
        ctrl.next();
        
        ctrl.phoneType = 'route';
        ctrl.next();   
             
        ctrl.routeId = 'routetemp' ;
        ctrl.next();
        
        ctrl.step = 1;       
        ctrl.phoneType = 'phone';
        ctrl.phoneId = '' ;        
        ctrl.next();                         

        //Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        ctrl.phoneandroute();
        ctrl.next();
        
        MockHttpResponseGenerator.errCount = true;
        ctrl.phoneandroute();
        
        ctrl.step = 2;
        ctrl.outsmsObj ='--None--';
        ctrl.next();
        
        ctrl.outsmsText = '';
        ctrl.outsmsNum ='';
        ctrl.outsmsTime ='';
        ctrl.outsmsRT ='';    
        ctrl.outsmsONum ='' ;
        ctrl.outsmsObj ='';
        ctrl.outsmsisRT =true;
        ctrl.step = 2;
        ctrl.next();
        
        ctrl.outsmsisRT =false;
        ctrl.outsmsObj ='Basic_sms_object__c';
        ctrl.outsmsText = 'hhh';
        ctrl.outsmsNum ='hhh';
        ctrl.outsmsTime ='ttt';   
        ctrl.outsmsONum ='ooo' ;
        ctrl.step = 2;
        ctrl.Next();
        
        ctrl.outsmsisRT =true;   
        ctrl.outsmsRT = '';
        ctrl.step = 2;
        ctrl.Next();     
        
        ctrl.outsmsNum ='nnn';
        ctrl.step = 2;
        ctrl.Next();

        //Get list of objects 
        
        for(SelectOption so : ctrl.getName()){
            if( so.getValue() == 'Basic_sms_object__c'){
                ctrl.outsmsObj = so.getValue();
                system.debug('VALUE IN OBJECT : ' + so.getValue() );
            }    
        }
        
        ctrl.step = 3;
        //IN bound
        ctrl.insmsObj ='--None--';
        ctrl.save();ctrl.saveActivate();
        
        ctrl.insmsText = '';
        ctrl.insmsNum ='';
        ctrl.insmsTime ='';
        ctrl.insmsRT ='';    
        ctrl.insmsONum ='' ;
        ctrl.insmsObj ='';
        ctrl.insmsisRT =true;
        ctrl.save();ctrl.saveActivate();
        
        ctrl.insmsisRT =false;
        ctrl.insmsObj ='Basic_sms_object__c';
        ctrl.insmsText = 'hhh';
        ctrl.insmsNum ='nnn';
        ctrl.insmsTime ='ttt';   
        ctrl.insmsONum ='ooo' ;
        ctrl.save();ctrl.saveActivate();
        
        ctrl.insmsTime = ctrl.insmsNum ;        
        ctrl.save();ctrl.saveActivate();
        
        ctrl.insmsObj = ctrl.outsmsObj ;
        ctrl.insmsisRT = true ;
        ctrl.outsmsisRT = true;
        ctrl.insmsRT = ctrl.outsmsRT ;
        ctrl.save();ctrl.saveActivate();
        
        
        ctrl.outsmsisRT = false;
        ctrl.insmsNum = 'someRandom';        
        ctrl.save();ctrl.saveActivate();
        

        //Get list of objects 
        
        for(SelectOption so : ctrl.getName()){
            if( so.getValue() == 'Basic_sms_object__c'){
                ctrl.insmsObj = so.getValue();
                system.debug('VALUE IN OBJECT : ' + so.getValue() );
            }    
        }
        
        
        //Get list of record types in an object Inbound and Outbound
        ctrl.getOutRecordTypes();        
        ctrl.getInRecordTypes();
        
        //Get list of Fields in object 
        ctrl.getObFields();
        ctrl.getIbFields();
        
        ctrl.setAllObSelect();
        ctrl.setAllIbSelect();
        
        //Actions 

        ctrl.okaygotit();
        

        ctrl.prev();
                        
        //ctrl.deleteSet();
        ctrl.refreshValues();
        
        triggerHandle trg = new triggerHandle();
        trg.createHttpRequest('endpoint', 'String method' , 'String sessionId');
        trg.deleteApexTrigger('String trgId', 'String sessionId' );
        trg.createApexClass();
        trg.deleteApexClass('string cid' , 'String sessionId' );
        trg.isSandbox();
        
        triggerHandle trg2 = new triggerHandle( 'objectName' , 'String trgname', 'String trgbody' , 'String URL' );
        
        Test.stoptest();
    }
}