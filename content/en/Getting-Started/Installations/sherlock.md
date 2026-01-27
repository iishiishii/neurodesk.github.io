---
title: "Sherlock"
linkTitle: "Sherlock"
weight: 3
description: >
  Use Neurodesk on Sherlock - the HPC at Stanford University
---

Neurodesk runs on Stanfords supercomputer "Sherlock" and below are different ways of accessing it.

{{< toc >}}


# Using Neurodesk on Sherlock via ssh

## Using Neurodesk containers
Setup your ~/.ssh/config
```
Host sherlock
    ControlMaster auto
    ForwardX11 yes
    ControlPath ~/.ssh/%l%r@%h:%p
    HostName login.sherlock.stanford.edu
    User <sunetid> 
    ControlPersist yes
```
and then connect to sherlock
```
ssh sherlock
```

You can module use the neurodesk modules (if they have been installed before - see instructions for installing and updating below):
```bash
module use /home/groups/polimeni/modules
export APPTAINER_BINDPATH=/scratch,/tmp
```

You can also add these to your ~/.bashrc:
```
echo "module use /home/groups/polimeni/modules/" >> ~/.bashrc
echo "export APPTAINER_BINDPATH=/scratch,/tmp" >> ~/.bashrc
```

Now you can list all modules (Neurodesk modules are the first ones in the list):
```bash
ml av
```

Or you can module load any tool you need:
```bash
ml fsl/6.0.7.18
```

## Submitting a job:

put this in a file, e.g. `submit.sbatch`:
```
#!/bin/bash
#
#SBATCH --job-name=test
#SBATCH --time=47:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem-per-cpu=2G
#SBATCH --output=test_job.%j.out
#SBATCH --error=test_job.%j.err
#SBATCH -p normal

module use /home/groups/polimeni/modules/
module load ants
```

use sh_part to see which partitions and limits are available:
```
sh_part
```

then submit:
```
sbatch submit.sbatch
```

check:
```
squeue -u $USER
```

cancel jobs:
```
scancel <jobid>
```
more details https://www.sherlock.stanford.edu/docs/user-guide/running-jobs/#example-sbatch-script


## Using GUI applications
First you need to connect to Sherlock with SSH forwarding (e.g. from a Linux machine or from your local neurodesk or from a mac with https://www.xquartz.org/ installed, or from windows using Mobaxterm)

and then request an interactive job and start the software:
```bash
sh_dev
ml mrtrix3
mrview
```

## GPU support
request a GPU and then add --nv option:
```bash
sh_dev -g 1
module load fsl/6.0.5.1
export neurodesk_singularity_opts='--nv'
eddy_cuda9.1
```

## GPU support for GUIs (not yet working!)
on macos:
```
brew install --cask xquartz
brew install --cask virtualgl
```

```
vglconnect user@server
vglrun [application_name]
```




# Using Neurodesk on Sherlock via Ondemand
<!-- markdown-link-check-disable -->
Open a jupyterlab session via Open On-Demand: https://ondemand.sherlock.stanford.edu/
<!-- markdown-link-check-enable -->
![Ondemand Jupyterlab](/static/docs/installations/ondemand-jupyterlab.png)

## Installing jupyterlab plugins:
open a terminal in jupyterlab and install:
```bash
pip install jupyterlab_niivue ipyniivue jupyterlmod
```
After the installation finished restart the jupyterlab session in Ondemand.

## Neuroimaging Visualization in the File Browser and notebooks of Jupyter Lab
The `pip install jupyterlab_niivue` added an extension to jupyterlab that visualizes neuroimaging data directly via a double-click in the filebrowser in jupyterlab:
![alt text](/static/docs/installations/jupyter-lab-niivue.png)

## Using containers inside a jupyter notebook
The install of `pip install jupyterlmod` made the following possible inside a jupyter notebook:
```python
import module
await module.load('niimath')
```

## Using niivue inside a jupyter notebook:
The install of `pip install ipyniivue` allows interactive visualizations inside jupyter notebooks: See examples here https://niivue.github.io/ipyniivue/gallery/index.html





# Using Neurodesk via a full neurodesktop session
## starting
```bash
bash connectSherlock.sh
```

connect:
```bash
connectSherlock
```

## updating the desktop image
```bash
cd /home/groups/polimeni/neurodesk
apptainer pull docker://ghcr.io/neurodesk/neurodesktop/neurodesktop:2026-01-26
ln -s /home/groups/polimeni/neurodesk/neurodesktop_2026-01-26.sif /home/groups/polimeni/neurodesk/neurodesktop_latest.sif 
```

## manual start in a job
```bash
apptainer run \
   --fakeroot \
   --nv \
   --overlay ~/neurodesktop-overlay.img \
   --bind /home/groups/polimeni/neurodesk/local/containers/:/neurodesktop-storage/containers \
   --no-home \
   --home ~/neurodesktop-home:/home/jovyan \
   --env CVMFS_DISABLE=true \
   --env NB_UID=$(id -u) \
   --env NB_GID=$(id -g) \
   --env NEURODESKTOP_VERSION=test_2026-01-26 \
   /home/groups/polimeni/neurodesk/neurodesktop-test_2026-01-26.sif \
   start-notebook.py --allow-root
```

# connecting with VScode
VScode does not work on he login nodes due to resource restrictions. It might be possible to run it inside a compute job and inside a container.

# connecting with Cursor
Cursor does not work on the login nodes due to resource restrictions. It might be possible to run it inside a compute job and inside a container.

# using coding agents on sherlock
Copilot CLI — an extension of GitHub Copilot that answers natural-language prompts and generates shell commands and code snippets interactively in the CLI. Integrates with developer workflow and git metadata, good at scaffolding repo-level changes. Use this for drafting Slurm scripts, shell-based data-movement commands, Makefiles, container entrypoints, and succinct code edits from the terminal. Caution: always validate generated shell commands before running on Oak.
```
ml copilot-cli
copilot
```

Gemini CLI — a CLI assistant that can generate code from Google’s Gemini family of models (via Google Cloud/Vertex AI or client tooling). Provides strong multilingual reasoning and contextual code completion. Use this for translating research intent into cloud and hybrid workflows, generating code for TPU/GPU workloads, and producing infrastructure-as-code snippets that tie to GCP resources. Caution: always confirm data residency and compliance requirements for sensitive data.
```
ml gemini-cli
gemini
```

Claude Code (Claude family) — a coding-specialized variant in the Anthropic Claude model family aimed at code generation, refactoring, and reasoning tasks. Provides conversational reasoning about code, multi-step planning for algorithmic tasks, and safer-response tuning relative to generic models. Caution: check private endpoints/dedicated instances before sending sensitive datasets.
```
ml claude-code
claude
```

Codex — an OpenAI model family good at producing short code snippets, language translations, and API glue, historically the basis for many coding assistants. Use this for scaffold code, translating pseudocode to working scripts, and generating wrappers for system calls and schedulers. Caution: watch out for API hallucinations and insecure shell usage suggestions; verification in GPT-4 (which often supersedes Codex in capability and safety) advised.
```
ml codex
codex
```

Crush CLI — an all-around CLI assistant from the Charmbracelet Go-based “ecosystem” intended to improve interactive developer workflows and scripting. Use it for interactive shells or task runners, pipeline composition for local data preprocessing, productivity (nicer prompts, piping primitives, nicer output formatting), or small automation tasks such as repo tooling and glue scripts.
```
ml crush
crush
```

# Misc

## note on miniconda
we need an older version of Miniconda on Sherlock due to the outdated glibc:
```
wget https://repo.anaconda.com/miniconda/Miniconda3-py310_23.3.1-0-Linux-x86_64.sh
bash Miniconda3-py310_23.3.1-0-Linux-x86_64.sh
```

## note on MRIQC
NOTE: MRIQC has its $HOME variable hardcoded to be /home/mriqc. This leads to problems. A workaround is to run this before mriqc:
```bash
export neurodesk_singularity_opts="--home $HOME:/home"
```

## note on AFNI
NOTE: If you are using AFNI then the default detach behavior will cause SIGBUS errors and a crash. To fix this run AFNI with:
```bash
afni -no_detach
```

# Data transfer
## Transfer files to and from Onedrive
First install rclone on your computer and set it up for onedrive. Then copy the config file ~/.config/rclone/rclone.conf to sherlock. Then run rclone on sherlock:
```
ml system
ml rclone
rclone ls 
rclone copy
```

### setting up rclone for onedrive (needs to be done on a computer with a browser, so not sherlock):
```bash 
rclone config
# select n for new remote
# enter a name, e.g. onedrive
# select one drive from the list, depending on the rclone version this could be 38
# hit enter for default client_id
# hit enter for default client_secret
# select region 1 Microsoft Global
# hit enter for default tenant
# enter n to skip advanced config
# enter y to open a webbrowser and authenticate with onedrive
# enter 1 for config type OneDrive Personal or Business
# hit enter for default config_driveid
# enter y to accept
# enter y again to confirm
# then quit config q
# now test:
rclone ls onedrive:
# if it's not showing the files from your onedrive, change the config_driveid in ~/.config/rclone/rclone.conf
vi ~/.config/rclone/rclone.conf
```

## Transfer files using datalad
```
ml contribs
ml poldrack
ml datalad-uv
datalad
```

## Transfer files via scp
``` 
scp foo <sunetid>@dtn.sherlock.stanford.edu:
# this file will end up in your scratch space
```

# Managing Neurodesk on Sherlock
## Installing Neurodesk for a lab
This is already done and doesn't need to be run again!
```bash
cd /home/groups/polimeni/
git clone https://github.com/neurodesk/neurocommand.git neurodesk
cd neurodesk 
pip3 install -r neurodesk/requirements.txt --user 
bash build.sh --cli
bash containers.sh
export APPTAINER_BINDPATH=`pwd -P`
```

## Installing additional containers
Everyone has write permissions and can download and install new containers.
```bash
cd /home/groups/polimeni/neurodesk
git pull
bash build.sh
bash containers.sh
# to search for a container:
bash containers.sh freesurfer
# then install the choosen version by copy and pasting the specific command install command displayed
```

## Updating Neurodesktop image
```
```



