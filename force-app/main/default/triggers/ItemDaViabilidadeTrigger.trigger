trigger ItemDaViabilidadeTrigger on Item_da_viabilidade__c (before insert, before update)  {
	
	if(Trigger.isBefore){
		if(Trigger.isInsert){
			ItemDaViabilidadeTriggerHandler.preencheCampos();
		}

		if(Trigger.isUpdate){
			ItemDaViabilidadeTriggerHandler.preencheCampos();
		}
	}
}