public class ItemSAPHelper {
    
    public class ItemSAPHelperException extends Exception {}
    
    public static void validate(ItemSAPDTO.Response obj){
        if(String.isBlank(obj.ItemCode)){
            throw new ItemSAPHelperException('ItemCode não pode ser vazio');
        }
        if(String.isBlank(obj.ItemName)){
            throw new ItemSAPHelperException('ItemName não pode ser vazio');
        }
    }
    
    public static Product2 createObject(ItemSAPDTO.Response obj){
        
        String vertical;
        String tipoUtilizacao;
        
        switch on obj.U_Vertical{
            when '1' { vertical = 'Segurança'; }
            when '2' { vertical = 'Cloud & DataCenter'; }
            when '3' { vertical = 'Conectividade'; }
            when '4' { vertical = 'Mobilidade'; }
            when '5' { vertical = 'Serviços Gerenciados & Profissionais'; }
        }
        
        switch on obj.U_UtilizacaoSalesforce{
            when 'PV' { tipoUtilizacao = 'Produto de venda'; }
            when 'EQ' { tipoUtilizacao = 'Equipamento'; }
            when 'IN' { tipoUtilizacao = 'Insumo'; }            
        }
        
        Product2 prod = new Product2();
        
        prod.ProductCode = obj.ItemCode;
        prod.Name = obj.ItemName;
        prod.Description = obj.ItemName;
        prod.QuantityUnitOfMeasure = obj.InventoryUOM;
        prod.IsActive = obj.Valid == 'tYes' ? true : false;
        
        prod.UltimaAtualizacaoDoProdutoNoSap__c = !String.isBlank(obj.UpdateDate) ? Date.valueOf(obj.UpdateDate) : null;
        prod.Family = vertical;
        prod.TipoDeUtilizacao__c = tipoUtilizacao;
        
        return prod;
    }
    
    public static List<PricebookEntry> createPBEntry(List<Product2> prodList){
        
        List<PricebookEntry> listPBEntry = new List<PricebookEntry>();
        
        String standardPriceBookId = Test.isRunningTest() ? Test.getStandardPricebookId() : PricebookDAO.buscarPricebookName('Standard Price Book')?.Id;
        String equipamentosInsumosPriceBookId = PricebookDAO.buscarPricebookName('Equipamentos e Insumos')?.Id;
        String vendasPriceBookId = PricebookDAO.buscarPricebookName('Vendas')?.Id;
        
        for(Product2 prod : prodList){
            
            if(standardPriceBookId != null){
                PricebookEntry pbEntry = new PricebookEntry();
                pbEntry.Pricebook2Id = standardPriceBookId;
                pbEntry.Product2Id = prod.Id;
                pbEntry.UnitPrice = 0;
                pbEntry.UseStandardPrice = false;
                pbEntry.isActive = true;
                listPBEntry.add(pbEntry);
            }
            
            if(prod.ProductCode.startsWith('C') && vendasPriceBookId != null){
                PricebookEntry pbEntry = new PricebookEntry();
                pbEntry.Product2Id = prod.Id;
                pbEntry.UnitPrice = 0;
                pbEntry.UseStandardPrice = false;
                pbEntry.isActive = true;
                pbEntry.Pricebook2Id = vendasPriceBookId;
                listPBEntry.add(pbEntry);
            }            
            
            if(prod.ProductCode.startsWith('P') && equipamentosInsumosPriceBookId != null){
                PricebookEntry pbEntry = new PricebookEntry();
                pbEntry.Product2Id = prod.Id;
                pbEntry.UnitPrice = 0;
                pbEntry.UseStandardPrice = false;
                pbEntry.isActive = true;
                pbEntry.Pricebook2Id = equipamentosInsumosPriceBookId;
                listPBEntry.add(pbEntry);
            }
        }
        
        return listPBEntry;
    }
    
    public static List<Product2> createProdutcsToUpdate(List<Product2> prodListFromSAP){
        
        Map<String, Product2> mapProductFromSAP = new Map<String, Product2>();
        List<Product2> listProductToUpdate = new List<Product2>();
        
        for (Product2 product : prodListFromSAP) {
            mapProductFromSAP.put(product.ProductCode, product);
        }
        
        for (Product2 product : ProductDAO.buscarProductCode(mapProductFromSAP.keySet())) {
            product.IsActive = mapProductFromSAP.get(product.ProductCode).isActive;
            product.TipoDeUtilizacao__c = mapProductFromSAP.get(product.ProductCode).TipoDeUtilizacao__c;
            product.QuantityUnitOfMeasure = mapProductFromSAP.get(product.ProductCode).QuantityUnitOfMeasure;
            product.UltimaAtualizacaoDoProdutoNoSap__c = mapProductFromSAP.get(product.ProductCode).UltimaAtualizacaoDoProdutoNoSap__c;
                
            listProductToUpdate.add(product);
        }
        
        return listProductToUpdate;
        
    }
    
    public static List<Product2> createProdutcsToInsert(List<Product2> prodListFromSAP, List<Product2> listProductFromDatabase){
        
        List<Product2> productsToInsert = new List<Product2>();
        Set<String> setProdCode = new Set<String>();

        for(Product2 product : listProductFromDatabase){
            setProdCode.add(product.ProductCode);
        }

        for(Product2 product : prodListFromSAP){
            if(!setProdCode.contains(product.ProductCode)){
                productsToInsert.add(product);
            }
        }
        
        return productsToInsert;
    }
}