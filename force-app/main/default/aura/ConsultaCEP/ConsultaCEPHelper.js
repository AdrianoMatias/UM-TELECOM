({
    doConsultaCEP : function(component, event ) {
        var action = component.get("c.consultaCEP");
        action.setParams({
            'idAnaliseViabilidade': component.get("v.recordId")
        });

        action.setCallback(this, function(response){
			var state = response.getState();
			if( state === "SUCCESS" ) {
				var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title"		: 'SUCCESS',
                    "message"	: 'CEP consultado com sucesso!',
                    "type"		: "success"});
                toastEvent.fire(); 
                $A.get('e.force:refreshView').fire();			
				$A.get("e.force:closeQuickAction").fire();

			} else {
				component.set('v.error',true);
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title"		: 'Erro',
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