public class ServiceAppointmentTriggerHelper {
    // Função para verificar se o usuário está restrito a usar apenas o Field Service Mobile App
    public static Boolean isUserRestrictedToFieldServiceApp() {
        Id currentUserId = UserInfo.getUserId();
        System.debug('ID do usuário logado: ' + currentUserId);
        
        // Obtém o usuário atual
        User currentUser = [SELECT RestrictToFieldServiceApp__c FROM User WHERE Id = :currentUserId LIMIT 1];
        
        // Verifica se o campo RestrictToFieldServiceApp__c está marcado como TRUE
        return currentUser.RestrictToFieldServiceApp__c;
    }
}
