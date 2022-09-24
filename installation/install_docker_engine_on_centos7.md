# :notes: Install Docker Engine on CentOS 7

# :paw_prints: Steps

1. Set up the repository. 
    
    Install the `yum-utils` package (which provides the `yum-config-anager`
     utility) and set up the repository.
    
    ```bash
    sudo yum install -y yum-utils
    
    sudo yum-config-manager \
        --add-repo \
        https://download.docker.com/linux/centos/docker-ce.repo
    ```
    
    If prompted to accept the GPG key, verify that the fingerprint matches `060A 61C5 1B55 8A7F 742B 77AA C52F EB6B 621E 9F35`, and if so, accept it.
    
    This command installs Docker, but it doesn’t start Docker. It also creates a `docker` group, however, it doesn’t add any users to the group by default.
    
2. Install Docker Engine.
    
    Install the *latest version* of Docker Engine, containerd, and Docker Compose or go to the next step to install a specific version:
    
    ```bash
    sudo yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin
    ```
    
3. Start Docker.
    
    ```bash
    sudo systemctl start docker
    
    sudo systemctl status docker
    ```
    
4. Verify that Docker Engine is installed correctly by running the `hello-world`
 image.
    
    ```bash
    sudo docker run hello-world
    ```
    
    This command downloads a test image and runs it in a container. When the container runs, it prints a message and exits.
    
5. Create the `docker` group.
    
    ```bash
    sudo groupadd docker
    ```
    
6. Add your user to the `docker` group.
    
    ```bash
    sudo usermod -aG docker $USER
    ```
    
7. Log out and log back in so that your group membership is re-evaluated.

# References

- [Install Docker Engine on CentOS](https://docs.docker.com/engine/install/centos/#installation-methods)