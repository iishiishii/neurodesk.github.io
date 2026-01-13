---
title: "Sherlock"
linkTitle: "Sherlock"
weight: 3
description: >
  Use Neurodesk on Sherlock - the HPC at Stanford University
---

{{< toc >}}

## Using Neurodesk containers interactively

<!-- markdown-link-check-disable -->
Neurodesk runs on Stanfords supercomputer "Sherlock". To access neurodesk tools you need to be in an interactive job (e.g. via Open On-Demand: https://ondemand.sherlock.stanford.edu/)
<!-- markdown-link-check-enable -->

You can module use the neurodesk modules (if they have been installed before - see instructions for installing and updating below):
```bash
module use /home/groups/polimeni/modules
export APPTAINER_BINDPATH=/scratch,/tmp
```

Now you can list all modules (Neurodesk modules are the first ones in the list):
```bash
ml av
```

Or you can module load any tool you need:
```bash
ml fsl/6.0.7.18
```

## Using GUI applications

First you need to connect to Sherlock with SSH forwarding (e.g. from a Linux machine or from your local neurodesk)
```bash
ssh -X YOUR_USER_NAME@login.sherlock.stanford.edu
```
and then request an interactive job:
```bash
sh_dev
ml mrtrix3
mrview
```

NOTE: If you are using AFNI then the default detach behavior will cause SIGBUS errors and a crash. To fix this run AFNI with:
```bash
afni -no_detach
```

NOTE: MRIQC has its $HOME variable hardcoded to be /home/mriqc. This leads to problems. A workaround is to run this before mriqc:
```bash
export neurodesk_singularity_opts="--home $HOME:/home"
```

## GPU support
request a GPU and then add --nv option:
```bash
sh_dev -g 1
module load fsl/6.0.5.1
export neurodesk_singularity_opts='--nv'
eddy_cuda9.1
```

## Visualization in the File Browser and notebooks of Jupyter Lab
Start a jupyter lab session and then install this:
```bash
pip install jupyterlab_niivue ipyniivue
```


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

## Installing Neurodesk for a lab
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
```bash
cd /home/groups/polimeni/neurodesk
git pull
bash build.sh
bash containers.sh
```


