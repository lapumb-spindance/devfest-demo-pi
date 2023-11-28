# yocto-starter-kit

This repository utilizes the [Yocto Project](https://www.yoctoproject.org/)'s [Poky](https://www.yoctoproject.org/software-item/poky/) reference distribution and is meant to be a starting point for embedded Linux development.

## Prerequisites

>:warning: **Yocto Project tooling is required to run in a Linux environment.** If you are on Windows or an Intel-based Mac, you will need to setup a Linux environment. Please note that, although this is tooling in this repository to facilitate developing on Windows/MacOS, **full support is not guaranteed**.

See the [Dockerfile](.devcontainer/Dockerfile) for the full list of dependencies if you are on a Linux host.

If you are on a Windows 11 (or 10) host, see [windows_11_setup_steps.md](docs/windows_11_setup_steps.md) for instructions on setting up your environment.

## Getting Started

Clone this repository:

```bash
git clone --recursive git@github.com:spindance/yocto-starter-kit.git
```

>Note: if you do not add the `--recursive` flag, run `./tools/update_submodules.sh` once the repository has successfully been cloned.

### Containerized Development

This repository utilizes Yocto Project tooling that is **required to be run in a Linux environment**. Since not everyone has access to a Linux machine, this repository has been containerized using [Visual Studio Code Remote Containers](https://code.visualstudio.com/docs/remote/containers). This allows you to develop in a Linux environment without having to install Linux on your machine.

If you choose to use a containerized environment for development, the following dependencies must be installed:

**MacOS**:

```bash
brew install node
npm install -g @devcontainers/cli
```

**Linux / WSL2**:

>Note: along with the following dependencies, if you are working in WSL(2) and have not already done so, it is probably a good idea to hike up your resources. For example, on a machine with 16GB RAM and 20 (logical) cores, you may want a configuration like the following in your `${env:USERPROFILE}\.wslconfig`:
>
  > ```txt
  >[wsl2]
  >memory=14GB
  >swap=4GB
  >processors=18
  >```
>
> See [the Microsoft documentation](https://learn.microsoft.com/en-us/windows/wsl/wsl-config#wslconfig) for more information about the `.wslconfig`.

```bash
sudo apt install nodejs npm -y
sudo npm cache clean -f
sudo npm install -g n
sudo n stable
sudo npm install -g @devcontainers/cli
```

:warning: If you opt to develop directly in WSL(2), be sure to install the dependencies outlined in the [Dockerfile](.devcontainer/Dockerfile).

[Docker Desktop](https://www.docker.com/products/docker-desktop) must also be installed and running. **Make sure you are signed into a docker account (free is fine) and docker is running**.

#### Visual Studio Code

>**Note: before proceeding, make sure you have the [Dev Containers Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) installed and enabled in Visual Studio Code.**

To utilize the container defined in this repository, open this repository in Visual Studio Code. You will likely be greeted with a prompt to "_Reopen in Container_". If so, click the "_Reopen in Container_" button, which will create a Docker container (if necessary) and mount you at the location of this repository in the container filesystem. If not, open the command palette (Mac: `Cmd+Shift+P`, Windows: `Ctrl+Shift+P`) and search for "Remote-Containers: Reopen in Container". A new VSCode window will open with the container running, where you can execute all your `git` commands and run the Yocto Project tooling.

#### Command Line

If you do not want to use VSCode, you can still use the containerized environment. From the root of this repository, run the following command, which will create a Docker container (if necessary) and mount you at the location of this repository in the container filesystem:

```bash
./.devcontainer/enter_container.sh
```

>To exit the container, enter the `exit` command.

#### Important Note about Containerized Development

It has been observed that errors occur when attempting to enter the container in VS Code after having already entered the container from the command line (and / or vice-versa). If you run into this issue, delete the image / container that was spun up by the other method and try again. **That said, it is probably best to stick to one method of entering the container until we figure out a more graceful solution**.

### Non-Containerized Development

Don't want to use a Docker container to build? No problem! See the [Yocto Project Quick Start](https://docs.yoctoproject.org/dev-manual/start.html#preparing-the-build-host) for setting up either your native Linux host.

### Project-Level Environment Setup

Once you have your Linux environment setup, it is time to setup the project environment by sourcing the `.envrc` file:

```bash
source .envrc
```

This can be done manually, or you can use [direnv](https://direnv.net/) (`sudo apt install direnv`) to automatically source this file when you enter the project directory.

>Note: if using `direnv`, ensure the tool is properly [hooked into your shell](https://direnv.net/docs/hook.html).

#### Custom Configurations

The `.envrc` file also sources a `.userenv` file if one is available. This file is ignored by git, so you can add any custom environment variables or overwrite any existing environment variables you see fit. For an example `.userenv` file, see the [example](.userenv.example) file.

### The `bitbake` Command

This repository is setup in a way that makes it simple for multiple developers to contribute to the same project. In order to achieve this, several custom environment variables have to be sent to `bitbake` to map dynamic paths correctly. Because of this, using the raw `bitbake` command **will not work**. Instead, utilize the `execute_bitbake.sh` script to properly source the environment variables and execute `bitbake`:

```bash
./execute_bitbake <additional_args_here>
```

>Note: this script is used within the [build.sh](build.sh). Do not use this script directly unless you are experienced with the Yocto Project tooling.

## Building and Flashing an Image

Once you have your environment setup and your hardware connected, it is time to build and flash the image to a uSD card. Building has been simplified to a `build.sh` script, which will build the `core-image-base` image by default. To build the image, simply run `./build.sh`.

Once the build completes successfully, you can flash the image to a uSD card by running `./flash.sh` **if you are working on a native Linux machine**. This script will automatically detect the newest image, but you also have the option to supply a specific image. Run `./flash.sh -h` for more information.

If you are _not_ on a native Linux machine, use the following for flashing:

- Windows: [rufus](https://rufus.ie/en/)
  >Keep the default options, but when "SELECT"ing a file, make sure to change the filter to `All files (*.*)`. When you plug in your uSD card, Windows will complain. Only focus on the `rufus` application and do not do anything with any explorer windows that pop up.
- MacOS: [balenaEtcher](https://etcher.balena.io/#download-etcher)

## Helpful Resources

- [Yocto Project Documentation](https://docs.yoctoproject.org/4.0.11/singleindex.html)
- [OpenEmbedded Layers Index](https://layers.openembedded.org/layerindex/branch/kirkstone/layers/)
- [DigiKey Yocto Project Introduction](https://www.youtube.com/playlist?list=PLEBQazB0HUyTpoJoZecRK6PpDG31Y7RPB)
  >The first video in the series is focused on [buildroot](https://buildroot.org/), but the rest of the videos are focused on the Yocto Project.
