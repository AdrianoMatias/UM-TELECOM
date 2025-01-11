@IsTest
public class Test_LogClear {
    @Istest
    public static void LogClear() {
        
        String CRON_EXP = '0 0 0 15 3 ? *';
        Test.startTest();
        String jobId = System.schedule('Schedule_LogClear',  CRON_EXP, new Schedule_LogClear());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }
}