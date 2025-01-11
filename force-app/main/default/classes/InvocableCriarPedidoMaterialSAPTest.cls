@isTest 
public with sharing class InvocableCriarPedidoMaterialSAPTest {
    
    @TestSetup
	static void setup() {
		
        Account acc = new Account();
        acc.Name = 'umtelecom';
        acc.Codigo_SAP_cliente__c = 'TESTE';
        insert acc;

        WorkType workType = new WorkType();
        workType.Name = 'Teste';
        workType.EstimatedDuration = 3;
        insert workType;

        Contract contract = new Contract();
        //contract.GerarOrdemDeTrabalho__c = true;
        contract.AccountId = acc.Id;
        insert contract;

        Item_do_Contrato__c ic = new Item_do_Contrato__c();
        ic.Name = 'Circuito';
        ic.Numero_do_circuito__c  = '00007891';
        ic.Contrato__c = contract.Id;
        insert ic;

        WorkOrder workOrder = new workOrder();
        workOrder.AccountId  = acc.Id;
        workOrder.WorkTypeId = workType.Id;
        workOrder.Circuito__c = ic.Id;
        insert workOrder;

        Product2 product = new Product2();
        product.Name = 'PROD TESTE 1';
        product.ProductCode = 'CODE0001';
        insert product;

        ItemDesignado__c  itemDesignado = new ItemDesignado__c();
        itemDesignado.Produto__c = product.Id; 
        itemDesignado.Quantidade__c = 1;
        itemDesignado.Valor__c = 2990;
        itemDesignado.OrdemDeServico__c = workOrder.Id;
        insert itemDesignado;
        
    }
    
    @isTest static void executeSuccessTest() {  
        
        WorkOrder wo = [SELECT Id FROM WorkOrder LIMIT 1];

        List<InvocableCriarPedidoMaterialSAP.Request> requestList = new List<InvocableCriarPedidoMaterialSAP.Request>();
        InvocableCriarPedidoMaterialSAP.Request req = new InvocableCriarPedidoMaterialSAP.Request();
        req.workOrderId = wo.Id;
        requestList.add(req);

        HttpMock mock = new HttpMock(201,'OK','{"DocNum": 23198}', new Map<String,String>());
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        List<InvocableCriarPedidoMaterialSAP.Result> results = InvocableCriarPedidoMaterialSAP.execute(requestList);
        Test.stopTest();

    }
}