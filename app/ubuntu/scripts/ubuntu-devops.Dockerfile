FROM ubuntu:base
USER devops

# Debug mode
ENV DEBIAN_FRONTEND noninteractive
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install sudo and SSHD
RUN sudo apt update -y && sudo apt install -y openssh-server 

# Configure SSHD.
RUN sudo mkdir /var/run/sshd
ADD ./sshd_config /etc/ssh/sshd_config
RUN sudo ssh-keygen -A -v
RUN sudo /usr/sbin/sshd -t

RUN ssh-keygen -b 4096 -f "$HOME/.ssh/id_rsa" -N "" -q -t rsa

EXPOSE 22
CMD ["/usr/bin/sudo", "/usr/sbin/sshd", "-D"]

#...
# docker build . -f ubuntu-devops.Dockerfile -t ubuntu:devops