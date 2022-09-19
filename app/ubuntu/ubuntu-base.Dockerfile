FROM ubuntu:22.04 
USER root

ENV DEBIAN_FRONTEND noninteractive
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install sudo and SSHD
RUN apt update -y && apt install -y sudo 

# Set up devops user
RUN useradd -rm -d /home/devops -s /bin/bash -g root -G sudo -u 1000 devops 
RUN echo devops:devops | chpasswd
RUN echo "devops    ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

USER devops
WORKDIR /home/devops

CMD ["sleep", "infinity"]

#...
# docker build . -f ubuntu-base.Dockerfile -t ubuntu:base