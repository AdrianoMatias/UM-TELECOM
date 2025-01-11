global class FaturaSAPBatchUpsert implements Database.Batchable<SObject> {

    private List<Fatura__c> faturasToUpsert;
    
    public FaturaSAPBatchUpsert(List<Fatura__c> faturasToUpsert){
        this.faturasToUpsert = faturasToUpsert;
    }

    global Iterable<SObject> start(Database.BatchableContext BC) {
        return faturasToUpsert;
    }
    
    global void execute(Database.BatchableContext BC, List<SObject> scope) {
        List<Fatura__c> faturas = (List<Fatura__c>) scope;
        upsert faturas NumeroFaturaSAP__c;
    }
    
    global void finish(Database.BatchableContext BC) {}
}