#!/bin/bash

docker build -t kotlin-jdk -f kotlinJDK.docker .

docker build -t kotlin-jre -f kotlinJRE.docker .


# Doesn't require git clone outside of the image but could result in a race condition between this call
# and the image's git clone.  Cannot seem to set a label from a RUN inside the image.
latest_commit=$(git ls-remote https://github.com/cpaulcox/javalin-kotlin-example master | cut -f 1)


docker build --build-arg org=cpaulcox --build-arg repo=javalin-kotlin-example --build-arg latest_commit=${latest_commit} -t kotlin-app -f kotlinSampleMultiStage.docker .


docker inspect kotlin-app | grep -C2 Labels

docker run -d --name javalin -p8888:8888 --rm kotlin-app

# Connect as bash when have an ENTRYPOINT defined.  docker run -it javalin bash can't override...perhaps could override entrypoint on the CLI
#docker exec -it javalin bash

sleep 30

curl http://localhost:8888/users

docker stop javalin


docker rmi $(docker images -q --filter "dangling=true")


