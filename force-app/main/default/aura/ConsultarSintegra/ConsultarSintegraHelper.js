({
    consultarSintegraHelper : function(component, helper, event) {
        component.set("v.mostrarSpinner", true);
        var action = component.get("c.buscarSintegra");
        action.setParams({
            'accId' : component.get("v.recordId")
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            var errors = action.getError();
            if( state === "SUCCESS" ) {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title"	   : "Sucesso!",
                    "message"  : "Consulta realizada com sucesso.",
                    "duration" : 3000,
                    "type"	   : "SUCCESS"
                });
                toastEvent.fire();
                helper.fecharModal(component, helper, event);
                helper.refreshView(component, helper, event);
            } else {
                if (errors) {
					if (errors[0] && errors[0].message) {
						var toastEvent = $A.get("e.force:showToast");
						toastEvent.setParams({
							"title"        : 'Houve um erro ao consultar o Sintegra.',
                            "message"    : errors[0].message,
                            "duration"  : 10000,
							"type"        : "error"});
						toastEvent.fire();
					}
				}
                
                helper.fecharModal(component, helper, event);
            }
            component.set("v.mostrarSpinner", false);
        });
        
        $A.enqueueAction( action );
    },

    fecharModal : function(component, helper, event) {
        $A.get("e.force:closeQuickAction").fire();
    },

    refreshView : function(component, helper, event) {
        window.location.reload(10000);
    },
})