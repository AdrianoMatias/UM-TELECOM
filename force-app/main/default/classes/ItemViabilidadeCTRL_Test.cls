@isTest
public class ItemViabilidadeCTRL_Test {
	
    @testSetup
    public static void dataCreation() {
              
       Account acc = new Account();
        
       acc.Name = 'Teste Viabilidade Dreamm';
       acc.CNPJ__c = '00.000.000/0000-21';
       acc.Type = 'Prospect';
        
       insert acc;
        
       Opportunity opp = new Opportunity();
        
        opp.AccountId = acc.Id;
        opp.Name = 'Oportunidade de Teste Viabilidade Dreamm';
        opp.Meses__c = 12;
        opp.Dia_do_vencimento__c = '1';
        opp.StageName = 'Mapeamento';
        opp.CloseDate = Date.Today();
        
        insert opp;
        
        opp.StageName = 'Viabilidade';
        update opp;
        
        Analise_de_viabilidade__c av = new Analise_de_viabilidade__c();
        
        av.RecordTypeId = Schema.SObjectType.Analise_de_viabilidade__c.getRecordTypeInfosByName().get('Lan to Lan (L2L)').getRecordTypeId();
        av.Oportunidade__c = opp.Id;
        av.Pendencia__c = 'Sem Pendência';
        av.Status__c = 'Aberta';
        
        insert av;
        
        Produto_de_viabilidade__c pv = new Produto_de_viabilidade__c();
        
        pv.Name = 'Produto de Teste Viabilidade Dreamm';
        pv.Valor_unitario__c = 100.20;
        pv.Codigo__c = 'P000045';
        
        insert pv;
        
        Item_da_viabilidade__c iv = new Item_da_viabilidade__c();
                
        iv.RecordTypeId = Schema.SObjectType.Item_da_viabilidade__c.getRecordTypeInfosByName().get('Item da viabilidade').getRecordTypeId();
        iv.Produto_de_viabilidade__c = pv.Id;
        iv.Analise_de_Viabilidade__c = av.Id;
        iv.Valor__c = 100.20;
        
        insert iv;
    }
    
    @isTest static void testSucesso() {
        
        Integracoes__c integracoes = new Integracoes__c();
        
        integracoes.Name = 'Item de Viabilidade';
        integracoes.Metodo__c = 'GET';
        integracoes.Token__c = 'vfsvsfbb14gb56';
        integracoes.url__c = 'csscfv.com';
        
        insert integracoes;
        
        String iv = [SELECT Id FROM Item_da_viabilidade__c].Id;
                
        String jsonString = '{"ResultCode": 0, "ResultDescription": "Dados Carregados", "DatabaseID": "1", "Database": "SBO_1Telecom", "Extra": [{"codigo": "P000003", "name": "ABRACADEIRA BAP 3 C/PARAFUSO", "valor": 12.40}]}';
        
        HttpMock mock = new HttpMock(200,'OK',jsonString, new Map<String,String>());
		Test.setMock(HttpCalloutMock.class, mock);
        
        Test.startTest();
        try{
        	ItemViabilidadeCTRL.getItemViabilidade(iv);		
        } catch (Exception ex) {
			system.debug(ex.getMessage());
		}
		Test.stopTest();
    }
    
    @isTest static void testErro() {
        
        String iv = [SELECT Id FROM Item_da_viabilidade__c].Id;
                
        String jsonString = '{"ResultCode": 0, "ResultDescription": "Dados Carregados", "DatabaseID": "1", "Database": "SBO_1Telecom", "Extra": [{"codigo": "P000003", "name": "ABRACADEIRA BAP 3 C/PARAFUSO", "valor": 12.40}]}';
        
        HttpMock mock = new HttpMock(200,'OK',jsonString, new Map<String,String>());
		Test.setMock(HttpCalloutMock.class, mock);
        
        Test.startTest();
        try{
        	ItemViabilidadeCTRL.getItemViabilidade(iv);		
        } catch (Exception ex) {
			system.debug(ex.getMessage());
		}
		Test.stopTest();
    }
    
    @isTest static void testEnderecoAnaliseViabilidade() {
        Analise_de_viabilidade__c analiseViabilidade = [Select Id from Analise_de_viabilidade__c];
        analiseViabilidade.Prazo_de_Instalacao__c = 1;
        analiseViabilidade.Status__c = 'Concluída';
        update analiseViabilidade;
    }
}