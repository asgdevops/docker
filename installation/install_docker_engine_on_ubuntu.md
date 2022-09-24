# :notes: Install Docker Engine on Ubuntu

# :paw_prints: Steps

## ****Uninstall old versions****

Older versions of Docker were called `docker`, `docker.io`, or `docker-engine`. If these are installed, uninstall them:

```bash
sudo apt-get remove docker docker-engine docker.io containerd runc
```

## ****Install using the repository****

### ****Set up the repository****

1. Update the `apt` package index and install packages to allow `apt` to use a repository over HTTPS:

    ```bash
    sudo apt-get update \
    && sudo apt-get install -y ca-certificates curl gnupg lsb-release
    ```

2. Add Docker’s official GPG key:

    ```bash
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    ```

3. Use the following command to set up the repository:

    ```bash
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    ```

### ****Install Docker Engine****

1. Update the `apt`package index, and install the *latest version* of Docker Engine, containerd, and Docker Compose, or go to the next step to install a specific version:

    ```bash
    sudo apt-get update 
    && sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
    ```

2. Verify that Docker Engine is installed correctly by running the `hello-world`
 image.

    ```bash
    sudo docker run hello-world
    ```

## ****Manage Docker as a non-root user****

1. Create the `docker` group.

    ```bash
    sudo groupadd docker
    ```

2. Add your user to the `docker` group.

    ```bash
      sudo usermod -aG docker $USER
    ```

3. Log out and log back in so that your group membership is re-evaluated.

    If testing on a virtual machine, it may be necessary to restart the virtual machine for changes to take effect.

    On a desktop Linux environment such as X Windows, log out of your session completely and then log back in.

    On Linux, you can also run the following command to activate the changes to groups:

    ```bash
    newgrp docker
    ```

4. Verify that you can run `docker` commands without `sudo`.

    ```bash
    docker run hello-world
    ```

# References

- [Install Docker Engine on Ubuntu](http://docs.docker.com/engine/install/ubuntu/)
- [Post-installation steps for Linux](https://docs.docker.com/engine/install/linux-postinstall/)
