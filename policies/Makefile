#
# Edit the Makefile variables below as described:
#
# POLICY_NAME      - a name of your choice for your open-horizon policy
# SERVICE_NAME      - a name of your choice for your open-horizon Service
# SERVICE_VERSION   - version (in format N.N.N) for your open-horizon Service
# SERVICE_CONTAINER - your full container ID (registry/repo:version)
# CONTAINER_CREDS   - optional container access creds (registry/repo:user:token)
# ARCH              - an open-horizon architecture (see `hzn architecture`)
#

POLICY_NAME:="mqtt"
SERVICE_NAME:="mqtt"
SERVICE_VERSION:="1.0.0"
SERVICE_CONTAINER:="eclipse-mosquitto:1.6.9"
CONTAINER_CREDS:=
ARCH:="amd64"

publish-service: validate-org
	@ARCH=$(ARCH) \
        SERVICE_NAME="$(SERVICE_NAME)" \
        SERVICE_VERSION="$(SERVICE_VERSION)"\
        SERVICE_CONTAINER="$(SERVICE_CONTAINER)" \
        hzn exchange service publish -O $(CONTAINER_CREDS) -f service.json --pull-image

publish-policy: validate-org
	@ARCH=$(ARCH) \
        SERVICE_NAME="$(SERVICE_NAME)" \
        SERVICE_VERSION="$(SERVICE_VERSION)"\
        POLICY_NAME="$(POLICY_NAME)" \
	hzn exchange policy publish -f business.policy.json

publish-policy-1: validate-org
	@ARCH=$(ARCH) \
        SERVICE_NAME="$(SERVICE_NAME)" \
        SERVICE_VERSION="$(SERVICE_VERSION)"\
        POLICY_NAME="$(POLICY_NAME)" \
	hzn exchange business addpolicy -f business.policy.json issy

register-policy: validate-org
	hzn register --policy "${HZN_ORG_ID}/$(POLICY_NAME)"

validate-org:
	@if [ -z "${HZN_ORG_ID}" ]; \
          then { echo "***** ERROR: \"HZN_ORG_ID\" is not set!"; exit 1; }; \
          else echo "Using Exchange Org ID: \"${HZN_ORG_ID}\""; \
        fi
	@sleep 1

clean:
	-hzn unregister -f
	-hzn exchange policy remove -f "${HZN_ORG_ID}/$(POLICY_NAME)"
	-hzn exchange service remove -f "${HZN_ORG_ID}/$(SERVICE_NAME)_$(SERVICE_VERSION)_$(ARCH)"
	-docker rmi -f "$(SERVICE_CONTAINER)"

.PHONY: publish-service publish-policy register-policy validate-org clean

