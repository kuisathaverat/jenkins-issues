JENKINS_TAG ?= 2.241

export JENKINS_VERSION=$(JENKINS_TAG)

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
	ssh-keygen -t ssh-rsa -b 4096 -f ssh-agent/ssh/rsa-key -N ""
	ssh-keygen -t rsa-sha2-256 -b 4096 -f ssh-agent/ssh/rsa-256-key -N ""
	ssh-keygen -t rsa-sha2-512 -b 4096 -f ssh-agent/ssh/rsa-512-key -N ""
	ssh-keygen -f ssh-agent/ssh/ed25519key -m PEM -t ed25519
	ssh-keygen -f ssh-agent/ssh/dsakey -m PEM -t dsa -b 1024
	ssh-keygen -f ssh-agent/ssh/ecdsakey -m PEM -t ecdsa -b 521
	cat ssh-agent/ssh/rsa-key.pub > ssh-agent/ssh/authorized_keys
	cat ssh-agent/ssh/rsa-256-key.pub >> ssh-agent/ssh/authorized_keys
	cat ssh-agent/ssh/rsa-512-key.pub >> ssh-agent/ssh/authorized_keys
	cat ssh-agent/ssh/ed25519key.pub >> ssh-agent/ssh/authorized_keys
	cat ssh-agent/ssh/dsakey.pub >> ssh-agent/ssh/authorized_keys
	cat ssh-agent/ssh/ecdsakey.pub >> ssh-agent/ssh/authorized_keys
	echo "you have to add the private key to jenkins/jenkins_home/jenkins.yaml"
