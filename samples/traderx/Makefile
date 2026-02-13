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
		--provisioners https://raw.githubusercontent.com/score-spec/community-provisioners/refs/heads/main/service/score-compose/10-service.provisioners.yaml

compose.yaml: account-service/score.yaml database/score.yaml ingress/score.yaml people-service/score.yaml position-service/score.yaml reference-data/score.yaml trade-feed/score.yaml trade-processor/score.yaml trade-service/score.yaml web-frontend/score.yaml .score-compose/state.yaml Makefile
	score-compose generate \
		account-service/score.yaml \
		database/score.yaml \
		people-service/score.yaml \
		position-service/score.yaml \
		reference-data/score.yaml \
		trade-feed/score.yaml \
		trade-processor/score.yaml \
		trade-service/score.yaml \
		web-frontend/score.yaml
	score-compose generate \
		ingress/score.yaml \
		--build 'ingress={"context":"ingress/","tags":["ingress:local"]}'

## Generate a compose.yaml file from the score specs and launch it.
.PHONY: compose-up
compose-up: compose.yaml
	docker compose up --build -d --remove-orphans

## Generate a compose.yaml file from the score spec, launch it and test (curl) the exposed container.
.PHONY: compose-test
compose-test: compose-up
	sleep 5
	curl $$(score-compose resources get-outputs 'dns.default#ingress.dns' --format '{{ .host }}:8080')

## Delete the containers running via compose down.
.PHONY: compose-down
compose-down:
	docker compose down -v --remove-orphans || true

.score-k8s/state.yaml:
	score-k8s init \
		--no-sample \
		--provisioners https://raw.githubusercontent.com/score-spec/community-provisioners/refs/heads/main/service/score-k8s/10-service.provisioners.yaml

manifests.yaml: account-service/score.yaml database/score.yaml ingress/score.yaml people-service/score.yaml position-service/score.yaml reference-data/score.yaml trade-feed/score.yaml trade-processor/score.yaml trade-service/score.yaml web-frontend/score.yaml .score-k8s/state.yaml Makefile
	score-k8s generate \
		account-service/score.yaml \
		database/score.yaml \
		people-service/score.yaml \
		position-service/score.yaml \
		reference-data/score.yaml \
		trade-feed/score.yaml \
		trade-processor/score.yaml \
		trade-service/score.yaml \
		web-frontend/score.yaml
	score-k8s generate \
		ingress/score.yaml \
		--image ingress:local

## Create a local Kind cluster.
.PHONY: kind-create-cluster
kind-create-cluster:
	./scripts/setup-kind-cluster.sh

## Load the local container image in the current Kind cluster.
.PHONY: kind-load-image
kind-load-image:
	kind load docker-image ingress:local

NAMESPACE ?= default
## Generate a manifests.yaml file from the score spec and apply it in Kubernetes.
.PHONY: k8s-up
k8s-up: manifests.yaml
	kubectl apply \
		-f manifests.yaml \
		-n ${NAMESPACE}
	kubectl wait deployments/ingress \
		-n ${NAMESPACE} \
		--for condition=Available \
		--timeout=90s
	kubectl wait pods \
		-n ${NAMESPACE} \
		-l app.kubernetes.io/name=ingress \
		--for condition=Ready \
		--timeout=90s

## Expose the container deployed in Kubernetes via port-forward.
.PHONY: k8s-test
k8s-test: k8s-up
	curl $$(score-k8s resources get-outputs dns.default#ingress.dns --format '{{ .host }}')

## Delete the deployment of the local container in Kubernetes.
.PHONY: k8s-down
k8s-down:
	kubectl delete \
		-f manifests.yaml \
		-n ${NAMESPACE}

## Generate catalog-info.yaml for Backstage.
.PHONY: generate-catalog-info
generate-catalog-info:
	score-k8s init \
		--no-sample \
		--provisioners https://raw.githubusercontent.com/score-spec/community-provisioners/refs/heads/main/service/score-k8s/10-service.provisioners.yaml \
		--patch-templates https://raw.githubusercontent.com/score-spec/community-patchers/refs/heads/main/score-k8s/backstage-catalog-entities.tpl
	score-k8s generate \
		--namespace traderx-demo \
		account-service/score.yaml \
		database/score.yaml \
		people-service/score.yaml \
		position-service/score.yaml \
		reference-data/score.yaml \
		trade-feed/score.yaml \
		trade-processor/score.yaml \
		trade-service/score.yaml \
		web-frontend/score.yaml
		--output catalog-info.yaml
	score-k8s generate \
		--namespace traderx-demo \
		--generate-namespace \
		ingress/score.yaml \
		--image ingress:local \
		--output catalog-info.yaml
	sed 's,$$GITHUB_REPO,score-spec/examples,g' -i catalog-info.yaml
