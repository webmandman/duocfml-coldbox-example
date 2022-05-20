component accessors="true" singleton {
    
    property name="wirebox" inject="wirebox";
    property name="hyper"   inject="HyperBuilder@Hyper";
    property name="jwt"   inject="jwt@jwtcfml";
    property name="coldbox";

    property name="TokenValidator" inject="DuoTokenValidator@duocfml";
    property name="utils" inject="Utils@duocfml";
    
    property name="settings";

    INVALID_MSG = 'INVALID';
    VALID_MSG = 'VALID';

    /**
	 * Constructor
	 */
    function init(struct settings={}){

        // setState( wirebox.getInstance("State").init( arguments.settings.secureLength ) );

        setSettings( arguments.settings );
        setColdbox( '' );
        setWirebox( '' );

        // Passed in settings?
		if( arguments.settings.count() ) {
			configure();
		}

        return this;
    }

    /**
	 * onDIComplete - only fires if wirebox is present
	 */
    function onDIComplete() {
		// If we have WireBox, see if we can get ColdBox
		if( !isNull( wirebox ) ) {
			// backwards compat with older versions of ColdBox 
			if( wirebox.isColdBoxLinked() ) {
			    setColdBox( wirebox.getColdBox() );
			    setSettings( wirebox.getInstance( 'box:moduleSettings:duocfml' ) );   
			}
		}
		
		configure();
	}

    private void function configure(){

        // If we are not in a coldbox app
        if( isSimpleValue( getColdBox() ) ){
            // manually append (without overwriting) the settings
            // because at this point it could that a non-coldbox/wirebox app
            // already set some settings, all that is left to do is use any 
            // default settings that are not being overwritten.
            settings.append( new config.DefaultSettings().configure(), false );
        }

    }

    public any function initialize(required string uname){

        // var config = DuoConfig.buildConfig( getSettings() );
        // DuoClientService.healthCheck();

        // health check
        // 1. build payload
        // 2. send http request
        var healthcheck_url = 'https://' & getSettings().apihostname & '/oauth/v1/health_check';

        var iat = now();

        session.duo_state = {
            'iat': iat
        }

        var client_assertion_payload = {
            'iss': getSettings().clientid,
            'sub': getSettings().clientid,
            'aud': healthcheck_url,
            'exp': dateadd("n", 5, iat), // auto converted to unix timestamp
            'jti': hash(gettickcount()),
            'iat': iat // auto converted to unix timestamp
        }

        var healthcheck_jwt = jwt.encode(client_assertion_payload, getSettings().clientsecret, 'HS512');

        var healthcheck_params = {
            'client_id': getSettings().clientid,
            'client_assertion': healthcheck_jwt
        };

        var health = hyper
            .setMethod( 'post' )
            .setQueryParams( healthcheck_params )
            .setUrl( healthcheck_url )
            .send();

        if( health.isError() || health.isServerError() ) return "UNHEALTHY";
        
        // authorize
        // 1. build auth url
        // 2. return auth url for application to use

        var authorize_url = 'https://' & getSettings().apihostname & '/oauth/v1/authorize';

        var request_payload = {
            'response_type': 'code',
            'scope': 'openid',
            'exp': dateadd("n", 5, iat),
            'client_id': getSettings().clientid,
            'redirect_uri': getSettings().duoauthredirecturi,
            'state': utils.generateCryptoSecureValue(),
            'duo_uname': arguments.uname,
            'iss': getSettings().clientid,
            'aud': 'https://' & getSettings().apihostname
        };

        session.duo_state.append( {
            'exp': request_payload.exp,
            'state': request_payload.state,
            'duo_uname': arguments.uname
        } );
        
        var authorize_jwt = jwt.encode(request_payload, getSettings().clientsecret, 'HS512');

        var authorize_params = {
            'response_type': 'code',
            'client_id': getSettings().clientid,
            'request': authorize_jwt,
            'redirect_uri': getSettings().duoauthredirecturi,
            'scope': 'openid',
            'nonce': utils.generateCryptoSecureValue()
        }

        session.duo_state.append( {'nonce': authorize_params.nonce});

        var authorize = hyper
            .setMethod( 'post' )
            .setQueryParams( authorize_params )
            .setUrl( authorize_url );

        return authorize.getFullUrl(true);
    }

    public any function finalize(
        required string uname,
        required string state,
        required string code
    ){

        if( session.duo_state.state !== arguments.state ) return "INVALIDSTATE";

        var token_url = 'https://' & getSettings().apihostname & '/oauth/v1/token';
        
        var client_assertion_payload = {
            'iss': getSettings().clientid,
            'sub': getSettings().clientid,
            'aud': 'https://' & getSettings().apihostname & '/oauth/v1/token',
            'exp': dateadd("n", 5, session.duo_state.iat),
            'jti': utils.generateCryptoSecureValue()
        };

        var token_jwt = jwt.encode( client_assertion_payload, getSettings().clientsecret, 'HS512' );

        var token_params = {
            'grant_type': 'authorization_code', 
            'code': arguments.code,
            'redirect_uri': getSettings().duoauthredirecturi,
            'client_assertion_type': 'urn:ietf:params:oauth:client-assertion-type:jwt-bearer',
            'client_assertion': token_jwt,
            'client_id': getSettings().clientid
        }

        var token = hyper
            .setMethod( 'post' )
            .setQueryParams( token_params )
            .setUrl( token_url )
            .send();

        if( token.isError() || token.isServerError() ) return INVALID_MSG;

        var tokenDecoded = jwt.decode(token.json().id_token, getSettings().clientsecret, 'HS512' );

        var validateResult = TokenValidator.validate(
            duo_state = session.duo_state,
            token_payload = {
                'jti': client_assertion_payload.jti,
                'code': arguments.code,
                'type': token_params.client_assertion_type,
                'aud': client_assertion_payload.aud
            },
            token = tokenDecoded,
            clientid = getSettings().clientid,
            apihostname = getSettings().apihostname
        );

        return validateResult;
    }
    
    private any function healthCheck() {

        return 'healthcheck() ran.';
        
    }

    private any function authorize() {

        return 'authorize() ran.';

    }

    private any function token() {

        return 'token() ran.';

    }

}