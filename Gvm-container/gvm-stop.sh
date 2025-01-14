#! /usr/bin/bash

docker stop $(docker ps | awk '{print $1}' | sed '1d')
