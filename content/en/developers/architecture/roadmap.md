---
title: "Project Roadmap"
linkTitle: "Roadmap"
weight: 100
description: >-
     This page outlines our development priorities for Neurodesk. If any of these sound exciting to you, get in touch and we'll help you become a contributor!
---

Our detailed task tracking lives on the [Neurodesk Project Board](https://github.com/orgs/neurodesk/projects/9/views/4). Below is a summary of the larger themes guiding development.

---

## Streamlining the container build and release process

### Improving the workflow for adding new applications

We have built a [container builder UI](https://neurodesk.org/neurocontainers-ui/) that lets contributors define new applications interactively. We continue to improve this workflow and the underlying GitHub Actions pipelines to make it even easier to add, test, and publish containers.

### Standardizing container deployment

Container deployment currently relies on a chain of custom scripts spread across several repositories. We want to adopt community-standard tools like [SHPC](https://singularity-hpc.readthedocs.io/) to reduce duplication and maintenance burden.

Related issues:

- [Use SHPC to manage singularity containers and build module files](https://github.com/neurodesk/transparent-singularity/issues/7)
- [Make the module system more flexible](https://github.com/neurodesk/neurocommand/issues/152)
- [Sign commits and containers we build](https://github.com/neurodesk/neurocontainers/issues/504)

### Reuse and citability of containers

There is currently no good way to describe and cite individual software containers. We want to increase the reusability and citability of Neurodesk containers through better metadata and tooling.

Related issues:

- [Metadata and a database for all containers](https://github.com/neurodesk/neurocontainers/issues/218)
- [Boutiques descriptors for containers](https://github.com/neurodesk/neurocontainers/issues/217)

---

## Improving user experience

### Documentation and tutorials

The [education platform](https://neurodesk.org/edu/) hosts both static tutorials and interactive notebooks, with an integrated review system to help maintain tutorial quality. We want to continue expanding coverage of neuroimaging workflows and improve automated testing of tutorial content.

### Teaching and workshops

Neurodesk is a great fit for teaching neuroimaging methods, but it's not yet easy to run a custom instance for a larger group. We want to make it simpler to deploy Neurodesk for classes and workshops with shared data storage, autoscaling, ARM processor support, and multi-cloud compatibility (Google Cloud, AWS, Azure, OpenStack, OpenShift).

---

## Expanding platform capabilities

### Container and application improvements

We are actively working on expanding the container ecosystem, including logging, labelling, and porting existing containers to ARM architecture.

Current work in progress:

- [Logging of container runs](https://github.com/neurodesk/neurodesktop/issues/336)
- [Container labelling](https://github.com/neurodesk/neurodesktop/issues/347)
- [Port existing containers to ARM](https://github.com/neurodesk/neurocontainers/issues/1252)

### Migration to Jupyter Book v2

We are migrating to Jupyter Book v2, along with UI improvements for the learning experience.

Current work in progress:

- [Update to Jupyter Book v2](https://github.com/neurodesk/neurodeskedu/issues/10)
- [Adding home button to Jupyter 2](https://github.com/neurodesk/neurodeskedu/issues/25)
- [Dropdown launcher for play servers](https://github.com/neurodesk/neurodeskedu/issues/26)

### Desktop environment and app improvements

We are working on improving the desktop environment and the Neurodesk application experience.

Current work in progress:

- [Use LXQt for desktop](https://github.com/neurodesk/neurodesktop/issues/320)
- [Getting started notebook as startup page](https://github.com/neurodesk/neurodesktop/issues/319)
- [Safari copy/paste fix](https://github.com/neurodesk/neurodesktop/issues/101)

---

## Get involved

Check the [project board](https://github.com/orgs/neurodesk/projects/9/views/4) for the full list of open tasks, or see our [contribution guide](/overview/contribute/) to get started.