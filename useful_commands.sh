HORIZON AGENT COMMANDS
View the status of your edge node: hzn node list
View the agreement that was made to run the helloworld edge service example: hzn agreement list
View the edge service containers that Horizon started: docker ps
View the log of the helloworld edge service: hzn service log -f ibm.helloworld
View the Horizon configuration: cat /etc/default/horizon
View the Horizon agent daemon status: systemctl status horizon
View the steps performed in the agreement negotiation process: hzn eventlog list
View the node policy that was set that caused the helloworld service to deployed: hzn policy list

HORIZON EXCHANGE COMMANDS
HZN_ORG_ID and HZN_EXCHANGE_USER_AUTH as instructed in the output of deploy-mgmt-hub.sh.
View all of the hzn exchange sub-commands available: hzn exchange --help
View the example edge services: hzn exchange service list IBM/
View the example patterns: hzn exchange pattern list IBM/
View the example deployment policies: hzn exchange deployment listpolicy
Verify the policy matching that resulted in the helloworld service being deployed: hzn deploycheck all -b policy-ibm.helloworld_1.0.0
View your node: hzn exchange node list
View your user in your org: hzn exchange user list
Use the verbose flag to view the exchange REST APIs the hzn command calls, for example: hzn exchange user list -v
View the public files in CSS that agent-install.sh can use to install/register the agent on edge nodes: hzn mms -o IBM -u "$HZN_ORG_ID/$HZN_EXCHANGE_USER_AUTH" object list -d -t agent_files