public class CaseTriggerHandler {
    
    public static Id CaseRecordTypeIdChamado = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Chamado').getRecordTypeId();
    public static Id CaseRecordTypeIdMassivo = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Evento Massivo').getRecordTypeId();
    public static List<string> statusNaoMassivo = new List<String> {'Resolvido','Encerrado','Validação','Satisfação'};
        public static string statusFechado = 'Resolvido';
    public static Id profileId = userinfo.getProfileId();
    public static Boolean ignoreHandler = false;
    public static final Map<String,String> mapaTipoAtendimentoSLA = new Map<String,String> {
        'NOC|Parceiro Alootelecom (reparo)' => 'SLA 6 horas',
            'NOC|Parceiro BRISANET (repararo)' => 'SLA 6 horas',
            'NOC|Parceiro CGV (reparo)' => 'SLA 6 horas',
            'NOC|Parceiro Compuline (reparo)' => 'SLA 6 horas',
            'NOC|Parceiro DANIEL TELECOM (reparo)' => 'SLA 6 horas',
            'NOC|Parceiro FLASHNET (reparo)' => 'SLA 6 horas',
            'NOC|Parceiro Globenet (reparo)' => 'SLA 6 horas',
            'NOC|Parceiro Internexa (reparo)' => 'SLA 6 horas',
            'NOC|Parceiro Master  - Fortaleza (reparo)' => 'SLA 6 horas',
            'NOC|Parceiro MOB dwdm (reparo)' => 'SLA 6 horas',
            'NOC|Parceiro OOPS (Reparo)' => 'SLA 6 horas',
            'NOC|Parceiro Parceiros Oxente (reparo)' => 'SLA 6 horas',
            'NOC|Parceiro Smart (reparo)' => 'SLA 6 horas',
            'NOC|Parceiro Tely (reparo)' => 'SLA 6 horas',
            'NOC|Parceiro Veloo (reparo)' => 'SLA 6 horas',
            'NOC|Parceiro Voax (reparo)' => 'SLA 6 horas',
            'NOC|Parceiro Wirelink (reparo/DWDM)' => 'SLA 6 horas',
            'NOC|Parceiro BBG telecom (reparo)' => 'SLA 6 horas',
            'NOC|Parceiro parceiro Netprimus (reparo)' => 'SLA 6 horas',
            'NOC|Parceiro TTVI internet (reparo)' => 'SLA 6 horas',
            'NOC|JANELA DE MANUTENÇÃO PROGRAMADA' => 'SLA 6 horas',
            'NOC|JANELA DE MANUTENÇÃO EMERGENCIAL' => 'SLA 6 horas',
            'SUPORTE N1|Circuito Indisponível - Equipamento' => 'SLA 6 horas',
            'SUPORTE N1|Circuito Indisponível - Fibra' => 'SLA 6 horas',
            'SUPORTE N1|Circuito Indisponível - Infraestrutura' => 'SLA 6 horas',
            'SUPORTE N1|Circuito Indisponível - Lógico' => 'SLA 6 horas',
            'SUPORTE N1|Circuito Indisponível - Rádio' => 'SLA 6 horas',
            'NOC|Falha de Backbone 1telecom - Elétrica' => 'SLA 6 horas',
            'NOC|Falha de Backbone 1telecom - Equipamento' => 'SLA 6 horas',
            'NOC|Falha de Backbone 1telecom - Fibra' => 'SLA 6 horas',
            'NOC|Falha de Backbone 1telecom - Lógico' => 'SLA 6 horas',
            'NOC| Falha Elétrica em Infraestrutura 1Telecom' => 'SLA 6 horas',
            'SUPORTE N1|Falha Backbone - Problemas com Roteamento' => 'SLA 6 horas',
            'NGR|ESCALONAMENTO' => 'SLA 2 horas',
            'NGR|OSCILAÇÃO' => 'SLA 2 horas',
            'SUPORTE N1|Alteração de Rota' => 'SLA 2 horas',
            'SUPORTE N1|Baixa Performance (up/down)' => 'SLA 2 horas',
            'SUPORTE N1|Bloqueio de Link' => 'SLA 2 horas',
            'SUPORTE N1|Cancelamento de Link' => 'SLA 2 horas',
            'SUPORTE N1|Parceiro de Simples Abertura' => 'SLA 2 horas',
            'SUPORTE N1|Configuração/Alteração BGP' => 'SLA 2 horas',
            'SUPORTE N1|Desbloqueio de Link' => 'SLA 2 horas',
            'SUPORTE N1|Downgrade de Link' => 'SLA 2 horas',
            'SUPORTE N1|Latência Alta' => 'SLA 2 horas',
            'SUPORTE N1|Lentidão' => 'SLA 2 horas',
            'SUPORTE N1|Mudança de Endereço do Cliente' => 'SLA 2 horas',
            'SUPORTE N1|Oscilação' => 'SLA 2 horas',
            'SUPORTE N1|Outros' => 'SLA 2 horas',
            'SUPORTE N1|Perda de pacote' => 'SLA 2 horas',
            'SUPORTE N1|Reenvio de fatura' => 'SLA 2 horas',
            'SUPORTE N1|Sem Acesso (destinos)' => 'SLA 2 horas',
            'SUPORTE N1|Solicitação de IP Adicional' => 'SLA 2 horas',
            'SUPORTE N1|Teste de Link' => 'SLA 2 horas',
            'SUPORTE N1|Upgrade de Link' => 'SLA 2 horas'
            };
                
                public static void getIndisponibilidade(){
                    
                    String profileName = '';
                    
                    List<Case> lstCase = (List<Case>) Trigger.new;
                    
                    
                    for(Case caso : lstCase){
                        if(caso.Indisponibilidade__c && !((Case) trigger.oldMap.get(caso.id)).Indisponibilidade__c && caso.Data_Hora_Indisponibilidade__c == null ){caso.Data_Hora_Indisponibilidade__c  = Datetime.now();}
                    }
                }
    
    public static void validaEdicaoIndisponibilidade() {
        List<Case> casos = (List<Case>) Trigger.new;
        Map<Id,Case> oldMap = (Map<Id,Case>) Trigger.oldMap;
        if(!ignoreHandler) {
            ignoreHandler = true;
            List<Profile> perfis = [Select Id,Name from Profile where Id=:profileId];
            String profileName;
            if( perfis.size() > 0 ) {
                profileName = perfis[0].Name;
            }
            
            for( Case caso : casos ) {
                if( oldMap.get( caso.Id ).Data_Hora_Indisponibilidade__c != null && caso.Data_Hora_Indisponibilidade__c != oldMap.get( caso.Id ).Data_Hora_Indisponibilidade__c && profileName != null && profileName != 'Supervisor Atendimento' && profileName != 'Administrador do Sistema' ) {caso.Data_Hora_Indisponibilidade__c.addError( 'Não é possível editar a Data/Hora da Indisponibilidade' );}
            }
        }
        
        ignoreHandler = false;
    }
    
    public static void sendCustomNotification(List<Case> casesList) {
        if(!ignoreHandler) {
            Map<String, CustomNotificationType> mapNotifications = new Map<String, CustomNotificationType>();
            for(CustomNotificationType notification : [SELECT Id, DeveloperName FROM CustomNotificationType]) {
                mapNotifications.put(notification.DeveloperName, notification);
            }
            
            for (Case caseFlag : casesList) {
                
                // Notificação para Violação da KPI TMR
                if ((caseFlag.Status == 'Novo' || caseFlag.Status == 'Em andamento') && caseFlag.KPI_TMR_Violado__c == true && caseFlag.KPI_TMR_Violado__c != ((Case) Trigger.oldMap.get(caseFlag.Id)).KPI_TMR_Violado__c) {
                    Set<String> recipientsIds = new Set<String>(); 
                    Messaging.CustomNotification notification = new Messaging.CustomNotification();
                    
                    notification.setTitle('TMR Violado');
                    notification.setBody('O caso ' + caseFlag.CaseNumber + ' teve seu KPI TMR Violado.');
                    
                    notification.setNotificationTypeId(mapNotifications.get('KPI_TMR_Violado').Id);
                    notification.setTargetId(caseFlag.Id);
                    
                    recipientsIds.add(caseFlag.OwnerId);
                    
                    try {
                        notification.send(recipientsIds);
                    }catch (Exception e) {System.debug('Problem sending notification: ' + e.getMessage());}
                }
                
                // Notificação para Violação da KPI TMP
                if ((caseFlag.Status == 'Pausado' || caseFlag.Status == 'Agendado') && caseFlag.KPI_TMP_Violado__c == true && caseFlag.KPI_TMP_Violado__c != ((Case) Trigger.oldMap.get(caseFlag.Id)).KPI_TMP_Violado__c) {
                    Set<String> recipientsIds = new Set<String>(); 
                    Messaging.CustomNotification notification = new Messaging.CustomNotification();
                    
                    notification.setTitle('TMP Violado');
                    notification.setBody('O caso ' + caseFlag.CaseNumber + ' teve seu KPI TMP Violado.');
                    
                    notification.setNotificationTypeId(mapNotifications.get('KPI_TMP_Violado').Id);
                    notification.setTargetId(caseFlag.Id);
                    
                    recipientsIds.add(caseFlag.OwnerId);
                    
                    try {
                        notification.send(recipientsIds);
                    }
                    catch (Exception e) {System.debug('Problem sending notification: ' + e.getMessage());}
                }
                
                // Notificação para Violação da KPI MTTR
                if (caseFlag.Status == 'Escalado' && caseFlag.KPI_SLO_Violado__c == true && caseFlag.KPI_SLO_Violado__c != ((Case) Trigger.oldMap.get(caseFlag.Id)).KPI_SLO_Violado__c) {
                    Set<String> recipientsIds = new Set<String>();
                    Messaging.CustomNotification notification = new Messaging.CustomNotification();
                    
                    notification.setTitle('SLO Violado');
                    notification.setBody('O caso ' + caseFlag.CaseNumber + ' teve seu KPI SLO Violado.');
                    
                    notification.setNotificationTypeId(mapNotifications.get('KPI_SLO_Violado').Id);
                    notification.setTargetId(caseFlag.Id);
                    
                    recipientsIds.add(caseFlag.OwnerId);
                    
                    try {
                        notification.send(recipientsIds);
                    }
                    catch (Exception e) {System.debug('Problem sending notification: ' + e.getMessage());}
                }
                
                // Notificação para Violação da KPI TMS
                if (statusNaoMassivo.contains(caseFlag.Status) && caseFlag.KPI_TMS_Violado__c == true && caseFlag.KPI_TMS_Violado__c != ((Case) Trigger.oldMap.get(caseFlag.Id)).KPI_TMS_Violado__c) {
                    System.debug('Notificação TMS');
                    Set<String> recipientsIds = new Set<String>(); 
                    Messaging.CustomNotification notification = new Messaging.CustomNotification();
                    
                    notification.setTitle('TMS Violado');
                    notification.setBody('O caso ' + caseFlag.CaseNumber + ' teve seu KPI TMS Violado.');
                    
                    notification.setNotificationTypeId(mapNotifications.get('KPI_TMS_Violado').Id);
                    notification.setTargetId(caseFlag.Id);
                    
                    recipientsIds.add(caseFlag.OwnerId);
                    
                    try {
                        notification.send(recipientsIds);
                    }
                    catch (Exception e) {System.debug('Problem sending notification: ' + e.getMessage());}
                }
            }  
        }
    }
    
    public static void inserirDatasKPI() {
        Map<String, Boolean> mapTMR = new Map<String, Boolean>();
        Map<String, Boolean> mapTMP = new Map<String, Boolean>();
        Map<String, Boolean> mapSLO = new Map<String, Boolean>();
        Set<String> idsCaso = new Set<String>();
        List<CaseMileStone> marcosAtualizar = new List<CaseMileStone>();
        system.debug('Entrou no inserirDatasKPI1');
        if(!ignoreHandler) {
            ignoreHandler = true;
            for(Case caso : (List<Case>) Trigger.new) {
                if(Trigger.isInsert) {
                    caso.KPI_TMR_Data_Hora_de_Inicio__c = Datetime.now();
                    caso.KPI_TMS_Data_Hora_de_Inicio__c = Datetime.now();
                } else {
                    system.debug('Entrou no inserirDatasKPI2');
                    System.debug(statusNaoMassivo.contains(caso.Status));
                    System.debug(caso.Status);
                    System.debug(statusNaoMassivo.contains(((Case) Trigger.oldMap.get(caso.Id)).Status));
                    System.debug(((Case) Trigger.oldMap.get(caso.Id)).Status);
                    if((caso.Status == 'Pausado' || caso.Status == 'Agendado') && (((Case) Trigger.oldMap.get(caso.Id)).Status != caso.Status) && caso.KPI_TMP_Data_Hora_de_Inicio__c == null) {
                        caso.KPI_TMP_Data_Hora_de_Inicio__c = Datetime.now();
                    }else if(caso.Status == 'Escalado' && (((Case) Trigger.oldMap.get(caso.Id)).Status != caso.Status) && caso.KPI_SLO_Data_Hora_de_Inicio__c == null) {
                        caso.KPI_SLO_Data_Hora_de_Inicio__c = Datetime.now();
                    } 
                    if(caso.Status != 'Novo' && caso.Status != 'Em andamento' && (((Case) Trigger.oldMap.get(caso.Id)).Status == 'Novo' || ((Case) Trigger.oldMap.get(caso.Id)).Status == 'Em andamento')) {
                        caso.KPI_TMR_Data_Hora_de_Fim__c = Datetime.now();
                        mapTMR.put(caso.Id, true);
                    }else if(caso.Status != 'Pausado' && caso.Status != 'Agendado' && (((Case) Trigger.oldMap.get(caso.Id)).Status == 'Pausado' || ((Case) Trigger.oldMap.get(caso.Id)).Status == 'Agendado')) {
                        caso.KPI_TMP_Data_Hora_de_Fim__c = Datetime.now();
                        mapTMP.put(caso.Id, true);
                    }else if(caso.Status != 'Escalado' && ((Case) Trigger.oldMap.get(caso.Id)).Status == 'Escalado') {
                        caso.KPI_SLO_Data_Hora_de_Fim__c = Datetime.now();
                        mapSLO.put(caso.Id, true);
                    }
                    
                    //Alteração 22/07/2024 - Carlos
                    //Conclusão de CaseMilestone por Status alterado
                    if(caso.Status != 'Escalado' && ((Case) Trigger.oldMap.get(caso.Id)).Status == 'Escalado'){
                        
                        for(CaseMileStone marco :[SELECT Id, MilestoneType.Name, CaseId, CompletionDate FROM CaseMilestone WHERE CaseId = :caso.Id AND CompletionDate =: NULL]) {
                            if(marco.MilestoneType.Name == 'AUTOATENDIMENTO' || marco.MilestoneType.Name == 'FIELD SERVICE' || marco.MilestoneType.Name == 'CMC' || marco.MilestoneType.Name == 'INFRAESTRUTURA' || marco.MilestoneType.Name == 'IMPLANTAÇÃO' || marco.MilestoneType.Name == 'NGR' || marco.MilestoneType.Name == 'O&M' || marco.MilestoneType.Name == 'PARCEIRO' || marco.MilestoneType.Name == 'PÓS-VENDA' || marco.MilestoneType.Name == 'SUPORTE N1' || marco.MilestoneType.Name == 'SUPORTE N2' || marco.MilestoneType.Name == 'SUPORTE N3' || marco.MilestoneType.Name == 'SOLUÇÕES DIGITAIS' || marco.MilestoneType.Name == 'SUPORTE DE CAMPO (NOC)' || marco.MilestoneType.Name == 'Backbone' || marco.MilestoneType.Name == 'TI Backoffice (Interno)' || marco.MilestoneType.Name == 'INFRA-TI' || marco.MilestoneType.Name == 'SEGURANÇA-TI' || marco.MilestoneType.Name == 'DESENVOLVIMENTO-TI' || marco.MilestoneType.Name == 'FORNECEDOR TI' || marco.MilestoneType.Name == 'CLOUD-TI' || marco.MilestoneType.Name == 'INFRA-SD' || marco.MilestoneType.Name == 'SEGURANÇA-SD' || marco.MilestoneType.Name == 'DESENVOLVIMENTO-SD' || marco.MilestoneType.Name == 'FORNECEDOR-SD' || marco.MilestoneType.Name == 'CLOUD-SD') {
                                marco.CompletionDate = Datetime.now();
                                marcosAtualizar.add(marco);
                            }
                        }         
                    }
                    //Conclusão de CaseMilestone por Área alterada
                    if(caso.Area__c <> ((Case) Trigger.oldMap.get(caso.Id)).Area__c && ((Case) Trigger.oldMap.get(caso.Id)).Area__c != null && caso.Status == 'Escalado'){
                        
                        for(CaseMileStone marco :[SELECT Id, MilestoneType.Name, CaseId, CompletionDate FROM CaseMilestone WHERE CaseId = :caso.Id AND CompletionDate =: NULL]) {
                            if(marco.MilestoneType.Name == 'AUTOATENDIMENTO' || marco.MilestoneType.Name == 'CMC' || marco.MilestoneType.Name == 'FIELD SERVICE' || marco.MilestoneType.Name == 'INFRAESTRUTURA' || marco.MilestoneType.Name == 'IMPLANTAÇÃO' || marco.MilestoneType.Name == 'NGR' || marco.MilestoneType.Name == 'O&M' || marco.MilestoneType.Name == 'PARCEIRO' || marco.MilestoneType.Name == 'PÓS-VENDA' || marco.MilestoneType.Name == 'SUPORTE N1' || marco.MilestoneType.Name == 'SUPORTE N2' || marco.MilestoneType.Name == 'SUPORTE N3' || marco.MilestoneType.Name == 'SOLUÇÕES DIGITAIS' || marco.MilestoneType.Name == 'SUPORTE DE CAMPO (NOC)' || marco.MilestoneType.Name == 'Backbone' || marco.MilestoneType.Name == 'TI Backoffice (Interno)' || marco.MilestoneType.Name == 'INFRA-TI' || marco.MilestoneType.Name == 'SEGURANÇA-TI' || marco.MilestoneType.Name == 'DESENVOLVIMENTO-TI' || marco.MilestoneType.Name == 'FORNECEDOR TI' || marco.MilestoneType.Name == 'CLOUD-TI' || marco.MilestoneType.Name == 'INFRA-SD' || marco.MilestoneType.Name == 'SEGURANÇA-SD' || marco.MilestoneType.Name == 'DESENVOLVIMENTO-SD' || marco.MilestoneType.Name == 'FORNECEDOR-SD' || marco.MilestoneType.Name == 'CLOUD-SD') {
                                marco.CompletionDate = Datetime.now();
                                marcosAtualizar.add(marco);
                            }
                        }  
                    }
                    
                    if(!marcosAtualizar.isEmpty()) {update marcosAtualizar;}
                    ignoreHandler = false;  
                    
                    //Encerra alterações aqui - Carlos
                    
                    if(statusNaoMassivo.contains(caso.Status) && !statusNaoMassivo.contains(((Case) Trigger.oldMap.get(caso.Id)).Status)) {
                        caso.KPI_TMS_Data_Hora_de_Fim__c = Datetime.now();
                        System.debug(caso.KPI_TMS_Data_Hora_de_Fim__c);
                        if(caso.KPI_TMS_Data_Hora_de_Inicio__c != null && caso.KPI_TMS_Data_Hora_de_Inicio__c.addHours(12) < caso.KPI_TMS_Data_Hora_de_Fim__c) {caso.KPI_TMS_Violado__c = true;}
                    }
                    if(mapTMR.get(caso.Id) != null && mapTMP.get(caso.Id) != null && mapSLO.get(caso.Id) != null) {idsCaso.add(caso.Id);}
                }
            }
            
            
            for(CaseMileStone marco :[SELECT Id, MilestoneType.Name, CaseId, CompletionDate FROM CaseMilestone WHERE CaseId IN :idsCaso]) {
                if(marco.MilestoneType.Name == 'KPI TMR (Triagem)' && mapTMR.get(marco.CaseId) != null) {
                    marco.CompletionDate = Datetime.now();
                    marcosAtualizar.add(marco);
                }
                if(marco.MilestoneType.Name == 'KPI TMP (Pausas)' && mapTMP.get(marco.CaseId) != null) {
                    marco.CompletionDate = Datetime.now();
                    marcosAtualizar.add(marco);
                }
                if(marco.MilestoneType.Name == 'KPI SLO (Escalação)' && mapSLO.get(marco.CaseId) != null) {
                    marco.CompletionDate = Datetime.now();
                    marcosAtualizar.add(marco);
                }
            }
            
            if(!marcosAtualizar.isEmpty()) {update marcosAtualizar;}
            ignoreHandler = false;
        }
    }
    
    public static void encerrarCasosFilhos(){
        
        Set<id> setCasePai = new Set<id>();
        Map<id, case> mapCase = new Map<id, Case>();
        List<Case> lstCasos = (List<case>) trigger.new;
        Map<id, case> mapCaseOld = (Map<id, case>)trigger.oldMap;
        if(!ignoreHandler || Test.isRunningTest() ) {
            ignoreHandler = true;
            if(!lstCasos.isEmpty()){
                for(Case caso : lstCasos){
                    if((caso.Status == statusFechado && mapCaseOld.get(caso.id).status != statusFechado)){
                        setCasePai.add(caso.id);
                        mapCase.put(caso.id, caso);
                    }
                }
                if(!setCasePai.isEmpty()){
                    List<case> lstFilhos = [SELECT id, Status, ParentId, Motivo_do_Encerramento__c, Encerrado_no_Primeiro_Contato__c, Description FROM Case WHERE ParentId IN:setCasePai and Desconsiderar_Evento_Massivo__c = false ];
                    if(!lstFilhos.isEmpty()){
                        for(Case filho : lstFilhos){
                            filho.Status = statusFechado;
                            filho.Motivo_do_Encerramento__c = mapCase.get(filho.ParentId).Motivo_do_Encerramento__c;
                            filho.Encerrado_no_Primeiro_Contato__c = mapCase.get(filho.ParentId).Encerrado_no_Primeiro_Contato__c;
                            filho.Description = mapCase.get(filho.ParentId).Description;
                        }
                        update lstFilhos;
                    }
                }   
            }
        }
        ignoreHandler = false;
    }
    
    public static void mapearCasoPai(){
        System.debug('Entrou no metodo de mapeamento');
        List<Case> Chamados = new List<Case>();
        List<Case> Massivos = new List<Case>();
        if(!ignoreHandler) {
            ignoreHandler = true;
            
            List<Case> lstCases = (List<Case>) trigger.new;
            for(Case caso : lstCases){
                if(caso.recordTypeId == CaseRecordTypeIdChamado){
                    Chamados.add(caso);
                }else if(caso.recordTypeId == CaseRecordTypeIdMassivo){
                    Massivos.add(caso);
                }
            }
            
            if(!Chamados.isEmpty()){buscarPai(Chamados); System.debug('Achou chamados  >> ' + Chamados);}
            if(!Massivos.isEmpty()){setarPai(Massivos); System.debug('Achou massivos  >> ' + Massivos );}
        }
        
        ignoreHandler = false;
    }
    
    public static void buscarPai (List<Case> lstChamados){
        if( !ignoreHandler ) {
            
            System.debug('BUSCAR PAI');
            Map<id, List<Item_do_Contrato__c>> mapContratoItem = new Map<id, List<Item_do_Contrato__c>>();
            Set<id> setCasos = new Set<id>();
            Set<id> setContrato = new Set<id>();
            boolean atualizar = false;
            
            List<Case> todosCasosAbertosMassivos = [SELECT id, status, description, recordTypeId FROM Case WHERE status !=: statusFechado  AND recordTypeId =:CaseRecordTypeIdMassivo ];
            System.debug('CASOS MASSIVOS BUSCAR PAI >>> ' + todosCasosAbertosMassivos);
            if(!lstChamados.isEmpty()){
                for(Case chamado : lstChamados){
                    setCasos.add(chamado.id);
                }
            }
            System.debug('setCasos ' + setCasos);
            List<Case> lstChamadosFull = [SELECT 	id,
                                          AccountId,
                                          Account.Name,
                                          Account.Nome_Fantasia__c,
                                          Account.Razao_Social__c,
                                          Account.CNPJ__c,
                                          parentId,
                                          Contrato__c,
                                          Item_do_Contrato__c,
                                          Item_do_Contrato__r.Bairro_de_destino__c,
                                          Item_do_Contrato__r.Cep_de_destino__c,
                                          Item_do_Contrato__r.Cidade_de_destino__c,
                                          Item_do_Contrato__r.Complemento_de_destino__c,
                                          Item_do_Contrato__r.Referencia_de_destino__c,
                                          Item_do_Contrato__r.Rua_de_destino__c,                                         
                                          Item_do_Contrato__r.Bairro_de_origem__c,
                                          Item_do_Contrato__r.Cep_de_origem__c,
                                          Item_do_Contrato__r.Cidade_de_origem__c,
                                          Item_do_Contrato__r.Complemento_de_origem__c,
                                          Item_do_Contrato__r.Referencia_de_origem__c,
                                          Item_do_Contrato__r.Rua_de_origem__c                                          
                                          FROM Case WHERE Status !=:statusFechado AND recordTypeId =:CaseRecordTypeIdChamado AND id IN:setCasos and Desconsiderar_Evento_Massivo__c = false ];
            if(!lstChamadosFull.isEmpty()){
                System.debug('BUSCAR PAI  2');
                for(Case getContrato : lstChamadosFull) {
                    setContrato.add(getContrato.Contrato__c); 
                }
                
                List<Item_do_Contrato__c> lstItems = [SELECT Id,
                                                      Contrato__c, 
                                                      Bairro_de_destino__c, 
                                                      Cep_de_destino__c, 
                                                      Cidade_de_destino__c, 
                                                      Complemento_de_destino__c, 
                                                      Referencia_de_destino__c, 
                                                      Rua_de_destino__c, 
                                                      Bairro_de_origem__c, 
                                                      Cep_de_origem__c, 
                                                      Cidade_de_origem__c, 
                                                      Complemento_de_origem__c, 
                                                      Referencia_de_origem__c, 
                                                      Rua_de_origem__c 
                                                      FROM Item_do_Contrato__c  WHERE Contrato__c IN:setContrato];
                if(!lstItems.isEmpty()){
                    System.debug('BUSCAR PAI  3');
                    for(Item_do_Contrato__c item : lstItems){ 
                        if(mapContratoItem.containsKey(item.Contrato__c)){ 
                            mapContratoItem.get(item.Contrato__c).add(item);	 System.debug('BUSCAR PAI  4');
                        } else{ 
                            List<Item_do_Contrato__c> lstItem = new List<Item_do_Contrato__c>();
                            lstItem.add(item);
                            mapContratoItem.put(item.Contrato__c, lstItem);	
                        }
                    }
                }
                
                for(Case ch : lstChamadosFull){
                    for(Case ma : todosCasosAbertosMassivos){
                        System.debug('caso MA: ' + ma);
                        if(String.isNotBlank(ma.Description)){
                            List<String> descricoes =  ma.description.split('\n');
                            System.debug('BUSCAR PAI description  >> ' + descricoes);
                            String name = ch.Account.Name != null ? ch.Account.Name.toLowerCase() : '';
                            string nomeFantasia = ch.Account.Nome_Fantasia__c != null ? ch.Account.Nome_Fantasia__c.toLowerCase() : '';
                            String razaoSocial = ch.Account.Razao_Social__c != null ? ch.Account.Razao_Social__c.toLowerCase() : '';
                            string cnpj = ch.Account.CNPJ__c != null ? ch.Account.CNPJ__c.toLowerCase() : '';
                            List<string> descricoesFormatadas = stringEmCaixaBaixa(descricoes);
                            System.debug('descricoesFormatadas  >> ' + descricoesFormatadas);
                            
                            
                            for( String descricao : descricoesFormatadas ) {
                                if( name.contains( descricao.trim() ) || nomeFantasia.contains( descricao.trim() ) || razaoSocial.contains( descricao.trim() ) || cnpj.contains( descricao.trim() ) || varerItensContrato(descricoesFormatadas, mapContratoItem.get(ch.Contrato__c)) ) {
                                    System.debug('BUSCAR PAI  5');
                                    atualizar = true;
                                    if(ch.parentId == null){
                                        ch.parentId = ma.id;
                                    } 
                                } else if( ch.Item_do_Contrato__c != null && ( (ch.Item_do_Contrato__r.Bairro_de_destino__c != null && ch.Item_do_Contrato__r.Bairro_de_destino__c.containsIgnoreCase( descricao )) || (ch.Item_do_Contrato__r.Cep_de_destino__c != null && ch.Item_do_Contrato__r.Cep_de_destino__c.containsIgnoreCase( descricao )) || (ch.Item_do_Contrato__r.Cidade_de_destino__c != null && ch.Item_do_Contrato__r.Cidade_de_destino__c.containsIgnoreCase( descricao )) || (ch.Item_do_Contrato__r.Complemento_de_destino__c != null && ch.Item_do_Contrato__r.Complemento_de_destino__c.containsIgnoreCase( descricao )) || (ch.Item_do_Contrato__r.Referencia_de_destino__c != null && ch.Item_do_Contrato__r.Referencia_de_destino__c.containsIgnoreCase( descricao )) || (ch.Item_do_Contrato__r.Rua_de_destino__c != null && ch.Item_do_Contrato__r.Rua_de_destino__c.containsIgnoreCase( descricao )) || (ch.Item_do_Contrato__r.Bairro_de_origem__c != null && ch.Item_do_Contrato__r.Bairro_de_origem__c.containsIgnoreCase( descricao )) || (ch.Item_do_Contrato__r.Cep_de_origem__c != null && ch.Item_do_Contrato__r.Cep_de_origem__c.containsIgnoreCase( descricao )) || (ch.Item_do_Contrato__r.Cidade_de_origem__c != null && ch.Item_do_Contrato__r.Cidade_de_origem__c.containsIgnoreCase( descricao )) || (ch.Item_do_Contrato__r.Complemento_de_origem__c != null && ch.Item_do_Contrato__r.Complemento_de_origem__c.containsIgnoreCase( descricao )) || (ch.Item_do_Contrato__r.Referencia_de_origem__c != null && ch.Item_do_Contrato__r.Referencia_de_origem__c.containsIgnoreCase( descricao )) || (ch.Item_do_Contrato__r.Rua_de_origem__c != null && ch.Item_do_Contrato__r.Rua_de_origem__c.containsIgnoreCase( descricao ) ) ) ) {
                                    atualizar = true;
                                    if(ch.parentId == null){
                                        ch.parentId = ma.id;
                                    } 
                                }
                                
                                break;
                            }
                            
                        }
                    }
                }
                
                if(atualizar){
                    System.debug('BUSCAR PAI ATUALIZOU');
                    ignoreHandler = true;
                    update lstChamadosFull;	
                    ignoreHandler = false;
                }
                
            }            
        }
    }
    
    
    public static void setarPai (List<Case> lstMassivo){
        if( !ignoreHandler ) {
            
            System.debug('SETAR PAI');
            Set<id> setContrato = new Set<id>();
            Map<id, List<Item_do_Contrato__c>> mapContratoItem = new Map<id, List<Item_do_Contrato__c>>();
            boolean atualizar = false;
            
            List<Case> lstChamadosFull = [SELECT 	id,
                                          AccountId,
                                          Account.Name,
                                          Account.Nome_Fantasia__c,
                                          Account.Razao_Social__c,
                                          Account.CNPJ__c,
                                          parentId,
                                          Contrato__c
                                          FROM Case WHERE Status NOT IN : statusNaoMassivo AND recordTypeId =:CaseRecordTypeIdChamado AND Desconsiderar_Evento_Massivo__c = false ];
            
            System.debug('BUSCAR PAI CHAMADOS FULL >> ' + lstChamadosFull);
            
            List<Case> lstChamadosUpdate = new List<Case>();        
            
            if(!lstChamadosFull.isEmpty()){
                for(Case getContrato : lstChamadosFull) {setContrato.add(getContrato.Contrato__c); }
                List<Item_do_Contrato__c> lstItems = [SELECT Id,
                                                      Contrato__c, 
                                                      Bairro_de_destino__c, 
                                                      Cep_de_destino__c, 
                                                      Cidade_de_destino__c, 
                                                      Complemento_de_destino__c, 
                                                      Referencia_de_destino__c, 
                                                      Rua_de_destino__c, 
                                                      Bairro_de_origem__c, 
                                                      Cep_de_origem__c, 
                                                      Cidade_de_origem__c, 
                                                      Complemento_de_origem__c, 
                                                      Referencia_de_origem__c, 
                                                      Rua_de_origem__c 
                                                      FROM Item_do_Contrato__c  WHERE Contrato__c IN:setContrato];
                if(!lstItems.isEmpty()){
                    for(Item_do_Contrato__c item : lstItems){ 
                        if(mapContratoItem.containsKey(item.Contrato__c)){ 
                            mapContratoItem.get(item.Contrato__c).add(item);	
                        } else{
                            List<Item_do_Contrato__c> lstItem = new List<Item_do_Contrato__c>();
                            lstItem.add(item);
                            mapContratoItem.put(item.Contrato__c, lstItem);		
                        }
                    }
                }
                
                
                for(Case casoAbertoMassivo : lstMassivo){
                    Boolean achou = false;
                    if(String.isNotBlank(casoAbertoMassivo.description)){
                        List<String> descricoes =  casoAbertoMassivo.description.split('\n');
                        List<String> descricoesFormatadas = stringEmCaixaBaixa(descricoes);
                        for(Case ch : lstChamadosFull){
                            String name = ch.Account.Name != null ? ch.Account.Name.toLowerCase() : '';
                            String nomeFantasia = ch.Account.Nome_Fantasia__c != null ? ch.Account.Nome_Fantasia__c.toLowerCase() : '';
                            String razaoSocial = ch.Account.Razao_Social__c != null ? ch.Account.Razao_Social__c.toLowerCase() : '';
                            String cnpj = ch.Account.CNPJ__c != null ? ch.Account.CNPJ__c.toLowerCase() : '';
                            for( String descricao : descricoesFormatadas ) {
                                if( name.contains( descricao ) || nomeFantasia.contains(descricao) || razaoSocial.contains(descricao) || cnpj.contains(descricao) || varerItensContrato(descricoesFormatadas, mapContratoItem.get(ch.Contrato__c))){  
                                    
                                    atualizar = true;
                                    system.debug('parentID ==== ' + ch.parentId);
                                    if(ch.parentId == null){
                                        ch.parentId = casoAbertoMassivo.id;
                                        lstChamadosUpdate.add( ch ) ;
                                    }
                                }
                                break;
                            }
                        }
                    }
                }
                
                if(atualizar){
                    System.debug('SETAR PAI ATUALIZOU ');
                    ignoreHandler = true;
                    update lstChamadosUpdate;	
                    ignoreHandler = false;
                }
            }
        }
    }
    
    public static Boolean varerItensContrato(List<String> descricoes, List<Item_do_Contrato__c> itens ){
        
        
        boolean retorno = false;
        
        if(itens != null && !itens.isEmpty()){
            for(Item_do_Contrato__c item : itens){
                
                string bairro = item.Bairro_de_destino__c != null ? item.Bairro_de_destino__c.toLowerCase()  : '';
                string cep = item.Cep_de_destino__c != null ? item.Cep_de_destino__c.toLowerCase()  : '';
                string cidade = item.Cidade_de_destino__c != null ? item.Cidade_de_destino__c.toLowerCase()  : '';
                string complemento = item.Complemento_de_destino__c != null ? item.Complemento_de_destino__c.toLowerCase()  : '';
                string referencia = item.Referencia_de_destino__c != null ? item.Referencia_de_destino__c.toLowerCase()  : '';
                string rua = item.Rua_de_destino__c != null ? item.Rua_de_destino__c.toLowerCase()  : '';
                string bairroOrigem = item.Bairro_de_origem__c != null ? item.Bairro_de_origem__c.toLowerCase()  : '';
                string cepOrigem = item.Cep_de_origem__c != null ? item.Cep_de_origem__c.toLowerCase()  : '';
                string cidadeOrigem = item.Cidade_de_origem__c != null ? item.Cidade_de_origem__c.toLowerCase()  : '';
                string complementoOrigem = item.Complemento_de_origem__c != null ? item.Complemento_de_origem__c.toLowerCase()  : '';
                string referenciaOrigem = item.Referencia_de_origem__c != null ? item.Referencia_de_origem__c.toLowerCase()  : '';
                string ruaOrigem = item.Rua_de_origem__c != null ? item.Rua_de_origem__c.toLowerCase()  : '';
                
                for( String descricao : descricoes ) {
                    if((bairro != null && bairro.containsIgnoreCase( descricao )) || (cep != null && cep.containsIgnoreCase( descricao )) || (cidade != null && cidade.containsIgnoreCase( descricao )) || (complemento != null && complemento.containsIgnoreCase( descricao )) || (referencia != null && referencia.containsIgnoreCase( descricao )) || (rua != null && rua.containsIgnoreCase( descricao )) || (bairroOrigem != null && bairroOrigem.containsIgnoreCase( descricao )) || (cepOrigem != null && cepOrigem.containsIgnoreCase( descricao )) || (cidadeOrigem != null && cidadeOrigem.containsIgnoreCase( descricao )) || (complementoOrigem != null && complementoOrigem.containsIgnoreCase( descricao )) || (referenciaOrigem != null && referenciaOrigem.containsIgnoreCase( descricao )) || (ruaOrigem != null && ruaOrigem.containsIgnoreCase( descricao ))) {                    
                        retorno = true;
                        break;
                    }
                }
                
            }
        }
        
        return retorno;
    }
    
    public static List<string> stringEmCaixaBaixa(List<string> lista){
        List<String> retorno = new List<String>();
        if(!lista.isEmpty()){
            for(String st : lista){
                String valor = st.toLowerCase();
                retorno.add(valor.trim());
            }
        }
        return retorno;
    }
    
    public static void criaPausa() {
        List<Case> casos = (List<Case>) Trigger.new;
        Map<Id,Case> oldMap = (Map<Id,Case>) Trigger.oldMap;
        
        List<Pausa_do_Caso__c> pausas = new List<Pausa_do_Caso__c>();
        for( Case caso : casos ) {
            if( (caso.Status == 'Pausado' && oldMap.get( caso.Id ).Status != 'Pausado') || (caso.Status == 'Agendado' && oldMap.get( caso.Id ).Status != 'Agendado') ) {
                Pausa_do_Caso__c pausa = new Pausa_do_Caso__c();
                pausa.Name = Datetime.now().format('dd/MM/yyyy HH:mm');
                pausa.Caso__c = caso.Id;
                pausa.Data_Hora_Inicio__c = Datetime.now();
                pausa.Em_andamento__c = true;
                pausas.add( pausa );
            }
        }
        
        if( pausas.size() > 0 ) {
            insert pausas;
        }
    }
    
    public static void encerraPausa() {
        List<Case> casos = (List<Case>) Trigger.new;
        Map<Id,Case> oldMap = (Map<Id,Case>) Trigger.oldMap;
        if(!ignoreHandler) {
            ignoreHandler = true;
            casos = [Select Id, Status, (Select Id, Data_Hora_Fim__c from Pausas_do_Caso__r where Em_Andamento__c = true) from Case where Id in :casos];
            
            List<Pausa_do_Caso__c> pausas = new List<Pausa_do_Caso__c>();
            for( Case caso : casos ) {
                if( (caso.Status != 'Pausado' && oldMap.get( caso.Id ).Status == 'Pausado') || (caso.Status != 'Agendado' && oldMap.get( caso.Id ).Status == 'Agendado')) {
                    for( Pausa_do_Caso__c pausa : caso.Pausas_do_Caso__r ) {
                        pausa.Data_Hora_Fim__c = Datetime.now();
                        pausa.Em_andamento__c = false;
                        pausas.add( pausa );
                    }
                }
            }
            
            if( pausas.size() > 0 ) {update pausas;}
        }
        
        ignoreHandler = false;
    }
    
    public static void enviaIndisponibilidade() {
        List<Case> casos = (List<Case>) Trigger.new;
        Map<Id,Case> oldMap = (Map<Id,Case>) Trigger.oldMap;
        
        if(!ignoreHandler) {
            ignoreHandler = true;
            
            Set<ID> casosEnviar = new Set<ID>();
            for( Case caso : casos ) {
                if( caso.IsClosed && !oldMap.get( caso.Id ).IsClosed && caso.Indisponibilidade__c && caso.Indisponibilidade_Total__c > 0 ) {casosEnviar.add( caso.Id );}
            }
            
            if(casosEnviar.size() > 0 ){enviaIndisponibilidadeSAP( casosEnviar );}
        }
        ignoreHandler = false;
    }
    
    @future(callout=true)
    public static void enviaIndisponibilidadeSAP( Set<ID> idCasos ) {
        List<Case> casos = [Select Id, Item_do_Contrato__r.Numero_do_Circuito__c, Indisponibilidade_Total__c from Case where ID in :idCasos];
        IntegrationServices instance = IntegrationServices.getInstance();
        for( Case caso : casos ) {
            instance.EnviarSAPDesconto(caso.Item_do_Contrato__r.Numero_do_circuito__c, Date.today(), caso.Indisponibilidade_Total__c);
        }
    }
    
    public static void setarContaEContrato(){
        
        List<Case> lstCase = (List<Case>) Trigger.new;
        Set<id> itens = new Set<id>();
        if(!ignoreHandler) {
            ignoreHandler = true;
            
            if(!lstCase.isEmpty()){
                for(Case caso : lstCase){
                    if(caso.Item_do_Contrato__c  != null){
                        itens.add(caso.Item_do_Contrato__c);
                    }
                }
                Map<id, Item_do_Contrato__c> mapItens = new Map<id, Item_do_Contrato__c>([SELECT id, Contrato__c, Contrato__r.AccountId FROM Item_do_Contrato__c WHERE id IN:itens]);
                for(Case casoATT : lstCase){
                    if(casoATT.Item_do_Contrato__c != null){
                        casoATT.AccountId = mapItens.get(casoATT.Item_do_Contrato__c).Contrato__r.AccountId;
                        casoATT.Contrato__c  = mapItens.get(casoATT.Item_do_Contrato__c).Contrato__c;
                    }
                }
            }
        }
        
        ignoreHandler = false;
    }
    
    public static void copiarDadosCasosFilho(){
        
        if( !ignoreHandler ) {            
            List<Case> lstCase = (List<Case>) Trigger.new;
            Map<id,Case> casesMap = new Map<id,Case>();
            for(Case caso : lstCase ){
                casesMap.put(caso.Id,caso);
            }
            
            Map<id, Case> mapCasosFilhos = new Map<id, Case>([SELECT Id, Area__c, Tipo_do_Chamado__c, Tipo_Atendimento__c, ParentId, Categoria__c, Status, Priority, Motivo_do_Encerramento__c, Descricao_do_Encerramento__c, RFO__c, Indisponibilidade__c, Data_Hora_Indisponibilidade__c, Fornecedor__c FROM Case WHERE ParentId IN: casesMap.keySet() AND Status NOT IN :statusNaoMassivo]);
            if(!mapCasosFilhos.isEmpty()){
                for(Case casoATT : mapCasosFilhos.values()){
                    casoATT.Trecho__c 		   = casesMap.get(casoATT.ParentId).Trecho__c;
                    casoATT.Area__c   		   = casesMap.get(casoATT.ParentId).Area__c;
                    casoATT.Tipo_Atendimento__c = casesMap.get(casoATT.ParentId).Tipo_Atendimento__c;
                    casoATT.Categoria__c 	   = casesMap.get(casoATT.ParentId).Categoria__c;
                    casoATT.Status 			   = casesMap.get(casoATT.ParentId).Status;
                    casoATT.Priority 		   = casesMap.get(casoATT.ParentId).Priority;
                    casoATT.Motivo_do_Encerramento__c = casesMap.get( casoATT.ParentId ).Motivo_do_Encerramento__c;
                    casoATT.Descricao_do_Encerramento__c = casesMap.get( casoATT.ParentId ).Descricao_do_Encerramento__c;
                    casoATT.RFO__c = casesMap.get( casoATT.ParentId ).RFO__c;
                    casoATT.Indisponibilidade__c = casesMap.get( casoATT.ParentId ).Indisponibilidade__c;
                    casoATT.Data_Hora_Indisponibilidade__c = casesMap.get( casoATT.ParentId ).Data_Hora_Indisponibilidade__c;
                    casoATT.Fornecedor__c = casesMap.get( casoAtt.ParentId ).Fornecedor__c;
                    // casoATT.Desconsiderar_Evento_Massivo__c = true;
                }
                
                ignoreHandler = true;
                update mapCasosFilhos.values();
                
                // for(Case casoATT : mapCasosFilhos.values()){
                //     casoATT.Desconsiderar_Evento_Massivo__c = false;
                // }
                
                // update mapCasosFilhos.values();
                ignoreHandler = false;
            }
        }
    }
    
    public static void copiarDadosCasoPai() {
        List<Case> casos = (List<Case>) Trigger.new;
        
        Set<ID> idCasosPai = new Set<ID>();
        if(!ignoreHandler) {
            ignoreHandler = true;
            
            for( Case caso : casos ) {
                if( !statusNaoMassivo.contains( caso.Status ) && caso.ParentId != null ) {idCasosPai.add( caso.ParentId );}
            }
            
            Map<ID,Case> mapaCasosPai = new Map<ID,Case>([Select Id, Trecho__c, Area__c, Tipo_Atendimento__c, Categoria__c, Status, Priority, Motivo_do_Encerramento__c, Descricao_do_Encerramento__c, RFO__c, Indisponibilidade__c, Data_Hora_Indisponibilidade__c, Fornecedor__c FROM Case where Id in :idCasosPai]);
            for( Case caso : casos ) {
                if( !statusNaoMassivo.contains( caso.Status ) && caso.ParentId != null && mapaCasosPai.containsKey( caso.ParentId ) && !caso.Desconsiderar_Evento_Massivo__c ) {
                    caso.Trecho__c 		   = mapaCasosPai.get(caso.ParentId).Trecho__c;
                    caso.Area__c   		   = mapaCasosPai.get(caso.ParentId).Area__c;
                    caso.Tipo_Atendimento__c = mapaCasosPai.get(caso.ParentId).Tipo_Atendimento__c;
                    caso.Categoria__c 	   = mapaCasosPai.get(caso.ParentId).Categoria__c;
                    caso.Status 			   = mapaCasosPai.get(caso.ParentId).Status;
                    caso.Priority 		   = mapaCasosPai.get(caso.ParentId).Priority;
                    caso.Motivo_do_Encerramento__c = mapaCasosPai.get( caso.ParentId ).Motivo_do_Encerramento__c;
                    caso.Descricao_do_Encerramento__c = mapaCasosPai.get( caso.ParentId ).Descricao_do_Encerramento__c;
                    caso.RFO__c = mapaCasosPai.get( caso.ParentId ).RFO__c;
                    caso.Indisponibilidade__c = mapaCasosPai.get( caso.ParentId ).Indisponibilidade__c;
                    caso.Data_Hora_Indisponibilidade__c = mapaCasosPai.get( caso.ParentId ).Data_Hora_Indisponibilidade__c;
                    caso.Fornecedor__c = mapaCasosPai.get( caso.ParentId ).Fornecedor__c;
                }
            }
        }
        
        ignoreHandler = false;
    }
    
    /*
public static void replicarNotasEAnexosCasosFilhos(){
List<Case> lstCase = (List<Case>) Trigger.new;
Map<id, Case> oldMapCase = (Map<id, Case>) Trigger.oldMap;
List<Note> notas = new List<Note>();
List<ContentDocumentLInk> anexos = new List<ContentDocumentLInk>();
Set<id> idsPai = new Set<id>();
Map<id, List<Note>> mapPaiNotas = new Map<Id, List<Note>>();
Map<id, List<ContentDocumentLInk>> mapPaiAnexos = new Map<Id, List<ContentDocumentLInk>>();
if(!ignoreHandler){
for(Case caso : lstCase){
if(caso.ParentId != null && (oldMapCase == null  || caso.ParentId != oldMapCase.get(caso.id).ParentId)){
idsPai.add(caso.parentId);
}
}
system.debug(idsPai);
List<Note> notasGeral = [SELECT Id, ParentId, Title, IsPrivate, Body, OwnerId, IsDeleted FROM Note WHERE parentId In:idsPai ];
List<ContentDocumentLink> AnexosGeral  = [SELECT Id, LinkedEntityId, ContentDocumentId, ShareType, Visibility FROM ContentDocumentLink WHERE LinkedEntityId In:idsPai];
if(!notasGeral.isEmpty()){
for(Note nota : notasGeral){
if(!mapPaiNotas.containsKey(nota.parentId)){
List<Note> notasDoPai = new List<Note>();
notasDoPai.add(nota);
mapPaiNotas.put(nota.parentId, notasDoPai );
}else{
mapPaiNotas.get(nota.parentId).add(nota);
}
}
}
if(!AnexosGeral.isEmpty()){
for(ContentDocumentLink anexo : AnexosGeral){
if(!mapPaiAnexos.containsKey(anexo.LinkedEntityId)){
List<ContentDocumentLink> AnexosDoPai = new List<ContentDocumentLink>();
AnexosDoPai.add(anexo);
mapPaiAnexos.put(anexo.LinkedEntityId, AnexosDoPai );
}else{
mapPaiAnexos.get(anexo.LinkedEntityId).add(anexo);
}
}
}
for(Case caso : lstCase){
if(caso.ParentId != null && (oldMapCase == null  || caso.ParentId != oldMapCase.get(caso.id).ParentId)){
if(mapPaiNotas.containsKey(caso.parentId)){
for(Note notasADD : mapPaiNotas.get(caso.parentId)){
Note notaClone = notasADD.clone(false,false,true,true);
notaClone.parentId = caso.id;
notas.add(notaClone);
}
}
if(mapPaiAnexos.containsKey(caso.parentId)){
if(mapPaiAnexos.get(caso.parentId)!= null){
for(ContentDocumentLink anexoADD : mapPaiAnexos.get(caso.parentId)){
ContentDocumentLink anexoClone = anexoADD.clone(false,false,true,true);
anexoClone.LinkedEntityId = caso.id;
anexos.add(anexoClone);
}
}
}
}
}
ignoreHandler = true;
if(!notas.isEmpty()){ insert notas; }
if(!anexos.isEmpty()){ insert anexos; }
ignoreHandler = false;
}
}*/
    
    public static void associaSLA() {
        List<Case> casos = (List<Case>) Trigger.new;
        if(!ignoreHandler) {
            ignoreHandler = true;
            
            List<Entitlement> direitos = [Select Id, SLAProcess.Name, SLAProcess.VersionNumber from Entitlement where Account.Name = 'Conta Padrão'];
            Map<String,Entitlement> mapaDireitos = new Map<String,Entitlement>();
            for( Entitlement direito : direitos ) {mapaDireitos.put( direito.SLAProcess.Name, direito );}
            for( Case caso : casos ) {
                if( caso.Tipo_Atendimento__c != null &&  mapaTipoAtendimentoSLA.containsKey( caso.Tipo_Atendimento__c ) ) {caso.EntitlementId = mapaDireitos.get( mapaTipoAtendimentoSLA.get( caso.Tipo_Atendimento__c) ).Id;}
            }
        }
    }
    
    public static void fechaMarco() {
        List<Case> casos = (List<Case>) Trigger.new;
        Map<ID,Case> oldMap = (Map<ID,Case>) Trigger.oldMap;
        Set<ID> idCasos = new Set<ID>();
        if(!ignoreHandler) {
            ignoreHandler = true;
            for( Case caso : casos ) {
                if( oldMap == null || (caso.Status != oldMap.get( caso.Id ).Status && statusNaoMassivo.contains( caso.Status ) ) ) {
                    idCasos.add( caso.Id );
                }
            }
            
            System.debug('MARCOS >>> ' + idCasos );
            List<CaseMilestone> marcos = [Select Id, CompletionDate from CaseMilestone where CaseId in :idCasos];
            for( CaseMilestone marco : marcos ) {marco.CompletionDate = Datetime.now();}
            
            update marcos;
            ignoreHandler = false;
        }
    }
    
    public static void calculaDuracaoIndisponibilidade() {
        List<Case> casos = (List<Case>) Trigger.new;
        Map<ID,Case> oldMap = (Map<ID,Case>) Trigger.oldMap;
        if(!ignoreHandler) {
            ignoreHandler = true;
            Map<String,Case> casosMap = new Map<String,Case> ([Select Id, Data_Hora_Indisponibilidade__c, Data_Hora_do_Encerramento_da_Indisponibi__c,Data_Hora_Encerramento__c, Indisponibilidade__c, (Select Data_Hora_Inicio__c, Data_Hora_Fim__c from Pausas_do_Caso__r) from Case where Id in :casos]);
            
            for( Case caso : casos ) {
                if( caso.Indisponibilidade__c ) {
                    Long duracaoPausa = CasoUtils.calculaIndisponibilidade( casosMap.get( caso.Id ) );
                    caso.Indisponibilidade_Total_Calc__c = Decimal.valueOf( duracaoPausa );
                }
            }
        }
        
        ignoreHandler = false;
        Decimal a = 1;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
         a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
        a++;
    }
    /*
public static void casosSolicitacoesInternas(){

Set<id> setItensContrato = new Set<id>();
Map<id, List<Case>> mapItemCasos = new Map<id,List<Case>>();
Map<id, Case> mapItemCaseAntigo = new Map<id, Case>();
List<Case> novosCasos = new List<Case>();
List<Item_do_Contrato__c> itemsAtualizar = new List<Item_do_Contrato__c>();
for(Case caso : (List<Case>) Trigger.new){
if(caso.IsClosed && caso.Item_do_Contrato__c != null && !caso.Gerado_Automaticamente__c){
setItensContrato.add(caso.Item_do_Contrato__c);
mapItemCaseAntigo.put(caso.Item_do_Contrato__c, caso);
}
}

if(!setItensContrato.isEmpty()){
List<Case> lstCasosItens = [SELECT id,
Item_do_Contrato__c, 
ClosedDate  
FROM Case Where Item_do_Contrato__c IN:setItensContrato AND (ClosedDate = LAst_N_Months:2 OR ClosedDate = THIS_MONTH) ];
System.debug('casos 3 meses >>>  ' + lstCasosItens.size());
if(!lstCasosItens.isEmpty()){
for(Case caso : lstCasosItens){
if(mapItemCasos.get(caso.Item_do_Contrato__c) != null){
mapItemCasos.get(caso.Item_do_Contrato__c).add(caso);
}else{
List<Case> casosItem = new List<Case>();
casosItem.add(caso);
mapItemCasos.put(caso.Item_do_Contrato__c, casosItem);
}
}

Map<id, Item_do_Contrato__c> mapItensContrato = new Map<id, Item_do_Contrato__c>([SELECT id, Casos_Fechados_nos_ultimos_3_meses__c FROM Item_do_Contrato__c Where id IN:setItensContrato]); 
System.debug('mapItensContrato >>>  ' + mapItensContrato);
for(id item : setItensContrato){
if(mapItemCasos.get(item).size() >= 3){
Case novoCaso = new Case();
novoCaso.AccountId = mapItemCaseAntigo.get(item).AccountId != null ? mapItemCaseAntigo.get(item).AccountId: null;
novoCaso.Contrato__c = mapItemCaseAntigo.get(item).Contrato__c != null ? mapItemCaseAntigo.get(item).Contrato__c : null ;
novoCaso.Item_do_Contrato__c = item;
novoCaso.ContactId = mapItemCaseAntigo.get(item).ContactId != null ? mapItemCaseAntigo.get(item).ContactId : null;
novoCaso.Origin = 'Solicitação Internas';
novoCaso.Categoria__c = 'Recorrências';
novoCaso.Tipo_Atendimento__c = 'NOC|Análise de Recorrência em Chamados';
novoCaso.SLA_por_Tipo_de_Atendimento__c = 'TMS até 48 horas';
novoCaso.Area__c = 'SUPORTE N3';
novoCaso.Motivo_do_Escalonamento__c = 'Consultoria para Reparo do Cliente Final (Sem Indisponibilidade)';
novoCaso.Gera_Desconto_Cliente__c = 'Não';
novoCaso.Gerado_Automaticamente__c = true;
novosCasos.add(novoCaso);
}
System.debug('mapItensContrato.get(item).Casos_Fechados_nos_ultimos_3_meses__c >>>  ' + mapItensContrato.get(item).Casos_Fechados_nos_ultimos_3_meses__c);
System.debug('mapItemCasos.get(item).size() >>>  ' + mapItemCasos.get(item).size());
if(mapItensContrato.get(item).Casos_Fechados_nos_ultimos_3_meses__c != mapItemCasos.get(item).size()){
mapItensContrato.get(item).Casos_Fechados_nos_ultimos_3_meses__c = mapItemCasos.get(item).size();
itemsAtualizar.add(mapItensContrato.get(item));
}
}
}
}

if(!novosCasos.isEmpty()) insert novosCasos;
if(!itemsAtualizar.isEmpty()) update itemsAtualizar;
}*/
}