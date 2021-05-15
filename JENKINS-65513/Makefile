JENKINS_TAG ?= 2.277.4-lts-jdk11

VENV ?= .venv
PYTHON ?= python3
PIP ?= pip3

export JENKINS_VERSION:=$(JENKINS_TAG)

.PHONY: help
help:
	@echo "Targets:"
	@echo "you need to add the entry '127.0.0.1 jenkins.example.com' to yout /etc/hosts file"
	@echo "http://jenkins.example.com:8080 should be the Jenkins URL"
	@echo ""
	@grep '^## @help' Makefile|cut -d ":" -f 2-3|( (sort|column -s ":" -t) || (sort|tr ":" "\t") || (tr ":" "\t"))

## @help:start:Start the Jenkins instance.
.PHONY: start
start: gen-jcasc-file
	docker-compose up --force-recreate --build --remove-orphans;

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
	ssh-keygen -t ssh-rsa -b 4096 -f ssh-agent-rsa/ssh/rsa-key -N "" -m pem
	openssl rsa -DES-EDE3-CBC -in ssh-agent-rsa/ssh/rsa-key -out ssh-agent-rsa/ssh/rsa-key-des-ede3-cbc -passout pass:password
	openssl rsa -DES-CBC -in ssh-agent-rsa/ssh/rsa-key -out ssh-agent-rsa/ssh/rsa-key-des-cbc -passout pass:password
	openssl rsa -AES-128-CBC -in ssh-agent-rsa/ssh/rsa-key -out ssh-agent-rsa/ssh/rsa-key-aes128-cbc -passout pass:password
	openssl rsa -AES-256-CBC -in ssh-agent-rsa/ssh/rsa-key -out ssh-agent-rsa/ssh/rsa-key-aes256-cbc -passout pass:password
	openssl rsa -AES-192-CBC -in ssh-agent-rsa/ssh/rsa-key -out ssh-agent-rsa/ssh/rsa-key-aes192-cbc -passout pass:password
	ssh-keygen -t rsa-sha2-256 -b 4096 -f ssh-agent-rsa256/ssh/rsa-256-key -N ""
	ssh-keygen -t rsa-sha2-512 -b 4096 -f ssh-agent-rsa512/ssh/rsa-512-key -N ""
	ssh-keygen -f ssh-agent-ed25519/ssh/ed25519key -m PEM -t ed25519 -N ""
	ssh-keygen -f ssh-agent-dsa/ssh/dsakey -m PEM -t dsa -b 1024 -N ""
	ssh-keygen -f ssh-agent-ec/ssh/ecdsakey -m PEM -t ecdsa -b 521 -N ""
	cat ssh-agent-rsa/ssh/rsa-key.pub > ssh-agent-rsa/ssh/authorized_keys
	cat ssh-agent-rsa256/ssh/rsa-256-key.pub >> ssh-agent-rsa256/ssh/authorized_keys
	cat ssh-agent-rsa512/ssh/rsa-512-key.pub >> ssh-agent-rsa512/ssh/authorized_keys
	cat ssh-agent-ed25519/ssh/ed25519key.pub >> ssh-agent-ed25519/ssh/authorized_keys
	cat ssh-agent-dsa/ssh/dsakey.pub >> ssh-agent-dsa/ssh/authorized_keys
	cat ssh-agent-ec/ssh/ecdsakey.pub >> ssh-agent-ec/ssh/authorized_keys
	cp -R ssh-agent-rsa/ssh ssh-agent-ubuntu-14.04/ssh
	cp -R ssh-agent-rsa/ssh ssh-agent-ubuntu-16.04/ssh
	cp -R ssh-agent-rsa/ssh ssh-agent-ubuntu-18.04/ssh
	cp -R ssh-agent-rsa/ssh ssh-agent-ubuntu-20.04/ssh
	cp -R ssh-agent-rsa/ssh ssh-agent-host-dsa/ssh
	cp -R ssh-agent-rsa/ssh ssh-agent-host-ec/ssh
	cp -R ssh-agent-rsa/ssh ssh-agent-host-ed/ssh
	cp -R ssh-agent-rsa/ssh ssh-agent-host-rsa/ssh
	$(MAKE) gen-jcasc-file

## @help:virtualenv:Create a Python virtual environment.
.PHONY: virtualenv
virtualenv:
	$(PYTHON) --version
	test -d $(VENV) || virtualenv -q --python=$(PYTHON) $(VENV);\
	source $(VENV)/bin/activate;\
	$(PIP) install -r requirements.txt;

## @help:gen-jcasc-file:Generates the JCasC file with the SSH Privatekey
.PHONY: gen-jcasc-file
gen-jcasc-file: JCASC_FILE="./jenkins/jenkins_home/jenkins.yaml"
gen-jcasc-file: virtualenv
	source $(VENV)/bin/activate;\
	DOCKER_URI="$(DOCKER_URI)" \
	j2 --format=env "$(JCASC_FILE).j2" -o "$(JCASC_FILE)" --customize customization.py

## @help:download-plugin-manager:Download the Jenkins plugin Manager
.PHONY: download-plugin-manager
download-plugin-manager:
	curl -L -o jenkins/jenkins_home/jenkins-plugin-manager.jar https://github.com/jenkinsci/plugin-installation-manager-tool/releases/latest
