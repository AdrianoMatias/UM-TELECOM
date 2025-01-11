@isTest
private class CNPJConfigCTRL_Test {

    @testSetup
    static void dataCreation() {
        CNPJConfig__c conCONFIG = new CNPJConfig__c();
        conCONFIG.Name = 'MailingPostalCode';
        conCONFIG.Label__c = 'CEP de Correspondência';
        conCONFIG.From__c = 'MailingPostalCode';
        conCONFIG.To__c = 'MailingPostalCode';
        conCONFIG.Prefix__c = 'Con';
        insert conCONFIG;

        CNPJConfig__c accCONFIG = new CNPJConfig__c();
        accCONFIG.Name = 'BillingPostalCode';
        accCONFIG.Label__c = 'CEP de Cobrança';
        accCONFIG.From__c = 'BillingPostalCode';
        accCONFIG.To__c = 'BillingPostalCode';
        accCONFIG.Prefix__c = 'Acc';
        insert accCONFIG;

        CNPJConfig__c accCONFIG2 = new CNPJConfig__c();
        
        accCONFIG2.Name = 'DRMM_CNPJ__c';
        accCONFIG2.Label__c = 'CNPJ';
        accCONFIG2.From__c = 'DRMM_CNPJ__c';
        accCONFIG2.To__c = 'DRMM_CNPJ__c';
        accCONFIG2.Prefix__c = 'Acc';
        insert accCONFIG2;

		CNPJTokens__c tokens = new CNPJTokens__c();

		tokens.Name = 'Teste Dreamm';
        tokens.Receita__c = 'Dreamm Token maps';
        tokens.Maps__c = 'Dreamm Token maps';
        insert tokens;
    }

    @isTest static void getContactsWithData() {
        List<CNPJConfigCTRL.ConfigWrapper> wrappers = CNPJConfigCTRL.getConfigs('Con');
        System.assertEquals(1, wrappers.size());
        CNPJConfigCTRL.ConfigWrapper wrapper = wrappers[0];
        System.assertEquals(wrapper.config.Name, 'MailingPostalCode');
        System.assertEquals(wrapper.config.Label__c, 'CEP de Correspondência');
        System.assertEquals(wrapper.config.From__c, 'MailingPostalCode');
        System.assertEquals(wrapper.config.To__c, 'MailingPostalCode');
        System.assertEquals(wrapper.config.Prefix__c, 'Con');
    }

    @isTest static void getContactsWithoutData() {
        delete [Select Id from CNPJConfig__c];
        List<CNPJConfigCTRL.ConfigWrapper> wrappers = CNPJConfigCTRL.getConfigs('Con');
        System.assertNotEquals(0, wrappers.size());
    }
    
    @isTest static void getAccountsWithData() {
        List<CNPJConfigCTRL.ConfigWrapper> wrappers = CNPJConfigCTRL.getConfigs('Acc');
        System.assertEquals(2, wrappers.size());
        CNPJConfigCTRL.ConfigWrapper wrapper = wrappers[0];
        System.assertEquals(wrapper.config.Name, 'BillingPostalCode');
        System.assertEquals(wrapper.config.Label__c, 'CEP de Cobrança');
        System.assertEquals(wrapper.config.From__c, 'BillingPostalCode');
        System.assertEquals(wrapper.config.To__c, 'BillingPostalCode');
        System.assertEquals(wrapper.config.Prefix__c, 'Acc');
    }

    @isTest static void getAccountsWithoutData() {
        delete [Select Id from CNPJConfig__c];
        List<CNPJConfigCTRL.ConfigWrapper> wrappers = CNPJConfigCTRL.getConfigs('Acc');
        System.assertNotEquals(0, wrappers.size());
    }
    

    @isTest static void getAccountFields() {
        List<CNPJConfigCTRL.CustomSelectOption> fields = CNPJConfigCTRL.getFields('Account');
        Boolean hasNameField = false;
        for( CNPJConfigCTRL.CustomSelectOption field : fields ) {
            if( field.value == 'Name' ) {
                hasNameField = true;
                break;
            }
        }

        System.assert(hasNameField);
    }

    @isTest static void getContactFields() {
        List<CNPJConfigCTRL.CustomSelectOption> fields = CNPJConfigCTRL.getFields('Contact');
        Boolean hasFirstNameField = false;
        Boolean hasLastNameField = false;
        Boolean hasAccountIdField = false;
        for( CNPJConfigCTRL.CustomSelectOption field : fields ) {
            if( field.value == 'FirstName' ) {
                hasFirstNameField = true;               
            } else if( field.value == 'LastName' ) {
                hasLastNameField = true;
            }
        }

        System.assert(hasFirstNameField);
        System.assert(hasLastNameField);
        System.assert(!hasAccountIdField);
    }

    @isTest static void saveConfigsSuccess() {
        List<CNPJConfigCTRL.ConfigWrapper> wrappers = CNPJConfigCTRL.getConfigs('Acc');
        String jsonStr = JSON.serialize(wrappers);
        CNPJConfigCTRL.saveConfigs(jsonStr);
    }

    @isTest static void saveConfigsError() {
        List<CNPJConfigCTRL.ConfigWrapper> wrappers = CNPJConfigCTRL.getConfigs('Acc');
        wrappers[0].config.Id = null;
        String jsonStr = JSON.serialize(wrappers);
        Boolean hasError = false;
        try {
            CNPJConfigCTRL.saveConfigs(jsonStr);
        } catch( Exception e ) {
            hasError = true;
        }

        System.assert(hasError);
    }

	@isTest static void saveTokenReceita() {
        String tipo;
        try {
			tipo =  CNPJConfigCTRL.getToken('Receita');
        } catch( Exception e ) {
        }
    }

	@isTest static void saveTokenMaps() {
        String tipo;
        try {
			 tipo =  CNPJConfigCTRL.getToken('Maps');
        } catch( Exception e ) {
        }

    }

	@isTest static void saveTokenTest() {
        String tipo;
        try {
			CNPJConfigCTRL.saveToken('teste Receita','teste Maps');
        } catch( Exception e ) {
        
		}
    }

}