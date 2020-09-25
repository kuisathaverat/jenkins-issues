JENKINS_TAG ?= 2.257
VENV ?= .venv
PYTHON ?= python3
PIP ?= pip3

export JENKINS_VERSION=$(JENKINS_TAG)

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
	ssh-keygen -t ssh-rsa -b 4096 -f ssh-agent-rsa/ssh/rsa-key -N ""
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
	echo "RSA key user"; \
	read ID_RSA_USER; \
	echo "RSA key password"; \
	read ID_RSA_PASSWORD; \
	source $(VENV)/bin/activate;\
	ID_RSA_USER=$${ID_RSA_USER} \
	ID_RSA=$$(cat ${HOME}/.ssh/id_rsa) \
	ID_RSA_PASSWORD=$${ID_RSA_PASSWORD} \
	PRIVATE_KEY_DSA=$$(cat ssh-agent-dsa/ssh/dsakey) \
	PRIVATE_KEY_RSA=$$(cat ssh-agent-rsa/ssh/rsa-key) \
	PRIVATE_KEY_RSA256=$$(cat ssh-agent-rsa256/ssh/rsa-256-key) \
	PRIVATE_KEY_RSA512=$$(cat ssh-agent-rsa512/ssh/rsa-512-key) \
	PRIVATE_KEY_ED25519=$$(cat ssh-agent-ed25519/ssh/ed25519key) \
	PRIVATE_KEY_EC=$$(cat ssh-agent-ec/ssh/ecdsakey) \
	j2 --format=env $(JCASC_FILE).j2 -o $(JCASC_FILE)
