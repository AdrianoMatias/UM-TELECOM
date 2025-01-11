({
    retrieveValor : function(component, event, helper) {
        console.log("Starting Integration");
        
        var action = component.get("c.getItemViabilidade");
        action.setParams({
            "viabilityId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                component.set("v.showSpinner", false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title"     : "Sucesso",
                    "message"   : "Item de viabilidade atualizado com sucesso.",
                    "duration"  : 5000,
                    "type"      : "SUCCESS"
                });
                
                toastEvent.fire();
                $A.get("e.force:closeQuickAction").fire();
                $A.get('e.force:refreshView').fire();
            } else {
                component.set("v.showSpinner", false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title"     : "ERRO",
                    "message"   : "Erro! Entre em contato com o administrador do sistema.",
                    "duration"  : 5000,
                    "type"      : "ERROR"
                });
                
                toastEvent.fire();
                $A.get("e.force:closeQuickAction").fire();
            }
        });
        $A.enqueueAction(action);
        console.log("Exiting Integration");
    }
})