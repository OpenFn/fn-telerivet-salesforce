/**********************************IMPORTANT**************************************
* Class: ContactTriggerHandler_Example 
* Created by : Nadeem Shaikh
----------------------------------------------------------------------------------
* Purpose/Methods: Central trigger logic for the Contact object in the system.
----------------------------------------------------------------------------------
* Utility Test Data: Test_trgContact
----------------------------------------------------------------------------------
* Version History: (All changes and TA reworks should be entered as new row )
* VERSION    DEVELOPER NAME    DATE            DETAIL FEATURES
    1.0      Nadeem Shaikh     21/10/2014      INITIAL DEVELOPMENT
*********************************************************************************/

Public with sharing class ContactTriggerHandler extends TriggerHandler{ // class_begin
  
  public ContactTriggerHandler() {    
      this.setMaxLoopCount(1);
  }

/****************************************************
   Trigger context for all BEFORE events 
****************************************************/
  
  protected override void beforeInsert() {
    // All code logic for BEFORE INSERT Trigger context for trgLease should go here.
    System.debug('----------- Before Insert');
  }
  
  protected override void beforeUpdate() {
    // All code logic for BEFORE UPDATE Trigger context for trgLease should go here.  
    System.debug('----------- Before Update');  
  }  

  protected override void beforeDelete() {
     // All code logic for BEFORE DELETE Trigger context for trgLease should go here.   
     System.debug('----------- Before Delete');     
  }  

/****************************************************
   Trigger context for all AFTER events 
****************************************************/

  protected override void afterInsert() {
    // All code logic for AFTER INSERT Trigger context for trgLease should go here.
    System.debug('----------- After Insert');    
  }

  protected override void afterUpdate() {    
    // All code logic for AFTER INSERT Trigger context for trgLease should go here. 
    System.debug('----------- After Update');
    a_method_with_functionality((List<Contact>) Trigger.New);    
  }
  
  protected override void afterDelete() {
     // All code logic for AFTER INSERT Trigger context for trgLease should go here.   
     System.debug('----------- After Delete');     
  }
  
  protected override void afterUndelete() {
     // All code logic for AFTER INSERT Trigger context for trgLease should go here. 
     System.debug('----------- After undelete');       
  }
  
  
  
/****************************************************
   Method definition used in trigger context 
****************************************************/

  private void a_method_with_functionality(List<Contact> TrgNew){    
  
 
      System.debug('=========== Updating');
      //List<Contact> lstContUpdate = [SELECT Id FROM Contact];      
      //update lstContUpdate ;
      
      /*
      Contact con = new Contact(LastName='Testing Trigger Handler');
      System.debug('=========== Inserting');
      insert con;
      System.debug('=========== Updating');
      update con;
      System.debug('=========== Deleting');
      delete con;
      System.debug('=========== Undelete');
      undelete con;
      System.debug('=========== Deleting');
      delete con;
      */
      
    
  }
  
    
} // class_end