public class InvocableCriaItensContrato { 

 @InvocableMethod
    public static void invokeBatch(List<String> queryString1) {
        BatchCriaItensContrato batch = new BatchCriaItensContrato(queryString1);
        Database.executeBatch(batch, 1);
    }
}