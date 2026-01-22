---
title: "Sherlock"
linkTitle: "Sherlock"
weight: 3
description: >
  Use Neurodesk on Sherlock - the HPC at Stanford University
---

{{< toc >}}

# Using Neurodesk on Sherlock

## Using Neurodesk containers interactively

<!-- markdown-link-check-disable -->
Neurodesk runs on Stanfords supercomputer "Sherlock". To access neurodesk tools you need to be in an interactive job (e.g. via Open On-Demand: https://ondemand.sherlock.stanford.edu/)
<!-- markdown-link-check-enable -->

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
#
#SBATCH --time=10:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=2G

srun hostname
srun sleep 60
```

then submit:
```
sbatch submit.sbatch
```

check:
```
squeue -u $USER
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

## GPU support for GUIs (needs more testing)
on macos:
```
brew install --cask xquartz
brew install --cask virtualgl
```

```
vglconnect user@server
vglrun [application_name]
```

## Neuroimaging Visualization in the File Browser and notebooks of Jupyter Lab
Start a jupyter lab session in Ondemand:
![Ondemand Jupyterlab](/static/docs/installations/ondemand-jupyterlab.png)

and then install this in a new terminal:
```bash
pip install jupyterlab_niivue ipyniivue
```
After the installation finished restart the jupyterlab session in Ondemand.

This adds an extension to jupyterlab that visualizes neuroimaging data directly via a double-click in the filebrowser in jupyterlab:
![alt text](/static/docs/installations/jupyter-lab-niivue.png)


## Using containers inside a jupyter notebook
You need to install this:
```bash
pip install jupyterlmod
```

Then start a notebook and run these commands:
```python
import module
await module.load('niimath')
```

## connecting with VScode
VScode does not work on he login nodes due to resource restrictions. It might be possible to run it inside a compute job. 

## connecting with Cursor
Cursor does not work on the login nodes due to resource restrictions. It might be possible to run it inside a compute job.


## using coding agents on sherlock
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

## Misc

### note on miniconda
# we need an older version of Miniconda on Sherlock due to the outdated glibC:
```
wget https://repo.anaconda.com/miniconda/Miniconda3-py310_23.3.1-0-Linux-x86_64.sh
bash Miniconda3-py310_23.3.1-0-Linux-x86_64.sh
```

### note on MRIQC
NOTE: MRIQC has its $HOME variable hardcoded to be /home/mriqc. This leads to problems. A workaround is to run this before mriqc:
```bash
export neurodesk_singularity_opts="--home $HOME:/home"
```

### note on AFNI
NOTE: If you are using AFNI then the default detach behavior will cause SIGBUS errors and a crash. To fix this run AFNI with:
```bash
afni -no_detach
```

# Data transfer
## Transfer files to and from Onedrive
First install rclone on your computer and set it up for onedrive. Then copy the config file ~/.config/rclone/rclone.conf to sherlock. Then run rclone on sherlock:
```
ml rclone
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


