trigger SolicitacaoDiversaTrigger on Solicitacao_Diversa__c (before insert, before update) {
    if(Trigger.isBefore){
		if(Trigger.isInsert){
			SolicitacaoDiversaTriggerHandler.atribuirFila();
			SolicitacaoDiversaTriggerHandler.validaTipoSolicitacao();
		}
		
		if(Trigger.isUpdate){
			SolicitacaoDiversaTriggerHandler.atribuirFila();
			SolicitacaoDiversaTriggerHandler.validaTipoSolicitacao();
			SolicitacaoDiversaTriggerHandler.atualizaItemContrato();
		} 
	} 
}