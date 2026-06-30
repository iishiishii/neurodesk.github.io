---
title: "Neurodesk App"
linkTitle: "Neurodesk App"
weight: 1
aliases:
- /getting-started/local/neurodeskapp/
- /getting-started/local/neurodeskapp
- /getting-started/neurodesktop/portable/
- /getting-started/neurodesktop/portable
- /docs/getting-started/neurodesktop/neurodeskapp/
- /docs/getting-started/neurodesktop/portable/
- /docs/getting-started/neurodesktop/portable
- /docs/getting-started/local/neurodeskapp/
- /docs/getting-started/local/neurodeskapp
- /docs/Getting-Started/Local/neurodeskapp
description: >
  A cross-platform desktop application for Neurodesk: The easiest way to use Neurodesktop
---

<img style="float: right;" src="{{< relurl "/static/docs/getting-started/neurodeskapp/neurodesk-desktop.png" >}}" width="750">


<!-- ![Neurodesk App](/static/docs/getting-started/neurodeskapp/neurodesk-desktop.png 'neurodeskapp') -->

### Determine System Privileges

Before running the app, check whether your system has privileged access (root/admin permissions). This determines which engine you need to use to run the app:

If you have privileged access → Use Docker or Podman Engine

If you do NOT have privileged access → Use TinyRange Engine, or run remote instance

<img src="{{< relurl "/static/docs/getting-started/neurodeskapp/engine-options.png" >}}" width="400">

### Minimum System Requirements

1. At least 5GB free space for neurodesktop base image.
2. One of the following options, depending on system privileges:

- With privileged access: Docker or Podman to run respective engines

- Without privileged access: TinyRange Engine (included with Neurodesk App) and QEMU (only on macOS)

## Downloading Neurodesk App

- [Debian, Ubuntu Linux Installer x64](https://github.com/neurodesk/neurodesk-app/releases/latest/download/NeurodeskApp-Setup-Debian-x64.deb)
- [Red Hat, Fedora, SUSE Linux Installer x64](https://github.com/neurodesk/neurodesk-app/releases/latest/download/NeurodeskApp-Setup-Fedora-x64.rpm)
- [Debian, Ubuntu Linux Installer arm64](https://github.com/neurodesk/neurodesk-app/releases/download/v1.8.0/NeurodeskApp-Setup-Debian-arm64.deb)
- [Red Hat, Fedora, SUSE Linux Installer arm64](https://github.com/neurodesk/neurodesk-app/releases/latest/download/NeurodeskApp-Setup-Fedora-arm64.rpm)
- [Arch-based package via AUR](https://aur.archlinux.org/packages/neurodeskapp-bin)
- [macOS Intel Installer](https://github.com/neurodesk/neurodesk-app/releases/latest/download/NeurodeskApp-Setup-macOS-x64.dmg), [macOS Apple silicon Installer](https://github.com/neurodesk/neurodesk-app/releases/latest/download/NeurodeskApp-Setup-macOS-arm64.dmg)
- [Windows Installer](https://github.com/neurodesk/neurodesk-app/releases/latest/download/NeurodeskApp-Setup-Windows.exe)


{{< alert color="info" >}}
**On Microsoft edge**, follow these steps to download the executable file:


<img src="{{< relurl "/static/docs/getting-started/neurodeskapp/neurodeskapp-edge-download.png" >}}" style="max-width: 800px; width: 100%;" alt="Microsoft Edge download steps">
{{< /alert >}}

## Installing Docker

{{< alert color="info" >}}
Docker is required for starting a local instance of Neurodesk.<br>
If only connecting to a remote Neurodesk servers, you may **skip Installing Docker**
{{< /alert >}}

The Neurodesk App requires Docker to be installed on your computer. If you already have Docker installed, you can skip this step.

- [Docker Desktop for Windows](https://docs.docker.com/docker-for-windows/install/)
- [Docker Desktop for Mac](https://docs.docker.com/docker-for-mac/install/)
- [Docker Engine for Linux](https://docs.docker.com/engine/install/)

After installation, open a terminal (Linux/macOS) or command prompt (Windows) and run the following command to verify that Docker is working correctly:

```bash
docker --version
docker run hello-world
```

## Installing QEMU

{{< alert color="info" >}}
QEMU is only needed if your using TinyRange on macOS.
It is not needed on Windows or Linux using TinyRange since it's included in the install.
{{< /alert >}}

The easist way to install QEMU on macOS is using [Homebrew](https://brew.sh/):

```bash
brew install qemu
```

You can verify the installation by running:

```bash
qemu-system-aarch64 --version
```

## Installing Neurodesk App

If you have an existing Neurodesk App installation, please first uninstall it by following the uninstall instructions [here](#uninstalling-neurodesk-app). Then, install the app for your system:

- Debian, Ubuntu Linux Installer: `sudo apt install -f ./NeurodeskApp-Setup-Debian.deb`
- Red Hat, Fedora, SUSE Linux Installer: `sudo rpm -i NeurodeskApp-Setup-Fedora.rpm`
- Arch-based package via AUR: `yay neurodesk` (or follow instructions [here](https://wiki.archlinux.org/title/Arch_User_Repository#Installing_and_upgrading_packages))
- macOS Installer: Double click the downloaded dmg file, then drag the NeurodeskApp.app to the Applications folder; for starting the app: Right click on the NeurodeskApp.app and select "Open". For Apple Silicon systems (M1/M2): Make sure to enable Rosetta support in the docker settings for best performance!
- Windows Installer: Double click the downloaded exe file; Accept to install from an unknown publisher with Yes; then accept the license agreement and click finish at the end.

## Launching Neurodesk App

The Neurodesk App can be launched directly from your operating system's application menu, or by running the `neurodeskapp` command in the command line.

> Note that the Neurodesk App will set the File Browser's root directory based on the launch method used. The default working directory is the user's home directory - this can be customized from the Settings dialog.

## Sessions and Projects

Sessions represent local project launches and connections to existing Neurodesk servers. Each Neurodesk UI window in the app is associated with a separate session and sessions can be restored with the same configuration later on.

### Session start options

You can start a new session by using the links at the Start section of the Welcome Page.

<img src="{{< relurl "/static/docs/getting-started/neurodeskapp/start-session.png" >}}" style="max-width: 800px; width: 100%;" alt="Start session">

- `Open Local Neurodesk..` creates a new session in the default working directory.
- `Connect to remote Neurodesk server..` creates a session by connecting to a remote Neurodesk server.

Previously opened sessions are stored as part of application data and they are listed on the Welcome Page. Clicking an item in the `Recent sessions` list restores the selected session.

## Connecting to local Neurodesk

Neurodesk App creates new Neurodesk sessions by launching a locally running Neurodesk server and connecting to it. To open a local instance, click the `Open Local Neurodesk..` button in the Start section of the Welcome Page.

This will show a Jupyterlab interface. There are two options to interact with Neurodesk through this interface:

- By clicking the `NeurodeskApp` icon on the right. This will launch a new window to start a Neurodesk interface.
- By module loading containers on the left bar. You can interact with loaded modules through the command line interface.

<img src="{{< relurl "/static/docs/getting-started/neurodeskapp/connect-to-local.png" >}}" style="max-width: 800px; width: 100%;" alt="Connect to local">

## Connecting to a remote Neurodesk Server

It can also connect to an existing Neurodesk server instance that is running remotely. In order to connect to a server, click the `Connect to remote Neurodesk server..` button in the Start section of the Welcome Page.

<img src="{{< relurl "/static/docs/getting-started/neurodeskapp/connect-to-server.png" >}}" style="max-width: 800px; width: 100%;" alt="Connect to server">

This will launch a dialog that automatically lists the remote Neurodesk server instances.

Select a server from the list or enter the URL of the Neurodesk application server. If the server requires a token for authentication, make sure to include it as a query parameter of the URL as well (`/lab?token=<token-value>`). After entering a URL hit `Enter` key to connect.

If the `Persist session data` option is checked, then the session information is stored and Neurodesk App will re-use this data on the next launch. If this option is not checked, the session data is automatically deleted at the next launch and servers requiring authentication will prompt for re-login.

You can delete the stored session data manually at any time by using the `Clear History` option in the Privacy tab of Settings dialog.

<img src="{{< relurl "/static/docs/getting-started/neurodeskapp/settings-privacy.png" >}}" style="max-width: 800px; width: 100%;" alt="Settings privacy tab showing Clear History option">

## Configuration and data files

Neurodesk App stores data in ~/neurodesktop-storage for Linux and Mac, or C:/neurodesktop-storage for Windows, as default.

## Add a Custom Data Directory

Neurodesk App stores its data in the following locations:

- By default, /home/jovyan/neurodesktop-storage in the app (which is bound with local directory ~/neurodesktop-storage in Unix/MacOS or C:/neurodesktop-storage in Windows)

- By choice, in the settings window below, select `Additional Directory` on the left side bar, click `Change` button to select the local directory, then click `Apply & restart`. The next time you start the app, the data from the local directory can be found in /home/jovyan/data.

{{< alert color="info">}}
If you are using Windows it is currently not possible to mount external hard drives. We recommend copying data from the external drive to your local disk first and then processing it in Neurodesk.
{{< /alert >}}

{{< alert color="info">}}
If you are using MacOS and Docker mounting an external hard drive will work out of the box. If you are using Podman you have to modify the Podman machine settings with the following commands once and then set the path in the Neurodesk App:
```
podman machine reset -f
podman machine init --rootful --now -v /Volumes:/Volumes -v $HOME:$HOME podman-machine-default
```
{{< /alert >}}

<img src="{{< relurl "/static/docs/getting-started/neurodeskapp/additional_dir.png" >}}" style="max-width: 800px; width: 100%;" alt="Additional Directory settings interface">

{{< alert color="info">}}
If you are using conda environments and you are installing packages or even new kernels, make sure to read this: https://neurodesk.org/edu/tutorials/programming/conda.html
{{< /alert >}}

## Troubleshooting Neurodesk App

### /var/run/docker.sock: connect: permission denied, docker

This means that docker is not correctly setup yet, run:
```
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

sudo chown root:docker /var/run/docker.sock
sudo chmod 666 /var/run/docker.sock
```

### FATAL:setuid_sandbox_host.cc(158)

If you see the error "FATAL:setuid_sandbox_host.cc(158)] The SUID sandbox helper binary was found, but is not configured correctly. Rather than run without sandboxing I'm aborting now. You need to make sure that /opt/NeurodeskApp/chrome-sandbox is owned by root and has mode 4755.
Trace/breakpoint trap (core dumped)" this is caused by a recent change in Ubuntu 24.04.

A temporary workaround: Create the file /etc/apparmor.d/neurodeskapp
 With this content:

```
# This profile allows everything and only exists to give the
# application a name instead of having the label "unconfined"

abi <abi/4.0>,
include <tunables/global>

profile neurodeskapp "/opt/NeurodeskApp/neurodeskapp" flags=(unconfined) {
  userns,

  # Site-specific additions and overrides. See local/README for details.
  include if exists <local/neurodeskapp>
}
```

Then restart your computer. Then try to start the neurodesk app again.

### Running Neurodesk App with Podman on restricted Linux systems

{{< alert color="warning" >}}
This is an **advanced** guide for getting the Neurodesk App working with **Podman** (instead of Docker) on locked-down Linux machines — for example, hosts that use **Active Directory (AD)** accounts, an **NFS-mounted** home or data directory, and where image pulls through the App tend to time out. On a standard desktop with Docker or rootful Podman you should **not** need any of this.

The steps below were validated with **Podman 3.4.4 on Ubuntu 22**. Replace every `<placeholder>` with your own values.
{{< /alert >}}

**1. Install the Podman shim script**

Some environments need a wrapper around `podman` to fix an NFS volume-mount bug and to sanitize the UID/GID that the App passes to the container. Create an executable file named `podman` in `~/.local/bin/` (owned by your user), so it is found on `PATH` before the real binary:

```bash
#!/bin/bash

CURRENT_UID=$(id -u)
CURRENT_GID=$(id -g)

NEW_ARGS=()
for arg in "$@"; do
    # 1. Fix the NFS volume-mount bug by appending the overlay override option (:O)
    if [[ "$arg" == *"/nfs/<mount>"* ]]; then
        arg="${arg//\/nfs\/<mount>:\/data/\/nfs\/<mount>:\/data:O}"
    fi

    # 2. Sanitize the network IDs
    if [[ "$arg" == *"NB_UID=${CURRENT_UID}"* ]]; then
        arg="${arg//NB_UID=${CURRENT_UID}/NB_UID=1000}"
    fi
    if [[ "$arg" == *"NB_GID=${CURRENT_GID}"* ]]; then
        arg="${arg//NB_GID=${CURRENT_GID}/NB_GID=100}"
    fi
    NEW_ARGS+=("$arg")
done

exec /usr/bin/podman "${NEW_ARGS[@]}"
```

Then make it executable:

```bash
chmod +x ~/.local/bin/podman
```

{{< alert color="info" >}}
Replace `<mount>` with your NFS mount point. If you are **not** using an NFS mount, you can omit the overlay (`:O`) fix entirely.

The UID/GID sanitizing is only needed for **non-person AD accounts** that are not assigned a UID/GID. If your organization uses AD with a normal person account that has an assigned UID and GID, you most likely do **not** need this and can skip the shim.
{{< /alert >}}

If you do need the UID workaround, add your account to `/etc/subuid` and `/etc/subgid` (this is why the shim above uses `1000`):

```
# /etc/subuid
<USERNAME>:1000:65536

# /etc/subgid
<USERNAME>:100000:65536
```

**2. Download the image over the CLI**

Because pulls through the App can time out, pull and re-tag the image from a terminal first (run this as the user who will launch the App):

```bash
podman pull ghcr.io/neurodesk/neurodesktop/neurodesktop:<version>
podman tag ghcr.io/neurodesk/neurodesktop/neurodesktop:<version> docker.io/vnmd/neurodesktop:<version>
```

Then stop any lingering Podman/Neurodesk processes and migrate Podman:

```bash
pkill -9 -u <USERNAME> -f "podman|neurodesk"
podman system migrate
```

**3. Point the launcher at the shim**

Edit the application shortcut so it uses your `~/.local/bin` `PATH`:

```bash
sudo nano /usr/share/applications/neurodeskapp.desktop
```

Set the `Exec` line to:

```
Exec=bash -c "PATH=\"$HOME/.local/bin:$PATH\" /opt/NeurodeskApp/neurodeskapp" %U
```

{{< alert color="info" >}}
Type this line out by hand rather than copy-pasting — invisible characters and whitespace from a copy can break the launcher.
{{< /alert >}}

Then launch the App from the application menu (the shortcut), **not** from the CLI.

**4. Recovering from a broken volume or incompatible storage**

If a session fails to start, delete the broken home volume and try again:

```bash
# Kill any lingering container attempts
pkill -9 -u $USER -f "podman|neurodesk"

# Delete the broken home volume
podman volume rm neurodesk-home
```

If Podman's storage database is incompatible (for example after a Podman upgrade), reset it:

```bash
podman system reset --force
```

If that still doesn't work, remove the stale storage config:

```bash
sudo rm -f /home/$USER/.config/containers/storage.conf
```

Then re-pull and re-tag the image (step 2 above), run `podman system migrate`, and launch again via the shortcut.

## Uninstalling Neurodesk App

### Debian, Ubuntu Linux

```bash
sudo apt-get purge neurodeskapp # remove application
sudo rm /usr/bin/neurodeskapp # remove command symlink
rm -rf ~/.config/neurodeskapp # to remove application cache
```

### Red Hat, Fedora, SUSE Linux

```bash
sudo rpm -e neurodeskapp # remove application
sudo rm /usr/bin/neurodeskapp # remove command symlink
rm -rf ~/.config/neurodeskapp # to remove application cache
```

### Arch-based Linux distributions

```bash
sudo pacman -Rs neurodeskapp-bin
```

### macOS

Find the application installation `NeurodeskApp.app` in Finder (in /Applications or ~/Applications) and move to Trash by using `CMD + Delete`. Clean other application generated files using:

```bash
rm -rf ~/Library/neurodeskapp # to remove application cache
rm -rf ~/Library/Application\ Support/neurodeskapp # to remove user data
```

### Windows

On Windows, go to `Windows Apps & Features` dialog using `Start Menu` -> `Settings` -> `Apps` and uninstall Neurodesk App as shown below.

In order to remove application cache, delete `C:\Users\<username>\AppData\Roaming\neurodeskapp` directory. The AppData directory is a hidden directory - so make sure to activate hidden Items in the Windows explorer under View -> Show -> Hidden Items
