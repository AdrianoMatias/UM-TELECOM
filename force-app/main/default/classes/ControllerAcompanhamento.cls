public with sharing class ControllerAcompanhamento {
    public Date dataInicio {get; set;}
    public Boolean timer {get; set;}
    public Date dataFim {get; set;}
    public String texto {get; set;}
    public Boolean mostrarBlocoMapa {get; set;}
    public List<SelectOption> usuarios {get; set;}
    public String idUsuario {get; set;}
    public List<Geo> geolocalizacoes {get;set;}
    public String geolocalizacoesJson {get;set;}

    public ControllerAcompanhamento() {
        this.dataInicio = calcularDataInicio();
        this.dataFim = calcularDataFim();
        this.mostrarBlocoMapa = false;
        carregarUsuarios();
    }

    //Método para calcular a data inicial da semana.
    public static Date calcularDataInicio() {
        Date data = Date.today().toStartOfWeek();
        return data;
    }

    //Método para calcular a data final da semana.
    public static Date calcularDataFim() {
        Date data = Date.today().toStartOfWeek().addDays(6);
        if(data > Date.today()) {
            data = Date.today();
        }
        return data;
    }

    //Método para carregar os usuários ativos.
    public void carregarUsuarios() {
        List<SelectOption> options = new List<SelectOption>();
        List<User> listaUsuarios = [SELECT Id, Name FROM User WHERE isActive = True];

        if(!listaUsuarios.isEmpty()) {
            for(User usuario : listaUsuarios) {
                options.add(new SelectOption(usuario.Id, usuario.Name));
            }
            this.usuarios = options;
        }
    }

    //Método para buscar todos o compromissos relacionados a conta.
    public void carregarCompromissos(){
        try{
            if(dataInicio > Date.today() || dataFim > Date.today()) {
                ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.ERROR, 'Você está filtrando datas futuras, certifique de colocar datas até no máximo o dia de hoje.');            
                ApexPages.addMessage(message);  
                timerOn();

            }else {
                System.debug(idUsuario);
                List<Event> compromissosAgendados = [SELECT Id, Subject, Status__c, WhatId, WhoId, ActivityDate, Check_in__c, Check_in__r.Geolocalizacao__Longitude__s, Check_in__r.Geolocalizacao__Latitude__s, Check_in__r.Motivo__c, Check_in__r.CreatedDate FROM Event WHERE ActivityDate>=:dataInicio AND ActivityDate<=:dataFim AND OwnerId=:idUsuario];
                System.debug(compromissosAgendados);
                Set<String> ids = new Set<String>();
                geolocalizacoes = new List<Geo>();
                
                for(Event compromisso : compromissosAgendados){
                    System.debug('WhatId >> ' + compromisso.WhatId);
                    if(compromisso.WhatId != null) {
                        ids.add(compromisso.WhatId);
                        
                    } else if(compromisso.WhoId != null) {
                        System.debug('WhoId >> ' + compromisso.WhoId);
                        ids.add(compromisso.WhoId);
                    }
                }
                
                List<Account> listaContas = [SELECT Id, Name, Geolocalizacao__Latitude__s, Geolocalizacao__Longitude__s FROM Account WHERE Id IN :ids];
                Map<String, Account> mapaContas = new Map<String, Account>();
                for(Account conta : listaContas) {
                    mapaContas.put(conta.Id, conta);
                }
                System.debug('Mapa Contas >> ' + mapaContas);
                
                List<Lead> listaLead = [SELECT Id, Name, Status FROM Lead WHERE Id IN :ids AND Status != 'Qualificado'];
                Map<String, Lead> mapaLead = new Map<String, Lead>();
                System.debug('listaLead >> ' + listaLead);
                for(Lead lead : listaLead) {
                    mapaLead.put(lead.Id, lead);
                }
                System.debug('Mapa Lead >> ' + mapaLead);
    
                List<Opportunity> listaOportunidades = [SELECT Id, Name, AccountId FROM Opportunity WHERE Id IN :ids];
                Map<String, Opportunity> mapaOportunidades = new Map<String, Opportunity>();
                Set<String> idsContaGeo = new Set<String>();
                System.debug('listaOportunidades >> ' + listaOportunidades);
                for(Opportunity oportunidade : listaOportunidades) {
                    mapaOportunidades.put(oportunidade.Id, oportunidade);
                    idsContaGeo.add(oportunidade.AccountId);
                }
                List<Account> contasGeo = [SELECT Id, Name, Geolocalizacao__Latitude__s, Geolocalizacao__Longitude__s FROM Account WHERE Id IN :idsContaGeo];
                Map<String, Account> mapaContasGeo = new Map<String, Account>();
                for(Account conta : contasGeo) {
                    mapaContasGeo.put(conta.Id, conta);
                }
                System.debug(mapaContasGeo);
    
                for(Event c : compromissosAgendados){
                    String identificador;
                    System.debug('c.WhatId >> ' + c.WhatId);
                    if(c.WhatId != null) {
                        identificador = c.WhatId;
                    } else if(c.WhoId != null) {
                        identificador = c.WhoId;
                    }

                    if(String.isNotBlank(identificador) && (mapaOportunidades.get(identificador) != null || mapaContas.get(identificador) != null || mapaLead.get(identificador) != null)) {
                        Geo geo = new Geo();
                        System.debug('identificador >> ' + identificador);
                        String site = Site.getBaseUrl();
                        System.debug(site);
                        geo.dataCompromisso = c.ActivityDate.format();
                        geo.status = c.Status__c;
                        geo.link = site+'/'+c.Id;
                        geo.nomeCompromisso = c.Subject;
                        if(c.Check_in__c == null) {
                            geo.cor = 'vermelho';
                            geo.latitude = mapaContas.get(identificador) != null ? mapaContas.get(identificador).Geolocalizacao__Latitude__s : mapaContasGeo.get(mapaOportunidades.get(identificador).AccountId).Geolocalizacao__Latitude__s;
                            geo.longitude = mapaContas.get(identificador) != null ? mapaContas.get(identificador).Geolocalizacao__Longitude__s : mapaContasGeo.get(mapaOportunidades.get(identificador).AccountId).Geolocalizacao__Longitude__s;
        
                        } else {
                            if(mapaLead.get(identificador) == null) {
                                geo.dataCheckIn = c.Check_in__r.CreatedDate.format();
                                if(c.Check_in__c != null && c.ActivityDate <= Date.today()) {
                                    geo.cor = 'amarelo';
                                    geo.latitude = mapaContas.get(identificador) != null ? mapaContas.get(identificador).Geolocalizacao__Latitude__s : mapaContasGeo.get(mapaOportunidades.get(identificador).AccountId).Geolocalizacao__Latitude__s;
                                    geo.longitude = mapaContas.get(identificador) != null ? mapaContas.get(identificador).Geolocalizacao__Longitude__s : mapaContasGeo.get(mapaOportunidades.get(identificador).AccountId).Geolocalizacao__Longitude__s;
                                }
                                if(c.Check_in__c != null && c.Check_in__r.Geolocalizacao__Longitude__s != null && c.Check_in__r.Geolocalizacao__Latitude__s != null) {
                                    geo.cor = 'verde';
                                    geo.latitude = c.Check_in__r.Geolocalizacao__Latitude__s;
                                    geo.longitude = c.Check_in__r.Geolocalizacao__Longitude__s ;
                                }
                                if(c.Check_in__c != null && c.Check_in__r.Motivo__c != null) {
                                    geo.cor = 'azul';
                                    geo.latitude = mapaContas.get(identificador) != null ? mapaContas.get(identificador).Geolocalizacao__Latitude__s : mapaContasGeo.get(mapaOportunidades.get(identificador).AccountId).Geolocalizacao__Latitude__s;
                                    geo.longitude = mapaContas.get(identificador) != null ? mapaContas.get(identificador).Geolocalizacao__Longitude__s : mapaContasGeo.get(mapaOportunidades.get(identificador).AccountId).Geolocalizacao__Longitude__s;
                                }
                            } else {
                                geo.latitude = c.Check_in__r.Geolocalizacao__Latitude__s;
                                geo.longitude = c.Check_in__r.Geolocalizacao__Longitude__s;
                                geo.cor = 'verde';
                            }
                        }
                        if(mapaContas.get(identificador) != null) {
                            geo.identificador = 'Conta';
                            geo.conta = mapaContas.get(identificador).Name;
                            geo.oportunidade = null;
                            geo.statusLead = null;
                            geo.lead = null;
                        } else if(mapaOportunidades.get(identificador) != null) {
                            Opportunity oportunidade = mapaOportunidades.get(identificador);
                            geo.identificador = 'Oportunidade';
                            geo.conta = mapaContasGeo.get(oportunidade.AccountId).Name;
                            geo.oportunidade = oportunidade.Name;
                            geo.statusLead = null;
                            geo.lead = null;
                        } else {
                            geo.identificador = 'Lead';
                            geo.conta = null;
                            geo.oportunidade = null;
                            geo.statusLead = mapaLead.get(identificador).Status;
                            geo.lead = mapaLead.get(identificador).Name;
                        }
                        
                        geolocalizacoes.add(geo);
                        }
                    }
                }
    
                geolocalizacoesJson = JSON.serialize(geolocalizacoes);
                System.debug(geolocalizacoesJson);
                this.mostrarBlocoMapa = true;
            }catch(Exception ex){
            System.debug(ex.getMessage());
            System.debug(ex.getStackTraceString());
        }
    }

    public void clearMessage() {
        ApexPages.getMessages().clear();
    }

    public void timerOn() {
        timer = true;
    }

    public void timerOff() {
        timer = false;
    }

    //Classe com as informações para o marcador do google maps.
    public class Geo {
        public Decimal longitude {get;set;}
        public Decimal latitude {get;set;}
        public String cor {get;set;}
        public String conta {get;set;}
        public String oportunidade {get;set;}
        public String lead {get;set;}
        public String dataCompromisso {get;set;}
        public String nomeCompromisso {get;set;}
        public String dataCheckIn {get;set;}
        public String status {get;set;}
        public String link {get;set;}
        public String identificador {get;set;}
        public String statusLead {get;set;}
    }
}