resty-vod-docker
=======================

This repository contains a Dockerfile for building nginx with [Kaltura's
vod-module](https://github.com/kaltura/nginx-vod-module).

This repo is forked from [NY Times module](https://github.com/nytimes/nginx-vod-module-docker). But I swithced nginx with openresty for lua support. 
Building locally
----------------

This repository uses Docker's multi-stage builds, therefore building this image
requires Docker 17.05 or higher. Given that you have all the required
dependencies, building the image is as simple as running a ``docker build``:

```
docker build -t ithiru/resty-vod .
```

Added support additional OpenResty configure command make to allow Debug features etc.,

```
docker build -t ithiru/resty-vod --build-arg NGINX_CONFIG_ARGS="--with-debug -j2" --build-arg MAKE_ARGS="-j2" .
```

Docker Hub
----------

The image is available on Docker Hub: https://hub.docker.com/r/ithiru/resty-vod/.
