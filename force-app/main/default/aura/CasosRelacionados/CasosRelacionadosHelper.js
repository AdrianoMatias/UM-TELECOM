({
	consultarCasosRelacionados : function(component, event) {
        var caseId = component.get('v.recordId');
		var action = component.get('c.getCasosRelacionados');
		 action.setParams({
           "recordId": caseId
        })
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
				var data = response.getReturnValue();
				component.set('v.casosRelacionados', data);
                if(data.length > 0){
                    component.set('v.numeroCasos', data.length);
                }
				
            } else {
				var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
						this.toastEvent('Erro!', errors[0].message, 'error');
                    }
                }
			}
			component.set('v.showSpinner', false);
        });
        $A.enqueueAction(action);
	},
    
    toastEvent: function (title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    }
})