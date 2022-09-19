# Create a small network with Ubuntu Docker containers
## :paw_prints: Steps
- Create a ubuntu network
  ```Docker
  docker network create unet
  ```
- Using Dockerfiles build two images based on ubuntu system.
  - The first one `ubuntu-base.Dockerfile` is used to create a base image.
    ```Docker
    FROM ubuntu:22.04 
    USER root

    # Debug mode
    ENV DEBIAN_FRONTEND noninteractive
    SHELL ["/bin/bash", "-o", "pipefail", "-c"]

    # Install sudo and SSHD
    RUN apt update -y && apt install -y sudo 

    # Set up devops user and password
    RUN useradd -rm -d /home/devops -s /bin/bash -g root -G sudo -u 1000 devops 
    RUN echo devops:devops | chpasswd
    USER devops
    WORKDIR /home/devops

    CMD ["sleep", "infinity"]
    ```

  - Build the base image.
    ```bash
    docker build . -f ubuntu-base.Dockerfile -t ubuntu:base
    ```

  - The second one `ubuntu-devops.Dockerfile` helps to build the custom image allowing to connect the containers through SSH.
    ```Docker
    FROM ubuntu:base
    USER root

    # Debug mode
    ENV DEBIAN_FRONTEND noninteractive
    SHELL ["/bin/bash", "-o", "pipefail", "-c"]

    # Install SSH
    RUN apt update -y && apt install -y openssh-server 

    # Configure SSHD
    RUN mkdir /var/run/sshd
    ADD ./sshd_config /etc/ssh/sshd_config
    RUN ssh-keygen -A -v
    RUN /usr/sbin/sshd -t

    USER devops
    RUN ssh-keygen -b 4096 -f "$HOME/.ssh/id_rsa" -N "" -q -t rsa

    USER root
    EXPOSE 22
    CMD ["/usr/sbin/sshd", "-D"]
    ```

  - Build the custom image within SSH isntalled.
    ```Docker
    docker build . -f ubuntu-devops.Dockerfile -t ubuntu:devops
    ```


- Create a set of containers with different SSH port each.
  ```Docker
  docker run \
  --detach \
  --name ubuntu-00 \
  --network unet \
  --publish 2200:22 \
  ubuntu:devops 
  
  docker run \
  --detach \
  --name ubuntu-01 \
  --network unet \
  --publish 2201:22 \
  ubuntu:devops 

  docker run \
  --detach \
  --name ubuntu-02 \
  --network unet \
  --publish 2202:22 \
  ubuntu:devops 
  ```

  - Parameters description:
    - `--detach`: runs the container in background mode.
    - `--name`: sets the name of the container.
    - `--network unet`: specifies which network to connect. (in this case unet)
    - `--publish`: maps the host port to the container port. (_host:container_)
    - `ubuntu:devops`: is the name of the custom image within SSH installed.

- Get the IP address of each ubuntu container.
  ```bash
  container="ubuntu-00" 
  docker inspect $container | grep -E '"IPAddress": "([1-9]{1,3}.){1,4}'  | sed 's/ //g' | cut -f 1 -d ,
  ```

  i.e.
  ```bash
  $ container="ubuntu-00"
  $ docker inspect $container | grep -E '"IPAddress": "([1-9]{1,3}.){1,4}'  | sed 's/ //g' | cut -f 1 -d ,
  "IPAddress":"192.168.176.2"

  $ container="ubuntu-01"
  $ docker inspect $container | grep -E '"IPAddress": "([1-9]{1,3}.){1,4}'  | sed 's/ //g' | cut -f 1 -d ,
  "IPAddress":"192.168.176.3"

  $ container="ubuntu-02"
  $ docker inspect $container | grep -E '"IPAddress": "([1-9]{1,3}.){1,4}'  | sed 's/ //g' | cut -f 1 -d ,
  "IPAddress":"192.168.176.4"
  ```

- To display the SSH keys issue any of the commands below"
  ```bash
  docker exec ubuntu-00 cat /home/devops/.ssh/id_rsa.pub
  ```

- Test the SSH session using the following command:
  ```bash
  ssh -i ~/.ssh/ubuntu-00.id_rsa devops@192.168.176.2
  ```

## Connect o the container susing SSH public skeys
- Copy the container public key to the host.
  - _format `docker cp <containerId>:/file/path/within/container /host/path/target`_

  ```
  docker cp ubuntu-00:/home/devops/.ssh/id_rsa.pub ~/.ssh/ubuntu-00.id_rsa.pub
  ```

- Set readonly privileges
  ```bash
  chmod 0400 ~/.ssh/ubuntu-00.id_rsa.pub
  ls -l ~/.ssh/ubuntu-00.id_rsa.pub
  ```

- Add the publick key to the authorized_keys file
  ```bash
  docker exec ubuntu-00 cat /home/devops/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
  ```

- Connect to the container using SSH keys.
  ```bash
  ssh -i ~/.ssh/ubuntu-00.id_rsa devops@192.168.176.2
  ```

  _If getting a warning like this_
  ```
  Warning: Identity file /home/ansalaza/.ssh/ubuntu-00.id_rsa not accessible: No such file or directory.
  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  @    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
  Someone could be eavesdropping on you right now (man-in-the-middle attack)!
  It is also possible that a host key has just been changed.
  The fingerprint for the ED25519 key sent by the remote host is
  SHA256:DMmC5ycRBzS3xptjP05jzCNEEki3VaE135CUH9hkGK8.
  Please contact your system administrator.
  Add correct host key in /home/ansalaza/.ssh/known_hosts to get rid of this message.
  Offending ED25519 key in /home/ansalaza/.ssh/known_hosts:35
    remove with:
    ssh-keygen -f "/home/ansalaza/.ssh/known_hosts" -R "192.168.176.2"
  Host key for 192.168.176.2 has changed and you have requested strict checking.
  Host key verification failed.
  ```
  _remove the old IP Address record from the `~/.ssh/known_hosts`_
  ```
  ssh-keygen -f ~/.ssh/known_hosts -R 192.168.176.2
  ```

# :page_facing_up: Script files
- [sshd_config](sshd_config)
- [ubuntu-base.Dockerfile](ubuntu-base.Dockerfile)
- [ubuntu-devops.Dockerfile](ubuntu-devops.Dockerfile)

# :books: References
- [Ubuntu official image](https://hub.docker.com/_/ubuntu)
- [How to setup an ssh server within a docker container ](https://dev.to/s1ntaxe770r/how-to-setup-ssh-within-a-docker-container-i5i)
- [Running ssh-keygen without human interaction?](https://superuser.com/questions/478798/running-ssh-keygen-without-human-interaction)
- [Deprecated option RSAAuthentication, how do I login via SSH with key?](https://askubuntu.com/questions/1275396/deprecated-option-rsaauthentication-how-do-i-login-via-ssh-with-key)
