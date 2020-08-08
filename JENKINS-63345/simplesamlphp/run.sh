#!/bin/sh
docker stop SimpleSAMLphp
docker rm SimpleSAMLphp
docker build -t kuisat/simplesamlphp .
docker run --rm --name SimpleSAMLphp -d \
  -p 58080:80 \
  -p 58443:443 \
  -e "SIMPLESAMLPHP_ADMIN_PASSWORD=admin" \
  -e  "SIMPLESAMLPHP_SP_ENTITY_ID=http://jenkins.example.com:8080/jenkins/securityRealm/finishLogin" \
  -e "SIMPLESAMLPHP_SP_ASSERTION_CONSUMER_SERVICE=http://jenkins.example.com:8080/jenkins/securityRealm/finishLogin"\
  -e "SIMPLESAMLPHP_SP_SINGLE_LOGOUT_SERVICE=http://jenkins.example.com:8080/jenkins/logout" \
  kuisat/simplesamlphp
  
echo "http://127.0.0.1:58080/simplesaml/module.php/core/frontpage_welcome.php"
echo "http://127.0.0.1:58080/simplesaml/saml2/idp/metadata.php"
