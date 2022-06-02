# Requirements

Start a trial with Duo Security at https://signup.duo.com. Setup your account, add yourself and your phone number as an end-user, create an application, and use your application's client id, client secret, and api hostname for the required environment variables of this coldbox application.

Learn all about Duo's web sdk requirements at https://duo.com/docs/oauthapi. 

Duo requires that the redirect uri is secure(https). See instructions below.

# Installation

1. git clone https://github.com/webmandman/duocfml-coldbox-example
2. cd duocfml-coldbox-example
3. create .env file with all required environment variables, see .env.example 
    - duo_clientid (get from your application settings @duosecurity.com)
    - duo_clientsecret (get from your application settings @duosecurity.com)
    - duo_apihostname (get from your application settings @duosecurity.com)
    - duo_authredirecturi (this is the url duo will redirect back to your application)
6. box install
7. box server start

# Create a self-signed certificate

When you start the server(step 7) configured for this app Commandbox will serve the site at https://local.duocfmlexample/ but you'll get a browser warning that it is not secure. Follow the following steps to generate a certificate for https://local.duocfmlexample

1. Edit settings in certificate.cnf as you wish or leave it as is.
2. In terminal, make sure you have openssl in your PATH.
3. CD into the root of this application
4. Run this command `openssl req -new -x509 -newkey rsa:2048 -sha256 -nodes -keyout local.duocfmlexample.key -days 3560 -out local.duocfmlexample.crt -config certificate.cnf`
5. This will generate two files, local.duocfmlexample.key and local.duocfmlexample.crt
6. Now add the crt file to your browser keystore or your OS keystore. If you use Chrome to test, then simple add your crt to Trusted Root Certificates via Settings > Privacy > Manage Certs
7. Add the certfile and keyfile settings under SSL in server.json. The location of the files can be anywhere on your OS.

```
"SSL":{
       "enable":true,
       "port":443,
       "certFile":"local.duocfmlexample.crt",
       "keyfile":"local.duocfmlexample.key"
}
```


# Todo

1. Add an actual login form
