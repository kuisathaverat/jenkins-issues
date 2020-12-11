JENKINS_TAG ?= 2.267
VENV ?= .venv
PYTHON ?= python3
PIP ?= pip3

export JENKINS_VERSION:=$(JENKINS_TAG)

JOBS_ENABLED ?= false
JENKINS_URL = http://localhost:8080

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
	docker-compose build --force-rm --no-cache
	docker-compose start
#	docker-compose start --force-recreate --build --remove-orphans;

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
	JOBS_ENABLED="$(JOBS_ENABLED)" \
	DOCKER_URI="$(DOCKER_URI)" \
	j2 --format=env $(JCASC_FILE).j2 -o $(JCASC_FILE) --customize customization.py

## @help:download-plugin-manager:Download the Jenkins plugin Manager
.PHONY: download-plugin-manager
download-plugin-manager:
	curl -L -o jenkins/jenkins_home/jenkins-plugin-manager.jar https://github.com/jenkinsci/plugin-installation-manager-tool/releases/latest

## @help:download-dependencies:Download the dependencies to build Docker images.
.PHONY: download-dependencies
download-dependencies:
	export JENKINS_URL="https://ci.jenkins.io/job/Core/job/jenkins/job/PR-5049/22/artifact/org/jenkins-ci/main/jenkins-war/2.270-rc30619.ae60983c246a/jenkins-war-2.270-rc30619.ae60983c246a.war"; \
	curl -fsSL -o jenkins/war/jenkins.war $${JENKINS_URL};
	export SSHD_MODULE_URL="https://repo.jenkins-ci.org/incrementals/org/jenkins-ci/modules/sshd/3.0-rc166.9325e5d37325/sshd-3.0-rc166.9325e5d37325.hpi"; \
	curl -fsSL -o jenkins/jenkins_home/plugins/sshd.jpi $${SSHD_MODULE_URL};

## @help:test:Run a set of ssh connection tests againts the SSH Jenkins instance.
.PHONY: test
test:
	@echo "**************************************** Clean ****************************************"
	@rm -fr jenkins-cli.jar workflowLibs
	@echo "**************************************** SSH connection test ****************************************"
	@ssh -p 2222 -i ./rsa-512-key -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null admin@localhost who-am-i
	@echo "**************************************** Jenkins CLI SSH connection test ****************************************"
	@curl -fsSL -O $(JENKINS_URL)/jnlpJars/jenkins-cli.jar
	@java -jar ./jenkins-cli.jar -ssh -user admin -i ./rsa-512-key -s $(JENKINS_URL) who-am-i
	@echo "**************************************** Jenkins Git Server SSH connection test ****************************************"
	@GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i ./rsa-512-key" git clone ssh://admin@localhost:2222/workflowLibs.git
