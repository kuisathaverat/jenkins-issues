JENKINS_VERSION ?= 2.232

.PHONY: help
help:
	@echo "You need to add the following entries to your /etc/host file"
	@echo "127.0.0.1     saml.example.com saml"
	@echo "127.0.0.1     jenkins.example.com jenkins"
	@echo ""
	@echo "Users to access Jenkins:"
	@echo "tesla - password"
	@echo "couri - password"
	@echo "newton - password"
	@echo ""
	@echo "Service URLs:"
	@echo "http://jenkins.example.com:8080"
	@echo "http://saml.example.com/simplesaml"
	@echo ""
	@echo "Targets:"
	@echo ""
	@grep '^## @help' Makefile|cut -d ":" -f 2-3|( (sort|column -s ":" -t) || (sort|tr ":" "\t") || (tr ":" "\t"))

## @help:start:Start the Jenkins instance.
.PHONY: start
start:
	JENKINS_VERSION=$(JENKINS_VERSION) \
	docker-compose up --force-recreate --build --remove-orphans

## @help:stop:Stop the Jenkins instance.
.PHONY: stop
stop:
	-docker-compose down

## @help:clean:Delete the Jenkins docker image an volumes.
.PHONY: clean
clean: stop
	-docker volume rm jenkins_home

## @help:generate-keys:Generates a RSA 4096 keys to connect to the SSH agent.
.PHONY: generate-keys
generate-keys:
	ssh-keygen -t rsa -b 4096 -f ssh-agent/ssh/rsa-key -N ""
	cat ssh-agent/ssh/rsa-key.pub > ssh-agent/ssh/authorized_keys
	echo "you have to add the private key to jenkins/jenkins_home/jenkins.yaml"

## @help:generate-keystore:Generates a RSA 4096 keys and store it on a keystore, you can use it with the SAML plugin.
generate-keystore:
	keytool -genkeypair -alias saml-key -keypass changeme \
	  -keystore jenkins/jenkins_home/saml-key.jks -storepass changeme \
	  -keyalg RSA -keysize 4096 -validity 365 -deststoretype pkcs12
