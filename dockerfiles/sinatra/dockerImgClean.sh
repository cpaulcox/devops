#!/bin/bash

# Removes all untagged images
docker rmi $(docker images -a | grep "^<none>" | awk '{print $3}')
