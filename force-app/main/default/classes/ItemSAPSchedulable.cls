global class ItemSAPSchedulable implements Schedulable {
    @InvocableMethod
    global static void invokeProces() {
        System.enqueueJob(new ItemSAPBatchProcess());
    }

    global void execute(SchedulableContext ctx) {
		System.enqueueJob(new ItemSAPBatchProcess());
    }   
}