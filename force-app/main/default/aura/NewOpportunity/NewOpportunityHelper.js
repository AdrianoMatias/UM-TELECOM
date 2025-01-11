({
	cancelar : function(cmp, event, helper) {
        var cancelar = $A.get("e.force:navigateToComponent");        
        cancelar.setParams({
            componentDef: "c:Itens_do_Contrato",
            componentAttributes: {
                recordId : cmp.get("v.recordId")
            }
        });
        cancelar.fire();
	},
    
    salvar : function(cmp, event, helper) {
        var getAccountId = cmp.get('c.getAccountId');
        getAccountId.setParams({
            "recordId": cmp.get("v.recordId")
        });
        
        getAccountId.setCallback(this, $A.getCallback(function(response) {
            if (response.getState() === "SUCCESS") {               
                var newOpportunity = cmp.get("c.newOpportunity");
                newOpportunity.setParams({
                    "name": cmp.find("Name").get("v.value"),
                    "closeDate": cmp.find("closeDate").get("v.value"),
                    "tipo": cmp.find("tipo").get("v.value"),
                    "amount": cmp.find("amount").get("v.value"),
                    "accountId": response.getReturnValue(),
                    "contractId": cmp.get("v.recordId"),
                    "description": cmp.get("v.numeroDoCircuito")
                });
                
                newOpportunity.setCallback(this, $A.getCallback(function(response) {
                    if (response.getState() === "SUCCESS") {       
                        var salvar = $A.get("e.force:navigateToSObject");
                        salvar.setParams({
                            "recordId": response.getReturnValue().Id
                        });
                        salvar.fire();                       
                        
                    } else if (response.getState() === "ERROR") {
                        console.error(response.getError());
                        alert("Verifique os campos e tente novamente.");
                    }
                }));
                $A.enqueueAction(newOpportunity);
                
            } else if (response.getState() === "ERROR") {
                console.error(response.getError());
            }
        }));
        $A.enqueueAction(getAccountId);
    }
})