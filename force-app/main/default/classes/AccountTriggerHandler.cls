public class AccountTriggerHandler  {

	public static void formatacaondereco(){
		Map<Id,Account> newMapAccount = (Map<Id,Account>) Trigger.newMap;
		Map<Id,Account> oldMap = (Map<Id,Account>) Trigger.oldMap;
		Map<String,String> mapLogradouro = new Map<String,String>();
		for (logradouro__c log : [Select Id, Name, codigo__c, Abreviatura__c FROM logradouro__c]){
			mapLogradouro.put(log.abreviatura__c, log.Name);
		}
		for(Account acc : newMapAccount.values()){
			
			System.debug('>>'+oldMap.get(acc.Id).BillingStreet);
			if(acc.Razao_Social__c!=null && acc.Name!=acc.Razao_Social__c) acc.Name = acc.Razao_Social__c;
			if(acc.BillingStreet != null && oldMap.get(acc.Id).BillingStreet == null){
				System.debug('rua>>'+acc.BillingStreet);
				System.debug('cep>>'+acc.BillingPostalCode);
				System.debug('estado>>'+acc.BillingState);
				System.debug('cidade>>'+acc.BillingCity);
				System.debug('bairoo>>'+acc.Bairro_de_cobranca__c);
				System.debug('numero>>'+acc.Numero_de_cobranca__c);
				String rua = acc.BillingStreet;
				String TipoLogradouro = rua.split(' ')[0];
				TipoLogradouro = TipoLogradouro.toUpperCase();
				acc.BillingStreet = rua.removeStart(TipoLogradouro);
				if(mapLogradouro.containsKey(TipoLogradouro)){
					acc.Tipo_de_logradouro_cobranca__c = mapLogradouro.get(TipoLogradouro);
				}

				acc.Numero_de_cobranca__c = rua.substringBetween('Nº ',',');
				system.debug('>>>> '+rua.substringBetween('Nº ',','));
				acc.Bairro_de_cobranca__c = rua.substringAfterLast(',');
				system.debug('>>>> '+rua.substringAfterLast(','));
			
				System.debug('rua>>'+acc.BillingStreet);
				System.debug('cep>>'+acc.BillingPostalCode);
				System.debug('estado>>'+acc.BillingState);
				System.debug('cidade>>'+acc.BillingCity);
				System.debug('bairoo>>'+acc.Bairro_de_cobranca__c);
				System.debug('numero>>'+acc.Numero_de_cobranca__c);

				if(acc.ShippingStreet == null && oldMap.get(acc.Id).ShippingStreet == null){
					acc.ShippingCity		= acc.BillingCity;
					acc.ShippingCountry		= acc.BillingCountry;
					acc.ShippingPostalCode	= acc.BillingPostalCode;
					acc.ShippingState		= acc.BillingState;
					acc.ShippingStreet		= acc.BillingStreet;
					acc.Bairro_de_entrega__c = acc.Bairro_de_cobranca__c;
					acc.Tipo_de_logradouro_entrega__c = acc.Tipo_de_logradouro_cobranca__c;
					acc.Numero_de_entrega__c = acc.Numero_de_cobranca__c;
				}
			}
		}
	}

	public static void associaCatalogoOpp(){
	
		Map<Id,Account> newMapAccount = (Map<Id,Account>) Trigger.newMap;
		Map<Id,Account> oldMap = (Map<Id,Account>) Trigger.oldMap;
		
		Map<String,String> idAccUF = new Map<String,String>();
		
		for(Account acc : newMapAccount.values()){
			if(acc.BillingState != null && oldMap.get(acc.Id).BillingState == null) idAccUF.put(acc.Id,acc.BillingState);
		}
		
		if(idAccUF.size()>0){
			List<Opportunity> listOpp = [SELECT Id, Pricebook2Id, AccountId, Account.BillingState FROM Opportunity WHERE StageName = 'Mapeamento' AND Pricebook2Id = NULL];

			if(listOpp.size()>0){
				String Idpapel = UserInfo.getUserRoleId();
				List<Group> papeis = [Select Id, DeveloperName FROM Group Where Id =:Idpapel];
				String TipoPapel = null;
				if(!papeis.isEmpty()){
					if(papeis.get(0).DeveloperName.containsIgnoreCase('CARRIER')||papeis.get(0).DeveloperName.containsIgnoreCase('ISP')){
						TipoPapel = 'CARRIER';
					}else if(papeis.get(0).DeveloperName.containsIgnoreCase('GOVERNO')||papeis.get(0).DeveloperName.containsIgnoreCase('ISP')){
						TipoPapel = 'CORPORATIVO';
					}
				}

				List<Pricebook2> catalogos = [SELECT Id, UF__c FROM Pricebook2 Where UF__c IN: idAccUF.values() and isActive =:true and Tipo_do_catalogo__c =:TipoPapel];
				
				if(catalogos.size()>0){
					Map<String,String> mapCatalogo = new Map<String,String>();
					List<Opportunity> oppUpdates = new List<Opportunity>();
				
					for(Pricebook2 c : catalogos){
						mapCatalogo.put(c.UF__c,c.Id);
					}

					for(Opportunity opp : listOpp){
						opp.Pricebook2Id = mapCatalogo.get(opp.Account.BillingState);
						oppUpdates.add(opp); 
					}

					update oppUpdates; 
				}
			}
		}
	}

	public static void validaCnpj(){
        
        List<Account> contas = (List<Account>) Trigger.new;
        
        String cnpjTelaSemFormatacao;
		String cnpjTelaComFormatacao;
		Map<String,Account> mapConta = new Map<String,Account>(); 
		
		for(Account conta : contas){
			if(!String.isBlank(conta.CNPJ__c)){
				cnpjTelaSemFormatacao = conta.CNPJ__c.replaceAll('\\D','');

				if(cnpjTelaSemFormatacao.length()!=14 && cnpjTelaSemFormatacao.length()!=11) conta.addError('Quantidade de caracteres inválida no campo cnpj');
				
				if(cnpjTelaSemFormatacao.length()==11 && conta.Type!='Parceiro') conta.addError('Somente contas do tipo parceiro aceitam CPF');
				
				if(cnpjTelaSemFormatacao.length()==14){
					cnpjTelaComFormatacao = cnpjTelaSemFormatacao.replaceAll('(\\d{2})(\\d{3})(\\d{3})(\\d{4})(\\d{2})', '$1.$2.$3/$4-$5');
				}else if(cnpjTelaSemFormatacao.length()==11){
					cnpjTelaComFormatacao = cnpjTelaSemFormatacao.replaceAll('(\\d{3})(\\d{3})(\\d{3})(\\d{2})', '$1.$2.$3-$4');
				}

				cnpjTelaComFormatacao = cnpjTelaSemFormatacao.replaceAll('(\\d{2})(\\d{3})(\\d{3})(\\d{4})(\\d{2})', '$1.$2.$3/$4-$5');
				mapConta.put(cnpjTelaComFormatacao,conta);
				mapConta.get(cnpjTelaComFormatacao).CNPJ__c = cnpjTelaComFormatacao;
			}
		}

        if(!mapConta.isEmpty()){	
			List<Account> listaContaComFormatacao = [SELECT Id, CNPJ__c FROM Account WHERE CNPJ__c IN:mapConta.keySet()];
			
			if(!listaContaComFormatacao.isEmpty()){
				for(Account conta : listaContaComFormatacao){
					if(mapConta.containsKey(conta.CNPJ__c) && mapConta.get(conta.CNPJ__c).CNPJ__c.Equals(conta.CNPJ__c) && mapConta.get(conta.CNPJ__c).Id != conta.Id ){
						mapConta.get(conta.CNPJ__c).addError('Já existe uma conta com este CNPJ! ');
					}
				}
			}
		}
	}
}