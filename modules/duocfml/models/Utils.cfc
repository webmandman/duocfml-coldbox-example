component accessors="true" {
    
    property name="wirebox" inject="wirebox";
    property name="securelength";

    function init(required numeric secureLength = 36 ){
        
        setSecurelength( secureLength );
        
        return this;
    }

    public string function generateCryptoSecureValue(){
        var secure_random = createObject('java','java.security.SecureRandom');
        var sb = createObject('java','java.lang.StringBuilder');
        while ( sb.length() < getSecurelength() ) {
            sb.append( formatBaseN(secure_random.nextInt(),16) );
        }
        return sb.substring( 0, getSecurelength() );
    }
    
}