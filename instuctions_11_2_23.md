https://open-horizon.github.io/docs/mgmt-hub/docs/index.html
1. First of all I install management-hub with the script ./deploy-mgmt-hub.sh (if for some reason it was already installed flag "-SP"). If we want external edge devices 
we need to make sure they can communicate with the management hug. So:
    export HZN_LISTEN_IP=<external-ip>(192.168.1.14)   # an IP address the edge devices can reach
    export HZN_TRANSPORT=https
    ./deploy-mgmt-hub.sh
These commands should be run before running ./deploy-mgmt-hub.sh -SP (if it needs to be run).
Also in the script there is field that defines the name of the organization that is created("myorg" in the original script).
I might need to change that.

2. After this script is done I should run the ./test-mgmt-hub.sh -c <config-file>  to test it all(15/2 everything OK)
    2.1 The config-file is a file that contains the Automatically generated these passwords/tokens from the output of the first script.(test_config.sh).

3. Something to remember in the ./deploy-mgmt-hub.sh the flag  -A(E) -->  Do not install the horizon agent package. (It will still install the horizon-cli package.) 
Without this flag, it will install and register the horizon agent (as well as all of the management hub services).I need to read the flags to see what I need.
-A    Do not install the horizon agent package. (It will still install the horizon-cli package.) Without this flag, it will install and register the horizon agent (as well as all of the management hub services).
-E    Skip loading the horizon example services, policies, and patterns.


4. Follow the commands in useful_commands.sh to get somewhat familiar with hzn.

                                            ################ ADD MORE EDGE DEVICES ##############

If the ./deploy-mgmt-hub.sh has already run we have to stop it(stop the mgmt hub).
./deploy-mgmt-hub.sh -SP   # stop the mgmt hub services and delete the data.
export HZN_LISTEN_IP=192.168.1.14   # an IP address the edge devices can reach (<external-ip>)
export HZN_TRANSPORT=https
./deploy-mgmt-hub.sh

5. On its new node we want to add, we run the script import_agent.sh

6. After the script is finished on the mgmt-hub device we make sure that the node was added:  hzn exchange node list

7. I then continue with the instuctions from https://github.com/edgexfoundry-holding/open-horizon-integration/blob/main/hub/04-configure-anax.md

8. On the agent I run the commands from run_on_agent_to_add_node.sh
    

9. Next we will publish an example EdgeX service to the openhorizon hub: 
        git clone https://github.com/edgexfoundry-holding/open-horizon-integration.git
        cd ./open-horizon-integration
        cd hub/oh
        envsubst '${HZN_LISTEN_IP}' < config.json.template > config.json
        
        This file (config.json) is modified and I have it localy. 

10. hzn key create -l 4096 myorg lamprinos@mail.com(this step has already been run in the ./deploy-mgmt-hub.sh and should not be run 
again):
    Which should have an output like: Created keys:
                                            /root/.hzn/keys/service.private.key
                                            /root/.hzn/keys/service.public.pem

11. Publish the service definition to the exchange. The command will run for a bit, and will pull each container from the container     
    registry so that it can obtain the container digest. The digest is recorded in the published service definition. This example 
    service is composed of several EdgeX microservices.
    
    cmd: 
        hzn exchange service publish -P -f hub/configs/service.json

    Check if it worked: hzn exchange service list
    Desired output:  
        [
        "myorg/com.github.joewxboy.horizon.edgex_1.0.1_amd64"
        ]

12. Next, publish a pattern to the exchange. A pattern is the easiest way for a node to indicate 
    which services it should run. Policy based service deployment is also supported, but is slightly 
    more complex to setup. In this pattern the original was changed in order to have the right org("${HZN_ORG_ID}") instead of the 
    original "testorg".

        hzn exchange pattern publish -f hub/configs/pattern.json


13. Now check to ensure the pattern is available:

        hzn exchange pattern list

        It should respond with:

        [
        "myorg/pattern-edgex-amd64"
        ]

----------->From this point forward we run everythingin the agent.
Last, let's register the openhorizon agent with the hub, so that it will begin executing the service.
To prepare the node, manually create the volumes that will be used by the edge services:
14. docker volume create db-data
    docker volume create log-data
    docker volume create consul-data
    docker volume create consul-config 

    (Optiinal) docker volume list (veirfy the volumes were created)

15. Manually setup and open the permissions on the host directories being bound:
    mkdir -p /var/run/edgex/logs
    mkdir -p /var/run/edgex/data
    mkdir -p /var/run/edgex/consul/data
    mkdir -p /var/run/edgex/consul/config
    mkdir -p /root/res
    chmod -R a+rwx /var/run/edgex
    chmod -R a+rwx /root/res

16. Copy the configuration files from the res folder in this repository to the x folder on the host.
    Now register the node:
    hzn register -p pattern-edgex-amd64 --policy node.policy (maybe it needs hzn unregister first and I need to copy the node.policy
    from the /hub/configs directory from 
    the hub device: hub repo  https://github.com/edgexfoundry-holding/open-horizon-integration.git)

17. 
    To confirm that your edge node is registered for the pattern, run:
    hzn node list

    and confirm that the response shows your node ID. and that you're configured for the testorg/pattern-edgex-amd64 pattern.
    hzn agreement list or for the verbose details: 
    hzn eventlog list

    Then I should run "docker ps" to make sure the containers are running(it might take a couple of minutes for them to show). 
------------->



18. https://github.com/edgexfoundry-holding/open-horizon-integration/blob/main/hub/05-view-device-data.md

19. Let's open a shell to the environment that is running the Horizon Agent (Anax). To confirm that it is the correct location and Horizon is operating properly, check the version:
    hzn version

20. Check to ensure that your Edge Node is properly configured:
    hzn node list | jq '.configstate'

21. Then check to ensure that the com.github.joewxboy.horizon.edgex Service is running:
    hzn service list <mark >(for in my setup it does not because for some reason the node is running in the same machine as the hub)</mark>

22. And last, let's ask Docker to show us the running images contained within that Service:
    docker ps

                                                    VIEW THE DATA

23. Now that you've verified that Open Horizon has deployed EXF, it's time to use EXF to view the events and readings that the Random Integer Device Service is sending.
    According to the EXF documentation, you could request the URL for Core Data, but that will show you all of the events and readings since the Service was started, which could get quite long (run on the egde node):
    curl --silent http://localhost:48080/api/v1/event | jq

    We can further limit the results with jq to show us only the most recent reading:

    curl --silent http://localhost:48080/api/v1/event | jq .[0].readings[0].value
    
    Core Metadata will show us the properties of the Device:

    curl --silent http://localhost:48081/api/v1/device | jq .[0].service

24. I better check the Modify the Device Settings. https://github.com/edgexfoundry-holding/open-horizon-integration/blob/main/hub/05-view-device-data.md

25. 