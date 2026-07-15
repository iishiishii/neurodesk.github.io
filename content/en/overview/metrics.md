---
title: "Metrics"
linkTitle: "Metrics"
weight: 7
aliases:
- /docs/overview/metrics

description: >-
     User metrics, analytics and service uptime
---

## User metrics
The chart shows the cumulative number of Neurodesk users over time, the map shows where users are located, and the table below lists the number of new users acquired each month.

{{< user-metrics >}}

## Analytics of users in the last 28 days
<iframe title="Google Analytics report" src="https://lookerstudio.google.com/embed/reporting/1b5d3da0-7a67-4440-bc3c-95bd6fd94f18/page/2VKTD" frameborder="0" style="border:0"></iframe>

## Neurodesk App download metrics
<img src="{{< relurl "/static/docs/overview/neurodeskapp_metrics.png" >}}" width="95%">

## Docker metrics
Total Neurodesktop container pulls: ![Docker Pulls](https://img.shields.io/docker/pulls/vnmd/neurodesktop)

## Github metrics
| Repository                                                                      | Stars                                                                      | Open issues                                                                     | Last Commit                                                                      |
| --------------------------------------------------------------------------------| -------------------------------------------------------------------------- | ------------------------------------------------------------------------------- | -------------------------------------------------------------------------------- |
| [neurodesktop](https://github.com/neurodesk/neurodesktop)                       | ![](https://img.shields.io/github/stars/neurodesk/neurodesktop)            | ![](https://img.shields.io/github/issues-raw/neurodesk/neurodesktop)            | ![](https://img.shields.io/github/last-commit/neurodesk/neurodesktop)            |
| [neurocommand](https://github.com/neurodesk/neurocommand)                       | ![](https://img.shields.io/github/stars/neurodesk/neurocommand)            | ![](https://img.shields.io/github/issues-raw/neurodesk/neurocommand)            | ![](https://img.shields.io/github/last-commit/neurodesk/neurocommand)            |
| [neurocontainers](https://github.com/neurodesk/neurocontainers)                 | ![](https://img.shields.io/github/stars/neurodesk/neurocontainers)         | ![](https://img.shields.io/github/issues-raw/neurodesk/neurocontainers)         | ![](https://img.shields.io/github/last-commit/neurodesk/neurocontainers)         |
| [transparent-singularity](https://github.com/neurodesk/transparent-singularity) | ![](https://img.shields.io/github/stars/neurodesk/transparent-singularity) | ![](https://img.shields.io/github/issues-raw/neurodesk/transparent-singularity) | ![](https://img.shields.io/github/last-commit/neurodesk/transparent-singularity) |
| [neurodeskEDU](https://github.com/neurodesk/neurodeskedu)                       | ![](https://img.shields.io/github/stars/neurodesk/neurodeskedu)       | ![](https://img.shields.io/github/issues-raw/neurodesk/neurodeskedu)       | ![](https://img.shields.io/github/last-commit/neurodesk/neurodeskedu)       |
| [neurodesk.github.io](https://github.com/neurodesk/neurodesk.github.io)         | ![](https://img.shields.io/github/stars/neurodesk/neurodesk.github.io)     | ![](https://img.shields.io/github/issues-raw/neurodesk/neurodesk.github.io)     | ![](https://img.shields.io/github/last-commit/neurodesk/neurodesk.github.io)     |
| [neurodesk-app](https://github.com/neurodesk/neurodesk-app)                     | ![](https://img.shields.io/github/stars/neurodesk/neurodesk-app)           | ![](https://img.shields.io/github/issues-raw/neurodesk/neurodesk-app)           | ![](https://img.shields.io/github/last-commit/neurodesk/neurodesk-app)           |



## NeurodeskEDU and Play usage
These service-specific statistics are generated from Google Analytics 4 and separated by the tracked host or path.

{{< ga4-service-usage ids="neurodeskedu,play-america,play-europe,play-australia" >}}

## Webapp usage metrics
These statistics are generated from Google Analytics 4 for each hosted Neurodesk webapp, separated by the tracked host.

{{< ga4-service-usage ids="webapp-calmar,webapp-dicompare,webapp-musclemap,webapp-qsmbly,webapp-seedseg,webapp-sct,webapp-vesselboost" >}}

## Uptime metrics

{{< uptime-metrics >}}
