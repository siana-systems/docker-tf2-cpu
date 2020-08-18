# SIANA TensorFlow/Keras Development Docker for CPU-Host

This repo is used to build a docker image for deep-learning development targeting TensorFlow 2.0 with Keras.

At its core, it includes the lastest versions of TensorFlow and Keras. In addition, several typical packages are included to help with parsing data (images and audio, refer to the Dockerfile for details.) 

## Pre-requisites
Notes:
  * the following instructions were tested on Linux/Ubuntu 18.04
  * the following instructions assumed the root path under: ~/docker-tf2-cpu
 
You will need:
  * to install [Docker Engine](https://docs.docker.com/engine/install/)

## Running the container
To run the container, simply run:
 ```console
 foo@bar: ~/docker-tf2-cpu$ make bash
 ```
 From the terminal, you can then run your TensorFlow/Keras python scripts.
  
 The doker container maps /src/workspace/ to your ~/docker-keras-cpu folder on the host side.
 
 Note: review the Makefile targets for different runtime options.

## Building the image
Open a terminal into your ~/docker-keras-cpu and run:
```console
 foo@bar: ~/docker-tf2-cpu$ make build
```
Docker will launch and proceed to build a new image named: "docker-tf2-cpu"

On completion, you should see the new image listed: 
```console
foo@bar: ~/docker-tf2-cpu$ docker image list
```

