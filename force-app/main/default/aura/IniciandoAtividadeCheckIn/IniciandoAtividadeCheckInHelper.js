({
	getLocation : function(component, event, helper ) {
		var mapMarker = [];
        if(navigator.geolocation){
			var	marker;
            navigator.geolocation.getCurrentPosition(function(pos) {
				component.set("v.latitude", pos.coords.latitude);
				component.set("v.longitude", pos.coords.longitude);
				mapMarker.push({
					'location': {
						'Latitude' : pos.coords.latitude,
						'Longitude' : pos.coords.longitude
					},
					'icon' : 'utility:location',
				});
				component.set("v.mapMarkers",mapMarker);
				component.set("v.indMapaRend",true);
			});
        }else{
            mobileforce.device.getLocation(function(pos){
				component.set("v.latitude", pos.coords.latitude);
				component.set("v.longitude", pos.coords.longitude);
				mapMarker.push({
					'location': {
						'Latitude' : pos.coords.latitude,
						'Longitude' : pos.coords.longitude
					},
					'icon' : 'utility:location'
				});
				component.set("v.mapMarkers",mapMarker);
				component.set("v.indMapaRend",true);

            });            
        }
	},

	populaMotivo : function(component, event, helper ) {
		var action = component.get("c.listarMotivosCTRL");

		action.setCallback(this,function(response){
            var state = response.getState();
			if(state === 'SUCCESS'){
				var retorno = action.getReturnValue();

                console.log(retorno.lstMotivos);
				component.set("v.LMotivo",retorno.lstMotivos);
			}else{
				var errors = action.getError();
				if( errors ) {
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						"title"     : "Erro",
						"message"   : errors[0].message,
						"duration"  : 5000,
						"type"      : "error"
					});
					toastEvent.fire();
				}
			}
		});
		$A.enqueueAction(action);
	},

    confirmarHLP: function (component, event, helper) {
		
		var idobject = component.get("v.recordId");
		var lat = component.get("v.latitude");
		var lon = component.get("v.longitude");
		//var motivo = component.get("v.motivo");
		//var justif = component.get("v.justificativa");
		
		var action = component.get("c.confirmarIniciandoAtividade");
		
		action.setParams({
			'IdRegist'		: idobject,
			'latitude'		: lat,
			'longitude'		: lon
		});

		action.setCallback(this,function(response){
			var status = response.getState();
			console.log(status);
			if(status==='SUCCESS'){
				var navEvt = $A.get("e.force:navigateToSObject");
					navEvt.setParams({
						"recordId": response.getReturnValue(),
						"slideDevName": "detail"
					});
				navEvt.fire();
			}else{
				var errors = action.getError();
				if( errors ) {
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						"title"     : "Erro",
						"message"   : "Houve um erro ao salvar o checkin. Mensagem: " + errors[0].message,
						"duration"  : 5000,
						"type"      : "error"
					});
					toastEvent.fire();
				}
			}
		});
		$A.enqueueAction(action);
	}
})