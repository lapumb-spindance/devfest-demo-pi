# Developing in this Repository on Windows 11

This document is meant to describe the setup process to begin development in this repository on a Windows 11 (and probably Windows 10) host. There are tips surrounding SSH keys and configuration, as this guide was prepared from a fresh Windows 11 installation.

## Steps

1. Install [Visual Studio Code](https://code.visualstudio.com/)
1. Open Windows PowerShell
    >You may need to open it as an administrator, depending on your permissions and setup.
1. Install [git](https://git-scm.com/download/win) (or `choco install git` if you have [Chocolatey](https://chocolatey.org/) installed)
1. Install [WSL2](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
    >`wsl --install` (this will install the Ubuntu distribution)
1. Install and sign in to [Docker Desktop](https://www.docker.com/products/docker-desktop)
1. Follow [the Docker instructions](https://docs.docker.com/desktop/wsl/) for allowing Docker to run with WSL2
1. Launch WSL2 (`wsl`, assuming you followed the instructions in the step above)
1. Update the WSL2 Ubuntu distribution with `sudo apt update -y && sudo apt upgrade -y && sudo apt full-upgrade -y`

    >**From this point on, everything will be done in WSL2**

1. Login to your [GitHub](www.github.com) account that has access to this repo
1. [Generate a new SSH key](https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) and add it to your GitHub account, if necessary. If you have multiple SSH keys for `git`, you may need to configure SSH to use the correct key. To do this, create (or modify) the `~/.ssh/config`. In one use case, it might look like:

    ```bash
    # Default (Personal) GitHub
    Host github.com
    HostName github.com
    IdentityFile ~/.ssh/id_ed25519
    IdentitiesOnly yes
    AddKeysToAgent yes
    PreferredAuthentications publickey

    # SpinDance GitHub
    Host github.com-spindance
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_rsa_spindance
    IdentitiesOnly yes
    AddKeysToAgent yes
    PreferredAuthentications publickey
    ```

    where the `IdentityFile` is the path to the private key, and the `Host` is the alias you want to use for the host. You can use this new configuration to clone this repo with: `git clone --recursive git@github.com-spindance:lapumb-spindance/yocto-starter-kit.git`

    **Notice the `..@github.com-spindance` in the URL. This is the alias we defined in the `~/.ssh/config` file, which means the `IdentityFile` for that host will be used.**

1. Start the SSH agent with `eval $(ssh-agent)` or add `eval $(ssh-agent -s)` to your `~/.*rc` file
1. Add your SSH key to the SSH agent with `ssh-add ~/.ssh/<key_name>`

    >Note: if you do not want to have to `ssh-add` your key every time you open up a terminal, add the following to your `~/.*rc` file:

    ```bash
    add_all_ssh_to_agent() {
        # Dynamically get the user's home directory and SSH dir.
        local local_user=$(whoami)
        local ssh_dir="/home/$local_user/.ssh"

        # Get a list of all the .pub files in the SSH dir.
        local ssh_dir_contents=$(ls -a $ssh_dir/*.pub 2> /dev/null)

        # Check what shell is being used. If we're using zsh, we need to use a different
        # method to split the SSH dir into an array than just using 'ls'.
        local current_shell=$(ps -hp $$)
        local ssh_dir_contents_array=()

        # Search for substrings of the current shell to determine which shell is being used.
        if [[ $current_shell == *"zsh"* ]]; then
            ssh_dir_contents_array=(${(f)ssh_dir_contents})
        elif [[ $current_shell == *"bash"* ]]; then
            ssh_dir_contents_array=$ssh_dir_contents
        else
            echo "Unknown shell: $current_shell"
        fi

        for file in $ssh_dir_contents_array; do
            file_without_extension="${file%.*}"
            ssh-add $file_without_extension
        done
    }
    add_all_ssh_to_agent
    ```

1. At this point, you are ready to follow the steps in the [README.md](../README.md) to begin development in this repository. Feel free to a utilize containerized environment or develop natively in WSL2.
