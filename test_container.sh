#!/bin/bash 

docker rmi add_firewall_rule:v1;
docker build -t add_firewall_rule:v1 .;
docker run --rm --name add_firewall_rule add_firewall_rule:v1;
