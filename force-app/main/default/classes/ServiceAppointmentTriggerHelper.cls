public class ServiceAppointmentTriggerHelper {
    public static Boolean isFieldServiceMobileUser() {
        // Obtém o ID do usuário logado
        Id currentUserId = UserInfo.getUserId();
        
        UserAppInfo userAppInfo = [SELECT Id, AppDefinitionId FROM UserAppInfo WHERE UserId =:UserInfo.getUserId() ORDER BY LastModifiedDate DESC LIMIT 1];
        
        AppDefinition appDefinition = [SELECT Label FROM AppDefinition Where DurableId =:userAppInfo.AppDefinitionId LIMIT 1];
        String appName = appDefinition.Label;
        
        System.debug('appName------->' + appName);
                
        if (appName.contains('Field Service Mobile App')) {
            return true;
        } else {
            return false;    
        }
        
        
    }
}