public class AccountDAO {

    public static Account buscarCodigoCliente(String codigoCliente) 
	{
		List<Account> accountList = buscarCodigoCliente(new Set<String>{codigoCliente});
		return accountList != null && !accountList.isEmpty() ? accountList[0] : null;
	}

	public static List<Account> buscarCodigoCliente(Set<String> setCodigoCliente) {
		return [
			SELECT
				Id,
            	Codigo_SAP_cliente__c,
            	Name,
            	CNPJ__c
			FROM
				Account
			WHERE
				Codigo_SAP_cliente__c IN :setCodigoCliente
		];
	}
}