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
                    
                    if (row.Contrato__r) {
                        row.ContractNumber = row.Contrato__r.ContractNumber;
                        row.StartDate = row.Contrato__r.StartDate;
                        row.EndDate = row.Contrato__r.EndDate;
                    }                    
                }
                console.log(rows);
                cmp.set('v.mydata', rows);
            } else if (state === "ERROR") {
                console.error(response.getError());
            }
        }));
        
        $A.enqueueAction(action);
    },
    
    edit: function(cmp, event, helper) {
        var edit = $A.get('e.force:navigateToComponent');
        var selectedRows = cmp.get('v.selectedRows');
        
        for (var i = 0; i < selectedRows.length; i++) {
            var contractId = selectedRows[i].Contrato__c;
        }
        
        edit.setParams({
            'componentDef': 'c:Itens_do_Contrato',
            'componentAttributes': {
                'recordId': contractId
            }
        });
        
        edit.fire();
    }
})