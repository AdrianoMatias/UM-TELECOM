({
   init: function (cmp, event, helper) {     
       cmp.set('v.mycolumns', [
            {label: 'Número do Contrato', fieldName: 'ContractNumber', type: 'text'},
            {label: 'Status Financeiro', fieldName: 'Status_Financeiro__c', type: 'text'},
            {label: 'Data de início', fieldName: 'StartDate', type: 'date'},
            {label: 'Data de término', fieldName: 'EndDate', type: 'date'}
        ]);
       
       helper.getData(cmp, event, helper);
    },
    
    disabledButton: function(cmp, event, helper) {	
        var selectedRows = event.getParam('selectedRows');
        if (selectedRows.length > 0) {
            cmp.set('v.disabledButton', false);
            cmp.set('v.selectedRows', selectedRows);
        } 
    },
    
    button: function (cmp, event, helper) {
        helper.edit(cmp, event, helper);
    }
})