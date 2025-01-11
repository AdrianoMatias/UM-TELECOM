@isTest 
private class CheckInMapCTRLTest {

	@TestSetup
	private static void setupDados(){
		TestUtils.dadosContaOportunidade();
		TestUtils.dadosLead();
        
        Check_in__c checkin = new Check_in__c();
		checkin.Geolocalizacao_de_Inicio_da_Atividade__Latitude__s = -7.67213;
		checkin.Geolocalizacao_de_Inicio_da_Atividade__Longitude__s = -35.0994;
        checkin.Data_Hora_do_Inicio_da_Atividade__c = DateTime.now();
        insert checkin;

		Event compromisso = new Event();
		compromisso.WhatId = [Select Id FROM Account].Id;
		compromisso.DurationInMinutes = 60;
		compromisso.ActivityDateTime = Datetime.now();
		compromisso.Subject = 'Chamada'; 
		insert compromisso;

		Event compromisso2 = new Event();
		compromisso2.WhatId = [Select Id FROM Opportunity].Id;
		compromisso2.DurationInMinutes = 60;
		compromisso2.ActivityDateTime = Datetime.now();
		compromisso2.Subject = 'Reunião'; 
        compromisso2.Check_in__c = checkin.Id;
		insert compromisso2;

		Event compromisso3 = new Event();
		compromisso3.WhoId = [Select Id FROM Lead].Id;
		compromisso3.DurationInMinutes = 60;
		compromisso3.ActivityDateTime = Datetime.now();
		compromisso3.Subject = 'Outro'; 
		insert compromisso3;
	}
	
	@isTest
	private static void testLead() {
		lead l = [Select Id FROM Lead];
		Test.startTest();
			CheckInMapCTRL.listarMotivosCTRL();
			CheckInMapCTRL.confirmarCTRL(l.Id,-7.67213,-35.0994, null,null);
		Test.stopTest();
	}

	@isTest
	private static void testConta() {
		Account acc = [Select Id FROM Account];
		Test.startTest();
			CheckInMapCTRL.confirmarCTRL(acc.Id,-7.67213,-35.0994, null,null);
		Test.stopTest();
	}

	@isTest
	private static void testCompromisso() {
		List<Event> compromisso = [Select Id FROM Event WHERE Subject = 'Outro'];
		Test.startTest();
			CheckInMapCTRL.confirmarCTRL(compromisso[0].Id,-7.67213,-35.0994, null,null);

		Test.stopTest();
	}

	@isTest
	private static void testCompromisso1() {
		List<Event> compromisso = [Select Id FROM Event WHERE Subject = 'Chamada'];
		Test.startTest();
			CheckInMapCTRL.confirmarCTRL(compromisso[0].Id,-7.67213,-35.0994, null,null);
			
		Test.stopTest();
	}

	@isTest
	private static void testCompromisso2() {
		List<Event> compromisso = [Select Id FROM Event WHERE Subject = 'Reunião'];
		Test.startTest();
			CheckInMapCTRL.confirmarCTRL(compromisso[0].Id,-7.67213,-35.0994, null,null);

		Test.stopTest();
	}
    
    @isTest
	private static void testConfirmarIniciandoAtividade() {
		List<Event> compromisso = [Select Id FROM Event WHERE Subject = 'Reunião'];
		Test.startTest();
			CheckInMapCTRL.confirmarIniciandoAtividade(compromisso[0].Id,-7.67213,-35.0994);

		Test.stopTest();
	}
    
    @isTest
	private static void testCSonfirmarCkeckout() {
		List<Event> compromisso = [Select Id FROM Event WHERE Subject = 'Reunião'];
		Test.startTest();
			CheckInMapCTRL.confirmarCkeckout(compromisso[0].Id,-7.67213,-35.0994, 'Reparo em Backbone');

		Test.stopTest();
	}
    
    @isTest
	private static void testvalidarAnexo() {
		List<Event> compromisso = [Select Id FROM Event WHERE Subject = 'Reunião'];
		Test.startTest();
			CheckInMapCTRL.validarAnexo(compromisso[0].Id);

		Test.stopTest();
	}
}