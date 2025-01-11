({
   init: function (cmp, event, helper) {     
       cmp.set('v.mycolumns', [
           {label: 'Nome do Item do Contrato', fieldName: 'Name', type: 'text'},
           {label: 'Número do circuito', fieldName: 'Numero_do_circuito__c', type: 'number'},
           {label: 'Oportunidade', fieldName: 'Opportunity', type: 'text'},
           {label: 'Endereço de entrega do item', fieldName: 'Endereco_de_Destino__c', type: 'text'}
       ]);
       
       helper.getData(cmp, event, helper);
    },
    
    button: function (cmp, event, helper) {
        if (event.getSource().getLocalId() === "prosseguir") {
            helper.prosseguir(cmp, event, helper);
        } else if (event.getSource().getLocalId() === "voltar") {
            helper.voltar(cmp, event, helper);
        }
    },
    
    getNumeroDoCircuito : function (cmp, event, helper) {
        var numeroDoCircuito = [];
        for (var i = 0; i < event.getParam("selectedRows").length; i++) {
            numeroDoCircuito.push("\n" + event.getParam("selectedRows")[i].Name + " - " + event.getParam("selectedRows")[i].Numero_do_circuito__c);           
        }
        cmp.set("v.numeroDoCircuito", numeroDoCircuito.toString());
    }
})