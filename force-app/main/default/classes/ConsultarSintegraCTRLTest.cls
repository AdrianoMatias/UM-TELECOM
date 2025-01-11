@isTest
public class ConsultarSintegraCTRLTest {
    @TestSetup
	static void criarDados(){
		Account conta = new Account();
        conta.Name = 'Conta Teste 1';
        conta.CNPJ__c = '19403406000143';
		insert conta;
        
        CNPJTokens__c token = new CNPJTokens__c();
        token.Sintegra__c= 'teste';
        token.Name = 'Dreamm';
        insert token;
        system.debug('token '+ token);
        
        Sintegra_Config__c configSintegra = new Sintegra_Config__c();
        configSintegra.Name = 'teste polly';
        configSintegra.From__c ='bairro' ;
        configSintegra.Tipo__c ='Texto' ;
        configSintegra.Prefix__c ='Acc' ;
        configSintegra.To__c ='Site' ;
        insert configSintegra;
        
        Sintegra_Config__c configSintegra1 = new Sintegra_Config__c();
        configSintegra1.Name = 'teste polly 1';
        configSintegra1.From__c ='numero' ;
        configSintegra1.Tipo__c ='Número' ;
        configSintegra1.Prefix__c ='Acc' ;
        configSintegra1.To__c ='NumberOfEmployees' ;
        insert configSintegra1;
        
    }
    
    @isTest static void buscarSintegraTest() {
        Account acc = new Account();
        acc.Name = 'Conta teste 2';
        acc.CNPJ__c = null;
		insert acc;
        
        Test.startTest();
        
		try{
		ConsultarSintegraCTRL.buscarSintegra(acc.id);		
        } catch (Exception ex) {
            system.debug(ex.getMessage());
		}
		Test.stopTest();
        
        
    }
    @isTest static void buscarSintegraTest2() {
        
        String jsonString  = '{"code":"200","status":"OK","message":"OK","nome_empresarial":"Magnum distribuidora de pneus ltda","cnpj":"19403406000143","inscricao_estadual":"055790828","tipo_inscricao":"Não informado","data_situacao_cadastral":"13-12-2013","situacao_cnpj":"Ativo","situacao_ie":"Ativo","nome_fantasia":"Não informado","data_inicio_atividade":"16-10-2007","regime_tributacao":"Normal - regime periódico de apuração","informacao_ie_como_destinatario":"","porte_empresa":"Não informado","cnae_principal":{"codigo":"6319400","descricao":"Portais, provedores de conteúdo e outros serviços de informação na internet"},"data_fim_atividade":"","uf":"SP","municipio":"Sao paulo","logradouro":"Avenida brigadeiro faria lima","complemento":"Andar 17 a 20 torre sul andar 2 torre norte andar 18 a 20 torre norte","cep":"04538133","numero":"3477","bairro":"Itaim bibi"}';
           
        Account acc = [SELECT Id, CNPJ__c  FROM Account];
        system.debug('acc' + acc);

        
        HttpMock mock = new HttpMock(200,'OK',jsonString, new Map<String,String>());
		Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        
		try{
		ConsultarSintegraCTRL.buscarSintegra(acc.Id);		
        } catch (Exception ex) {
			system.debug(ex.getMessage());
		}
		Test.stopTest();
        
        
    }

    @isTest static void buscarSintegraTest3() {
        
        String jsonString  = '{"code":"200","status":"OK","message":"OK","nome_empresarial":"Magnum distribuidora de pneus ltda","cnpj":"19403406000143","inscricao_estadual":"055790828","tipo_inscricao":"Não informado","data_situacao_cadastral":"13-12-2013","situacao_cnpj":"Ativo","situacao_ie":"Ativo","nome_fantasia":"Não informado","data_inicio_atividade":"16-10-2007","regime_tributacao":"Normal - regime periódico de apuração","informacao_ie_como_destinatario":"","porte_empresa":"Não informado","cnae_principal":{"codigo":"6319400","descricao":"Portais, provedores de conteúdo e outros serviços de informação na internet"},"data_fim_atividade":"","uf":"SP","municipio":"Sao paulo","logradouro":"Avenida brigadeiro faria lima","complemento":"Andar 17 a 20 torre sul andar 2 torre norte andar 18 a 20 torre norte","cep":"04538133","numero":"3477","bairro":"Itaim bibi"}';
           
        Account acc = [SELECT Id, CNPJ__c  FROM Account];
        system.debug('acc' + acc);

        List<Sintegra_Config__c> sintegraList = [SELECT Id FROM Sintegra_Config__c WHERE Prefix__c = 'Acc'];
        delete sintegraList;

        
        HttpMock mock = new HttpMock(200,'OK',jsonString, new Map<String,String>());
		Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        
		try{
		ConsultarSintegraCTRL.buscarSintegra(acc.Id);		
        } catch (Exception ex) {
			system.debug(ex.getMessage());
		}
		Test.stopTest();
        
        
    }

    @isTest static void buscarSintegraTest4() {
        
        String jsonString  = '{"code":"200","status":"OK","message":"OK","nome_empresarial":"Magnum distribuidora de pneus ltda","cnpj":"19403406000143","inscricao_estadual":"055790828","tipo_inscricao":"Não informado","data_situacao_cadastral":"","situacao_cnpj":"Ativo","situacao_ie":"Ativo","nome_fantasia":"Não informado","data_inicio_atividade":"16-10-2007","regime_tributacao":"Normal - regime periódico de apuração","informacao_ie_como_destinatario":"","porte_empresa":"Não informado","cnae_principal":{"codigo":"6319400","descricao":"Portais, provedores de conteúdo e outros serviços de informação na internet"},"data_fim_atividade":"","uf":"SP","municipio":"Sao paulo","logradouro":"Avenida brigadeiro faria lima","complemento":"Andar 17 a 20 torre sul andar 2 torre norte andar 18 a 20 torre norte","cep":"04538133","numero":"","bairro":"Itaim bibi"}';
           
        Account acc = [SELECT Id, CNPJ__c  FROM Account];
        system.debug('acc' + acc);

        HttpMock mock = new HttpMock(200,'OK',jsonString, new Map<String,String>());
		Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        
		try{
		ConsultarSintegraCTRL.buscarSintegra(acc.Id);		
        } catch (Exception ex) {
			system.debug(ex.getMessage());
		}
		Test.stopTest();
        
        
    }

    @isTest static void buscarSintegraTest5() {
        
        String jsonString  = '{"code":"200","status":"OK","message":"OK","nome_empresarial":"Magnum distribuidora de pneus ltda","cnpj":"19403406000143","inscricao_estadual":"055790828","tipo_inscricao":"Não informado","data_situacao_cadastral":"null","situacao_cnpj":"Ativo","situacao_ie":"Ativo","nome_fantasia":"Não informado","data_inicio_atividade":"16-10-2007","regime_tributacao":"Normal - regime periódico de apuração","informacao_ie_como_destinatario":"","porte_empresa":"Não informado","cnae_principal":{"codigo":"6319400","descricao":"Portais, provedores de conteúdo e outros serviços de informação na internet"},"data_fim_atividade":"","uf":"SP","municipio":"Sao paulo","logradouro":"Avenida brigadeiro faria lima","complemento":"Andar 17 a 20 torre sul andar 2 torre norte andar 18 a 20 torre norte","cep":"04538133","numero":"","bairro":"Itaim bibi"}';
           
        Account acc = [SELECT Id, CNPJ__c  FROM Account];
        system.debug('acc' + acc);

        List<Sintegra_Config__c> sintegraList = [SELECT Id FROM Sintegra_Config__c WHERE Prefix__c = 'Acc'];
        sintegraList[0].To__c = '';
        update sintegraList;

        HttpMock mock = new HttpMock(200,'OK',jsonString, new Map<String,String>());
		Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        
		try{
		ConsultarSintegraCTRL.buscarSintegra(acc.Id);		
        } catch (Exception ex) {
			system.debug(ex.getMessage());
		}
		Test.stopTest();
        
        
    }
}