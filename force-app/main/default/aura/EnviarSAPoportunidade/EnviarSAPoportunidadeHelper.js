({
	EnviarSAPHelper: function (component, event) {
		
		var action = component.get('c.getEnvioSAPContrato');
		action.setParams({
			'oppId' : component.get('v.recordId')
		});

		action.setCallback(this, function(response){
			var state = response.getState();
			var state = response.getState();
			console.log(state);
			if( state === "SUCCESS" ) {
			    var toastEvent = $A.get("e.force:showToast");
			    toastEvent.setParams({
			        "title": "Sucesso!",
			        "message": "Contrato enviado ao SAP com sucesso!",
			        "type": "success",
			        "mode": "dismissible"
			    });
			    toastEvent.fire();				
				$A.get('e.force:refreshView').fire();
				$A.get("e.force:closeQuickAction").fire();
			} else {
                var errors = action.getError();

                if (errors) {
                    if (errors[0] && errors[0].message) {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title"		: 'Houve um erro no envio ao SAP',
                            "message"	: errors[0].message,
                            "type"		: "error"});
                        toastEvent.fire(); 
					    $A.get('e.force:refreshView').fire();			
						$A.get("e.force:closeQuickAction").fire();
                    }
                }				
			}
		});

		$A.enqueueAction(action);
	}
})