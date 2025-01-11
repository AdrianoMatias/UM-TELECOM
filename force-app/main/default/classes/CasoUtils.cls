public with sharing class CasoUtils {
    private CasoUtils() {}

    
    public static Long calculaIndisponibilidade( Case caso, Boolean queryAgain ) {
        if( queryAgain ) {
            caso = [Select Data_Hora_Indisponibilidade__c, Data_Hora_do_Encerramento_da_Indisponibi__c,Data_Hora_Encerramento__c, (Select Data_Hora_Inicio__c, Data_Hora_Fim__c from Pausas_do_Caso__r) from Case where Id = :caso.Id ];
        }

        return calculaIndisponibilidade( caso );
    }

    public static Long calculaIndisponibilidade( Case caso ) {

        Long duracaoPausa = 0;
        for( Pausa_do_Caso__c pausa : caso.Pausas_do_Caso__r ) {
            Long duracaoMaxima = caso.Data_Hora_do_Encerramento_da_Indisponibi__c.getTime() - caso.Data_Hora_Indisponibilidade__c.getTime();            
            if( pausa.Data_Hora_Inicio__c <= caso.Data_Hora_Indisponibilidade__c && pausa.Data_Hora_Fim__c != null && pausa.Data_Hora_Fim__c <= caso.Data_Hora_Indisponibilidade__c ) {
                continue;
            } else if( pausa.Data_Hora_Inicio__c <= caso.Data_Hora_Indisponibilidade__c && pausa.Data_Hora_Fim__c != null && pausa.Data_Hora_Fim__c <= caso.Data_Hora_do_Encerramento_da_Indisponibi__c ) {
                duracaoPausa += pausa.Data_Hora_Fim__c.getTime() - caso.Data_Hora_Indisponibilidade__c.getTime();
            } else if( pausa.Data_Hora_Inicio__c <= caso.Data_Hora_Indisponibilidade__c && pausa.Data_Hora_Fim__c != null && pausa.Data_Hora_Fim__c > caso.Data_Hora_do_Encerramento_da_Indisponibi__c ) {
                duracaoPausa += caso.Data_Hora_do_Encerramento_da_Indisponibi__c.getTime() - caso.Data_Hora_Indisponibilidade__c.getTime();
            } else if( pausa.Data_Hora_Inicio__c > caso.Data_Hora_Indisponibilidade__c && pausa.Data_Hora_Inicio__c >= caso.Data_Hora_do_Encerramento_da_Indisponibi__c ) {
                continue;
            } else if( pausa.Data_Hora_Inicio__c >= caso.Data_Hora_Indisponibilidade__c && pausa.Data_Hora_Fim__c != null && pausa.Data_Hora_Fim__c <= caso.Data_Hora_do_Encerramento_da_Indisponibi__c ) {
                duracaoPausa += pausa.Data_Hora_Fim__c.getTime() - pausa.Data_Hora_Inicio__c.getTime();
            } else if( pausa.Data_Hora_Inicio__c >= caso.Data_Hora_Indisponibilidade__c && pausa.Data_Hora_Fim__c != null && pausa.Data_Hora_Fim__c > caso.Data_Hora_do_Encerramento_da_Indisponibi__c ) {
                duracaoPausa += caso.Data_Hora_do_Encerramento_da_Indisponibi__c.getTime() - pausa.Data_Hora_Inicio__c.getTime();
            }
            
            if( duracaoPausa >= duracaoMaxima ) {
                duracaoPausa = duracaoMaxima;
                break;
            }
        }

        duracaoPausa = (duracaoPausa / 1000 / 60);
        return duracaoPausa;
    }
}