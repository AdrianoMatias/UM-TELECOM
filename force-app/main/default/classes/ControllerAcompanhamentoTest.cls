@isTest
public with sharing class ControllerAcompanhamentoTest {
    @TestSetup
    static void criarDados() {
        Account conta1 = new Account();
        conta1.Name = 'Conta Teste 1';
        conta1.Geolocalizacao__Latitude__s = -8.062296;
        conta1.Geolocalizacao__Longitude__s = -34.872616;
        conta1.OwnerId = UserInfo.getUserId();
        insert conta1;
    
        Account conta2 = new Account();
        conta2.Name = 'Conta Teste 2';
        conta2.Geolocalizacao__Latitude__s = -8.062296;
        conta2.Geolocalizacao__Longitude__s = -34.872616;
        conta2.OwnerId = UserInfo.getUserId();
        insert conta2;
    
        Account conta3 = new Account();
        conta3.Name = 'Conta Teste 3';
        conta3.Geolocalizacao__Latitude__s = -8.062296;
        conta3.Geolocalizacao__Longitude__s = -34.872616;
        conta3.OwnerId = UserInfo.getUserId();
        insert conta3;
    
        Account conta4 = new Account();
        conta4.Name = 'Conta Teste 4';
        conta4.Geolocalizacao__Latitude__s = -8.062296;
        conta4.Geolocalizacao__Longitude__s = -34.872616;
        conta4.OwnerId = UserInfo.getUserId();
        insert conta4;
    
        Opportunity oportunidade1 = new Opportunity();
        oportunidade1.Name = 'Oportunidade Teste 1';
        oportunidade1.CloseDate = Date.today();
        oportunidade1.StageName = 'Mapeamento';
        oportunidade1.AccountId = conta1.Id;
        oportunidade1.Meses__c = 12;
        oportunidade1.OwnerId = UserInfo.getUserId();
        insert oportunidade1;
    
        Opportunity oportunidade2 = new Opportunity();
        oportunidade2.Name = 'Oportunidade Teste 2';
        oportunidade2.CloseDate = Date.today();
        oportunidade2.StageName = 'Mapeamento';
        oportunidade2.AccountId = conta2.Id;
        oportunidade2.Meses__c = 12;
        oportunidade2.OwnerId = UserInfo.getUserId();
        insert oportunidade2;

        Check_in__c checkIn1 = new Check_in__c();
        checkIn1.Conta__c = conta1.Id;
        insert checkIn1;
    
        Check_in__c checkIn2 = new Check_in__c();
        checkIn2.Conta__c = conta2.Id;
        checkIn2.Motivo__c = 'Esqueci de fazer o CheckIn';
        insert checkIn2;
    
        Check_in__c checkIn3 = new Check_in__c();
        checkIn3.Conta__c = conta3.Id;
        checkIn3.Geolocalizacao__Latitude__s = -8.062296;
        checkIn3.Geolocalizacao__Longitude__s =  -34.872616;
        insert checkIn3;
    
        Event compromisso1 = new Event();
        compromisso1.WhatId = oportunidade1.Id;
        compromisso1.Check_in__c = checkIn1.Id;
        compromisso1.Subject = 'Reunião';
        compromisso1.Status__c = 'Realizado';
        compromisso1.ActivityDate = Date.today();
        compromisso1.StartDateTime = Datetime.now();
        compromisso1.EndDateTime = Datetime.now().addHours(1);
        compromisso1.OwnerId = UserInfo.getUserId();
        insert compromisso1;
    
        Event compromisso2 = new Event();
        compromisso2.WhatId = oportunidade2.Id;
        compromisso2.Check_in__c = checkIn2.Id;
        compromisso2.Subject = 'Reunião';
        compromisso2.Status__c = 'Realizado';
        compromisso2.ActivityDate = Date.today();
        compromisso2.StartDateTime = Datetime.now();
        compromisso2.EndDateTime = Datetime.now().addHours(1);
        compromisso2.OwnerId = UserInfo.getUserId();
        insert compromisso2;
    
        Event compromisso3 = new Event();
        compromisso3.WhatId = conta3.Id;
        compromisso3.Check_in__c = checkIn3.Id;
        compromisso3.Subject = 'Reunião';
        compromisso3.Status__c = 'Realizado';
        compromisso3.ActivityDate = Date.today();
        compromisso3.StartDateTime = Datetime.now();
        compromisso3.EndDateTime = Datetime.now().addHours(1);
        compromisso3.OwnerId = UserInfo.getUserId();
        insert compromisso3;
    
        Event compromisso4 = new Event();
        compromisso4.WhatId = conta4.Id;
        compromisso4.Subject = 'Reunião';
        compromisso4.Status__c = 'Realizado';
        compromisso4.Check_in__c = null;
        compromisso4.ActivityDate = Date.today();
        compromisso4.StartDateTime = Datetime.now();
        compromisso4.EndDateTime = Datetime.now().addHours(1);
        compromisso4.OwnerId = UserInfo.getUserId();
        insert compromisso4;
        
    }

    @isTest
    static void carregarCompromissosTest() {
        Test.startTest();
        ControllerAcompanhamento controller = new ControllerAcompanhamento();
        controller.idUsuario = UserInfo.getUserId();
        controller.carregarCompromissos();
        Test.stopTest();
    }
}