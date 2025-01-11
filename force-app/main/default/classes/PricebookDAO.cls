public class PricebookDAO {

    public static Pricebook2 buscarPricebookName(String name) {
		List<Pricebook2> pricebookList = buscarPricebookName(new Set<String>{name});
		return pricebookList != null && !pricebookList.isEmpty() ? pricebookList[0] : null;
	}

	public static List<Pricebook2> buscarPricebookName(Set<String> setName) {
		return [
			SELECT
				Id,
            	Name
			FROM
				Pricebook2
			WHERE
            		IsActive = true
			 	And Name IN :setName
		];
	}
}