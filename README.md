# Requirements

Start a trial with Duo Security at https://signup.duo.com. Setup your account, add yourself and your phone number as an end-user, create an application, and use your application's client id, client secret, and api hostname for the required environment variables of this coldbox application.

Learn all about Duo's web sdk requirements at https://duo.com/docs/oauthapi. 

Duo requires that the redirect uri is secure(https). See instructions below.

# Installation

1. git clone https://github.com/webmandman/duocfml-coldbox-example
2. cd duocfml-coldbox-example
3. create .env file with all required environment variables, look at .env.example to see what is required.
4. box install
5. box server start

# Create a self signed certificate (testing purposes only)

# Todo

1. Add an actual login form
2. Add instructions for self-signed cert
3. Add instructions for self signed certificate
