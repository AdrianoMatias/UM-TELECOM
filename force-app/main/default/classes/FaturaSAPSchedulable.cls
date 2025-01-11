global class FaturaSAPSchedulable implements Schedulable {
    @InvocableMethod
    global static void invokeProces() {
        System.enqueueJob(new FaturaSAPBatchProcess());
    }

    global void execute(SchedulableContext ctx) {
		System.enqueueJob(new FaturaSAPBatchProcess());
    }   
}