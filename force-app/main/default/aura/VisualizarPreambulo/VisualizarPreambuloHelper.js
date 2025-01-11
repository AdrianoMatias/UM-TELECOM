({
	visualizarPreambuloHlp: function (component) {
		var contratoId = component.get('v.recordId');

		var action = component.get('c.visualizarPreambulo');
		action.setParams({
			'contractId' : contratoId
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
                            "title"		: 'Houve um erro ao visualizar preambulo',
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