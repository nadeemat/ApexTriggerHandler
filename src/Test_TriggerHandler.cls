/**********************************IMPORTANT**************************************
* Class: LeaseTriggerHandler 
* Created by : Shaikh Mohd Nadeem
----------------------------------------------------------------------------------
* Purpose/Methods: Test class for control unit TriggerHandler.
----------------------------------------------------------------------------------
* Utility Test Data: TriggerHandler 
----------------------------------------------------------------------------------
* Version History: (All changes and TA reworks should be entered as new row )

* VERSION    DEVELOPER NAME    DATE            DETAIL FEATURES
    1.0      Nadeem Shaikh     23/10/2014      INITIAL DEVELOPMENT
*********************************************************************************/
@isTest
public class Test_TriggerHandler extends TriggerHandler {
	

	
		
		public override void beforeInsert(){
			TriggerHandler.bypass('test');
			TriggerHandler.clearBypass('test');
			TriggerHandler.isBypassed('test');
			TriggerHandler.clearAllBypasses();
		}

       	public override void beforeUpdate(){}
  		public override void beforeDelete(){}
  		public override void afterInsert(){}
  		public override void afterUpdate(){}
  		public override void afterDelete(){}
  		public override void afterUndelete(){}



	@isTest static void test_method_one() {
		Test_TriggerHandler trg = new Test_TriggerHandler();		
		trg.clearMaxLoopCount();
		trg.setMaxLoopCount(2);
		
		
		//trg.run();
		trg.beforeInsert();
		trg.beforeUpdate();
  		trg.beforeDelete();
  		trg.afterInsert();
  		trg.afterUpdate();
  		trg.afterDelete();
  		trg.afterUndelete();


	}
	
	
}