({
    loadCaso : function( component, event ) {
        var idCaso = component.get("v.recordId");

        var action = component.get("c.getCaso");
        action.setParams({
            "idCaso": idCaso
        });

        action.setCallback( this, function(response) {
            var state = response.getState();

            if( state === "SUCCESS" ) {
                console.log( response.getReturnValue() );
                component.set("v.caso",response.getReturnValue());
                component.set("v.idConta",component.get("v.caso").AccountId);
                
                if( component.get("v.caso").Account != null ) {
                    component.set("v.grupo",component.get("v.caso").Grupo__c);
                }
                this.loadContratos( component, event );
            }
        });

        $A.enqueueAction( action );

    },

    loadContratos : function( component, event ) {
        if( component.get("v.caso") != null ) {
            var idConta = component.get("v.caso").AccountId;
            var action = component.get("c.buscarContratos");

            action.setParams({
                "idConta": idConta
            });
    
            action.setCallback( this, function(response) {
                var state = response.getState();
    
                if( state === "SUCCESS" ) {
                    console.log( response.getReturnValue() );
                    component.set("v.contratos",response.getReturnValue());
                    this.loadItens( component, event );
                }
            });
    
            $A.enqueueAction( action );
        }
    },

    loadItens : function( component, event ) {
        if( component.get("v.caso") != null ) {
            var idConta = component.get("v.caso").AccountId;
            var action = component.get("c.buscarItensContrato");

            action.setParams({
                "idConta": idConta,
                "idContrato": null
            });
    
            action.setCallback( this, function(response) {
                var state = response.getState();
    
                if( state === "SUCCESS" ) {
                    console.log( response.getReturnValue() );
                    component.set("v.itens",response.getReturnValue());
                    component.set("v.itensFiltrados",response.getReturnValue());
                }
            });
    
            $A.enqueueAction( action );
        }
    },

    consultaContratos : function( component, event ) {
        
        var idConta =  event.getSource().get("v.value");
        component.set("v.idConta",idConta)
        var action = component.get("c.buscarContratos");

        action.setParams({
            "idConta": idConta
        });

        action.setCallback( this, function(response) {
            var state = response.getState();

            if( state === "SUCCESS" ) {
                var contratos = response.getReturnValue();
                component.set("v.contratos",contratos);     
                if( contratos.length > 0 ) {
                    component.set("v.grupo",contratos[0].Grupo__c);
                }
            }
        });

        $A.enqueueAction( action );
    },

    consultarItensContrato : function( component, event ) {
        var idConta = component.get("v.idConta");
        var idContrato = event.getSource().get("v.value");

        var action = component.get("c.buscarItensContrato");

        action.setParams({
            'idConta': idConta,
            'idContrato': idContrato
        });

        action.setCallback( this, function(response) {
            var state = response.getState();

            if( state === "SUCCESS" ) {
                console.log( response.getReturnValue() );
                component.set("v.itens",response.getReturnValue());
                component.set("v.itensFiltrados",response.getReturnValue());
            }
        });

        $A.enqueueAction( action );
    },

    consultaItensContratoConta : function( component, event ) {
        var idConta =  event.getSource().get("v.value");
        var action = component.get("c.buscarItensContrato");

        action.setParams({
            "idConta": idConta,
            "idContrato": null
        });

        action.setCallback( this, function(response) {
            var state = response.getState();

            if( state === "SUCCESS" ) {
                console.log( response.getReturnValue() );
                component.set("v.itens",response.getReturnValue());
                component.set("v.itensFiltrados",response.getReturnValue());
            }
        });

        $A.enqueueAction( action );
    },
    
    salvar : function( component, event ) {
        component.set("v.showSpinner", true);
        console.log( 'Entrou' );
        var idItem = component.find("item").get("v.value");
        console.log( idItem );

        var action = component.get("c.salvarCaso");

        action.setParams({
            "idConta": component.get("v.idConta"),
            "idCaso": component.get("v.recordId"),
            "idItem": idItem
        });

        action.setCallback( this, function(response) {
            var state = response.getState();

            if( state === "SUCCESS" ) {
                this.loadCaso( component, event );
                $A.get('e.force:refreshView').fire();
            } else {
                var errors = action.getError();
				if( errors ) {
                    var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
                        "title"     : "Erro",
						"message"   : errors[0].message,
						"duration"  : 5000,
						"type"      : "error"
					});
					toastEvent.fire();
				}
            }
            component.set("v.showSpinner", false);
        });

        $A.enqueueAction( action );
    },

    filtrarItens : function( component, event ) {
        var itens = component.get("v.itens");
        var itensFiltrados = [];
        var palavraChave = component.find("palavraChave").get("v.value");
        console.log( itens );

        if( palavraChave == null ) {
            console.log( 'VAZIO' );
            itensFiltrados = itens;
        } else {            
            for( var i = 0; i < itens.length; i++ ) {
                var item = itens[i];
                var strItem = item.Contrato__r.ContractNumber != null ? item.Contrato__r.ContractNumber : '';
                strItem = strItem + (item.Numero_do_circuito__c != null ? item.Numero_do_circuito__c : '') + '|';
                strItem = strItem + ((item.Produto__r != null && item.Produto__r.Name != null) ? item.Produto__r.Name : '') + '|';
                strItem = strItem + (item.Banda__c != null ? item.Banda__c : '') + '|';
                strItem = strItem + (item.Endereco_de_Destino__c != null ? item.Endereco_de_Destino__c : '') + '|';
                strItem = strItem + (item.Status__c != null ? item.Status__c : '') + '|'
                console.log( strItem + ' == ' + palavraChave );
                if( strItem.includes( palavraChave ) ) {
                    itensFiltrados.push( item );
                }
            }
        }

        component.set("v.itensFiltrados", itensFiltrados);
    }
})