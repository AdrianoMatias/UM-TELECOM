public class ProdutosDaOportunidadeCTRL  {

	@AuraEnabled
	public static List<ProdutosDaOportunidadeCTRL.produtoInfo> getListaProduto(String idcatalogo) {
		try {
			List<ProdutosDaOportunidadeCTRL.produtoInfo> listaProduto = new List<ProdutosDaOportunidadeCTRL.produtoInfo>();
			Set<Id> idProd = new Set<Id>();

			List<PricebookEntry> listPbe = [
				SELECT Id, Preco_Minimo_do_Executivo__c, Preco_Minimo_do_Gerente__c, Preco_do_Diretor__c, Pricebook2Id, Product2Id, Name, UnitPrice, ProductCode 
				FROM PricebookEntry 
				WHERE Pricebook2Id =: idcatalogo
			];
			
			for (PricebookEntry pbe : listPbe) {
				idProd.add(pbe.Product2Id);
			}

			List<Product2> listProdutosNaoCatalogados = [
				SELECT Id, Name, ProductCode 
				FROM Product2 
				WHERE id NOT IN: idProd AND ProductCode LIKE 'C%' AND IsActive = true
			];

			for (Product2 produto : listProdutosNaoCatalogados) {
				ProdutosDaOportunidadeCTRL.produtoInfo prod = new ProdutosDaOportunidadeCTRL.produtoInfo();
				prod.codigoProduto = produto.ProductCode;
				prod.nomeProduto = produto.Name;
				prod.IdProduto = produto.Id;
				listaProduto.add(prod);
			}

			return listaProduto;
		} catch (Exception ex) {
			throw new AuraHandledException('Houve um problema no retorno das informações do produto');
		}
	}


	
	@AuraEnabled
	public static void adicaoProduto(String produtoString, String idcatalogo){
		//adição de produto que não está no catálogo padrão para evitar erro
		Id catalogoPadrao = (!Test.isRunningTest() ? [Select Id FROM Pricebook2 WHERE IsStandard =: true limit 1].Id : Test.getStandardPricebookId());
		List<PricebookEntry> listaProdutos = [Select Id, product2Id FROM PricebookEntry WHERE Pricebook2Id =: catalogoPadrao];
		Map<Id,PricebookEntry> mapPbe = new Map<Id,PricebookEntry>();

		for(PricebookEntry pbe : listaProdutos){
			mapPbe.put(pbe.Product2Id, pbe);
		} 
		
		List<ProdutosDaOportunidadeCTRL.produtoInfo> ListProd;  
		System.debug('produtoString '+produtoString);
		
        if(String.isNotBlank(produtoString)) {
            ListProd = (List<ProdutosDaOportunidadeCTRL.produtoInfo>) JSON.deserialize(produtoString, list<ProdutosDaOportunidadeCTRL.produtoInfo>.class);
        }
		try{
			List<PricebookEntry> ListPbe = new List<PricebookEntry>();
			List<PricebookEntry> ListPbePadrao = new List<PricebookEntry>();
			for(ProdutosDaOportunidadeCTRL.produtoInfo prod : ListProd){
				
				if(!mapPbe.containsKey(prod.IdProduto)){
					PricebookEntry pbePadrao = new PricebookEntry();
					pbePadrao.Product2Id = prod.IdProduto;
					pbePadrao.Pricebook2Id = catalogoPadrao;
					pbePadrao.UnitPrice = prod.PrecoUnitario;
					pbePadrao.Preco_Minimo_do_Gerente__c = prod.precoGerente;
					pbePadrao.Preco_Minimo_do_Executivo__c = prod.precoExecutivo;
					pbePadrao.Preco_do_Diretor__c = prod.precoDiretor;
					pbePadrao.IsActive = true;
					ListPbePadrao.add(pbePadrao);
				}

				if(idcatalogo != catalogoPadrao){
					PricebookEntry pbe = new PricebookEntry();
					pbe.Product2Id = prod.IdProduto;
					pbe.Pricebook2Id = idcatalogo;
					pbe.UnitPrice = prod.PrecoUnitario;
					pbe.Preco_Minimo_do_Gerente__c = prod.precoGerente;
					pbe.Preco_Minimo_do_Executivo__c = prod.precoExecutivo;
					pbe.Preco_do_Diretor__c = prod.precoDiretor;
					pbe.IsActive = true;
					ListPbe.add(pbe);
				}
			}
			//inserindo produtos que não estão no catalogo
			System.debug('qtd produtos padrao '+ListPbePadrao.size());
			if(ListPbePadrao.size()>0) insert ListPbePadrao;
			insert ListPbe;
		}catch (exception ex){
			throw new AuraHandledException(ex.getMessage());
		}
	}

	Public class produtoInfo{
	
        @AuraEnabled public String  IdProduto;
		@AuraEnabled public String  nomeProduto;
		@AuraEnabled public String  codigoProduto;
        @AuraEnabled public Decimal precoExecutivo;
		@AuraEnabled public Decimal precoGerente;
		@AuraEnabled public Decimal precoDiretor;
        @AuraEnabled public Decimal PrecoUnitario;
		
		public produtoInfo() {
            this.IdProduto = '';
            this.nomeProduto = '';
            this.codigoProduto  = '';
            this.precoExecutivo  = 0;
            this.precoGerente  = 0;
			this.precoDiretor  = 0;
            this.PrecoUnitario = 0;
        } 
	}
}