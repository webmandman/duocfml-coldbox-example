# Requirements

Start a trial with Duo Security at https://signup.duo.com. Setup your account, add yourself and your phone number as an end-user, create an application, and use your application's client id, client secret, and api hostname for the required environment variables of this coldbox application.

Learn all about Duo's web sdk requirements at https://duo.com/docs/oauthapi. 

Duo requires that the redirect uri is secure(https). See instructions below.

# Installation

1. git clone https://github.com/webmandman/duocfml-coldbox-example
2. cd duocfml-coldbox-example
3. create .env file with all required environment variables
    - duo_clientid
    - duo_clientsecret
    - duo_apihostname
    - duo_authredirecturi
4. Create a self signed certificate
    - adsfafd
6. box install
7. box server start

# Todo

1. Add an actual login form
2. Add instructions for self-signed cert
3. Add instructions for self signed certificate
