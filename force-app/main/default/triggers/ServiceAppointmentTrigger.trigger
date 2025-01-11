trigger ServiceAppointmentTrigger on ServiceAppointment (before update) {
    
    List<ServiceAppointment> invalidUpdates = new List<ServiceAppointment>();

    Boolean isFieldServiceMobileApp = ServiceAppointmentTriggerHelper.isFieldServiceMobileUser();

    for (ServiceAppointment appointment : Trigger.new) {
        ServiceAppointment oldRecord = Trigger.oldMap.get(appointment.Id);

        if (appointment.Status == 'Concluído' && oldRecord.Status != 'Concluído') {
            if (!isFieldServiceMobileApp) {
                invalidUpdates.add(appointment);
            }
        }
    }

    if (!invalidUpdates.isEmpty()) {
        for (ServiceAppointment appointment : invalidUpdates) {
            //appointment.addError('A conclusão do compromisso de serviço só pode ser feita pelo aplicativo Field Service.');
        }
    }
}