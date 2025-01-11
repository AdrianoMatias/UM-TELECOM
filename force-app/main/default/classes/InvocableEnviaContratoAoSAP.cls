public class InvocableEnviaContratoAoSAP {
@InvocableMethod
    public static void invokeBatchEnviaContratoSAP(List<String> queryString1) {
        BatchEnviaContratoAoSAP batch = new BatchEnviaContratoAoSAP(queryString1);
        Database.executeBatch(batch, 1);
    }
}