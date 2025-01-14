#! /usr/bin/bash

docker-compose -f ~/backup/gvm-container/docker-compose.yml -p greenbone-community-edition pull notus-data vulnerability-tests scap-data dfn-cert-data cert-bund-data report-formats data-objects