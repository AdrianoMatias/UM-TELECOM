({
	getData : function(component, event) {
		var action = component.get("c.getDataDocument");
		action.setParams({
			'idContrato' : component.get('v.recordId')
		});
		
		action.setCallback( this, function( response ) {
			var state = response.getState();
		
			if( state === "SUCCESS" ) {
				var retorno = response.getReturnValue();
				if(retorno.hasContent == "true"){
					component.set("v.idFile",retorno.idFile);
		        	component.set("v.nameFile",retorno.nameFile);

		        	component.find('enviarContratosPadroes').set('v.checked', false);
		        	if(retorno.enviarContratosPadroes == "true"){
		        		component.find('enviarContratosPadroes').set('v.checked', true);
		        	}

		        	component.set("v.showFileCard",true);
	        	} else {
	        		component.set("v.showFileCard",false);
	        	}
			} else {
                var errors = action.getError();

                if (errors) {
                    if (errors[0] && errors[0].message) {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title"		: 'Houve um erro ao buscar as informações.',
                            "message"	: errors[0].message,
                            "type"		: "error"});
                        toastEvent.fire(); 
                    }
                }				
	    	}
		});
		
		$A.enqueueAction(action);
	},

	updateContractHLP : function(component, event) {
		// This will contain the List of File uploaded data and status
        var uploadedFiles = event.getParam("files");
        if(uploadedFiles.length){
	        for (var i = uploadedFiles.length - 1; i >= 0; i--) {
	        	var idFile = uploadedFiles[i].documentId;
	        	var nameFile = uploadedFiles[i].name;
	        	
	        	component.set("v.idFile","");
	        	component.set("v.nameFile","");

	        	component.set("v.idFile",idFile);
	        	component.set("v.nameFile",nameFile);
	        	component.set("v.showFileCard",true);

	        	var action = component.get("c.updateContract");
				action.setParams({
					'idFile' : idFile,
					'nameFile' : nameFile,
					'idContrato' : component.get("v.recordId")
				});
				
				action.setCallback( this, function( response ) { });
				
				$A.enqueueAction( action );
	        }
        } else {
        	var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title"		: 'Houve um erro ao salvar o contrato.',
                "message"	: 'Tente novamente.',
                "type"		: "error"});
            toastEvent.fire(); 
        }
	},

	removeFile : function(component, event) {
		var action = component.get("c.deleteDocument");
		action.setParams({
			'idContrato' : component.get('v.recordId')
		});
		
		action.setCallback( this, function( response ) {
			var state = response.getState();
		
			if( state === "SUCCESS" ) {
				component.set("v.idFile","");
	        	component.set("v.nameFile","");
				component.set("v.showFileCard",false);
			} else {
	        	var errors = action.getError();

                if (errors) {
                    if (errors[0] && errors[0].message) {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title"		: 'Houve um erro ao buscar as informações.',
                            "message"	: errors[0].message,
                            "type"		: "error"});
                        toastEvent.fire(); 
                    }
                }
	        }
		});
		
		$A.enqueueAction(action);
	},

	marcarEnviarContratosPadroes : function(component, event) {
		var action = component.get("c.marcarEnvio");
		action.setParams({
			'idContrato' : component.get('v.recordId'),
			'checked' : component.find('enviarContratosPadroes').get('v.checked')
		});
		
		action.setCallback( this, function( response ) {
			var state = response.getState();
			if( state === "SUCCESS" ) {}
		});
		
		$A.enqueueAction(action);
	}
})