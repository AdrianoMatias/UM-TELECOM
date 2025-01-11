public with sharing class PropostaCTRL {
    public String today {get;set;}
	public String nomeContatoOpp {get;set;}
	public String nomeConta {get;set;}
	public List<OpportunityLineItem> listaOli {get;set;}
    public Opportunity opp {get;set;}

    public PropostaCTRL(){}
    
    public PropostaCTRL(ApexPages.StandardController stdController){
		String idOpp = (String) stdController.getId();
        system.debug('>>>>>'+idOpp);
        listaOli = [Select Id, Name, Product2.Description, ProductCode, Product2.Name, Taxa_de_instalacao__c, Analise_de_viabilidade__c, Banda_Mbps__c, Retorno__c, Analise_de_viabilidade__r.Tipo_transporte__c, Analise_de_viabilidade__r.Numero_de_destino__c,
					Quantity, UnitPrice, Analise_de_viabilidade__r.Quantidade_de_Ips__c, Analise_de_viabilidade__r.Prazo_de_Instalacao__c, TotalPrice,Opportunity.Meses__c, Analise_de_viabilidade__r.Numero_de_origem__c,
					Analise_de_viabilidade__r.CEP_de_destino__c,  Analise_de_viabilidade__r.Rua_de_origem__c, Analise_de_viabilidade__r.Rua_de_destino__c, Analise_de_viabilidade__r.CEP_de_origem__c, 
					Analise_de_viabilidade__r.Data_da_conclusao__c, Analise_de_viabilidade__r.Qtd_Itens_Aprovacao__c, Analise_de_viabilidade__r.RecordType.Name, Analise_de_viabilidade__r.Complemento_da_origem__c, 
					Analise_de_viabilidade__r.Cidade_de_origem__c, Analise_de_viabilidade__r.Cidade_de_destino__c, Analise_de_viabilidade__r.Estado_de_origem__c, Analise_de_viabilidade__r.Estado_de_destino__c, 
					Analise_de_viabilidade__r.Bairro_de_origem__c, Analise_de_viabilidade__r.Bairro_de_destino__c, Analise_de_viabilidade__r.Ponto_de_referencia_do_destino__c, Analise_de_viabilidade__r.Ponto_de_referencia_de_origem__c, 
					Analise_de_viabilidade__r.Complemento_do_destino__c, Analise_de_viabilidade__r.Status__c, Analise_de_viabilidade__r.Tipo_de_logradouro_destino__c, Analise_de_viabilidade__r.Tipo_de_logradouro_origem__c
					FROM OpportunityLineItem 
					WHERE OpportunityId =: idOpp];

		opp = [select Id, AccountId, ContactId, Owner.Name, Owner.Phone, Owner.Title,  Account.BillingAddress, Account.BillingStreet, Account.Name FROM Opportunity WHERE Id =: idOpp];
		nomeConta = opp.Account.Name.toUpperCase();
		nomeContatoOpp = opp.Owner.Name.toUpperCase();
		System.debug('listaOli>> '+listaOli.size());
        Map<Integer, String> months = new Map<Integer, String>{ 1 => 'Janeiro', 2 => 'Fevereiro', 3 => 'Março', 4 => 'Abril', 5 => 'Maio', 6 => 'Junho', 7 => 'Julho',8 => 'Agosto', 9 => 'Setembro', 10 => 'Outubro',11 => 'Novembro', 12 => 'Dezembro'} ;
            
        Integer day = Datetime.now().day();
        Integer month = Datetime.now().month();
        Integer year = Datetime.now().year();
        
        this.today = 'Recife, ' + day + ' de ' + months.get(month) + ' de ' + year;
		System.debug(today);
    }
}