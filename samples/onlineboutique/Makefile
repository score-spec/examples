# Disable all the default make stuff
MAKEFLAGS += --no-builtin-rules
.SUFFIXES:

## Display a list of the documented make targets
.PHONY: help
help:
	@echo Documented Make targets:
	@perl -e 'undef $$/; while (<>) { while ($$_ =~ /## (.*?)(?:\n# .*)*\n.PHONY:\s+(\S+).*/mg) { printf "\033[36m%-30s\033[0m %s\n", $$2, $$1 } }' $(MAKEFILE_LIST) | sort

.PHONY: .FORCE
.FORCE:

.score-compose/state.yaml:
	score-compose init \
		--no-sample \
		--provisioners https://raw.githubusercontent.com/score-spec/community-provisioners/refs/heads/main/service/score-compose/10-service.provisioners.yaml \
		--patch-templates https://raw.githubusercontent.com/score-spec/community-patchers/refs/heads/main/score-compose/unprivileged.tpl

compose.yaml: ad/score.yaml cart/score.yaml currency/score.yaml email/score.yaml payment/score.yaml productcatalog/score.yaml recommendation/score.yaml shipping/score.yaml checkout/score.yaml frontend/score.yaml loadgenerator/score.yaml .score-compose/state.yaml Makefile
	score-compose generate \
		ad/score.yaml \
		cart/score.yaml \
		currency/score.yaml \
		email/score.yaml \
		payment/score.yaml \
		productcatalog/score.yaml \
		recommendation/score.yaml \
		shipping/score.yaml \
		checkout/score.yaml
	score-compose generate \
		frontend/score.yaml \
		--override-property containers.frontend.variables.FRONTEND_MESSAGE="Hello, Score Compose!"
	score-compose generate \
		loadgenerator/score.yaml

## Generate a compose.yaml file from the score spec and launch it.
.PHONY: compose-up
compose-up: compose.yaml
	docker compose up --build -d --remove-orphans
	sleep 5

## Generate a compose.yaml file from the score spec, launch it and test (curl) the exposed frontend container.
.PHONY: compose-test
compose-test: compose-up
	curl $$(score-compose resources get-outputs dns.default#frontend.dns --format '{{ .host }}:8080') | grep "Hello, Score Compose!"

## Delete the containers running via compose down.
.PHONY: compose-down
compose-down:
	docker compose down -v --remove-orphans || true

.score-k8s/state.yaml:
	score-k8s init \
		--no-sample \
		--provisioners https://raw.githubusercontent.com/score-spec/community-provisioners/refs/heads/main/service/score-k8s/10-service.provisioners.yaml \
		--patch-templates https://raw.githubusercontent.com/score-spec/community-patchers/refs/heads/main/score-k8s/unprivileged.tpl

manifests.yaml: ad/score.yaml cart/score.yaml currency/score.yaml email/score.yaml payment/score.yaml productcatalog/score.yaml recommendation/score.yaml shipping/score.yaml checkout/score.yaml frontend/score.yaml loadgenerator/score.yaml .score-k8s/state.yaml Makefile
	score-k8s generate \
		ad/score.yaml \
		cart/score.yaml \
		currency/score.yaml \
		email/score.yaml \
		payment/score.yaml \
		productcatalog/score.yaml \
		recommendation/score.yaml \
		shipping/score.yaml \
		checkout/score.yaml
	score-k8s generate \
		frontend/score.yaml \
		--override-property containers.frontend.variables.FRONTEND_MESSAGE="Hello, Score Kubernetes!"
	score-k8s generate \
		loadgenerator/score.yaml

## Create a local Kind cluster.
.PHONY: kind-create-cluster
kind-create-cluster:
	./scripts/setup-kind-cluster.sh

## Load the local container image in the current Kind cluster.
.PHONY: kind-load-image
kind-load-image:
	kind load docker-image ${CONTAINER_IMAGE}

NAMESPACE ?= default
## Generate a manifests.yaml file from the score spec, deploy it to Kubernetes and wait for the Pods to be Ready.
.PHONY: k8s-up
k8s-up: manifests.yaml
	kubectl apply \
		-f manifests.yaml \
		-n ${NAMESPACE}
	kubectl wait deployments/frontend \
		-n ${NAMESPACE} \
		--for condition=Available \
		--timeout=90s
	kubectl wait pods \
		-n ${NAMESPACE} \
		-l app.kubernetes.io/name=frontend \
		--for condition=Ready \
		--timeout=90s
	sleep 5
	kubectl get pods -n ${NAMESPACE}

## Test the expose frontend app
.PHONY: k8s-test
k8s-test: k8s-up
	curl $$(score-k8s resources get-outputs dns.default#frontend.dns --format '{{ .host }}') | grep "Hello, Score Kubernetes!"

## Delete the deployment of the local container in Kubernetes.
.PHONY: k8s-down
k8s-down:
	kubectl delete \
		-f manifests.yaml \
		-n ${NAMESPACE}
	sleep 5