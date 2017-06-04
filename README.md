# docker-playground
some testing repo for integrating docker

useful commands:


Delete all existing containers

  docker rm $(docker ps -a -q)


Stop all running containers

  docker stop $(docker ps -a -q)


Delete all existing images

  docker rmi $(docker images -q -a)


Kill all running containers

  docker kill $(docker ps -q)


Delete dangling images
  docker rmi $(docker images -q -f dangling=true)


Remove all stopped containers
  docker rm $(docker ps -a -q)