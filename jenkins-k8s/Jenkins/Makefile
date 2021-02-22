JENKINS_VERSION ?= 2.257
KIND_VERSION ?= v0.8.1
HELM_VERSION ?= v3.0.2
JENKINS_HELM_CHART_VERSION ?= 2.6.4
BIN_DIR ?= $(CURDIR)/bin
ARCH = $(shell uname)
ARCH_L = $(shell uname|tr '[:upper:]' '[:lower:]')
KUBECTL_VERSION ?= $(shell curl -sSf https://storage.googleapis.com/kubernetes-release/release/stable.txt)
KIND ?= $(BIN_DIR)/kind
KUBECTL ?= $(BIN_DIR)/kubectl
HELM ?= $(BIN_DIR)/helm
CLUSTER_NAME ?= k8s

VENV ?= .venv
PYTHON ?= python3
PIP ?= pip3

JENKINS_PASSWORD ?= "SuP3rP4ssw0rd"
POD_NAME = $(shell kubectl get pods --namespace default -l "app.kubernetes.io/component=jenkins-master" -l "app.kubernetes.io/instance=jenkins" -o jsonpath="{.items[0].metadata.name}")

#.SILENT:

.PHONY: help
help:
	@echo "Targets:"
	@echo ""
	@grep '^## @help' Makefile|cut -d ":" -f 2-3|( (sort|column -s ":" -t) || (sort|tr ":" "\t") || (tr ":" "\t"))

bin:
	mkdir -p $(BIN_DIR)

## @help:bin/kind:Install kind CLI in the selected binary folder.
bin/kind: bin
	curl -sSLo $(BIN_DIR)/kind https://github.com/kubernetes-sigs/kind/releases/download/$(KIND_VERSION)/kind-$(ARCH)-amd64
	chmod +x $(BIN_DIR)/kind

## @help:bin/kubectl:Install kubectl CLI in the selected binary folder.
bin/kubectl: bin
	curl -sSLo $(BIN_DIR)/kubectl https://storage.googleapis.com/kubernetes-release/release/$(KUBECTL_VERSION)/bin/$(ARCH_L)/amd64/kubectl
	chmod +x $(BIN_DIR)/kubectl

## @help:bin/helm:Install Helm CLI in the selected binary folder.
bin/helm: bin
	curl -sSo $(BIN_DIR)/get_helm.sh \
		https://raw.githubusercontent.com/helm/helm/master/scripts/get
	chmod ugo+rx $(BIN_DIR)/get_helm.sh
	HELM_INSTALL_DIR="$(BIN_DIR)" \
		$(BIN_DIR)/get_helm.sh --no-sudo --version $(HELM_VERSION)
	rm $(BIN_DIR)/get_helm.sh
	$(HELM) repo add jenkinsci https://charts.jenkins.io
	$(HELM) repo update

## @help:install-ingress:Install a ingress controller in the K8s cluster.
.PHONY: install-ingress
install-ingress:
	$(KUBECTL) apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
	sleep 10s
	$(KUBECTL) wait --namespace ingress-nginx \
	--for=condition=ready pod \
	--selector=app.kubernetes.io/component=controller \
	--timeout=120s

## @help:create-kind-cluster:Create a kubernetes cluster using Kind.
.PHONY: create-kind-cluster
create-kind-cluster: bin/kubectl bin/kind
	$(KIND) create cluster --name $(CLUSTER_NAME) --config=kind-config.yml
	$(KUBECTL) cluster-info --context kind-$(CLUSTER_NAME)
	$(MAKE) install-ingress

## @help:destroy-cluster:Destroy the kubernetes cluster using Kind.
.PHONY: destroy-cluster
destroy-cluster: bin/kind
	-$(KIND) delete cluster --name $(CLUSTER_NAME)

## @help:start-helm:Deploy the Jenkins using jenkinsci/jenkins helm chart in the kubernetes cluster.
.PHONY: start-helm
start-helm: bin/helm
	$(MAKE) create-helm-secret
	$(MAKE) create-helm-configMap
	$(HELM) install \
		--values helm/helm-values.yml \
		--set master.tag=$(JENKINS_VERSION) \
		--version $(JENKINS_HELM_CHART_VERSION) \
		--wait \
		--timeout 600s \
		jenkins \
		jenkinsci/jenkins

## @help:stop-helm:Undeploy the jenkinsci/jenkins helm chart from the kubernetes cluster.
.PHONY: stop-helm
stop-helm: bin/helm bin/kubectl
	-$(HELM) uninstall jenkins
	-$(KUBECTL) delete secret jenkins-tls
	-$(KUBECTL) delete secret jenkins-password
	-$(KUBECTL) delete -f helm/jenkins-jobs-configmap.yml

## @help:start-jenkins-from-scratch:Run jenkinsci/jenkins helm chart on a k8s cluster, this target make a clean and all the steps needed to run the Docker conatiner on k8s.
.PHONY: start-jenkins-from-scratch
start-jenkins-from-scratch:
	$(MAKE) clean destroy-cluster
	$(MAKE) domain.key
	$(MAKE) create-kind-cluster
	$(MAKE) start-helm

## @help:domain.key:Create a RSA 2048 private key and a x509 certificate.
domain.key:
	printf "[dn]\nCN=jenkins.example.com\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:jenkins.example.com\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth" > domain.ext
	openssl req \
	       -newkey rsa:2048 -nodes -sha256 -keyout domain_private.key \
	       -x509 -days 365 -out domain.crt \
				 -subj '/CN=jenkins.example.com' -extensions EXT -config domain.ext
	openssl rsa -in domain_private.key -out domain.key

## @help:create-helm-secret:Create a K8s secrets the for jenkins password, certificate and the key.
.PHONY: create-helm-secret
create-helm-secret: bin/kubectl
	$(KUBECTL) create secret generic jenkins-password \
		--from-literal=username=jenkins \
		--from-literal=password=$(JENKINS_PASSWORD)
	$(KUBECTL) create secret generic jenkins-tls \
		--from-file=./domain.key \
		--from-file=./domain.crt

## Create a K8s configMap with the jobs used for the Jenkins Helm chart.
.PHONY: create-helm-configMap
create-helm-configMap: bin/kubectl
	$(KUBECTL) apply -f helm/jenkins-jobs-configmap.yml

## @help:clean:Remove the Docker image, the Docker volume, and the generated files.
.PHONY: clean
clean:
	-rm domain.key domain.crt ca.key ca.pem domain.csr domain.ext

## @help:log:Shows the logs of Jenkins.
.PHONY: log
log: bin/kubectl
	$(KUBECTL) logs $(POD_NAME)

## @help:port-forward:Forward the 9443 port of the Jenkins pod to the host.
.PHONY: port-forward
port-forward: bin/kubectl
	kubectl --namespace default port-forward $(POD_NAME) 9443:9443 9080:9080
