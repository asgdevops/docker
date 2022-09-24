FROM ubuntu:22.04 
USER root

ENV DEBIAN_FRONTEND noninteractive
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG username

# Install sudo and SSHD
RUN apt update -y && apt install -y sudo 

# Set up devops user
RUN useradd -rm -d /home/$username -s /bin/bash -g root -G sudo -u 1000 $username
RUN echo $username:$username | chpasswd
RUN echo "$username    ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

USER $username
WORKDIR /home/$username

CMD ["sleep", "infinity"]

#...
# docker build . --build-arg username=devops -f ubuntu-base.Dockerfile -t ubuntu:base