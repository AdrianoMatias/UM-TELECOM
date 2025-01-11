@isTest
public class AsyncEnviaContractPlusAoSAP_Test {
@isTest
    static void invocableSuccess1() {
        Account acc = new Account(Name = 'Test Account', Grupo__c = '103', Codigo_SAP_cliente__c = 'C568956');
        insert acc;
        
        Contract cont = new Contract(AccountId = acc.Id, Status = 'Esboço', DiaVencimento__c = '12', ContractTerm = 12, StartDate = system.today(), AluguelContractPlus__c = 'N', TemporarioContractPlus__c = 'N', PermutaContractPlus__c = 'N', RecorrenteContractPlus__c = 'N', TipoNotaContractPlus__c = '1');
        insert cont;
        
        Product2 prod = new Product2(Name = 'Test Product', ProductCode = 'TEST1234', isActive = true);
        insert prod;
        
        Item_do_Contrato__c item1 = new Item_do_Contrato__c();
        item1.Conta__c = acc.Id;
        item1.Name = 'Test Item 1';
        item1.Quantidade__c = 100.00;
        item1.Valor__c = 200.00;
        item1.Contrato__c = cont.Id;
        item1.NumeroItemContrato__c = 1;
        item1.Produto__c = prod.Id;
        item1.ValorUnitario__c = 250;
        item1.Status__c = 'AGUARDANDO';
        item1.TipoFaturamento__c = '1';
        item1.FormaPagamentoInstalacao__c = '-1';
        item1.TaxaInstalacao__c = 150.00;
        item1.Banda__c = 50;
        item1.Rua_de_origem__c = 'Teste, 123';
        item1.Bairro_de_origem__c = 'Jardim do Teste';
        item1.Estado_de_origem__c = 'São João do Teste';
        item1.Cep_de_origem__c = '01215-222';
        item1.Cidade_de_origem__c = 'Osasco';
        item1.Tipo_de_logradouro_de_origem__c = 'Rua';
        item1.Complemento_de_origem__c = 'apto 45';
        item1.Numero_de_origem__c = '152';
        item1.Rua_de_destino__c = 'Teste, 123';
        item1.Bairro_de_destino__c = 'Jardim do Teste';
        item1.Estado_de_destino__c = 'São João do Teste';
        item1.Cep_de_destino__c = '01215-222';
        item1.Cidade_de_destino__c = 'Osasco';
        item1.Tipo_de_logradouro_de_destino__c = 'Rua';
        item1.Complemento_de_destino__c = 'apto 45';
        item1.Numero_de_destino__c = '152';
        insert item1;
      
        List<String> queryString1 = new List<String>{item1.Id};
            
        Test.startTest();
        AsyncEnviaContractPlusAoSAP.upsertContractPlusSAP(queryString1);
        Test.stopTest();
    }
    
    
    @isTest
    static void invocableSuccess2() {
        Account acc = new Account(Name = 'Test Account', Grupo__c = '103', Codigo_SAP_cliente__c = 'C568956');
        insert acc;
        
        Contract cont = new Contract(AccountId = acc.Id, Codigo_do_contrato__c = '9589', Status = 'Esboço', DiaVencimento__c = '12', ContractTerm = 12, StartDate = system.today(), AluguelContractPlus__c = 'N', TemporarioContractPlus__c = 'N', PermutaContractPlus__c = 'N', RecorrenteContractPlus__c = 'N', TipoNotaContractPlus__c = '1');
        insert cont;
        
        Product2 prod = new Product2(Name = 'Test Product', ProductCode = 'TEST1234', isActive = true);
        insert prod;
        
        Item_do_Contrato__c item1 = new Item_do_Contrato__c();
        item1.Conta__c = acc.Id;
        item1.Name = 'Test Item 1';
        item1.Quantidade__c = 100.00;
        item1.Valor__c = 200.00;
        item1.Contrato__c = cont.Id;
        item1.NumeroItemContrato__c = 2;
        item1.Produto__c = prod.Id;
        item1.Status__c = 'AGUARDANDO';
        item1.TipoFaturamento__c = '1';
        item1.ValorUnitario__c = 250;
        item1.Banda__c = 50;
        item1.FormaPagamentoInstalacao__c = '132';
        item1.TaxaInstalacao__c = 150.00;
        item1.Rua_de_origem__c = 'Rua Teste, 123';
        item1.Bairro_de_origem__c = 'Jardim do Teste';
        item1.Estado_de_origem__c = 'São João do Teste';
        item1.Cep_de_origem__c = '01215-222';
        item1.Cidade_de_origem__c = 'Osasco';
        item1.Tipo_de_logradouro_de_origem__c = 'Rua';
        item1.Complemento_de_origem__c = 'apto 45';
        item1.Numero_de_origem__c = '152';
        item1.Rua_de_destino__c = 'Teste, 123';
        item1.Bairro_de_destino__c = 'Jardim do Teste';
        item1.Estado_de_destino__c = 'São João do Teste';
        item1.Cep_de_destino__c = '01215-222';
        item1.Cidade_de_destino__c = 'Osasco';
        item1.Tipo_de_logradouro_de_destino__c = 'Rua';
        item1.Complemento_de_destino__c = 'apto 45';
        item1.Numero_de_destino__c = '152';
        insert item1;
      
        List<String> queryString1 = new List<String>{item1.Id};
            
        Test.startTest();
        AsyncEnviaContractPlusAoSAP.upsertContractPlusSAP(queryString1);
        Test.stopTest();
    }
    
    @isTest
    static void invocableSuccess3() {
        Account acc = new Account(Name = 'Test Account', Grupo__c = '103', Codigo_SAP_cliente__c = 'C568956');
        insert acc;
        
        Contract cont = new Contract(AccountId = acc.Id, Status = 'Esboço', DiaVencimento__c = '12', ContractTerm = 12, StartDate = system.today(), AluguelContractPlus__c = 'N', TemporarioContractPlus__c = 'N', PermutaContractPlus__c = 'N', RecorrenteContractPlus__c = 'N', TipoNotaContractPlus__c = '1');
        insert cont;
        
        Product2 prod = new Product2(Name = 'Test Product', ProductCode = 'TEST1234', isActive = true);
        insert prod;
        
        Item_do_Contrato__c item1 = new Item_do_Contrato__c();
        item1.Conta__c = acc.Id;
        item1.Name = 'Test Item 1';
        item1.Quantidade__c = 100.00;
        item1.Valor__c = 200.00;
        item1.Contrato__c = cont.Id;
        item1.NumeroItemContrato__c = 1;
        item1.Produto__c = prod.Id;
        item1.ValorUnitario__c = 250;
        item1.Status__c = 'AGUARDANDO';
        item1.TipoFaturamento__c = '1';
        //item1.FormaPagamentoInstalacao__c = '-1';
        //item1.TaxaInstalacao__c = 150.00;
        item1.Banda__c = 50;
        item1.Rua_de_origem__c = 'Rua Teste, 123';
        item1.Bairro_de_origem__c = 'Jardim do Teste';
        item1.Estado_de_origem__c = 'São João do Teste';
        item1.Cep_de_origem__c = '01215-222';
        item1.Cidade_de_origem__c = 'Osasco';
        item1.Tipo_de_logradouro_de_origem__c = 'Rua';
        item1.Complemento_de_origem__c = 'apto 45';
        item1.Numero_de_origem__c = '152';
        item1.Rua_de_destino__c = 'Teste, 123';
        item1.Bairro_de_destino__c = 'Jardim do Teste';
        item1.Estado_de_destino__c = 'São João do Teste';
        item1.Cep_de_destino__c = '01215-222';
        item1.Cidade_de_destino__c = 'Osasco';
        item1.Tipo_de_logradouro_de_destino__c = 'Rua';
        item1.Complemento_de_destino__c = 'apto 45';
        item1.Numero_de_destino__c = '152';
        insert item1;
      
        List<String> queryString1 = new List<String>{item1.Id};
            
        Test.startTest();
        AsyncEnviaContractPlusAoSAP.upsertContractPlusSAP(queryString1);
        Test.stopTest();
    }
    
}