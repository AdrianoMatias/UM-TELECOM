@isTest
private class BatchCriaItensContrato_Test {
    
    @isTest
    static void testBatchCriaItensContrato1() {
        
        Account acc = new Account(Name = 'Test Account', Grupo__c = '103');
        insert acc;
        
        Contract cont = new Contract(AccountId = acc.Id, Status = 'Esboço');
        insert cont;
        
        Opportunity opp = new Opportunity(Name = 'Test Opportunity', AccountId = acc.Id, StageName = 'Mapeamento', CloseDate = Date.today(), Pricebook2Id = '01s4T000001Lo7JQAS', ContractId = cont.Id);
        insert opp;
        
        WorkType wt = new WorkType(Name = 'Controle geral da implantação Soluções Digitais', EstimatedDuration = 0);
        insert wt;
        
        Pricebook2 pb2 = new Pricebook2(Name = 'Equipamentos e Insumos', Regiao__c = 'Sudeste', UF__c = 'SP');
        insert pb2;
        
        Entitlement direito = new Entitlement(Name = 'Implantação - Geral', AccountId = acc.Id);
        insert direito;
        
        Product2 prod = new Product2(Name = 'Test Product', ProductCode = 'TEST123', isActive = true);
        insert prod;
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = '01s4T000001Lo7JQAS', Product2Id = prod.Id, UnitPrice = 1, IsActive = True);
        insert pbe;
        
        Analise_de_viabilidade__c av = new Analise_de_viabilidade__c(Oportunidade__c = opp.Id, Categoria_do_Cat_logo_de_Produtos__c = 'SD-WAN');
        insert av;
        
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId = opp.Id,
            Product2Id = pbe.Id,
            Quantity = 1,
            TotalPrice = 100.00,
            Analise_de_viabilidade__c = av.Id,
            Quantidade_de_produtos__c = 1
        );
        insert oli;
        
        String vIdOpp = opp.Id;
        List<String> queryString1 = new List<String>{vIdOpp};
            
        Test.startTest();
        InvocableCriaItensContrato.invokeBatch(queryString1);
        Test.stopTest();
        
        List<Item_do_Contrato__c> items = [SELECT Id, Name, Quantidade__c, Produto__c, Valor__c, NumeroItemContrato__c FROM Item_do_Contrato__c];
        System.assertEquals(1, items.size());
        
        Item_do_Contrato__c item = items[0];
        System.assertEquals('Test Product', item.Name);
        System.assertEquals(1, item.Quantidade__c);
        System.assertEquals(prod.Id, item.Produto__c);
        System.assertEquals(100.00, item.Valor__c);
        //System.assertEquals(1, item.NumeroItemContrato__c);
        
        // Verificar a atualização da linha de item da oportunidade
        OpportunityLineItem updatedOli = [SELECT Item_do_Contrato__c FROM OpportunityLineItem WHERE Id = :oli.Id];
        //System.assertNotEquals(null, updatedOli.Item_do_Contrato__c);
        
        // Verificar a atualização da análise de viabilidade
        Analise_de_viabilidade__c updatedAv = [SELECT Circuito_Existente__c FROM Analise_de_viabilidade__c WHERE Id = :av.Id];
        System.assertNotEquals(null, updatedAv.Circuito_Existente__c);
        
        // Verificar a criação da ordem de serviço
        List<WorkOrder> workOrders = [SELECT Id FROM WorkOrder WHERE Contrato__c = :opp.ContractId];
        //System.assertEquals(1, workOrders.size());
    }
    
    @isTest
    static void testBatchCriaItensContrato2() {
        
        Account acc = new Account(Name = 'Test Account', Grupo__c = '103');
        insert acc;
        
        Contract cont = new Contract(AccountId = acc.Id, Status = 'Esboço');
        insert cont;
        
        Opportunity opp = new Opportunity(Name = 'Test Opportunity', AccountId = acc.Id, StageName = 'Mapeamento', CloseDate = Date.today(), Pricebook2Id = '01s4T000001Lo7JQAS', ContractId = cont.Id);
        insert opp;
        
        WorkType wt = new WorkType(Name = 'Controle geral da implantação Soluções Digitais', EstimatedDuration = 0);
        insert wt;
        
        Pricebook2 pb2 = new Pricebook2(Name = 'Equipamentos e Insumos', Regiao__c = 'Sudeste', UF__c = 'SP');
        insert pb2;
        
        Entitlement direito = new Entitlement(Name = 'Implantação - Geral', AccountId = acc.Id);
        insert direito;
        
        Product2 prod = new Product2(Name = 'Test Product', ProductCode = 'TEST123', isActive = true);
        insert prod;
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = '01s4T000001Lo7JQAS', Product2Id = prod.Id, UnitPrice = 1, IsActive = True);
        insert pbe;
        
        Analise_de_viabilidade__c av = new Analise_de_viabilidade__c(Oportunidade__c = opp.Id, Categoria_do_Cat_logo_de_Produtos__c = 'SD-WAN', Concentrador__c = True);
        insert av;
        
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId = opp.Id,
            Product2Id = pbe.Id,
            Quantity = 1,
            TotalPrice = 100.00,
            Analise_de_viabilidade__c = av.Id,
            Quantidade_de_produtos__c = 1
        );
        insert oli;
        
        String vIdOpp = opp.Id;
        List<String> queryString1 = new List<String>{vIdOpp};
            
        Test.startTest();
        InvocableCriaItensContrato.invokeBatch(queryString1);
        Test.stopTest();
        
        List<Item_do_Contrato__c> items = [SELECT Id, Name, Quantidade__c, Produto__c, Valor__c, NumeroItemContrato__c FROM Item_do_Contrato__c];
        System.assertEquals(1, items.size());
        
        Item_do_Contrato__c item = items[0];
        System.assertEquals('Test Product', item.Name);
        System.assertEquals(1, item.Quantidade__c);
        System.assertEquals(prod.Id, item.Produto__c);
        System.assertEquals(100.00, item.Valor__c);
        //System.assertEquals(1, item.NumeroItemContrato__c);
        
        // Verificar a atualização da linha de item da oportunidade
        OpportunityLineItem updatedOli = [SELECT Item_do_Contrato__c FROM OpportunityLineItem WHERE Id = :oli.Id];
        //System.assertNotEquals(null, updatedOli.Item_do_Contrato__c);
        
        // Verificar a atualização da análise de viabilidade
        Analise_de_viabilidade__c updatedAv = [SELECT Circuito_Existente__c FROM Analise_de_viabilidade__c WHERE Id = :av.Id];
        System.assertNotEquals(null, updatedAv.Circuito_Existente__c);
        
        // Verificar a criação da ordem de serviço
        List<WorkOrder> workOrders = [SELECT Id FROM WorkOrder WHERE Contrato__c = :opp.ContractId];
        //System.assertEquals(1, workOrders.size());
    }
}