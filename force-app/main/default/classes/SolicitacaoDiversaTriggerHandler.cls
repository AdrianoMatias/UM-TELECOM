public class SolicitacaoDiversaTriggerHandler {
     
	 public static void atribuirFila() {
	 	List<Solicitacao_Diversa__c> soldvList = (List<Solicitacao_Diversa__c>) Trigger.new;
		Map<String,String> mapQueue = new Map<String,String>();

        List<QueueSobject> listQueue = [SELECT Id, Queue.name, QueueId, SobjectType FROM QueueSobject];
        For(QueueSobject fila: listQueue ){
            mapQueue.put(fila.Queue.name, fila.QueueId);
        }

		for(Solicitacao_Diversa__c soldv : soldvList){
			if(soldv.Setor__c != NULL && mapQueue.containsKey(soldv.Setor__c)){
				soldv.OwnerId = mapQueue.get(soldv.Setor__c);
			}
		}
    }


	public static void validaTipoSolicitacao() {
	 	List<Solicitacao_Diversa__c> listSoldv = (List<Solicitacao_Diversa__c>) Trigger.new;
		Set<Id> idItens = new Set<Id>();
		Set<Id> idProd = new Set<Id>();
		Map<Id,Product2> mapProdutos = new Map<Id,Product2>();
		Map<Id,Item_do_Contrato__c> mapItemContrato = new Map<Id,Item_do_Contrato__c>();
		System.debug('listSoldv>>> '+listSoldv);
		for(Solicitacao_Diversa__c sdv : listSoldv){
			if(sdv.Tipo_de_Solicitacao__c=='Upgrade'||sdv.Tipo_de_Solicitacao__c=='Downgrade'){
				idItens.add(sdv.Item_do_contrato__c);
				idProd.add(sdv.Produto__c);
			}
		}

		if(idItens.size()>0){
			mapItemContrato = new Map<Id,Item_do_Contrato__c>([Select Id, Name, Status__c, Produto__c, Valor__c, Produto__r.ProductCode FROM Item_do_Contrato__c Where Id IN: idItens]);
		}

		if(idProd.size()>0){
			mapProdutos = new Map<Id,Product2>([Select Id, Name, De__c, Ate__c, ProductCode FROM Product2 WHERE Id IN:idProd]);
		}

		if(mapProdutos.size()>0 && mapItemContrato.size()>0){
			for(Solicitacao_Diversa__c sdv : listSoldv){
				if(mapProdutos.containsKey(sdv.produto__c) && mapItemContrato.containsKey(sdv.Item_do_contrato__c)){
					if(mapProdutos.get(sdv.produto__c).De__c > sdv.Banda__c || mapProdutos.get(sdv.produto__c).Ate__c < sdv.Banda__c ){
						sdv.addError('A quantidde de banda solicitada não está disponível para este produto.');
					}
					
					if(mapItemContrato.get(sdv.Item_do_contrato__c).Produto__r.ProductCode != mapProdutos.get(sdv.produto__c).ProductCode){
						sdv.addError('O Produto que está realizando '+sdv.Tipo_de_Solicitacao__c +' é de um tipo diferente.');
					}
				}
			}
		}
	}

	public static void atualizaItemContrato() {
		List<Solicitacao_Diversa__c> listSoldv = (List<Solicitacao_Diversa__c>) Trigger.new;
		Map<Id,Solicitacao_Diversa__c> mapSol  = (Map<Id,Solicitacao_Diversa__c>) Trigger.oldMap;
		Set<Id> idItens = new Set<Id>();

		for(Solicitacao_Diversa__c sol : listSoldv){
			if('Upgrade, Downgrade'.containsIgnoreCase(sol.Tipo_de_Solicitacao__c) && sol.Status__c=='Concluída' && mapSol.get(sol.Id).Status__c=='Em andamento'){
				idItens.add(sol.Item_do_contrato__c);
			}
		}

		if(idItens.size()>0){
			Map<Id,Item_do_Contrato__c> mapItens = new Map<Id,Item_do_Contrato__c>([Select Id, Banda__c, Ultima_acao_contratual__c FROM Item_do_Contrato__c WHERE Id IN:idItens]);
			
			for(Solicitacao_Diversa__c sol : listSoldv){
				if(mapItens.containsKey(sol.Item_do_contrato__c)){
					mapItens.get(sol.Item_do_contrato__c).Produto__c = sol.Produto__c;
					mapItens.get(sol.Item_do_contrato__c).Banda__c = sol.Banda__c;
					if(sol.Tipo_de_Solicitacao__c=='Upgrade'){
						mapItens.get(sol.Item_do_contrato__c).Ultima_acao_contratual__c = 'Upgrade de Contrato';
					}else if(sol.Tipo_de_Solicitacao__c=='Downgrade'){
						mapItens.get(sol.Item_do_contrato__c).Ultima_acao_contratual__c = 'Downgrade de Contrato';
					}
				}
			}
			update mapItens.values();	
		}
	}
}