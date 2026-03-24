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

# Demo #0
pe "echo \"Demo #0 - score-k8s\""
pe "make k8s-up"
pe "kubectl get all"
pe "kubectl get pods"
pe "score-k8s resources get-outputs dns.default#ingress.dns"