({
    retrieveCnpjs : function(component, event, helper) {
        console.log("Starting retrieveCnpjs");
         
        component.set("v.showSpinner", true);
        
        var action = component.get("c.getCNPJs");
        component.set("v.accId", component.get("v.recordId"));
        action.setParams({
            "accId" : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var cnpjsList = response.getReturnValue();
                if(cnpjsList !== null && cnpjsList.length > 0) {
                    component.set("v.cnpjsList", cnpjsList);
                    var cnpj = cnpjsList[0];
                    cnpj = cnpj.substring(0, 19);
                    component.set("v.cnpj", cnpj);
                    component.set("v.showSpinner", false);
                } else {
                    component.set("v.showSpinner", false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title"     : "Aviso",
                        "message"   : "Nenhum CNPJ encontrado. Atualize o nome da empresa e tente novamente.",
                        "duration"  : 7000,
                        "type"      : "warning"
                    });
                    toastEvent.fire();
                    
                    $A.get("e.force:closeQuickAction").fire();
                }
            }
        });
        $A.enqueueAction(action);
        
        console.log("Exiting retrieveCnpjs");
    },
    
    selecionarHlp : function(component, event, helper) {
        console.log("Starting selecionarHlp");
        
        var action = component.get("c.selecionarCNPJ");
        action.setParams({
            "cnpjParam"  : component.get("v.cnpj"),
            "accIdParam" : component.get("v.accId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title"     : "Success!",
                    "message"   : "Dados atualizados com sucesso!",
                    "duration"  : 5000,
                    "type"      : "success"
                });
                toastEvent.fire();
            } else {
                var errors = action.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": 'ERRO!',
                            "message": errors[0].message,
                            "type": "error"
                        });
                        toastEvent.fire();
                    }
                }
            }
            
            $A.get("e.force:closeQuickAction").fire();
            $A.get('e.force:refreshView').fire();
        });
        $A.enqueueAction(action);
        
        console.log("Exiting selecionarHlp");
    }
})