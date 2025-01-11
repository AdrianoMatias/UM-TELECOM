({
    getData : function(cmp, event, helper) {
        var action = cmp.get('c.getContractItems');
        var recordId = cmp.get('v.recordId');
        
        action.setParams({
            'recordId': recordId
        });
        
        action.setCallback(this, $A.getCallback(function (response) {
            if (response.getState() === "SUCCESS") {
                var rows = response.getReturnValue();
                
                for (var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    if (row.Oportunidade__r.Name) {
                        row.Opportunity = row.Oportunidade__r.Name;
                    }
                }
                cmp.set('v.mydata', rows);
                
            } else if (state === "ERROR") {
                console.error(response.getError());
            }
        }));
        
        $A.enqueueAction(action);
    },
    
    prosseguir : function(cmp, event, helper) {
        var prosseguir = $A.get('e.force:navigateToComponent');
        var recordId = cmp.get('v.recordId');
        prosseguir.setParams({
            "componentDef": "c:NewOpportunity",
            'componentAttributes': {
                'recordId': recordId,
                'numeroDoCircuito': cmp.get('v.numeroDoCircuito')
            }
        });
        
        prosseguir.fire();
    },
    
    voltar : function(cmp, event, helper) {
        var action = cmp.get('c.getAccountId');
        var recordId = cmp.get('v.recordId');
        
        action.setParams({
            'recordId': recordId
        });
        
        action.setCallback(this, $A.getCallback(function (response) {
            if (response.getState() === "SUCCESS") {
                var accountId = response.getReturnValue();               
                var voltar = $A.get("e.force:navigateToComponent");
                voltar.setParams({
                    'componentDef': 'c:Aditivo_de_Contrato',
                    'componentAttributes': {
                        'recordId': accountId
                    }
                })
                voltar.fire();
            } else if (state === "ERROR") {
                console.error(response.getError());
            }
        }));
        
        $A.enqueueAction(action);
    }
})