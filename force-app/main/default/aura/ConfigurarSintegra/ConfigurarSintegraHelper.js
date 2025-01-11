({
	loadAccountConfigs : function( component, event) {
		this.loadConfigs( component, event, "Acc", "v.accountConfigs" );
	},

	loadAccountFields : function( component, event) {
		this.loadFields( component, event, "Account", "v.accountFields" );
	},

	loadTokenSintegra : function( component, event) {
		this.loadTokens( component, event, "v.tokenSintegra" );
	},

	loadTokenMaps : function( component, event) {
		this.loadTokens( component, event, "Maps", "v.tokenGoogleWS" );
	},

	loadTokens : function( component, event, attribute ) {
		var action = component.get("c.getToken");

		action.setCallback( this, function( response ) {
			var state = response.getState();
			console.log(response.getReturnValue() );
			if( state === "SUCCESS" ) {
				component.set(attribute, response.getReturnValue());
			}
		});

		$A.enqueueAction( action );	
	},

	loadConfigs : function( component, event, name, attribute ) {
		var action = component.get("c.getConfigs");

		action.setParams({
			'name' : name
		})

		action.setCallback( this, function( response ) {
			var state = response.getState();
			console.log(response.getReturnValue() );
			if( state === "SUCCESS" ) {
				component.set(attribute, response.getReturnValue());
			}
		});

		$A.enqueueAction( action );		
	},

	loadFields : function( component, event, sObjectName, attribute ) {
		var action = component.get("c.getFields");

		action.setParams({
			'sObjectName' : sObjectName
		})

		action.setCallback( this, function( response ) {
			var state = response.getState();

			if( state === "SUCCESS" ) {
				component.set(attribute, response.getReturnValue());
			}
		});

		$A.enqueueAction( action );		

	},

	onChangeAccountField : function( component, event ) {
		var index = event.getSource().get("v.name");
		var value = event.getSource().get("v.value");
		var accountConfigs = component.get("v.accountConfigs");
		var accountConfig = accountConfigs[index];

		accountConfig.config.To__c = value;
		accountConfigs[index] = accountConfig;
		component.set("v.accountConfigs", accountConfigs);
		console.log( component.get("v.accountConfigs") );
	},

	doSaveAccountConfigs : function( component, event ) {
		var action = component.get("c.saveConfigs");

		action.setParams({
			'configsWrappersStr' : JSON.stringify(component.get("v.accountConfigs"))
		});

		action.setCallback( this, function( response ) {
			var state = response.getState();

			if( state === "SUCCESS" ) {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title"     : "Sucesso!",
                    "message"   : "Configurações salvas com sucesso!",
                    "duration"  : 5000,
                    "type"      : "success"
                });
                toastEvent.fire();
			} else {
				var errors = action.getError();
				if( errors ) {
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						"title"     : "Erro",
						"message"   : "Houve um erro ao salvar as configurações. Mensagem: " + errors[0].message,
						"duration"  : 7000,
						"type"      : "error"
					});
					toastEvent.fire();
				}

			}
		});

		$A.enqueueAction( action );
	},

	doSaveCustomSettingsHLP : function( component, event ) {
		var action = component.get("c.saveToken");

		action.setParams({
			'sintegra' : component.get("v.tokenSintegra")
		});

		action.setCallback( this, function( response ) {
			var state = response.getState();

			if( state === "SUCCESS" ) {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title"     : "Sucesso!",
                    "message"   : "Configurações salvas com sucesso!",
                    "duration"  : 5000,
                    "type"      : "success"
                });
                toastEvent.fire();
			} else {
				var errors = action.getError();
				if( errors ) {
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						"title"     : "Erro",
						"message"   : "Houve um erro ao salvar as configurações. Mensagem: " + errors[0].message,
						"duration"  : 7000,
						"type"      : "error"
					});
					toastEvent.fire();
				}

			}
		});

		$A.enqueueAction( action );
	}
})