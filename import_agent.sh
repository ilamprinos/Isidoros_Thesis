export HZN_ORG_ID=issy
export HZN_EXCHANGE_USER_AUTH=admin:FwmlkT5nJmucoBO8xQkQ3ZFr2gFiS5  # use the pw deploy-mgmt-hub.sh displayed
export HZN_EXCHANGE_URL=https://192.168.1.69:3090/v1

export HZN_FSS_CSSURL=https://192.168.1.69:9443/
curl -sSL https://github.com/open-horizon/anax/releases/latest/download/agent-install.sh | bash -s -- -i anax: -k css: -c css: -p IBM/pattern-ibm.helloworld -w '*' -T 120
