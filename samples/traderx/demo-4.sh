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
rm -rf .score-k8s
clear

# Demo #4
clear
pe "echo \"Demo #4 - score-k8s (Mocks)\""
pe "code trade-service/score.yaml"
pe "code -g Makefile:88"
pe "make k8s-mock-up"
pe "code manifests.yaml"
pe "kubectl get all"
pe "kubectl get pods"
pe "score-k8s resources get-outputs dns.default#ingress.dns --format 'http://{{ .host }}'"
pe "echo https://microcks.127.0.0.1.nip.io/"

