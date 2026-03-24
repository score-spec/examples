#!/bin/bash

# setup
if [ ! -f demo-magic.sh ]; then
    curl -LO https://github.com/paxtonhare/demo-magic/raw/master/demo-magic.sh
fi
. demo-magic.sh -d #-n
clear

# Demo setup
alias k=kubectl
make k8s-down
make compose-down
rm -rf .score-compose
rm -rf .score-k8s
clear

# Demo #3
pe "echo \"Demo #3 - score-compose (Mocks)\""
pe "code trade-service/score.yaml"
pe "code -g Makefile:46"
pe "make compose-mock-up"
pe "code compose.yaml"
pe "docker ps"
pe "echo http://localhost:8080"
pe "echo http://localhost:9090"

# Demo #4
clear
pe "echo \"Demo #4 - score-k8s (Mocks)\""
pe "code trade-service/score.yaml"
pe "code -g Makefile:87"
pe "make k8s-mock-up"
pe "code manifests.yaml"
pe "kubectl get all"
pe "kubectl get pods"
pe "score-k8s resources get-outputs dns.default#ingress.dns --format 'http://{{ .host }}'"
pe "echo https://microcks.127.0.0.1.nip.io/"

