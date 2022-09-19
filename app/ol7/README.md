# Create a container with Oracle Linux 7 and Python CX
## :paw_prints: Steps
- Build a new `ol7:py-cx` image based on oracle linux 7 slim.
  ```Docker
  FROM oraclelinux:7-slim

  RUN yum -y install oraclelinux-developer-release-el7 oracleinstantclient-release-el7 
  RUN yum -y install python3 \
                    python3-libs \
                    python3-pip \
                    python3-setuptools \
                    python-cx_Oracle && \
      rm -rf /var/cache/yum/*

  ENTRYPOINT ["tail"]
  CMD ["-f","/dev/null"]
  ```

- Build the new image.
  ```bash
  docker build . -f ol7.Dockerfile -t ol7:py-cx
  ```

- Create a new container taking the image just created.
  ```Docker
  docker run --detach --name -rm ol7 ol7:py-cx
  ```

  - Parameters description:
    - `--detach`: runs the container in background mode.
    - `--name`: sets the name of the container.
    - `--rm`: deletes the container once it stops running.
    - `ol7:py-cx`: is the name of the oracle linux 7 custom image within python3 and python-cx installed.

# :page_facing_up: Script files
- [sshd_config](sshd_config)
- [ol7.Dockerfile](ol7.Dockerfile)

# :books: References
- [Installing cx_Oracle and Oracle Instant Client via Oracle Linux Yum Server](https://blogs.oracle.com/linux/post/installing-cx_oracle-and-oracle-instant-client-via-oracle-linux-yum-server)
- [Official Docker builds of Oracle Linux](https://hub.docker.com/_/oraclelinux)
