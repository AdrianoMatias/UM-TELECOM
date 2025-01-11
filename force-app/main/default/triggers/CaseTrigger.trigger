trigger CaseTrigger on Case (before insert, before update, After insert, After Update) {

    if(CaseTriggerHandler.ignoreHandler) return;

    if(Trigger.isBefore){
        if(Trigger.isInsert){
           // CaseTriggerHandler.getIndisponibilidade();
            CaseTriggerHandler.setarContaEContrato();
            CaseTriggerHandler.copiarDadosCasoPai();
            CaseTriggerHandler.associaSLA();
            CaseTriggerHandler.inserirDatasKPI();
        }
        if(Trigger.isUpdate){
            CaseTriggerHandler.setarContaEContrato();            
            CaseTriggerHandler.getIndisponibilidade();	
            CaseTriggerHandler.copiarDadosCasoPai();
            CaseTriggerHandler.validaEdicaoIndisponibilidade();	
            CaseTriggerHandler.associaSLA();
            CaseTriggerHandler.encerrarCasosFilhos();
            CaseTriggerHandler.calculaDuracaoIndisponibilidade();
            CaseTriggerHandler.inserirDatasKPI();
        }
    }
    if(Trigger.IsAfter){
        if(Trigger.isInsert){
            CaseTriggerHandler.mapearCasoPai();
            CaseTriggerHandler.copiarDadosCasosFilho();
            CaseTriggerHandler.fechaMarco();
        }
        if(Trigger.isUpdate){
            CaseTriggerHandler.criaPausa();
            CaseTriggerHandler.mapearCasoPai();
            CaseTriggerHandler.encerraPausa();
            CaseTriggerHandler.enviaIndisponibilidade();
            CaseTriggerHandler.copiarDadosCasosFilho();
            CaseTriggerHandler.fechaMarco();
            CaseTriggerHandler.sendCustomNotification(Trigger.New);
            //CaseTriggerHandler.casosSolicitacoesInternas();
        }
    }
    
}