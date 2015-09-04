//This Trigger will fire after insert, update, delete and undelete
trigger trgConCatCountries on Area__c (after insert, after update, after delete, after undelete) {

//If the event is insert or undelete, this list takes New Values or else it takes old values
List<Area__c> ProjStrategyList = (Trigger.isInsert|| Trigger.isUnDelete) ? Trigger.new : Trigger.old;

//to store Project Ids
List<Id> ProjectIds = new List<Id>();

//Loop through the Records to store the project Id values from the Project Area
for (Area__c proj_Strat : ProjStrategyList) {
ProjectIds.add(proj_Strat.Project_Grant__c);
}

//Sub-query to get the projects and all its Child Records where Id is equal to the Ids stored in ProjectIds
//Area__r is the Child Relationship name appended by '__r' as it is a custom object

List<Project__c> ProjectList = [
select
id,
(select id,Name, Type__c, Geographical_Area_Name__c from Project__c.Areas__r where Type__c = 'Country') 
from
Project__c
where
id in :ProjectIds];

//Loop through the List and store the Child Records as a String of values in Long Text Area Field i.e Project_Areas__c

for (Project__c proj : ProjectList) {

if(proj.Areas__r.size() > 0)
{
proj.Project_Areas__c = string.valueOf(proj.Areas__r[0].Geographical_Area_Name__c);
for(integer i=1;i < proj.Areas__r.size();i++)
{
proj.Project_Areas__c = proj.Project_Areas__c + '; ' + string.valueOf(proj.Areas__r[i].Geographical_Area_Name__c);
}
}
else
proj.Project_Areas__c = null;
}
//update the List
update ProjectList;

}