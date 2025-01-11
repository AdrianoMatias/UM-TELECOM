public class ProductDAO {

    public static Product2 buscarProductCode(String productCode) 
	{
		List<Product2> productList = buscarProductCode(new Set<String>{productCode});
		return productList != null && !productList.isEmpty() ? productList[0] : null;
	}

	public static List<Product2> buscarProductCode(Set<String> setProductCode) {
		return [
			SELECT
				Id,
            	ProductCode,
            	isActive,
                TipoDeUtilizacao__c,
                QuantityUnitOfMeasure,
                UltimaAtualizacaoDoProdutoNoSap__c
			FROM
				Product2
			WHERE
				ProductCode IN :setProductCode
		];
	}
}