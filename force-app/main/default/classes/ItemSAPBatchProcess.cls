public class ItemSAPBatchProcess implements Queueable, Database.AllowsCallouts {
    
    public static void execute(QueueableContext context) {
        
        ItemSAPDTO productTO = new ItemSAPDTO();
		List<Product2> listProduct = new List<Product2>();
		ItemSAPService service = new ItemSAPService();
        
        try{
            productTO = service.executarGet();
            
            if(productTO.statusCode == 200) {
                List<ControleDeServicos__c> logErro = new List<ControleDeServicos__c>();
                
                for(ItemSAPDTO.Response obj : productTO.value){
                    try{
                        ItemSAPHelper.validate(obj);
                        listProduct.add(ItemSAPHelper.createObject(obj));
                    }catch(ItemSAPHelper.ItemSAPHelperException e){
                        logErro.add(ControleDeServicoBO.getInstance().gerarLogPai('Erro', 'ItemSAPBatchProcess', 'Validate', null, JSON.serialize(obj), e.getMessage(), null, System.Now(), true));
                    }catch(Exception e){
                        logErro.add(ControleDeServicoBO.getInstance().gerarLogPai('Erro', 'ItemSAPBatchProcess', 'Exception', null, JSON.serialize(obj), e.getMessage(), null, System.Now(), true));
                    } 
                }
                
                if (!logErro.isEmpty()) {                
                    insert logErro;
                } 
            }
            
            if (!listProduct.isEmpty()) {
                
                List<Product2> listProductsToUpdate = new List<Product2>();
                List<Product2> productsToInsert = new List<Product2>();
                
                listProductsToUpdate = ItemSAPHelper.createProdutcsToUpdate(listProduct);
                productsToInsert = ItemSAPHelper.createProdutcsToInsert(listProduct, listProductsToUpdate);
           
                if(!listProductsToUpdate.isEmpty()){
                    Database.executeBatch(new ItemSAPBatchUpdateProduct(listProductsToUpdate), 200);
                }
                
                if(!productsToInsert.isEmpty()){
                    Database.executeBatch(new ItemSAPBatchInsertProduct(productsToInsert), 200);
                }
            }            

        }catch(Exception ex){
            insert ControleDeServicoBO.getInstance().gerarLogPai('Erro', 'ItemSAPBatchProcess', 'GET - Items SAP', null, JSON.serialize(productTO), ex.getMessage(), productTO.statusCode, System.Now(), true);
        }
    }    
}