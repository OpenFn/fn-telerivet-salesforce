public with sharing class CECR_RV {

/************************************************************************
*                       CREATE/EDIT CHILD RECORDS                       *
*************************************************************************
My friends, welcome to Create/Edit Child Records 2.0: CECR.

This Visualforce page can be quickly adapted to create and/or edit 
child records, e.g. Students in a Class, or Payments on an Opportunity.

Use the Control Panel to change the objects and fields and set whether 
this page can edit existing records or only create new records.

Full deployment instructions are in the Asset record in Veraforce.

******$$$******
Make it rain. Version 2 is here; look for the dollar signs denoting new features.
******$$$******

*/


List<String> lstStrFields = new List<String>();
//$$$ New update: there is a list of fields that show up in the main table, and a list that show up above.
List<objField> lstObjFields = new List<objField>();
List<objField> lstObjFieldsTop = new List<objField>();

Public List<SObject> childRecords {get;set;}
Public List<SObject> lstDeletedRecords {get;set;}
Public sObject parentRecord {get;set;}
//This is for storing values that are applied across all child records
Public sObject dummyChild {get;set;}
Map<String, schema.Sobjectfield> fieldMap = new Map<String, schema.Sobjectfield>();
Schema.SObjectType childObject;

String strParentObj;
Public String strParentName {get;set;}
String strChildObj;
String parentId;
String strLookupField;
String strRecordType;
String strRTId;
String strOrderBy;
Boolean existingRecords;
Boolean fieldDefaults;

Public String strPlural {get;set;}

//$$$ New stuff
String strPageId;
Public Page__c objPage {get;set;}
Public String strMode {get;set;}


    public CECR_RV() {
    
        Boolean input = true;
        Boolean output = false;
        Boolean yes = true;
        Boolean no = false;
    
        /*************************************************************/
        /*          S T A R T    C O N T R O L    P A N E L          */
        /*************************************************************/

            //If the child object's fields have default values, load them?
            //Due to a known SF error, please leave this as 'no.' Sorry, no default values! (https://success.salesforce.com/issues_view?id=a1p30000000Sz5RAAS)
            fieldDefaults = no;            
        
        /*************************************************************/
        /*            E N D    C O N T R O L    P A N E L            */
        /*************************************************************/
        
        //$$$ Rebuilding the page around the Page__c and Field__c objects
        strPageId = ApexPages.currentPage().getParameters().get('PageId');
        objPage = new Page__c();
        if(strPageId != null){
        
            /*+++++++++++++++++++++ NOTE +++++++++++++++++++++
               the WHERE condition "Name = :strPageId" for PAGES__C has been changed to "Id= :strPageId"
              ++++++++++++++++++++++++++++++++++++++++++++++++
            */
            List<Page__c> lstPages = [Select Id, Name, Page_Mode__c, Parent_Object_API_Name__c, Child_Object_API_Name__c, Lookup_Field_API_Name__c,
                                        Parent_Record_Name__c, Order_By_Field__c, Order_By_Direction__c, Order_By_Null_Handling__c, Record_Type__c,                                       
                                        (Select Id, Name, Input_or_Output__c, Required__c, Column_Header_Override__c, Display_in_Top_Section__c from Fields__r ORDER BY Field_Order__c) 
                                        from Page__c where Id = :strPageId];  
                                        
            System.debug('======== PAGES : ' + lstPages  );                                                 
            System.debug('======== URL PARAMETERS, PAGE ID : ' + ApexPages.currentPage().getParameters().get('PageId') + ' PARENT ID : ' + ApexPages.currentPage().getParameters().get('Id') );
            //$$$ Now everything has to happen within this if statement. Otherwise, display a blank page.
            if(lstPages.size() > 0){
                objPage = lstPages[0];
                strMode = '';
                if(objPage.Page_Mode__c == Label.Edit_existing_child_records ){ //'Edit existing child records'
                    strMode = 'E';
                }else if(objPage.Page_Mode__c == Label.Create_new_child_records){ //'Create new child records'
                    strMode = 'C';
                }else if(objPage.Page_Mode__c == Label.Create_records_with_no_common_parent){ //'Create records with no common parent'
                    strMode = 'W';
                }
                for(Field__c f : objPage.Fields__r){
                    if(!f.Display_in_Top_Section__c){
                        lstObjFields.add(new objField(f.Name, f.Input_or_Output__c, f.Required__c, f.Column_Header_Override__c));
                    }else{
                        lstObjFieldsTop.add(new objField(f.Name, f.Input_or_Output__c, f.Required__c, f.Column_Header_Override__c));
                        }
                    
                }
                
                //$$$ Only if mode is not 'W', we pull the id from the URL and use that to query the parent record - so we can display a name at the top
                if(strMode != 'W'){
                    parentId = ApexPages.currentPage().getParameters().get('Id');
                    String strParentQuery = 'SELECT ';
                        strParentQuery += objPage.Parent_Record_Name__c;
                        strParentQuery += ' from ';
                        strParentQuery += objPage.Parent_Object_API_Name__c;
                        strParentQuery += ' where Id = :parentId';
                    List<sObject> lstParent = Database.query(strParentQuery);
                    if(!lstParent.isEmpty()) parentRecord = lstParent[0];
                }
                strRTId = '';
                if(strRecordType != null) {
                    List<RecordType> lstRTs = Database.Query('Select Id from RecordType where sObjectType = \'' + objPage.Child_Object_API_Name__c + '\' and DeveloperName = \'' + objPage.Record_Type__c + '\''); 
                    if(!lstRTs.isEmpty()) {
                      strRTId = lstRTs[0].Id; }  
                  }
                
                //Schema.getGlobalDescribe() returns a map of String,sObjectType for all objects
                // -- we are using the map to get the child object sObject type, then we describe the sObject
                //and get a map of the fields
                System.debug('======== CHILD OBJECT API NAME : ' + objPage.Child_Object_API_Name__c );
                childObject = Schema.getGlobalDescribe().get(objPage.Child_Object_API_Name__c);
                Schema.DescribeSObjectResult childObjectDescription = childObject.getDescribe();
                fieldMap = childObjectDescription.Fields.getMap(); 
                strPlural = childObjectDescription.labelPlural;
                System.debug('======== CHILD OBJECT CONTETN : ' + childObject );
                
                //Loop through the objFields and fill in the label if it has been left blank
                for(objField objF : lstObjFields) {
                    if(objF.Label == null && fieldMap.get(objF.Name).getDescribe().getLabel() != null) {
                        objF.Label = fieldMap.get(objF.Name).getDescribe().getLabel(); }      
                    
                    //If field is "REQUIRED" at the "OBJECT LEVEL" make it "REQUIRED" at "PAGE LEVEL"
                    if(fieldMap.get(objF.Name).getDescribe().isNillable() == false){
                        objF.required = true ;       
                    }    
                }              
                getRecords();    
            }                          
        }      
    }
    
    public Class objField {
        Public String name {get;set;}
        Public String label {get;set;}
        Public Boolean input {get;set;}
        Public Boolean required {get; set;}
        
      public objField(String strName, String strInput, Boolean blnRequired, String strLabel) {
        name = strName;
        label = strLabel;
        if(strInput == 'Input'){
                input = true;
            }else{
                input = false;
            }
        required = blnRequired;
        
       }
    }

    public void getRecords() {    
        childRecords = new List<sObject>();
        lstDeletedRecords = new List<sObject>();
        //$$$ This is for storing values applied to all records
        if( strRTId != null && strRTId.length() > 0) {  
            dummyChild = childObject.newSObject(strRTId, fieldDefaults); }
          else {
            dummyChild = childObject.newSObject(null, fieldDefaults); }
        
        string query = 'SELECT ';
        for(integer i = 0; i< lstObjFields.size(); i++) {
            query += lstObjFields[i].Name;
            if(i < lstObjFields.size()-1){
              query += ', '; }
         }
        query += ' FROM '+ objPage.Child_Object_API_Name__c + ' where ' + objPage.Lookup_Field_API_Name__c + ' = :parentId';
        if(strRTId.length() > 0){
            query += 'AND RecordTypeId = \'' + strRTId + '\''; }
        
        if(objPage.Order_By_Field__c != null){
            query += ' ORDER BY ' + objPage.Order_By_Field__c;
              if(objPage.Order_By_Direction__c != null) query += ' ' + objPage.Order_By_Direction__c;
              if(objPage.Order_By_Null_Handling__c != null) query += ' ' + objPage.Order_By_Null_Handling__c;
        }
        if(strMode == 'E') {
          childRecords = Database.query(query); }
        
        if(childRecords.size() == 0) {
            addMultipleRows(2); }
     }
    
    public void addRow() {           
          sObject record;
          if( strRTId != null && strRTId.length() > 0) {  
            record = childObject.newSObject(strRTId, fieldDefaults); }
          else {
             system.debug('========BOOLEAN VALUE :' + fieldDefaults + ' CHILD OBJECT : ' + childObject);
            record = childObject.newSObject(null, fieldDefaults); }
            
            if(strMode != 'W') record.put(objPage.Lookup_Field_API_Name__c, parentId);
            childRecords.add(record);       
      }
      
    public void addMultipleRows(integer x){
        for(integer i = 0; i < x; i++){
            addRow();
        }
    }
    
    public void removeRow(){
        String rowIndex = ApexPages.currentPage().getParameters().get('delIndex');
        //Safety first
    
        if(rowIndex == null){
          //do nothing 
        }
        
        Integer index = Decimal.valueOf(rowIndex).intValue() - 1;
        //Possibly a mistake
    
        if(index >= childRecords.size()) {
          //do nothing
        }
            
        sObject currentChildRecord = childRecords[index];
        childRecords.remove(index);
       
        if(currentChildRecord != null && currentChildRecord.Id != null) {
          lstDeletedRecords.add(currentChildRecord);
        }
    }
       
    public List<objField> getObjFields () {    
        return lstObjFields;
    }
    public List<objField> getObjFieldsTop () {    
        return lstObjFieldsTop;
    }
    
    public void Save() {
        //$$$ New section for saving values from the dummyChild record to all rows
        for(sObject rec : childRecords){
            for(objField topField : lstObjFieldsTop){
                rec.put(topField.Name, dummyChild.get(topField.Name));
            }
        }
        
        try{
            if(strMode == 'W' || strMode == 'C'){
                insert childRecords;
            }else{
                upsert childRecords;
            }
            delete lstDeletedRecords;
        } catch(DmlException ex) {
            ApexPages.addMessages(ex);
        }
    }
    
    public pageReference QuickSave() {
        Save();
        getRecords();
        return null;
    }
    
    public pageReference SaveClose() {
        Save();
        return new pageReference('/' + parentId);
    }
    
    public pageReference Cancel() {
        return new pageReference('/' + parentId);
    }

}