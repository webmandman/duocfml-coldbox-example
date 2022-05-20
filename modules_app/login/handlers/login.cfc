component extends="coldbox.system.RestHandler" {

	property name="DuoClient" inject="DuoClient@duocfml";

	this.allowedMethods = {index='POST',auth='POST',debug='GET'};

	function index(event,rc,prc){
		event.getResponse().setData("hello");
	}

	function auth(event, rc, prc){
		
		// Step 1, validate username and password
		// Step 2, initialize the duoclient, health check and redirect to auth
		var result = DuoClient.initialize(
			uname = rc.useremail
		);

		event.getResponse().setData(result);

	}

	function auth_callback(event, rc, prc){

		// Step 3
		var result = DuoClient.finalize(
			uname = rc.useremail,
			state = rc.state,
			code = rc.code
		);

		event.getResponse().setData(result);
	}

	function debug(event,rc,prc){
		event.getResponse().setData(DuoClient.getSettings());
	}

	

}
