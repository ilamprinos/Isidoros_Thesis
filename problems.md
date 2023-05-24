Problems I encountered:
    1. For the error "Release file for https://download.docker.com/linux/ubuntu/dists/bionic/InRelease is not valid yet (invalid for another 1d 2h 57min 55s). Updates 
    for this repository will not be applied in ..." 
    (sudo hwclock --hctosys or https://docs.docker.com/config/daemon/systemd/(restrt docker))
    apt-get -o Acquire::Check-Valid-Until=false -o Acquire::Check-Date=false update

2. bash: ./deploy-mgmt-hub.sh: /bin/bash^M: bad interpreter: No such file or directory
solution:  sed -i -e 's/\r$//' deploy-mgmt-hub.sh
The problem is created when importing a script from windows. 


3. Waiting for the exchange..............................
 Error: can not reach the exchange at https://192.168.1.19:3090/v1 (tried for 60 seconds): curl: (7) Failed to connect to 192.168.1.19 port 3090: Connection refused.
It seems that there is an issue with docker. The containers are permanently stack on restarting I will leave it and wait for a while see
if the situation changes.

solution: 1)  ./deploy-mgmt-hub.sh -SP 
            and run again :  ./deploy-mgmt-hub.sh (Probably a network issue.).
            Or restart and run again without stoping. Or just run again. Some kind of network issue indeed.
          2) rm docker : apt-get remove -y docker-ce docker-ce-cli containerd.io

          3) docker logs --tail 50 --follow --timestamps exchange-api (check docker logs)
          the containers keep restarting 

4. On the agent if I delete everything and it shows some problem when trying again, I should restart the VM. 

5. /usr/bin/mandb: can't write to /var/cache/man/1218: No space left on device
/usr/bin/mandb: can't create index cache /var/cache/man/1218: No space left on device
Solution: sudo apt-get --simulate purge $(dpkg-query -Wf '${Package;-40}${Priority}\n' | awk '$2 ~ /optional|extra/ { print $1 }')
            apt --fix-broken install
            apt-get install curl
            apt-get install gnupg2
            apt-get update
            apt install software-properties-common

(The -- simulate flag lets you check without actually removing)