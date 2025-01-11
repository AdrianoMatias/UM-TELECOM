global class ItemSAPBatchUpdateProduct implements Database.Stateful, Database.Batchable<SObject> {

    private List<Product2> productsToUpdate;
    
    public ItemSAPBatchUpdateProduct(List<Product2> productsToUpdate){
        this.productsToUpdate = productsToUpdate;
    }

    global Iterable<SObject> start(Database.BatchableContext BC) {
        return productsToUpdate;
    }
    
    global void execute(Database.BatchableContext BC, List<SObject> scope) {
        List<Product2> products = (List<Product2>) scope;
        update products;
    }
    
    global void finish(Database.BatchableContext BC) {}
}