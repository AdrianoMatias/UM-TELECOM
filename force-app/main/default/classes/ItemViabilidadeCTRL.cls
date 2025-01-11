public class ItemViabilidadeCTRL {
    @AuraEnabled
    public static void getItemViabilidade(String viabilityId) {
        List<Produto_de_viabilidade__c> produtosViabilidade = new List<Produto_de_viabilidade__c>();
        List<Item_da_viabilidade__c> itensViabilidade = [SELECT Produto_de_viabilidade__c FROM Item_da_viabilidade__c WHERE Id =: viabilityId];
        if(String.isNotBlank(itensViabilidade[0].Produto_de_viabilidade__c)) {
            
        	produtosViabilidade = [SELECT Id, Codigo__c, Name, Valor_unitario__c FROM Produto_de_viabilidade__c WHERE Id =: itensViabilidade[0].Produto_de_viabilidade__c];
            System.debug('Produtos de Viabilidade: ' + produtosViabilidade[0]);
        }
        try {
            if(!produtosViabilidade.isEmpty()) {
                IntegrationModels.ProdutoViabilidade result = IntegrationServices.getSAPServiceProdutoViabilidade(produtosViabilidade[0].Codigo__c);
                
                System.debug('Result Extra: ' + result.Extra[0]);
                
                if (String.isNotBlank(result.Extra[0].codigo)) {
                    produtosViabilidade[0].Codigo__c = result.Extra[0].codigo;
                }
                
                if (String.isNotBlank(result.Extra[0].descricao)) {
                    produtosViabilidade[0].Name = result.Extra[0].descricao;
                }
                
                if (result.Extra[0].preco != null && result.Extra[0].preco > 0) {
                    produtosViabilidade[0].Valor_unitario__c = result.Extra[0].preco;
                }
                
                System.debug('Produtos de Viabilidade: ' + produtosViabilidade[0]);
                update produtosViabilidade;
            }
        } catch(Exception e) {
            System.debug('Linha: ' + e.getStackTraceString());
            System.debug('Mensagem ERRO: ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
}