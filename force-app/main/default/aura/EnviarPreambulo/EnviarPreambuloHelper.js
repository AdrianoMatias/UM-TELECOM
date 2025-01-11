({
	inicializaLista : function(component, event) {
		var action = component.get("c.listaContato");

		action.setParams({ 
			'idcontrato' : component.get("v.recordId")
		})

		action.setCallback( this, function( response ) {
			var state = response.getState();
			console.log('teste');
			if( state === "SUCCESS" ) {
				console.log('response.getReturnValue() >>'+response.getReturnValue());
				component.set("v.listaContatos", response.getReturnValue());
				component.set("v.possuiContatos", true);
				component.set("v.isModalOpen", true);
			}
		});

		$A.enqueueAction(action);		
	},

	enviarPreambuloHlp: function (component) {
		
		var ids = new Array();
		var getAllId = component.find("boxPack");
		
		if(!Array.isArray(getAllId)){
			if(component.find("boxPack").get("v.value")==true){
				ids.push(selectedList[i].Name);
			}
		}else{
			for (var i = 0; i < getAllId.length; i++) {
				if(component.find("boxPack")[i].get("v.value")==true){
					console.log('component.find("boxPack")[i].Name>>> '+component.find("boxPack")[i].get("v.name"));
					ids.push(component.find("boxPack")[i].get("v.name"));
				}
			}
		}

		var contratoId = component.get('v.recordId');
		console.log('contratoId>>'+contratoId);
		var action = component.get('c.enviarPreambulo');
		action.setParams({
			'contractId' : contratoId,
			'idsContatos' : JSON.stringify(ids)
		});

		action.setCallback(this, function(response){
			var state = response.getState();

			var state = response.getState();
			console.log(state);
			if( state === "SUCCESS" ) {
			    var toastEvent = $A.get("e.force:showToast");
			    toastEvent.setParams({
			        "title": "Sucesso!",
			        "message": "Preâmbulo enviada com sucesso!",
			        "type": "success",
			        "mode": "dismissible"
			    });
			    toastEvent.fire();				
				$A.get('e.force:refreshView').fire();
				$A.get("e.force:closeQuickAction").fire();
			} else {
                var errors = action.getError();

                if (errors) {
                    if (errors[0] && errors[0].message) {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title"		: 'Houve um erro ao enviar o preâmbulo',
                            "message"	: errors[0].message,
                            "type"		: "error"});
                        toastEvent.fire(); 
					    $A.get('e.force:refreshView').fire();			
						$A.get("e.force:closeQuickAction").fire();
                    }
                }				

			}
		});

		$A.enqueueAction(action);
	}
})