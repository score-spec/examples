#!/bin/bash

# setup
if [ ! -f demo-magic.sh ]; then
    curl -LO https://github.com/paxtonhare/demo-magic/raw/master/demo-magic.sh
fi
. demo-magic.sh -d #-n
clear

# Demo setup
make compose-down
rm -rf .score-compose
clear

# Demo #3
pe "echo \"Demo #3 - score-compose (Mocks)\""
pe "code trade-service/score.yaml"
pe "code -g Makefile:47"
pe "make compose-mock-up"
pe "code compose.yaml"
pe "docker ps"
pe "echo http://localhost:8080"
pe "echo http://localhost:9090"

