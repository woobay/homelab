<h1 tabindex="-1" dir="auto" style="bottom-border:none;"><img src="https://camo.githubusercontent.com/0b88a728a74d44cb11f842cbed1cacb61f4d67f09b3dcf5926ac4767a1bb1c27/68747470733a2f2f692e696d6775722e636f6d2f7031527a586a512e706e67" width="144px" height="144px" align="left"/>

<!-- markdownlint-disable-next-line MD013 -->
<a id="user-content-homelab" class="anchor" aria-hidden="true" href="#homelab"><svg class="octicon octicon-link" viewBox="0 0 16 16" version="1.1" width="16" height="16" aria-hidden="true"><path d="m7.775 3.275 1.25-1.25a3.5 3.5 0 1 1 4.95 4.95l-2.5 2.5a3.5 3.5 0 0 1-4.95 0 .751.751 0 0 1 .018-1.042.751.751 0 0 1 1.042-.018 1.998 1.998 0 0 0 2.83 0l2.5-2.5a2.002 2.002 0 0 0-2.83-2.83l-1.25 1.25a.751.751 0 0 1-1.042-.018.751.751 0 0 1-.018-1.042Zm-4.69 9.64a1.998 1.998 0 0 0 2.83 0l1.25-1.25a.751.751 0 0 1 1.042.018.751.751 0 0 1 .018 1.042l-1.25 1.25a3.5 3.5 0 1 1-4.95-4.95l2.5-2.5a3.5 3.5 0 0 1 4.95 0 .751.751 0 0 1-.018 1.042.751.751 0 0 1-1.042.018 1.998 1.998 0 0 0-2.83 0l-2.5 2.5a1.998 1.998 0 0 0 0 2.83Z"></path></svg></a>
Homelab
</h1>

> K8S cluster built with Cloud Init and managed using Flux for GitOps

<div align="center">


[![k8s](https://img.shields.io/badge/k8s-v1.29.2-blue?style=flat-square&logo=kubernetes)](https://k8s.io/)&nbsp;&nbsp;&nbsp;
[![GitHub last commit](https://img.shields.io/github/last-commit/woobay/homelab/main?style=flat-square&logo=git&color=F05133)](https://github.com/woobay/homelab/commits/main)
</div>
<br/>

Welcome to my homelab!
The repository is mostly focused on a modest kubernetes cluster with one control plane and two worker nodes running all of my self hosted services and storage,
but it also serves as the Infrastructure-as-Code (IaC) for my entire home network and devices.
Ultimately, this will include all applications for managing home IT systems.




# Homelab

Projet to remake my homelab using proxmox/terraform/k8s

## 2024-05-06
* Setup Flux as a GitOps solution
* Tried creating a nfs server with TrueNas Scale running in Proxmox
* Tried to create a PV that store the data in the nfs

## 2024-05-03
* Setup cluster automaticly with cloud init config and terraform
* Finished doc for Cluster Installation

## 2024-05-02
* Tried setting up K8s cluster in the VMS
* Tried to have the cluster auto install with cloud init
* Did not managed to do it

## 2024-05-01
* Started creating the infra for the cluster with Terraform
* Setup basic vm with terraform 

## 2024-04-11
* Setup Proxmox 
* Setup TrueNas
* Setup Jellyfin
