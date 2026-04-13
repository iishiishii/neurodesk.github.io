---
title: "OpenRecon"
linkTitle: "OpenRecon"
aliases:
- /docs/getting-started/neurocontainers/openrecon

description: >
  Build Neurocontainers for OpenRecon
---

{{< toc >}}

# Building an OpenRecon Container

These instructions were tested on GitHub Codespaces, and we recommend Codespaces as a starting point.

For a local setup, install [Docker](https://www.docker.com/), Python 3, and `neurodocker`. If `neurodocker` is not already on your `PATH`, add it:

```bash
python -m pip install neurodocker

# Check whether neurodocker is already on PATH:
which neurodocker

# If not, add the appropriate local install path.
# The path depends on your local setup.
export PATH=$PATH:~/.local/lib/python3.12/site-packages/bin
export PATH=$PATH:~/.local/bin
```

## 1. Add the Python MRD server to a Neurocontainers recipe

Add the OpenRecon macro to any recipe in the [neurocontainers recipes directory](https://github.com/neurodesk/neurocontainers/tree/main/recipes):

```yaml
- include: macros/openrecon/neurodocker.yaml
```

Make sure to adjust `invertcontrast.py` for your pipeline, or replace it with the files your pipeline needs from the [Python MRD server](https://github.com/kspaceKelvin/python-ismrmrd-server).

Here is an [example Neurocontainers recipe](https://github.com/neurodesk/neurocontainers/tree/main/recipes/openreconexample).

Then build the recipe:

```bash
sf-login openreconexample --architecture x86_64
# Or:
./builder/build.py generate openreconexample --recreate --build --login --architecture x86_64 --offline_mode true
```

## 2. Test the tool inside the container and then through the MRD server

### Convert data to MRD test data

Note: enhanced DICOM and NIfTI-to-MRD conversion scripts are not yet merged into the main branch of [python-ismrmrd-server](https://github.com/kspaceKelvin/python-ismrmrd-server/pull/15).

In the meantime, get the scripts here:

- [enhanceddicom2mrd.py](https://github.com/neurodesk/neurocontainers/blob/main/recipes/musclemap/enhanceddicom2mrd.py)
- [nifti2mrd.py](https://github.com/neurodesk/neurocontainers/blob/main/recipes/musclemap/nifti2mrd.py)

Then add them to the image in `build.yaml`:

```yaml
        - copy: enhanceddicom2mrd.py /opt/code/python-ismrmrd-server/enhanceddicom2mrd.py
        - copy: nifti2mrd.py /opt/code/python-ismrmrd-server/nifti2mrd.py
```

The directory that the container is built from is mounted automatically under `/buildhostdirectory`.

```bash
cd /opt/code/python-ismrmrd-server

# For legacy DICOM data:
python3 dicom2mrd.py -o input_data.h5 PATH_TO_YOUR_DICOM_FILES

# For enhanced DICOM data:
python /opt/code/python-ismrmrd-server/enhanceddicom2mrd.py -o /buildhostdirectory/input.h5 /buildhostdirectory/enhanced_dicom_data

# For converting NIfTI data to MRD:
python3 nifti2mrd.py -i /buildhostdirectory/input_Se1_Res0.8_0.8_Spac0.8.nii -o /buildhostdirectory/input_fromNIFTI.h5
```

Start the server and client, then test the application:

```bash
python3 /opt/code/python-ismrmrd-server/main.py -v -r -H=0.0.0.0 -p=9002 -s -S=/tmp/share/saved_data &
sleep 2
python3 /opt/code/python-ismrmrd-server/client.py -G dataset -o openrecon_output.h5 input_data.h5 -c openreconexample
```

## 3. Submit the container recipe to Neurocontainers

Submit the container recipe to the [neurocontainers repository](https://github.com/neurodesk/neurocontainers/).

Here is an example: [openreconexample](https://github.com/neurodesk/neurocontainers/tree/main/recipes/openreconexample).

The container is built automatically. If the build is successful, a pull request will be opened automatically for step 4.

## 4. Submit the container to OpenRecon

Submit the container to the [openrecon repository](https://github.com/neurodesk/openrecon/).

Here is an example: [openreconexample](https://github.com/neurodesk/openrecon/tree/main/recipes/openreconexample).

## Detailed instructions for building on GitHub directly

Contributed by Kerrin Pine.

### Prerequisites

You need a public GitHub account so the container can be submitted to the public Neurodesk OpenRecon repository and built.

### Process

1. Fork [`neurodesk/neurocontainers`](https://github.com/neurodesk/neurocontainers) to your personal GitHub account. In the upper-right corner, click `Fork`. If prompted, fork to your personal GitHub account.
2. After forking, go to your forked repository, for example `github.com/YOUR_GITHUB_USERNAME/neurocontainers`.
3. Create a new codespace. In your forked repository, click the green `<> Code` button, then select `Create codespace on main`.
4. In the terminal, run `neurodocker --version`. You should see a version such as `2.0.0`.
5. Still in the terminal, run `cd recipes`, create a project directory with `mkdir projectname`, and copy the files from `recipes/openreconexample` into this new directory.
6. In `build.yaml` and `test.yaml`, change all occurrences of `openreconexample` to your own project name, and change `openreconexample.py` to `projectname.py`.
7. Follow the instructions in `build.yaml` to build.
8. Building drops you into the container itself. Follow the instructions in `test.yaml` to import your own test DICOM data into an `.h5` file for testing. In Codespaces, you can drag data from another window into the folder.
9. Continue following the instructions in `test.yaml` to start the server and send demo data to it. For example:

   ```bash
   python3 /opt/code/python-ismrmrd-server/client.py \
     -G dataset \
     -o /buildhostdirectory/output.h5 \
     /buildhostdirectory/b0map.h5 \
     -c openreconexample
   ```

   You should see the expected number of images sent from the client to the server and returned by the server. The output in `output.h5` can be viewed with the built-in H5Web viewer.
10. To check intermediate outputs for troubleshooting, open Extensions with `Ctrl+Shift+X` or the Extensions icon on the left, then install `niivue` for NIfTI image viewing in Codespaces.
11. Once the container has been thoroughly tested and you are happy with it, commit the new files and push them if you were not working on `github.com`. Do not include your demo data.
12. To build a container ready for the scanner, first open a pull request. For example: `Add projectname container for OpenRecon MRD server`. In the pull request description, include the `neurodocker.yaml` build instructions, the customized MRD Python scripts, and the Codespaces testing notes.
13. The second step is to write a recipe for [`neurodesk/openrecon`](https://github.com/neurodesk/openrecon). Because it is a separate repository, fork it, navigate to `recipes`, create a folder for your project, and add `OpenReconLabel.json` and `params.sh` with the version number. `OpenReconLabel.json` defines how the container description and UI options appear on the scanner. Then open a pull request. Updating the version number will trigger the container to be rebuilt, and instructions for downloading and installing the container will appear as an issue in that repository.

## Tips, tricks, and troubleshooting OpenRecon

### Installing and testing a new OpenRecon package

Make sure that no protocol is open, because an open protocol can prevent installation of a new package.

Copy the OpenRecon zip file into `C:\Program Files\Siemens\Numaris\OperationalManagement\FileTransfer\incoming`.

Wait for the file to disappear.

Check whether it is being installed by watching `C:\ProgramData\Siemens\Numaris\log\syngo.MR.HostInfra.OpenRecon.Watcher`.

It should first create a 0 KB text file with the container name and version.

The text file then fills to about 100-200 KB.

Once the log file is written, you can open a protocol and check whether the package is available.

Run the sequence with OpenRecon enabled and check for errors in the log viewer at `C:\ProgramData\Siemens\Numaris\log\OpenRecon.utr`.

### Do not use Prio Recon with OpenRecon

This option has to be disabled in an OpenRecon sequence:

![Prio Recon needs to be disabled](/static/docs/neurocontainers/priorecon.JPG)

Right-click `Sequence` in the Scan Queue, then select `Edit Properties` (`Alt+Enter`) and `Execution`.

### CUDA version

Make sure that you install the correct CUDA version in the container and that it does not get overwritten by a `pip install`. OpenRecon only supports CUDA 11.x.

Always double-check in the container with:

```bash
# Check that the CUDA version is valid for MARS; it must be CUDA 11.x.
python -c "import torch; print(torch.version.cuda)"
```

### Versioning of containers

OpenRecon requires container versions. For example, on the scanner, version `1.2.3` only shows the major version in the selection box, but hovering over the name shows the full version:

![Seeing the specific version of the container](/static/docs/neurocontainers/versions.JPG)

OpenRecon will not install an update to a container with the same version.

### High-performance computing license side effects

For OpenRecon to work, the `N_High_End_Computing` license must be active on the scanner.

Activating this license takes memory away from the main ICE recon system, so normal recons might run out of memory sooner. If you need this memory back, you can temporarily disable this license and OpenRecon.

Turn the license off by commenting it out. Add `#` in front of the relevant lines in `C:\Program Files\Siemens\Numaris\bin\Common\Licensing\license.dat`.

Restart the whole system. Restarting the workspace is not enough.
