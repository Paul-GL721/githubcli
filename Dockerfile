
#with ubuntu base image, install gitcli
FROM ubuntu:20.04

LABEL com.paulgobero.image.authors="paul@paulgobero.com"

RUN apt-get update 

USER root

RUN type -p curl >/dev/null || apt-get install curl -y

RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main"\
 | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& apt-get update \
&& apt-get install gh -y

CMD /bin/bash
