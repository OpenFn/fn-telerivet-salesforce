public with sharing class ctrl_triggerTest1 {


    public list<objectClass> standardObjList{get;set;}
    public list<objectClass> customObjList{get;set;}   
    public FINAL integer numberOfObject;
    public set<string> objectSet{get;set;}
    //This is a variable to check if we're done with the Iteration.
    public string isIterationDone{get;set;}
    public string picklistValue {get;set;}
     
    //Constructor.
    public ctrl_triggerTest1(){
         
        //initializing the lists.
 
       customObjList  = new list<objectClass> ();
       standardObjList = new list<objectClass> ();
       objectSet= new set<string>();
       list<schema.sObjectType> allObjects = Schema.getGlobalDescribe().Values();
        //get number of objects available for iteration.
       numberOfObject = allObjects.size();
       isIterationDone = 'No';
       ObjectList();
       
        
   }
    
    public void ObjectList(){
        // check if we have all the objects added in the list
        if((customObjList.size() + standardObjList.size())<numberOfObject){
            integer i=0;
            for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values()){
                //We will iterate over this list only 99 times as there is governer limit of 100 childrelationship describes per invocations.
                if(i<99){
                    //adding the object name to the set, so that we do not add duplicates to the list.
                    if(!objectSet.contains(objTyp.getDescribe().getName())){
                        i++;
                        objectSet.add(objTyp.getDescribe().getName());
                        //check if its a custom or standard object.
                        if(objTyp.getDescribe().isCustom()){
                            customObjList.add(new objectClass(objTyp.getDescribe().getLabel(), objTyp.getDescribe().getName(), objTyp.getDescribe().getKeyPrefix(), objTyp.getDescribe().getChildRelationships(), objTyp.getDescribe().isCustomSetting(), objTyp.getDescribe().getRecordTypeInfos()));
                        }else{
                            standardObjList.add(new objectClass(objTyp.getDescribe().getLabel(), objTyp.getDescribe().getName(), objTyp.getDescribe().getKeyPrefix(), objTyp.getDescribe().getChildRelationships(), objTyp.getDescribe().isCustomSetting(), objTyp.getDescribe().getRecordTypeInfos()));
                        }
                    }
                }else{
                    break;
                }
            }
        }else{
            isIterationDone = 'Yes';
        }
    }
    
   //This is a wrapper class. 
   public class objectClass{
        public string label{get;set;}
        public string apiName{get;set;}
        public string keyPrefix{get;set;}
        public boolean isCustomSet{get;set;}
        public list<Schema.ChildRelationship> childObjects;
        public list<string> childObjectArray{get;set;}
        public list<schema.RecordTypeInfo> recordTypes;
        public list<string> recordTypeArray{get;set;}
        public objectClass(string lab, string api, string prefix, list<Schema.ChildRelationship> childObj, boolean isCustomSetting, list<schema.RecordTypeInfo> recordTypeList){
            this.label = lab;
            this.apiName = api;
            this.KeyPrefix = prefix;
            this.isCustomSet = isCustomSetting;
            this.childObjectArray = new list<string>();
            this.recordTypeArray = new list<string>();
            if(childObj!=null){
                for(schema.childRelationShip ch : childObj){
                    this.childObjectArray.add(ch.getChildSObject().getDescribe().getLabel()+' ('+ch.getChildSObject().getDescribe().getName()+')');
                }
            }
            if(recordTypeList!= null){
                for(schema.RecordTypeInfo rt: recordTypeList){
                    this.recordTypeArray.add(rt.getName());
                }
            }
        }
    }
    

}