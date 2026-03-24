#!/bin/bash

# setup
if [ ! -f demo-magic.sh ]; then
    curl -LO https://github.com/paxtonhare/demo-magic/raw/master/demo-magic.sh
fi
. demo-magic.sh -d #-n
clear

# Demo #1
pe "echo \"Demo #1 - score-k8s\""
pe "code trade-service/score.yaml"
pe "code -g Makefile:72"
pe "code manifests.yaml"
pe "kubectl get all"
pe "kubectl get pods"
pe "score-k8s resources get-outputs dns.default#ingress.dns --format 'http://{{ .host }}'"

# Demo #2
pe "echo \"Demo #2 - score-compose\""
clear
pe "code trade-service/score.yaml"
pe "code -g Makefile:21"
pe "make compose-up"
pe "code compose.yaml"
pe "docker ps"
pe "echo http://localhost:8080"

