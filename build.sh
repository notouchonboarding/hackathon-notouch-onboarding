#!/bin/bash

tag=`git log -1 --pretty=%h``
docker build . --tag notouchonboarding/helm:${tag} --no-cache
