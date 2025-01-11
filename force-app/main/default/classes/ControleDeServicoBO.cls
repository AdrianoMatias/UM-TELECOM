public without sharing class ControleDeServicoBO {
    private static final ControleDeServicoBO instance = new ControleDeServicoBO();
    public static ControleDeServicoBO getInstance() {
        return instance;
    }
    
    public ControleDeServicos__c gerarLogPai(String status, String nomeClasse, String nomeProcesso, String requestBody, String responseBody, String excecao, integer statusCode, DateTime dataExecucao, Boolean isBatch){
        ControleDeServicos__c logPai = new ControleDeServicos__c();
        logPai.Status__c = status;
        logPai.DataDaExecucao__c = Datetime.now();
        logPai.Classe__c = nomeClasse;
        logPai.Processo__c = nomeProcesso;
        logPai.RequestBody__c = requestBody;
        if(!String.isBlank(responseBody))
        logPai.ResponseBody__c = responseBody.abbreviate(131072);
        logPai.Excecao__c = excecao+' - '+statusCode;
        logPai.DataDaExecucao__c = dataExecucao;
        logPai.IsBatch__c = isBatch;
        System.debug('requestBody ' + requestBody); 
        System.debug('responseBody ' + responseBody); 
        
        return logPai;
    }
    @Future
    public static void insertLogFuture( String controleJson ){
        ControleDeServicos__c log = (ControleDeServicos__c) JSON.deserialize(controleJson, ControleDeServicos__c.class);
        insert log;
    }
}