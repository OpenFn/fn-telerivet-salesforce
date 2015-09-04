@isTest
private class CustomHelpText_Test 
{
	@isTest
	static void itShould()
	{
		
		CustomHelpText obj = new CustomHelpText();
		obj.sObjectName = 'Account';
		obj.fieldName = 'AccountSource';
		obj.altText = 'Temp Alt Text';
		system.debug( obj.gethelpText());

		obj.sObjectName = '';
		obj.fieldName = '';
		system.debug( obj.gethelpText() );
	}
}