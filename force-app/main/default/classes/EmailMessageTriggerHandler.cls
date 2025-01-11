public class EmailMessageTriggerHandler {
    
    public static void replicarEmailCasoFilho(){
        List<EmailMessage> emailsMessage = (List<EmailMessage>) Trigger.new;
        List<String> idsCaso = new List<String>();
        for(EmailMessage emailMessage : emailsMessage){
            idsCaso.add(emailMessage.ParentId);
        }

        if(idsCaso.size()>0){
            List<Case> lstFilhos =  [SELECT Id, ParentId FROM Case WHERE ParentId != null AND ParentId IN :idsCaso ];
            if(!lstFilhos.isEmpty()){
                Map<String, List<String>> mapCasoPaiFilho = new Map<String, List<String>>();
                for(Case caso : lstFilhos){
                    if(mapCasoPaiFilho.get(caso.ParentId)==null){
                        mapCasoPaiFilho.put(caso.ParentId, new List<String>());
                    }
                    mapCasoPaiFilho.get(caso.ParentId).add(caso.Id);
                }

                List<EmailMessage> newEmailsMessage = new List<EmailMessage>(); 
                for(EmailMessage emailMessage : emailsMessage){
                    if(mapCasoPaiFilho.get(emailMessage.ParentId) != null){
                        for(String idCaso : mapCasoPaiFilho.get(emailMessage.ParentId)){
                            EmailMessage replica = emailMessage.clone(false, true, false, false);
                            replica.ParentId = idCaso;
                            newEmailsMessage.add(replica);
                        }
                        if(!newEmailsMessage.isEmpty()){
                            insert newEmailsMessage;  
                        }
                    }
                }
            }
        }
    }
    
}