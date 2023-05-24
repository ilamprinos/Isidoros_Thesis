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

Inside the service.json the microservices are defined.