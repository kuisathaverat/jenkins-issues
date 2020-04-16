JENKINS_VERSION ?= 2.230

.PHONY: help
help:
	@echo "Targets:"
	@echo ""
	@grep '^## @help' Makefile|cut -d ":" -f 2-3|( (sort|column -s ":" -t) || (sort|tr ":" "\t") || (tr ":" "\t"))

## @help:start:Start the Jenkins instance.
.PHONY: start
start:
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
