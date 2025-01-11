trigger AnaliseDeViabilidadeTrigger on Analise_de_viabilidade__c (before update, after update)  {

	if(Trigger.isUpdate){
		if(Trigger.isBefore){
			AnaliseDeViabilidadeTriggerHandler.alteraTipoRegistroViabilidade();
		}
		
		if(Trigger.isAfter){
			AnaliseDeViabilidadeTriggerHandler.alteraTipoRegistroItemViabilidade();
		}
	}
 }