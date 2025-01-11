global class ItemSAPBatchInsertProduct implements Database.Stateful, Database.Batchable<SObject> {
    
    private List<Product2> productsToInsert;
    private List<Product2> productsToReturn = new List<Product2>();
    
    public ItemSAPBatchInsertProduct(List<Product2> productsToInsert){
        this.productsToInsert = productsToInsert;
    }
    
    global Iterable<SObject> start(Database.BatchableContext BC) {
        return productsToInsert;
    }
    
    global void execute(Database.BatchableContext BC, List<SObject> scope) {
        List<Product2> products = (List<Product2>) scope;      
        insert products;
        productsToReturn.addAll(products);
    }
    
    global void finish(Database.BatchableContext BC) {
        List<PricebookEntry> listPBEntry = ItemSAPHelper.createPBEntry(productsToReturn);
		Database.executeBatch(new ItemSAPBatchInsertPBEntry(listPBEntry), 200);
    }
}