global class Batch_LogClear implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{
    
    global Database.QueryLocator start(Database.BatchableContext BC) {   
        DateTime DiasAtras= DateTime.newInstance(Datetime.now().date().addDays(-60), Time.newInstance(0, 0, 0, 0));
        
        String query;
        query  = 'SELECT Id, CreatedDate FROM ControleDeServicos__c WHERE CreatedDate < '+DiasAtras.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        return Database.getQueryLocator(query);        
    }
    
    global void execute(Database.BatchableContext BC, List<ControleDeServicos__c> scope) {
        delete scope;
    }
    
    global void finish(Database.BatchableContext BC) {
        AsyncApexJob a = [Select a.TotalJobItems, a.Status, a.NumberOfErrors,a.JobType, a.JobItemsProcessed, a.ExtendedStatus, a.CreatedById,a.CompletedDate From AsyncApexJob a WHERE id = :BC.getJobId()];
        ControleDeServicos__c logPai = ControleDeServicoBO.getInstance().gerarLogPai('Sucesso', 'Batch_LogClear', 'Log Clear - Batch Finalizado', 'Controles/Logs excluídos: ' + a.JobItemsProcessed, null, null, null, null, True); 
        insert logPai;   
    }
}