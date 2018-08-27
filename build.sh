#!/bin/bash

tag=`git log -1 --pretty=%h`
docker build . --tag somashekar10/helm:${tag} --no-cache

docker push somashekar10/helm:${tag}
