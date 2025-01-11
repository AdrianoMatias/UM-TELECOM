global class ProductSAPBatchInsertProduct2 implements Database.Stateful, Database.Batchable<SObject> {
    
    private List<Product2> productsToInsert;
    private List<Product2> productsToReturn = new List<Product2>();
    
    public ProductSAPBatchInsertProduct2(List<Product2> productsToInsert){
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
        Database.executeBatch(new ProductSAPBatchInsertPBEntry(ItemSAPHelper.createPBEntry(productsToReturn)), 200);        
    }
}