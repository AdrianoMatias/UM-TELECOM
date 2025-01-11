({
	visualizarPropostaHlp: function (component) {
		var oppId = component.get('v.recordId');

		var action = component.get('c.visualizarPropostaCTRL');
		action.setParams({
			'oppId' : oppId
		});

		action.setCallback(this, function(response){
			var state = response.getState();

			var state = response.getState();
			console.log(state);
			if( state === "SUCCESS" ) {
			    var eUrl= $A.get("e.force:navigateToSObject");
				    eUrl.setParams({
				      "recordId" : response.getReturnValue()
				    });
				    eUrl.fire();				
					$A.get("e.force:closeQuickAction").fire();
			} else {
                var errors = action.getError();

                if (errors) {
                    if (errors[0] && errors[0].message) {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title"		: 'Houve um erro ao enviar a proposta',
                            "message"	: errors[0].message,
                            "type"		: "error"});
                        toastEvent.fire(); 
					    $A.get('e.force:refreshView').fire();			
						$A.get("e.force:closeQuickAction").fire();
                    }
                }				
			}
		});

		$A.enqueueAction( action );
	}
})