---
title: "PyNeurodesk"
linkTitle: "PyNeurodesk"
weight: 4
aliases:
- /docs/getting-started/pyneurodesk
- /docs/getting-started/neurocommand/pyneurodesk
description: >
  Use Neurodesk containers from Python, notebooks, and shell scripts
---

PyNeurodesk is the Python interface to Neurodesk containers. It lets you search for containers, start a local container runtime, run commands from Python, and load Neurodesk tools into an interactive shell.

Use PyNeurodesk when you want to:

- call Neurodesk tools from a Python script or notebook
- avoid managing container paths by hand
- load tools such as `niimath` into your terminal with `nd load`
- connect to an existing Neurodesk container daemon

{{< alert color="info" >}}
PyNeurodesk is installed from the Python package named `neurodesk`. After installation, both `import neurodesk` and `import pyneurodesk` work.
{{< /alert >}}

## Requirements

- Python 3.9 or newer
- a machine that can run the Neurodesk container daemon
- internet access for the first download of a container, Linux kernel, and emulator files

Live container execution depends on host virtualization support. On Linux systems this usually means KVM needs to be available. If you are on an HPC system, check with your system administrator before using PyNeurodesk on compute nodes.

## Install PyNeurodesk

Create and activate a Python environment first if you do not want to install into your main Python environment.

```bash
python3 -m venv neurodesk-python
source neurodesk-python/bin/activate
python -m pip install --upgrade pip
python -m pip install neurodesk
```

Check that the command line tools are available:

```bash
neurodesk --help
nd --help
```

## Run a container from Python

Import Neurodesk, prepare a container, then run a command inside it.

```python
import neurodesk as nd

niimath = nd.container("niimath")
print(niimath.run("niimath", "-help"))
```

The first run may take a little longer because PyNeurodesk needs to download and prepare the required files. Later runs reuse the local cache.

Many containers expose command wrappers. After the container is ready, you can call a wrapper as a Python method:

```python
import neurodesk as nd

niimath = nd.container("niimath")
print(niimath.niimath("-help"))
```

## Find available container versions

Use `search()` to see matching Neurodesk container versions:

```python
import neurodesk as nd

print(nd.search("niimath"))
```

When you call `nd.container("niimath")`, PyNeurodesk resolves the container from Neurodesk release metadata or CVMFS and prepares the preferred version automatically.

## Share a working directory

Use `share_dir()` when a container needs to read or write files from your host machine.

```python
from pathlib import Path
import neurodesk as nd

work = nd.share_dir(Path.cwd(), writable=True)
niimath = nd.container("niimath")

print(niimath.run("sh", "-lc", f"ls {work.guest_path}"))
```

The shared folder is mounted inside the container under a path like `/.share/<session-id>`. Use `writable=True` when the tool needs to create or modify files.

## Use PyNeurodesk from a shell

PyNeurodesk can add Neurodesk command wrappers to your current shell session.

For Bash:

```bash
source <(neurodesk activate --shell bash)
nd load niimath
niimath -help
```

For Zsh:

```bash
source <(neurodesk activate --shell zsh)
nd load niimath
niimath -help
```

For PowerShell:

```powershell
nd activate | iex
nd load niimath
niimath -help
```

The `nd load` command prepares the container and creates command wrappers for tools listed by the container metadata. These wrappers are stored in a temporary session directory and added to your `PATH`.

## Run a one-off shell command

After activating your shell, you can run a command without adding wrappers permanently to the session:

```bash
nd exec niimath -- niimath -help
```

## Connect to an existing daemon

If you already have a Neurodesk container daemon running, connect to it with a URL:

```python
import neurodesk as nd

client = nd.connect(base_url="http://127.0.0.1:3456")
print(client.instance_status())
```

You can also set the daemon URL with an environment variable:

```bash
export PYNEURODESK_BASE_URL=http://127.0.0.1:3456
```

## Useful environment variables

- `PYNEURODESK_BASE_URL`: connect to an existing daemon
- `PYNEURODESK_CACHE_DIR`: choose where PyNeurodesk stores daemon state and shell sessions
- `PYNEURODESK_CCVM`: use a specific `ccvm` daemon binary
- `PYNEURODESK_HTTP_TIMEOUT`: set the HTTP timeout in seconds
- `PYNEURODESK_BOOT_TIMEOUT`: set the VM boot timeout in seconds
- `PYNEURODESK_RELEASES_DIR`: use local Neurodesk release metadata
- `PYNEURODESK_RELEASES_API`: use a custom release metadata API endpoint

## Troubleshooting

### The first run is slow

This is expected. PyNeurodesk may need to download the container, Linux kernel, emulator, and image metadata. Try the same command again after the first run completes.

### The container daemon cannot start

Check that virtualization is available on your machine. On Linux, confirm that KVM is available and that your user has permission to use it.

### A command cannot see my data

Share the directory with `nd.share_dir()` in Python, or run the command from a directory that the active shell session can mount. If the tool needs to write outputs, make the share writable.

### I want to run fulltest recipes

Install the optional fulltest dependencies:

```bash
python -m pip install "neurodesk[fulltest]"
```

Then use the `pyneurodesk-fulltest` command.
