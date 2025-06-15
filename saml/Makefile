JENKINS_TAG ?= 2.504.2
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
	@echo "Starting Jenkins with JCasC configuration..."
	@echo "Jenkins URL: http://jenkins.example.com:8080"
	@echo "SAML URL: http://saml.example.com:8888/saml/metadata"
	@echo "add these entries to your /etc/hosts file:"
	@echo "127.0.0.1 jenkins.example.com"
	@echo "127.0.0.1 saml.example.com"
	@echo "Users:"
	@echo "tesla:password [developer,browser]"
	@echo "curie:password [browser]"
	@echo "nobel:password [administrator]"
	docker-compose up --force-recreate --build --remove-orphans;

## @help:stop:Stop the Jenkins instance.
.PHONY: stop
stop:
	-docker-compose down

## @help:clean:Delete the Jenkins docker image an volumes.
.PHONY: clean
clean: stop
	-docker volume rm jenkins_home

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
	j2 --format=env $(JCASC_FILE).j2 -o $(JCASC_FILE) --customize customization.py
