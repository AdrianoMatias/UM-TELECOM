public class ContractDAO {

    public static Contract buscarCodigoContrato(String codigoContrato) 
	{
		List<Contract> contractList = buscarCodigoContrato(new Set<String>{codigoContrato});
		return contractList != null && !contractList.isEmpty() ? contractList[0] : null;
	}

	public static List<Contract> buscarCodigoContrato(Set<String> setCodigoContrato) {
		return [
			SELECT
				Id,
            	Codigo_do_contrato__c,
            	AccountId,
            	Status
			FROM
				Contract
			WHERE
				Codigo_do_contrato__c IN :setCodigoContrato
		];
	}
}