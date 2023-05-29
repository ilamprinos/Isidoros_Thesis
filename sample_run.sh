docker run --network frontend --restart on-failure -p 6379 redis:alpine 
docker run -v db-data:/var/lib/postgresql/data --network backend postgres:9.4 
docker run --network frontend --restart on-failure -p 5000:80 dockersamples/examplevotingapp_vote:before 
docker run --network backend --restart on-failure -p 5001:80 dockersamples/examplevotingapp_result:before 
docker run --network frontend --network backend --restart on-failure dockersamples/examplevotingapp_worker 
docker run -v /var/run/docker.sock:/var/run/docker.sock -p 8080:8080 dockersamples/visualizer:stable 
