---
title: "Google Colab and Cloud Shell"
weight: 2
linkTitle: "Google"
aliases:
- /docs/getting-started/neurocontainers/googleColab
- /docs/getting-started/neurocontainers/googlecolab
- /docs/getting-started/hosted/googlecolab

description: >
  Neurodesk Singularity Containers for Google Colab
---

{{< toc >}}

## Colab

Open a notebook in Google Colab and run the following commands to set up the Neurodesk environment:

```python
import os
os.environ["LD_PRELOAD"] = "";
os.environ["APPTAINER_BINDPATH"] = "/content"
os.environ["MPLCONFIGDIR"] = "/content/matplotlib-mpldir"
os.environ["LMOD_CMD"] = "/usr/share/lmod/lmod/libexec/lmod"

!curl -J -O https://raw.githubusercontent.com/neurodesk/neurocommand/main/googlecolab_setup.sh
!chmod +x googlecolab_setup.sh
!./googlecolab_setup.sh

os.environ["MODULEPATH"] = ':'.join(map(str, list(map(lambda x: os.path.join(os.path.abspath('/cvmfs/neurodesk.ardc.edu.au/neurodesk-modules/'), x),os.listdir('/cvmfs/neurodesk.ardc.edu.au/neurodesk-modules/')))))
```

Once this setup is completed, you can list the available Neurodesk applications like this:
```python
import lmod
await lmod.avail()
```

and use applications like this:
```python
await lmod.load('fsl/6.0.4')
!bet
```

This notebook demonstrates how to use all Neurodesk applications in Google Colab: 
https://colab.research.google.com/drive/1g5cnZxj1llRaHmOs4xSglqsXnFkQYuol?usp=sharing

<img width="971" alt="image" src="https://user-images.githubusercontent.com/4021595/216230682-5f12f5d9-32fe-4174-9994-b257d26cfc06.png">

This is a google colab notebook that shows how to integrate with google drive and contains an example how to run fMRIprep in google colab:
https://colab.research.google.com/drive/11wVBkjNvrzo2TkUAILtWnPumAeFAfqkl?usp=sharing

and more examples can be found [in our example library](https://neurodesk.org/edu)

## Cloud Shell

This also works in a google cloud shell, e.g. for an interactive tutorial in google cloud cloudshell launch-tutorial:

First run this:
```bash
curl -J -O https://raw.githubusercontent.com/neurodesk/neurocommand/main/googlecloudshell_setup.sh
chmod +x googlecloudshell_setup.sh
./googlecloudshell_setup.sh
```

and then used in a tutorial.md:
```markdown
# My First fsl Tutorial in cloudshell

## Step 1: Say Hello
Run the following command to print a message:

```bash
module use /cvmfs/neurodesk.ardc.edu.au/neurodesk-modules/*
ml fsl
bet
```

The tutorial can be started via:
```bash
cloudshell launch-tutorial tutorial.md
```

Or via a URL:
```
https://ssh.cloud.google.com/cloudshell/editor?cloudshell_git_repo=REPO_URL&cloudshell_tutorial=path/to/tutorial.md
```
where 
cloudshell_git_repo: The URL of the Git repository to clone and
cloudshell_tutorial: The relative path to the markdown file inside that repo.
