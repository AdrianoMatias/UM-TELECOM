public with sharing class PreambuloCTRL {
    
    public Contract contrato {get;set;}
	public Account conta {get;set;}
    public Datetime dataAtual {get;set;}
    public String data {get;set;}
    public String dataAjustada {get;set;}
    public String dataPreambulo {get;set;}
    public String dataNascimento {get;set;}
    public User usuario {get; set;}
    public Decimal valor {get; set;}
    public Map<Id, Analise_de_viabilidade__c> mapAnalises {get; set;}
	public List<Item_do_Contrato__c> itens {get; set;}

    
    public PreambuloCTRL(){
		Id Idcontrato = ApexPages.currentPage().getParameters().get('id');
		System.debug('Idcontrato'+Idcontrato);
        contrato = [SELECT Id, OwnerId, ContractNumber, Codigo_do_contrato__c, AccountId, Total_do_contrato__c FROM Contract WHERE Id=:Idcontrato];
		System.debug('contrato>>>'+contrato);
		conta = [SELECT Id, Telefone_2__c, CNPJ__c, Razao_Social__c, Nome_Fantasia__c, Capital_Social__c, Natureza_Juridica__c, Data_de_Abertura__c, Situacao_RFB__c, Tipo_RFB__c, Inscricao_Estadual__c, Data_da_Situacao_Sintegra__c, 
						Situacao_Sintegra__c, Regime_de_Tributacao__c, Complemento_de_cobranca__c, Numero_de_cobranca__c, CNAE_Principal__c, Porte_da_Empresa__c, Inscricao_municipal__c, Descricao_das_Atividades__c, 
						Geolocalizacao__Latitude__s, Geolocalizacao__Longitude__s, Geolocalizacao__c, Bairro_de_cobranca__c, Numero_de_entrega__c, Bairro_de_entrega__c, Complemento_de_entrega__c, Email__c, Tipo_de_logradouro_cobranca__c, 
						Tipo_de_logradouro_entrega__c, Codigo_SAP_cliente__c, Codigo_SAP_envio__c, Codigo_SAP_cobranca__c,BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, BillingLatitude, BillingLongitude,
						BillingGeocodeAccuracy, BillingAddress, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry, ShippingLatitude, ShippingLongitude, ShippingGeocodeAccuracy, ShippingAddress, Phone, Website
						FROM Account WHERE Id =:contrato.AccountId];
		
		System.debug(conta);
	   
		itens = [SELECT Id, Contrato__c, Produto__r.Name, Produto__r.Description, Oportunidade__c, Dia_de_Vencimento__c, Banda__c, Valor__c, Ultima_acao_contratual__c, Status__c, Analise_de_Viabilidade__c, Name,
							Tipo_de_logradouro_de_origem__c,numero_de_origem__c,Rua_de_origem__c,Estado_de_origem__c,Complemento_de_origem__c,Cidade_de_origem__c,CEP_de_origem__c,Bairro_de_origem__c,
							Tipo_de_logradouro_de_destino__c,numero_de_destino__c,Rua_de_destino__c,Estado_de_destino__c,Complemento_de_destino__c,Cidade_de_destino__c,CEP_de_destino__c,Bairro_de_destino__c
							FROM Item_do_Contrato__c WHERE Contrato__c = :Idcontrato];

		System.debug(UserInfo.getUserId());
        usuario = [SELECT id, Phone FROM User where id = : contrato.OwnerId];
        dataAtual =  Datetime.now() ;
        data = dataAtual.format('dd MMMM yyyy', 'America/Sao_Paulo ');
        
        dataAjustada = data.replace('January', 'Janeiro').replace('February', 'Fevereiro').replace('March', 'Março').replace('April', 'Abril').replace('May', 'Maio').replace('June', 'Junho').replace('July', 'Julho').replace('August', 'Agosto').replace('September', 'Setembro').replace('October', 'Outubro').replace('November', 'Novembro').replace('December', 'Dezembro');
        
        dataPreambulo = dataAtual.format('dd/MM/yyyy', 'America/Sao_Paulo');
	}
    
    public PreambuloCTRL(ApexPages.StandardController stdController) {
        String Idcontrato = (String)stdController.getId();
        contrato = [SELECT Id, OwnerId, ContractNumber, Codigo_do_contrato__c, AccountId FROM Contract WHERE Id=:Idcontrato];
		System.debug('contrato>>>'+contrato);
		conta = [SELECT Id, Telefone_2__c, CNPJ__c, Razao_Social__c, Nome_Fantasia__c, Capital_Social__c, Natureza_Juridica__c, Data_de_Abertura__c, Situacao_RFB__c, Tipo_RFB__c, Inscricao_Estadual__c, Data_da_Situacao_Sintegra__c, 
						Situacao_Sintegra__c, Regime_de_Tributacao__c, Complemento_de_cobranca__c, Numero_de_cobranca__c, CNAE_Principal__c, Porte_da_Empresa__c, Inscricao_municipal__c, Descricao_das_Atividades__c, 
						Geolocalizacao__Latitude__s, Geolocalizacao__Longitude__s, Geolocalizacao__c, Bairro_de_cobranca__c, Numero_de_entrega__c, Bairro_de_entrega__c, Complemento_de_entrega__c, Email__c, Tipo_de_logradouro_cobranca__c, 
						Tipo_de_logradouro_entrega__c, Codigo_SAP_cliente__c, Codigo_SAP_envio__c, Codigo_SAP_cobranca__c,BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, BillingLatitude, BillingLongitude,
						BillingGeocodeAccuracy, BillingAddress, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry, ShippingLatitude, ShippingLongitude, ShippingGeocodeAccuracy, ShippingAddress, Phone, Website
						FROM Account WHERE Id =:contrato.AccountId];
		
		System.debug(conta);
	   
		itens = [SELECT Id, Contrato__c, Produto__c, Oportunidade__c, Dia_de_Vencimento__c, Banda__c, Valor__c, Ultima_acao_contratual__c, Status__c, Analise_de_Viabilidade__c, Name 
				 FROM Item_do_Contrato__c WHERE Contrato__c = :Idcontrato];
        
		System.debug(UserInfo.getUserId());
        usuario = [SELECT id, Phone FROM User where id = : contrato.OwnerId];
        dataAtual =  Datetime.now() ;
        data = dataAtual.format('dd MMMM yyyy', 'America/Sao_Paulo ');
        
        dataAjustada = data.replace('January', 'Janeiro').replace('February', 'Fevereiro').replace('March', 'Março').replace('April', 'Abril').replace('May', 'Maio').replace('June', 'Junho').replace('July', 'Julho').replace('August', 'Agosto').replace('September', 'Setembro').replace('October', 'Outubro').replace('November', 'Novembro').replace('December', 'Dezembro');
        
        dataPreambulo = dataAtual.format('dd/MM/yyyy', 'America/Sao_Paulo');
        
    }
}