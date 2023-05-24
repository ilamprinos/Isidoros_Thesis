#Stop the container(s) using the following command:
docker-compose down
#Delete all containers using the following command:
docker rm -f $(docker ps -a -q)
#Delete all volumes using the following command:
docker volume rm $(docker volume ls -q)
#Restart the containers using the following command:
docker-compose up -d


you can use this command to see if you have hide images:
    docker image ls -a
and if you want to remove all of them you can use this command :
    docker rmi -f $(docker image ls -a -q)
you know sometimes images files are stored in hard disk and then it cause low capacity.