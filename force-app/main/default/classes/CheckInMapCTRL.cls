public class CheckInMapCTRL {
    @AuraEnabled
    public static Map<String,Object> listarMotivosCTRL(){
        
        Map<String, Object> data = new Map<String, Object>();
        data.put('lstMotivos', Utils.getMapPicklistValues('Check_in__c', 'Motivo__c'));
        return data;
    }

	@AuraEnabled
	public static String confirmarCTRL(String IdRegist, Decimal latitude, Decimal longitude, String motivo, String justificativa) {
		System.debug(IdRegist);
		System.debug(latitude);
		System.debug(longitude);
		System.debug(motivo);
		System.debug(justificativa);
		Check_in__c checkin = new Check_in__c();
		checkin.Geolocalizacao__Latitude__s = latitude;
		checkin.Geolocalizacao__Longitude__s = longitude;
		checkin.Motivo__c = motivo;
		checkin.Justificativa__c = justificativa;
        checkin.Data_Hora_Checkin__c = DateTime.now();

		if(motivo=='Outro'&&String.isBlank(justificativa)) throw new AuraHandledException('Informe a justificativa');

		if(IdRegist.startsWithIgnoreCase('001')){
			checkin.Conta__c = IdRegist;
		}else if(IdRegist.startsWithIgnoreCase('00Q')){
			checkin.Lead__c = IdRegist;
		}else if(IdRegist.startsWithIgnoreCase('00U')){
			Event compromisso = [SELECT Id, WhatId, WhoId, Check_in__c FROM Event WHERE Id =: IdRegist];
			if(compromisso.WhatId != null && String.valueOf(compromisso.WhatId).startsWithIgnoreCase('006')){
				Opportunity opp = [SELECT Id, AccountId FROM Opportunity WHERE Id =: compromisso.WhatId];
				checkin.Conta__c = opp.AccountId;
			}else if(compromisso.WhatId != null && String.valueOf(compromisso.WhatId).startsWithIgnoreCase('001')){
				checkin.Conta__c = compromisso.WhatId;
			}else if(compromisso.WhoId != null && String.valueOf(compromisso.WhoId).startsWithIgnoreCase('00Q')){
				checkin.Lead__c = compromisso.WhoId;
			}else{
				throw new AuraHandledException('É necessário adicionar uma conta ou oportunidade no campo relativo a do compromisso.');
			}

			insert checkin;
			
			compromisso.Check_in__c = checkin.Id;
			update compromisso;

			return checkin.Id;

		}else{
			throw new AuraHandledException('Preencha o campo relativo a com uma conta ou oportunidade.');
		}

		Insert checkin;

		return checkin.Id;
	}
    
    @AuraEnabled
	public static String confirmarIniciandoAtividade(String IdRegist, Decimal latitude, Decimal longitude) {
		
        Event compromisso = [SELECT Id, Check_in__c FROM Event WHERE Id =:IdRegist];
        
		Check_in__c checkin = new Check_in__c();
        checkin.id = compromisso.Check_in__c;
		checkin.Geolocalizacao_de_Inicio_da_Atividade__Latitude__s = latitude;
		checkin.Geolocalizacao_de_Inicio_da_Atividade__Longitude__s = longitude;
        checkin.Data_Hora_do_Inicio_da_Atividade__c = DateTime.now();
		
		update checkin;
        return checkin.id;
	}
    
    @AuraEnabled
	public static String confirmarCkeckout(String IdRegist, Decimal latitude, Decimal longitude, String motivo) {
		
        Event compromisso = [SELECT Id, Check_in__c FROM Event WHERE Id =:IdRegist];
        
		Check_in__c checkin = new Check_in__c();
        checkin.id = compromisso.Check_in__c;
		checkin.Geolocalizacao_de_Fim_da_Atividade__Latitude__s = latitude;
		checkin.Geolocalizacao_de_Fim_da_Atividade__Longitude__s = longitude;
        checkin.Data_Hora_do_Fim_da_Atividade__c = DateTime.now();
        checkin.Motivo_do_atendimento__c = motivo;
		
		update checkin;
        return checkin.id;
	}
    
    @AuraEnabled
    public static List<String> validarAnexo(id recordId){
        List<String> pickListValuesList = new List<String>();
        List<ContentDocumentLink> cdl = [SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =:recordId];
        if(!cdl.isEmpty()){
            Schema.DescribeFieldResult fieldResult = Check_in__c.Motivo_do_atendimento__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry pickListVal : ple){
                pickListValuesList.add(pickListVal.getLabel());
            }     
        }
        
        return pickListValuesList;
    }
	
}