@isTest
public class ItemSAPBatchInsertPBEntryTest {

    @isTest
    private static void testMethod1() {
        
        TestFactoryData.createProduct2('P006638', true);

        List<PricebookEntry> pbEntryToInsert = new List<PricebookEntry>();
        String standardId = Test.getStandardPricebookId();
        Id productId = [Select Id, ProductCode, IsActive From Product2 LIMIT 1].Id;

        PricebookEntry pbEntry = new PricebookEntry();
        pbEntry.Pricebook2Id = standardId;
        pbEntry.Product2Id = productId;
        pbEntry.UnitPrice = 0;
        pbEntry.UseStandardPrice = false;
        pbEntry.isActive = false;
        pbEntryToInsert.add(pbEntry);

		Test.startTest();
		Database.executeBatch(new ItemSAPBatchInsertPBEntry(pbEntryToInsert), 1);
		Test.stopTest();

		List<PricebookEntry> result = [Select Id From PricebookEntry Where Product2Id = :productId And Pricebook2Id = :standardId];
    
        Assert.areEqual(1, result.size(), 'Deveria ser 1');
    }
}