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
module use ...
export APPTAINER_BINDPATH=/scratch,/tmp
```

Now you can list all modules (Neurodesk modules are the first ones in the list):
```bash
ml av
```

Or you can module load any tool you need:
```bash
ml qsmxt/6.4.1
```

If you want to use GUI applications (fsleyes, afni, suma, matlab, ...) you need to overwrite the temporary directory to be /tmp (otherwise you get an error that it cannot connect to the DISPLAY):
```bash
export TMPDIR=/tmp 
```

For matlab you also need to create a network license file in your ~/Downloads/network.lic:
```bash
cat <<EOF > ~/Downloads/network.lic
SERVER uq-matlab.research.dc.uq.edu.au ANY 27000
USE_SERVER
EOF
```

NOTE: If you are using AFNI then the default detach behavior will cause SIGBUS errors and a crash. To fix this run AFNI with:
```bash
afni -no_detach
```

NOTE: MRIQC has its $HOME variable hardcoded to be /home/mriqc. This leads to problems on Bunya. A workaround is to run this before mriqc:
```bash
export neurodesk_singularity_opts="--home $HOME:/home"
```


## Using containers inside a jupyter notebook
You need to install this in addtion:
```bash
pip install jupyterlmod
```

Then start a notebook and run these commands:
```python
import module
await module.load('niimath')
```

## Installing Neurodesk for a lab


## Updating Neurodesk for a lab


