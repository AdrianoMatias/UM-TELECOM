@isTest 
private class ProdutosDaOportunidadeCTRLTest {
	
	@TestSetup
	private static void setupDados(){
		TestUtils.dadosProdutoCatalogo();

		Product2 prodTest = new Product2();
		prodTest.ProductCode = 'C0000004';
		prodTest.IsActive = true;
		prodTest.Name = 'prod nao catalogado';
		insert prodTest;

	}

	@isTest
	private static void getListaProdutoTest() {
		Pricebook2 catalogo = [Select Id FROM Pricebook2 where Name =: 'Catalogo teste Nordeste - PE']; 
		Test.startTest();
		List<ProdutosDaOportunidadeCTRL.produtoInfo> listProdNCat = ProdutosDaOportunidadeCTRL.getListaProduto(catalogo.Id);
		ProdutosDaOportunidadeCTRL.adicaoProduto(JSON.serialize(listProdNCat),catalogo.Id);
		Test.stopTest();
	}
}