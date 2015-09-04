@isTest
private class trgConCatCountries_Test {
  @isTest
  static void myUnitTest() {
    Project__c proj = new Project__c (Name = 'test1');
    insert proj;
    Geographical_Area__c geo = new Geographical_Area__c(Name = 'testarea1', Type__c = 'Country');
    insert geo;
    Area__c area =  new Area__c(Project_Grant__c = proj.Id, Geographical_Area__c = geo.Id);
    insert area;
    
    geo.Type__c = 'Region';
    update geo;
    update area;
    
    ApexPages.Standardcontroller stdCon = new ApexPages.Standardcontroller(proj);
  }
}