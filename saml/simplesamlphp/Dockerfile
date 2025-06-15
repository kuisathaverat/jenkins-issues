#
# Starts a container with a SAML 2.0 IdP (simpleSaml).
#

FROM kristophjunge/test-saml-idp:1.14.15

ADD authsources.php /var/www/simplesamlphp/config/authsources.php
ADD config.php /var/www/simplesamlphp/config/config.php
ADD saml20-idp-hosted.php /var/www/simplesamlphp/metadata/saml20-idp-hosted.php