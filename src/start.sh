#!/bin/bash

REG_TOKEN=$(curl -sX POST -H "Authorization: token ${ACCESS_TOKEN}" https://api.github.com/orgs/"${ORG_NAME}"/actions/runners/registration-token | jq .token --raw-output)

./config.sh --url https://github.com/"${ORG_NAME}" --token "${REG_TOKEN}" --unattended --ephemeral && ./run.sh
