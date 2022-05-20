component {

    function configure() {
        // All default settings externalized into this CFC for non-ColdBox reuse
        settings = new models.config.DefaultSettings().configure();
    }

	/**
	* Fired when the module is unloaded
	*
	*function onUnload(){
	*	wirebox.getInstance( "DUO@DuoSDK" ).unload();
	*}
    */


}