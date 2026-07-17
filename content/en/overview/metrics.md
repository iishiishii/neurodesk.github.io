---
title: "Metrics"
linkTitle: "Metrics"
weight: 7
aliases:
- /docs/overview/metrics

description: >-
     User metrics, analytics and service uptime
---

## User locations — past 28 days
This Google Analytics map shows where Neurodesk users were recorded during the past 28 days.

<iframe title="Neurodesk users by location during the past 28 days" src="https://lookerstudio.google.com/embed/reporting/1b5d3da0-7a67-4440-bc3c-95bd6fd94f18/page/2VKTD" frameborder="0" style="border:0"></iframe>

## Cumulative user metrics — all time
The chart and map show cumulative Neurodesk users since tracking began. The table below lists new and cumulative users by month.

{{< user-metrics >}}

## Neurodesk App download metrics

  <iframe src="https://release-stats-graph-five.vercel.app/graph?owner=neurodesk&repo=neurodesk-app&theme=vue" frameborder="0" style="border:0"></iframe>

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



## NeurodeskEDU usage

{{< ga4-service-usage ids="neurodeskedu" intro="These statistics are generated from Google Analytics 4 for the NeurodeskEDU path." >}}

## Play usage

{{< ga4-service-usage ids="play-america,play-europe,play-australia" intro="These statistics are generated from Google Analytics 4 and reported separately for each tracked Play server." >}}

## Webapp usage metrics

{{< ga4-service-usage ids="webapp-calmar,webapp-dicompare,webapp-musclemap,webapp-qsmbly,webapp-seedseg,webapp-sct,webapp-vesselboost" intro="These statistics are generated from Google Analytics 4 for each hosted Neurodesk webapp, separated by the tracked host." >}}

## Uptime metrics

{{< uptime-metrics >}}
