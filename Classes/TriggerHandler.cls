/**********************************IMPORTANT**************************************
* Class: TriggerHandler 
* Created by : Shaikh Mohd Nadeem
----------------------------------------------------------------------------------
* Purpose/Methods: Central Control System for all the triggers in the system.
----------------------------------------------------------------------------------
* Utility Test Data: Test_TriggerHandler 
----------------------------------------------------------------------------------
* Version History: (All changes and TA reworks should be entered as new row )
* VERSION  DEVELOPER NAME    DATE            DETAIL FEATURES
    1.0    Nadeem Shaikh     21/10/2014      INITIAL DEVELOPMENT
*********************************************************************************/

public virtual class TriggerHandler {

  // static map of handlername, times run() was invoked
  private static Map<String, LoopCount> loopCountMap;
  private static Set<String> bypassedHandlers;

  static {
    loopCountMap = new Map<String, LoopCount>();
    bypassedHandlers = new Set<String>();
  }
    
  public TriggerHandler() {    

  }

  /***************************************
   * public methods
   ***************************************/

  // main method that will be called during execution
  public void run() {

    if(!validateRun()) return;

    //if(!addToLoopCount()) return;
    addToLoopCount();

    // dispatch to the correct handler method
    if(Trigger.isBefore && Trigger.isInsert) {
      this.beforeInsert();
    } else if(Trigger.isBefore && Trigger.isUpdate) {
      this.beforeUpdate();
    } else if(Trigger.isBefore && Trigger.isDelete) {
      this.beforeDelete();
    } else if(Trigger.isAfter && Trigger.isInsert) {
      this.afterInsert();
    } else if(Trigger.isAfter && Trigger.isUpdate) {
      this.afterUpdate();
    } else if(Trigger.isAfter && Trigger.isDelete) {
      this.afterDelete();
    } else if(Trigger.isAfter && Trigger.isUndelete) {
      this.afterUndelete();
    }

  }

  public void setMaxLoopCount(Integer max) {
    String handlerName = getHandlerName();
    if(!TriggerHandler.loopCountMap.containsKey(handlerName)) {
      TriggerHandler.loopCountMap.put(handlerName, new LoopCount(max));
    } else {
      TriggerHandler.loopCountMap.get(handlerName).setMax(max);
    }
  }

  public void clearMaxLoopCount() {
    this.setMaxLoopCount(-1);
  }

  public static void bypass(String handlerName) {
    TriggerHandler.bypassedHandlers.add(handlerName);
  }

  public static void clearBypass(String handlerName) {
    TriggerHandler.bypassedHandlers.remove(handlerName);
  }

  public static Boolean isBypassed(String handlerName) {
    return TriggerHandler.bypassedHandlers.contains(handlerName);
  }

  public static void clearAllBypasses() {
    TriggerHandler.bypassedHandlers.clear();
  }

  /***************************************
   * private methods
   ***************************************/

  private Boolean addToLoopCount() {
    String handlerName = getHandlerName();
    if(TriggerHandler.loopCountMap.containsKey(handlerName)) {
      Boolean exceeded = TriggerHandler.loopCountMap.get(handlerName).increment();
      if(exceeded) {
        Integer max = TriggerHandler.loopCountMap.get(handlerName).max ;
        //throw new TriggerHandlerException('Maximum loop count of ' + String.valueOf(max) + ' reached in ' + handlerName);
        System.debug('========= Warning : Max Trigger Execution Reached! Attempt to run ' + max + '.');
        return false ;
      }        
    }
      return true;
  }

  // make sure this trigger should continue to run
  private Boolean validateRun() {
    if(!Trigger.isExecuting && !Test.isRunningTest()) {
      throw new TriggerHandlerException('Trigger handler called outside of Trigger execution');
    }
    if(TriggerHandler.bypassedHandlers.contains(getHandlerName())) {
      return false;
    }
    TriggerHandler__c tac = TriggerHandler__c.getInstance(getHandlerName());
    if(tac == null){
        System.debug('=========== Custom setting for the trigger : '+ getHandlerName() + ' not found! Activating the trigger.');
        tac = new TriggerHandler__c();
        tac.Name = getHandlerName();
        tac.Active__c = true;
        insert tac;
        System.debug('=========== Trigger Handler : '+getHandlerName() + ' activated!');
    }
    if(tac.Active__c == false){
        System.debug('=========== Trigger Handler ' + getHandlerName() + ' is deactivated skipping trigger execution.');
        return false;
    }
    return true;
  }

  private String getHandlerName() {

    if(Test.isRunningTest()){
      return 'test';
    }
    return String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
  }

  /***************************************
   * context methods
   ***************************************/

  // context-specific methods for override
  protected virtual void beforeInsert(){}
  protected virtual void beforeUpdate(){}
  protected virtual void beforeDelete(){}
  protected virtual void afterInsert(){}
  protected virtual void afterUpdate(){}
  protected virtual void afterDelete(){}
  protected virtual void afterUndelete(){}

  /***************************************
   * inner classes
   ***************************************/

  // inner class for managing the loop count per handler
  private class LoopCount {
    private Integer max;
    private Integer count;

    public LoopCount() {
      this.max = 5;
      this.count = 0;
    }

    public LoopCount(Integer max) {
      this.max = max;
      this.count = 0;
    }

    public Boolean increment() {
      this.count++;
      return this.exceeded();
    }

    public Boolean exceeded() {
      if(this.max < 0) return false;
      if(this.count > this.max) {
        return true;
      }
      return false;
    }

    public Integer getMax() {
      return this.max;
    }

    public Integer getCount() {
      return this.count;
    }

    public void setMax(Integer max) {
      this.max = max;
    }
  }

  // exception class
  public class TriggerHandlerException extends Exception {}

}