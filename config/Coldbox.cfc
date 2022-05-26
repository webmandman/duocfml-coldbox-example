component{
	/**
	 * Configure the ColdBox App For Production
	 */
	function configure() {
		/**
		 * --------------------------------------------------------------------------
		 * ColdBox Directives
		 * --------------------------------------------------------------------------
		 * Here you can configure ColdBox for operation. Remember tha these directives below
		 * are for PRODUCTION. If you want different settings for other environments make sure
		 * you create the appropriate functions and define the environment in your .env or
		 * in the `environments` struct.
		 */
		coldbox = {
			// Application Setup
			appName                  : "quick test app",
			eventName                : "event",
			// Development Settings
			reinitPassword           : "",
			reinitKey                : "fwreinit",
			handlersIndexAutoReload  : true,
			// Implicit Events
			defaultEvent             : "login:login.index",
			requestStartHandler      : "",
			requestEndHandler        : "",
			applicationStartHandler  : "",
			applicationEndHandler    : "",
			sessionStartHandler      : "",
			sessionEndHandler        : "",
			missingTemplateHandler   : "",
			// Extension Points
			applicationHelper        : "",
			viewsHelper              : "",
			modulesExternalLocation  : [],
			viewsExternalLocation    : "",
			layoutsExternalLocation  : "",
			handlersExternalLocation : "",
			requestContextDecorator  : "",
			controllerDecorator      : "",
			// Error/Exception Handling
			invalidHTTPMethodHandler : "",
			exceptionHandler         : "",
			invalidEventHandler      : "",
			customErrorTemplate      : "/coldbox/system/exceptions/Whoops.cfm",
			// Application Aspects
			handlerCaching           : false,
			eventCaching             : false,
			viewCaching              : false,
			// Will automatically do a mapDirectory() on your `models` for you.
			autoMapModels            : true,
			// Auto converts a json body payload into the RC
			jsonPayloadToRC          : true
		};

		/**
		 * --------------------------------------------------------------------------
		 * Custom Settings
		 * --------------------------------------------------------------------------
		 */
		settings = {};

		/**
		 * --------------------------------------------------------------------------
		 * Environment Detection
		 * --------------------------------------------------------------------------
		 * By default we look in your `.env` file for an `environment` key, if not,
		 * then we look into this structure or if you have a function called `detectEnvironment()`
		 * If you use this setting, then each key is the name of the environment and the value is
		 * the regex patterns to match against cgi.http_host.
		 *
		 * Uncomment to use, but make sure your .env ENVIRONMENT key is also removed.
		 */
		// environments = { development : "localhost,^127\.0\.0\.1" };

		/**
		 * --------------------------------------------------------------------------
		 * Module Loading Directives
		 * --------------------------------------------------------------------------
		 */
		modules = {
			// An array of modules names to load, empty means all of them
			include : [],
			// An array of modules names to NOT load, empty means none
			exclude : []
		};

		/**
		 * --------------------------------------------------------------------------
		 * Application Logging (https://logbox.ortusbooks.com)
		 * --------------------------------------------------------------------------
		 * By Default we log to the console, but you can add many appenders or destinations to log to.
		 * You can also choose the logging level of the root logger, or even the actual appender.
		 */
		logBox = {
			// Define Appenders
			appenders : { coldboxTracer : { class : "coldbox.system.logging.appenders.ConsoleAppender" } },
			// Root Logger
			root      : { levelmax : "INFO", appenders : "*" },
			// Implicit Level Categories
			info      : [ "coldbox.system" ]
		};

		/**
		 * --------------------------------------------------------------------------
		 * Layout Settings
		 * --------------------------------------------------------------------------
		 */
		layoutSettings = { defaultLayout : "", defaultView : "" };

		/**
		 * --------------------------------------------------------------------------
		 * Custom Interception Points
		 * --------------------------------------------------------------------------
		 */
		interceptorSettings = { customInterceptionPoints : [] };

		/**
		 * --------------------------------------------------------------------------
		 * Application Interceptors
		 * --------------------------------------------------------------------------
		 * Remember that the order of declaration is the order they will be registered and fired
		 */
		interceptors = [];

		/**
		 * --------------------------------------------------------------------------
		 * Module Settings
		 * --------------------------------------------------------------------------
		 * Each module has it's own configuration structures, so make sure you follow
		 * the module's instructions on settings.
		 *
		 * Each key is the name of the module:
		 *
		 * myModule = {
		 *
		 * }
		 */
		moduleSettings = {

			duocfml : {
				'clientid' : getSystemSetting('DUO_CLIENTID'),
				'clientsecret': getSystemSetting('DUO_CLIENTSECRET'),
				'apihostname': getSystemSetting('DUO_APIHOSTNAME'),
				'duoauthredirecturi': getSystemSetting('DUO_AUTHREDIRECTURI')
			},

			cbDebugger = {
				// Master switch to enable/disable request tracking into storage facilities.
				enabled : true,
				// Turn the debugger UI on/off by default. You can always enable it via the URL using your debug password
				// Please note that this is not the same as the master switch above
				// The debug mode can be false and the debugger will still collect request tracking
				debugMode : true,
				// The URL password to use to activate it on demand
				debugPassword  : "cb:null",
				// This flag enables/disables the end of request debugger panel docked to the bottem of the page.
				// If you disable i, then the only way to visualize the debugger is via the `/cbdebugger` endpoint
				requestPanelDock : true,
				// Request Tracker Options
				requestTracker : {
					// Track all cbdebugger events, by default this is off, turn on, when actually profiling yourself :) How Meta!
					trackDebuggerEvents          : false,
					// Store the request profilers in heap memory or in cachebox, default is cachebox. Options are: local, cachebox
					storage                      : "cachebox",
					// Which cache region to store the profilers in if storage == cachebox
					cacheName                    : "template",
					// Expand by default the tracker panel or not
					expanded                     : true,
					// Slow request threshold in milliseconds, if execution time is above it, we mark those transactions as red
					slowExecutionThreshold       : 1000,
					// How many tracking profilers to keep in stack: Default is to monitor the last 20 requests
					maxProfilers                 : 50,
					// If enabled, the debugger will monitor the creation time of CFC objects via WireBox
					profileWireBoxObjectCreation : false,
					// Profile model objects annotated with the `profile` annotation
					profileObjects               : false,
					// If enabled, will trace the results of any methods that are being profiled
					traceObjectResults           : false,
					// Profile Custom or Core interception points
					profileInterceptions         : false,
					// By default all interception events are excluded, you must include what you want to profile
					includedInterceptions        : [],
					// Control the execution timers
					executionTimers              : {
						expanded           : true,
						// Slow transaction timers in milliseconds, if execution time of the timer is above it, we mark it
						slowTimerThreshold : 250
					},
					// Control the coldbox info reporting
					coldboxInfo : { expanded : false },
					// Control the http request reporting
					httpRequest : {
						expanded        : false,
						// If enabled, we will profile HTTP Body content, disabled by default as it contains lots of data
						profileHTTPBody : false
					}
				},
				// ColdBox Tracer Appender Messages
				tracers     : { enabled : false, expanded : false },
				// Request Collections Reporting
				collections : {
					// Enable tracking
					enabled      : false,
					// Expanded panel or not
					expanded     : false,
					// How many rows to dump for object collections
					maxQueryRows : 50,
					// Max number to use when dumping objects via the top argument
					maxDumpTop: 5
				},
				// CacheBox Reporting
				cachebox : { enabled : false, expanded : false },
				// Modules Reporting
				modules  : { enabled : true, expanded : false },
				// Quick and QB Reporting
				qb       : {
					enabled   : false,
					expanded  : false,
					// Log the binding parameters
					logParams : true
				},
				// cborm Reporting
				cborm : {
					enabled   : false,
					expanded  : false,
					// Log the binding parameters (requires CBORM 3.2.0+)
					logParams : true
				},
				  // Adobe ColdFusion SQL Collector
				 acfSql : {
					enabled   : false,
					expanded  : false,
					// Log the binding parameters
					logParams : true
				},
				// Async Manager Reporting
				async : {
					enabled : false,
					expanded : false
				}
			}
			
		};

		/**
		 * --------------------------------------------------------------------------
		 * Flash Scope Settings
		 * --------------------------------------------------------------------------
		 * The available scopes are : session, client, cluster, ColdBoxCache, or a full instantiation CFC path
		 */
		flash = {
			scope        : "session",
			properties   : {}, // constructor properties for the flash scope implementation
			inflateToRC  : true, // automatically inflate flash data into the RC scope
			inflateToPRC : false, // automatically inflate flash data into the PRC scope
			autoPurge    : true, // automatically purge flash data for you
			autoSave     : true // automatically save flash scopes at end of a request and on relocations.
		};

		/**
		 * --------------------------------------------------------------------------
		 * App Conventions
		 * --------------------------------------------------------------------------
		 */
		conventions = {
			handlersLocation : "handlers",
			viewsLocation    : "views",
			layoutsLocation  : "layouts",
			modelsLocation   : "models",
			eventAction      : "index"
		};
	}

	/**
	 * Development environment
	 */
	function development() {
		// coldbox.customErrorTemplate = "/coldbox/system/exceptions/BugReport.cfm"; // static bug reports
		coldbox.customErrorTemplate = "/coldbox/system/exceptions/Whoops.cfm"; // interactive bug report
	}
}
