Base docker image for https://github.com/NIF-au/imagetrove

See also https://registry.hub.docker.com/u/carlohamalainen/imagetrove-base/  (this should
be moved to a NIF-au account).

Note to self for updating the image on the Docker Hub:

    docker build -t=carlohamalainen/imagetrove-base .
    docker push carlohamalainen/imagetrove-base
