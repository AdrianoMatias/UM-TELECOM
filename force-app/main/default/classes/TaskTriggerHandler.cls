public class TaskTriggerHandler {
    public static void replicarAnexoEmail(){
        List<Task> tarefas = (List<Task>) Trigger.new;
        List<String> idsTarefas = new List<String>();
        for(Task tarefa : tarefas){
            idsTarefas.add(tarefa.Id);
        }

        if(idsTarefas.size()>0){
            TaskTriggerHandler.replicarAnexoEmailFuture(idsTarefas);
        }
    }
    
    @future
    public static void replicarAnexoEmailFuture(List<String> idsTarefas){
        List<EmailMessage> emailsMessage = [SELECT Id, ActivityId FROM EmailMessage WHERE ActivityId IN :idsTarefas];
        Map<String, String> mapEmailTarefa = new Map<String, String>(); 
        for(EmailMessage emailMessage : emailsMessage){
            mapEmailTarefa.put(emailMessage.Id, emailMessage.ActivityId);
        }
        
        if(!mapEmailTarefa.isEmpty()){
            List<ContentDocumentLink> cdls = [SELECT Id, ContentDocumentId, LinkedEntityId, Visibility FROM ContentDocumentLink WHERE LinkedEntityId IN :mapEmailTarefa.keySet()];
            List<ContentDocumentLink> newCdls = new List<ContentDocumentLink>();
            
            for(ContentDocumentLink cdl : cdls){
                if(mapEmailTarefa.get(cdl.LinkedEntityId) != null){
                    ContentDocumentLink newCdl = cdl.clone(false, true, false, false);
                    newCdl.LinkedEntityId = mapEmailTarefa.get(cdl.LinkedEntityId);
                    newCdls.add(newCdl);
                }
            }
            
            if(!newCdls.isEmpty()){
                Database.insert(newCdls, false);
            }
        }
    }
}