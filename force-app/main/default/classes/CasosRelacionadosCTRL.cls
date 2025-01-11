public class CasosRelacionadosCTRL {

    @AuraEnabled
    public static List<case> getCasosRelacionados(string recordId){
        
        List<Case> retorno = new List<Case>();
        List<Case> lstCaso = [SELECT Id, AccountId, Tipo_do_Chamado__c FROM Case WHERE id =:recordId ];
        if(!lstCaso.isEmpty()){
            string conta = lstCaso[0].AccountId;
            string tipo = lstCaso[0].Tipo_do_Chamado__c;
            retorno = [SELECT Id, AccountId, Tipo_do_Chamado__c, CaseNumber, Account.Name  FROM Case WHERE AccountId =:conta And Tipo_do_Chamado__c =:tipo And id !=:recordId];
        }
        return retorno;
    }
}