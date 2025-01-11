public class FaturaSAPBatchProcess implements Queueable, Database.AllowsCallouts {
    
    public static void execute(QueueableContext context) {
        
        FaturaSAPDTO faturaTO = new FaturaSAPDTO();
		List<Fatura__c> listFatura = new List<Fatura__c>();
		FaturaSAPService service = new FaturaSAPService();
        
        try{
            faturaTO = service.executarGet();
            
            if(faturaTO.statusCode == 200) {
                Set<String> setAccount = new Set<String>();
                Set<String> setContract = new Set<String>();
                Map<String, Account> mapAccount = new Map<String, Account>();
				Map<String, Contract> mapContract = new Map<String, Contract>();

                for(FaturaSAPDTO.Response obj : faturaTO.value){
                    setAccount.add(obj.CodigoDoCliente);
                    setContract.add(obj.ContratoSAP);
                }
                
                for(Account acc : AccountDAO.buscarCodigoCliente(setAccount)){
                    mapAccount.put(acc.Codigo_SAP_cliente__c, acc);
                }

                for(Contract con : ContractDAO.buscarCodigoContrato(setContract)){
                    mapContract.put(con.Codigo_do_contrato__c, con);
                }
                
                List<ControleDeServicos__c> logErro = new List<ControleDeServicos__c>();

                for(FaturaSAPDTO.Response obj : faturaTO.value){
                    try{
                        FaturaSAPHelper.validate(obj, mapAccount, mapContract);
                        listFatura.add(FaturaSAPHelper.createObject(obj, mapAccount, mapContract));
                    }catch(FaturaSAPHelper.FaturaSAPHelperException e){
                        logErro.add(ControleDeServicoBO.getInstance().gerarLogPai('Erro', 'FaturaSAPBatchProcess', 'Validate', null, JSON.serialize(obj), e.getMessage(), null, System.Now(), true));
                    }catch(Exception e){
                        logErro.add(ControleDeServicoBO.getInstance().gerarLogPai('Erro', 'FaturaSAPBatchProcess', 'Exception', null, JSON.serialize(obj), e.getMessage(), null, System.Now(), true));
                    }
                }

                if (!logErro.isEmpty()) {                
                    insert logErro;
                } 
            }
            
            if (!listFatura.isEmpty()) {                
				Database.executeBatch(new FaturaSAPBatchUpsert(listFatura), 200);
            }            

        }catch(Exception ex){
            insert ControleDeServicoBO.getInstance().gerarLogPai('Erro', 'FaturaSAPBatchProcess', 'GET - Faturas SAP', null, JSON.serialize(faturaTO), ex.getMessage(), faturaTO.statusCode, System.Now(), true);
        }
    }    
}