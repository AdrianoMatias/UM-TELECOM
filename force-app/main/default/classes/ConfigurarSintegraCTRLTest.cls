@isTest
public class ConfigurarSintegraCTRLTest {
    @TestSetup
    static void criarDados(){
        CNPJTokens__c token = new CNPJTokens__c();
        token.Name = 'Dreamm';
        token.Sintegra__c = '';
        insert token;
    }

    @isTest
    public static void getTokenTest() {
        Test.startTest();
        ConfigurarSintegraCTRL.getToken();
        Test.stopTest();
    }

    @isTest
    public static void saveTokenTest() {
        Test.startTest();
        ConfigurarSintegraCTRL.saveToken('abc');
        Test.stopTest();
    }

    @isTest
    public static void getFieldsTest() {
        Test.startTest();
        ConfigurarSintegraCTRL.getFields('Account');
        Test.stopTest();
    }

    @isTest
    public static void getConfigsTest() {
        Test.startTest();
        ConfigurarSintegraCTRL.getConfigs('Acc');
        Test.stopTest();
    }

    @isTest
    public static void saveConfigsTest() {
		String jsonString = JSON.serialize(ConfigurarSintegraCTRL.getConfigs('Acc'));
		Test.startTest();
        ConfigurarSintegraCTRL.saveConfigs(jsonString);
        Test.stopTest();
    }
}