component extends="coldbox.system.RestHandler" {

	property name="DuoClient" inject="DuoClient@duocfml";

	this.allowedMethods = {index='POST',auth='POST',getBaz='GET'};

	function index(event,rc,prc){
		event.getResponse().setData("hello");
	}

	function auth(event, rc, prc){
		
		// 

		
		 


		// 3. DuoClient.healthcheck
		DuoClient.initialize(userid = rc.useremail);

		event.getResponse().setData(DuoClient.getSettings());

	}

	function auth_callback(){

		DuoClient.finalize();
	}

	function debug(event,rc,prc){
		
	}

	

}
