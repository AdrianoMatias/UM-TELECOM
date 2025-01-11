public class AnaliseDeViabilidadeTriggerHandler  {

	public static void alteraTipoRegistroViabilidade(){
		Map<Id,Analise_de_viabilidade__c> newMapAnalise = (Map<Id,Analise_de_viabilidade__c>) Trigger.newMap;
		Map<Id,Analise_de_viabilidade__c> oldMapAnalise = (Map<Id,Analise_de_viabilidade__c>) Trigger.oldMap;
		Map<Id,OpportunityLineItem> mapIdOli = new Map<Id,OpportunityLineItem>();
		Id recordTypeConcluida = Schema.SObjectType.Analise_de_viabilidade__c.getRecordTypeInfosByDeveloperName().get('Concluida').getRecordTypeId();
		
		List<OpportunityLineItem> listOli = [Select id, Analise_de_viabilidade__c, Product2Id, Product2.Endereco_Destino__c, Product2.Endereco_origem__c FROM OpportunityLineItem WHERE Analise_de_viabilidade__c IN: newMapAnalise.keySet()];
		for(OpportunityLineItem oli : listOli){
			mapIdOli.put(oli.Analise_de_viabilidade__c, oli);
		}
		
		for(Analise_de_viabilidade__c av : newMapAnalise.values()){
            if(av.Status__c!='Aberta' && oldMapAnalise.get(av.Id).Status__c=='Aberta'){
			if(mapIdOli.containsKey(av.Id) && mapIdOli.get(av.Id).Product2.Endereco_Origem__c){
				if(String.isBlank(av.Bairro_de_origem__c) || String.isBlank(av.Cidade_de_origem__c) ||
					String.isBlank(av.Tipo_de_logradouro_origem__c) || String.isBlank(av.Rua_de_origem__c) ||
					String.isBlank(av.numero_de_origem__c) || String.isBlank(av.CEP_de_origem__c) ||String.isBlank(av.Estado_de_origem__c)){
						av.addError('Por favor, preencha todos os campos do endereço de origem.');
					}
				}
			
				if(mapIdOli.containsKey(av.Id) && mapIdOli.get(av.Id).Product2.Endereco_Destino__c){
					if(String.isBlank(av.Bairro_de_destino__c) || String.isBlank(av.Cidade_de_destino__c) ||
						String.isBlank(av.Tipo_de_logradouro_destino__c) || String.isBlank(av.Rua_de_destino__c) ||
						String.isBlank(av.numero_de_destino__c) || String.isBlank(av.CEP_de_destino__c) ||String.isBlank(av.Estado_de_destino__c)){
							av.addError('Por favor, preencha todos os campos do endereço de destino.');
                    			}
				}
			}
			
			if(av.Status__c=='Concluída' && oldMapAnalise.get(av.Id).Status__c!='Concluída'){
				av.RecordTypeId = recordTypeConcluida;
				av.Data_da_conclusao__c = Date.today();
			}
		}
	}


	public static void alteraTipoRegistroItemViabilidade(){
		List<Analise_de_viabilidade__c> listAnalise = (List<Analise_de_viabilidade__c>) Trigger.new;
		Map<Id,Analise_de_viabilidade__c> oldMapAnalise = (Map<Id,Analise_de_viabilidade__c>) Trigger.oldMap;
		
		Set<Id> idAnalises = new Set<Id>();

		for(Analise_de_viabilidade__c av : listAnalise){
			if(av.Status__c=='Concluída' && oldMapAnalise.get(av.Id).Status__c!='Concluída'){
				idAnalises.add(av.Id);
			}
		}

		List<Item_da_viabilidade__c> listItens = [Select Id, RecordTypeId FROM Item_da_viabilidade__c WHERE Analise_de_Viabilidade__c =:idAnalises];

		if(listItens.size()>0){
			Id recordTypeConcluida = Schema.SObjectType.Item_da_viabilidade__c.getRecordTypeInfosByDeveloperName().get('Concluida').getRecordTypeId();
			for(Item_da_viabilidade__c item : listItens){
				item.RecordTypeId = recordTypeConcluida;
			}

			update listItens;
		}
	}
}