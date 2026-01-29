---
title: "Greatlakes"
linkTitle: "Greatlakes"
weight: 3
description: >
  Use Neurodesk on Greatlakes - the HPC at University of Michigan
---

{{< toc >}}

### Setup on a desktop
```
module load singularity
# now change to a directory with enough storage, e.g. /nfs/turbo/username
git clone https://github.com/neurodesk/neurocommand.git 
cd neurocommand 
pip3 install -r neurodesk/requirements.txt --user 
bash build.sh --cli
bash containers.sh
export SINGULARITY_BINDPATH=`pwd -P`
bash containers.sh itksnap
# now select a version of itksnap to install. For this copy and paste the installation
echo "module load singularity" >> ~/.bashrc
echo "module use $PWD/local/containers/modules/" >> ~/.bashrc
echo "export SINGULARITY_BINDPATH=/nfs/,/scratch/" >> ~/.bashrc
```

### Setup on with a jupyter notebook
Start new Jupyter notebook by entering "load singularity" in the Module Commands field:

![image](https://github.com/user-attachments/assets/8c54a2a5-57db-4e43-9504-5c4b5e1278c1)

Then run these commands:
```
!pip install jupyterlmod

# Restart the kernel by clicking Kernel -> Restart Kernel

import module
await module.load('niimath')
```

