public with sharing class ctrlProjectTimeline {
    
        public ctrlProjectTimeline(ApexPages.StandardController controller) {
    
        }
    
    public string strcomp{get;set;}
    public string stroffice{get;set;}
    public Project__c objProj {get;set;}
    public List<Project__c> lstProject {get;set;}
    
     public ctrlProjectTimeline()
     {
       objProj = new Project__c();
       lstProject = new List<Project__c>();
        lstProject = [Select Id, Name,End_Date__c,Start_Date__c,company__c from Project__c where Start_Date__c != null and End_Date__c != null and current__c = true order by End_Date__c asc];
     
     }
     
     
     public string strquery {get;set;}
     public pagereference Filter()
     {
      
        string strcompany = ApexPages.CurrentPage().GetParameters().Get('strcomp');
        string stroffice = ApexPages.CurrentPage().GetParameters().Get('stroff');
        System.debug(stroffice);
        strquery = 'Select Id, Name,End_Date__c,Start_Date__c,company__c from Project__c where Start_Date__c != null and End_Date__c != null ';
        
        if(objProj.Company__c != null && objProj.Company__c != 'null') //strcompany != null && strcompany != 'null') //  objProj.Company__c != null)
          strquery += ' and Company__c = ' + '\'' + objProj.Company__c + '\'';
          
       if(objProj.Backstopping_Office__c != null && objProj.Backstopping_Office__c != 'null')
          strquery += ' and Backstopping_Office__c = ' + '\'' + objProj.Backstopping_Office__c + '\'';
          
       if(objProj.Division__c != null && objProj.Division__c != 'null')
          strquery += ' and Division__c = ' + '\'' + objProj.Division__c + '\'';
       
       if(objProj.current__c == true)   
        strquery += ' and current__c =' +  objProj.current__c;      
          
        strquery += ' order by End_Date__c asc'; 
           
        lstProject = Database.query(strquery);
        System.debug(lstProject);
        
        return null;
     }
     
     public List<SelectOption> getCompanies()
     {
        List<SelectOption> options = new List<SelectOption>();
            
        Schema.DescribeFieldResult fieldResult = Project__c.Company__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
          
           // options.add(new SelectOption('','--None--'));
            
        for( Schema.PicklistEntry f : ple)
        {
           options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
         return options;
     }
     
     public List<SelectOption> getOffice()
     {
        List<SelectOption> options = new List<SelectOption>();
            
        Schema.DescribeFieldResult fieldResult = Project__c.Backstopping_Office__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
          
           // options.add(new SelectOption('','--None--'));
            
        for( Schema.PicklistEntry f : ple)
        {
           options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
         return options;
     }
     
       public List<SelectOption> getFocus()
     {
        List<SelectOption> options = new List<SelectOption>();
            
        Schema.DescribeFieldResult fieldResult = Project__c.Division__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
          
           // options.add(new SelectOption('','--None--'));
            
        for( Schema.PicklistEntry f : ple)
        {
           options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
         return options;
     } 
    
    }