global class Schedule_LogClear implements Schedulable{
    global void execute(SchedulableContext SC) {
        Batch_LogClear ExecuteDelete =  new Batch_LogClear();
        Id batchId = Database.executeBatch(ExecuteDelete, 200); 
    }
}