FROM --platform=linux/amd64 ubuntu:20.04

SHELL ["/bin/bash", "-c"]
 
WORKDIR /src

COPY ["add_firewall_rules.sh", "./"]

RUN apt-get update
RUN apt install -y curl
RUN apt install -y iproute2
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

CMD . ./add_firewall_rules.sh