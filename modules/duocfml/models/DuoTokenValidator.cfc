component accessors="true" {
    
    property name="wirebox" inject="wirebox";

    INVALID_MSG = 'INVALID';
    VALID_MSG = 'VALID';

    function init(required numeric secureLength = 36 ){        
        return this;
    }

    public string function validate(
        required struct duo_state,
        required struct token_payload,
        required struct token,
        required string clientid,
        required string apihostname
    ){

        // https://openid.net/specs/openid-connect-core-1_0.html#IDTokenValidation

        // Rule #2
        if( token.iss !== token_payload.aud ) return INVALID_MSG;

        // Rule #3
        // aud could either be a string or an array of strings
        var isAudValid = true;
        if( isArray(token.aud) ){
            for (a in token.aud) {
                if( a !== arguments.clientid ) isAudValid = false;
            }
            if( !isAudValid ) return INVALID_MSG;
        }else if( isSimpleValue( token.aud ) ){
            if( token.aud !== arguments.clientid ) return INVALID_MSG;
        }else{
            return INVALID_MSG;
        }

        // Rule #4 and #5
        if( token.keyExists('azp') and token.azp !== arguments.clientid ){
            return INVALID_MSG;
        }        
        
        // Rule #9
        var unix_current_time = left(GetTickCount(), len(GetTickCount())-3);
        if( duo_state.iat > unix_current_time ) return INVALID_MSG;

        // Rule #11
        if( duo_state.nonce !== token.nonce ) return INVALID_MSG;
        
        return VALID_MSG;
    }
    
}