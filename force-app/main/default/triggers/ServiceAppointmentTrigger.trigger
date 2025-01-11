trigger ServiceAppointmentTrigger on ServiceAppointment (before update) {
    // Verifica se o usuário está restrito a usar apenas o Field Service Mobile App
    Boolean isUserRestrictedToMobileApp = ServiceAppointmentTriggerHelper.isUserRestrictedToFieldServiceApp();
    System.debug('Usuário está restrito ao Field Service Mobile App? ' + isUserRestrictedToMobileApp);

    for (ServiceAppointment appointment : Trigger.new) {
        ServiceAppointment oldRecord = Trigger.oldMap.get(appointment.Id);
        System.debug('Status anterior: ' + oldRecord.Status + ', Novo Status: ' + appointment.Status);

        // Valida alteração para "Concluído"
        if (appointment.Status == 'Concluído' && oldRecord.Status != 'Concluído') {
            System.debug('Alteração detectada para "Concluído".');

            // Se o usuário não estiver restrito ao Field Service Mobile App, bloqueia a alteração
            if (isUserRestrictedToMobileApp && !UserInfo.getUserType().equals('Mobile')) {
                System.debug('Alteração bloqueada. Usuário está no desktop e não no Field Service Mobile App.');
                
                try {
                    // Lança erro para bloquear a atualização
                    appointment.addError('A conclusão do compromisso de serviço só pode ser feita pelo aplicativo Field Service Mobile.');
                    System.debug('Erro adicionado com sucesso.');
                } catch (Exception ex) {
                    System.debug('Exceção ao adicionar erro: ' + ex.getMessage());
                }
            } else {
                System.debug('Alteração permitida no Field Service Mobile App ou usuário não restrito.');
            }
        }
    }
}
