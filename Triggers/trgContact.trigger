/**********************************IMPORTANT**************************************
* Class: trgContact
* Created by : Nadeem Shaikh
----------------------------------------------------------------------------------
* Purpose/Methods: Central trigger logic for the Lease object in the system.
----------------------------------------------------------------------------------
* Utility Test Data: Test_trgContact
----------------------------------------------------------------------------------
* Version History: (All changes and TA reworks should be entered as new row )

* VERSION    DEVELOPER NAME    DATE            DETAIL FEATURES
    1.0      Nadeem Shaikh     21/10/2014      INITIAL DEVELOPMENT
*********************************************************************************/
trigger trgContact on Contact (before insert, before update , before delete , after insert , after update , after delete , after undelete) {

    new ContactTriggerHandler().run();
}