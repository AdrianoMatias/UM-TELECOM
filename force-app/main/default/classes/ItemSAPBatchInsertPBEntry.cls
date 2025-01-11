global class ItemSAPBatchInsertPBEntry implements Database.Stateful, Database.Batchable<SObject> {

    private List<PricebookEntry> pbEntryToInsert;

    public ItemSAPBatchInsertPBEntry(List<PricebookEntry> pbEntryToInsert){
        this.pbEntryToInsert = pbEntryToInsert;
    }

    global Iterable<SObject> start(Database.BatchableContext BC) {
        return pbEntryToInsert;
    }
    
    global void execute(Database.BatchableContext BC, List<SObject> scope) {
        List<PricebookEntry> pbEntry = (List<PricebookEntry>) scope;
        insert pbEntry;  
    }
    
    global void finish(Database.BatchableContext BC) {}
}