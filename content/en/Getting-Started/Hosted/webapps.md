---
title: "Webapps"
linkTitle: "Webapps"
weight: 4
aliases:
- /docs/getting-started/hosted/webapps
description: >
  Browser-based Neurodesk webapps
---

Neurodesk offers a set of browser-native webapps for protocol comparison, QSM processing, medical image segmentation and many more tasks. They run directly in the browser, so there is no desktop installation step before you can start working.

Privacy and sensitive data: Files are processed locally in the browser and are NOT uploaded to a server or cloud service. In practice, your data stays on your machine while the app is running, which makes these tools well suited to sensitive patient data workflows.


{{< toc >}}

## CALMaR Co-designed Automated Lesion Mapping and Reporting

<a href="https://calmar.neurodesk.org/" target="_blank" rel="noopener noreferrer">calmar.neurodesk.org</a>

{{< webapp-usage id="calmar" >}}

CALMaR performs brain extraction, lesion masking, MNI registration, atlas overlap, functional-connectivity mapping, and reportable tables for stroke lesions.

<img src="https://github.com/user-attachments/assets/2db78ffd-187c-486f-b348-de4986e3ec71" class="img-fluid border rounded shadow-sm" alt="calmar screenshot" loading="lazy">


## dicompare

<a href="https://dicompare.neurodesk.org" target="_blank" rel="noopener noreferrer">dicompare.neurodesk.org</a>

dicompare is a browser-based tool for sharing, comparing, and validating DICOM acquisition protocols. It is useful when teams want to standardize scanner protocols across sites, compare local scans against agreed standards, and generate shareable schemas and compliance reports.

<img src="{{< relurl "/static/docs/getting-started/hosted/webapps/dicompare.png" >}}" class="img-fluid border rounded shadow-sm" alt="dicompare screenshot" loading="lazy">


## MuscleMap

<a href="https://musclemap.neurodesk.org" target="_blank" rel="noopener noreferrer">musclemap.neurodesk.org</a>

{{< webapp-usage id="musclemap" >}}

MuscleMap performs browser-based muscle segmentation from MRI data. It is designed for whole-body and regional muscle analysis and provides an interactive viewer for reviewing segmentation outputs.

<img src="{{< relurl "/static/docs/getting-started/hosted/webapps/musclemap.png" >}}" class="img-fluid border rounded shadow-sm" alt="MuscleMap screenshot" loading="lazy">


## QSMbly

<a href="https://qsmbly.neurodesk.org" target="_blank" rel="noopener noreferrer">qsmbly.neurodesk.org</a>

QSMbly provides a full Quantitative Susceptibility Mapping workflow in the browser. It supports DICOM and NIfTI input data and exposes the main preparation, masking, SWI, and QSM pipeline steps through a guided interface.

<img src="{{< relurl "/static/docs/getting-started/hosted/webapps/qsmbly.png" >}}" class="img-fluid border rounded shadow-sm" alt="QSMbly screenshot" loading="lazy">

## SeedSeg

<a href="https://seedseg.neurodesk.org/" target="_blank" rel="noopener noreferrer">seedseg.neurodesk.org</a>

SeedSeg performs browser-based segmentation of intraprostatic gold fiducial markers in prostate MRI using a 3D U-Net model. It supports DICOM and NIfTI input data. 

<img src="https://github.com/user-attachments/assets/0cdfe3d6-77e0-483a-a64a-763337bc03b2" class="img-fluid border rounded shadow-sm" alt="SeedSeg screenshot" loading="lazy">

## Spinal Cord Toolbox 

<a href="https://sct.neurodesk.org" target="_blank" rel="noopener noreferrer">sct.neurodesk.org</a>

{{< webapp-usage id="sct" >}}

This is a browser-based implementation of the Spinal Cord Toolbox MRI segmentation workflows.

<img src="https://github.com/user-attachments/assets/496b35d2-fa8b-4e04-a628-21aab752b9d9" class="img-fluid border rounded shadow-sm" alt="QSMbly screenshot" loading="lazy">

## VesselBoost

<a href="https://vesselboost.neurodesk.org" target="_blank" rel="noopener noreferrer">vesselboost.neurodesk.org</a>

{{< webapp-usage id="vesselboost" >}}

VesselBoost is a browser-based blood vessel segmentation tool. It combines preprocessing and inference steps in a guided workflow so users can segment vessel structures from MRI angiography data directly on their own machine.

<img src="{{< relurl "/static/docs/getting-started/hosted/webapps/vesselboost.png" >}}" class="img-fluid border rounded shadow-sm" alt="VesselBoost screenshot" loading="lazy">
