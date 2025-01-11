trigger ItemDoContratoTrigger on Item_do_Contrato__c (after insert, after update, before insert, before update)  { 

    if(Trigger.isAfter){
        if(Trigger.isInsert){
            //ItemDoContratoTriggerHandler.atualizaStatusContrato();
        }

        if(Trigger.isUpdate){
            //ItemDoContratoTriggerHandler.atualizaStatusContrato();
        }
    }

    if(Trigger.isBefore){
        if(Trigger.isInsert){
            //ItemDoContratoTriggerHandler.setarConta();
        }
    }
}