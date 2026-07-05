# 🚀 GPU Dashboard Deployment

A lightweight, containerized dashboard for monitoring GPU utilization and health in real-time. This project uses Docker Compose and includes a deployment manager script for easy updates and maintenance.

## 📋 Prerequisites

Before deploying, ensure your host machine meets the following requirements:

- **Docker & Docker Compose**: Installed and running.
- **NVIDIA Drivers**: Latest stable drivers installed on the host.
- **NVIDIA Container Toolkit**: Essential for allowing Docker containers to access the GPU hardware.
  - [Installation Guide for NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone <your-repo-url>
cd <repo-folder>
```

### 2. Set Permissions
Make the deployment manager script executable:
```bash
chmod +x deployment.sh
```

### 3. Launch the Manager
Run the interactive deployment script to start the dashboard:
```bash
./deployment.sh
```

---

## 🛠 Deployment Manager Guide

Instead of running raw Docker commands, use `./deployment.sh` to manage your instance. The manager provides the following options:

| Option | Action | Description |
| :--- | :--- | :--- |
| **1** | ⚡ **Quick Update** | Pulls the latest code and images, then restarts containers without deleting data. |
| **2** | ⚠️ **Full Reinstall** | Wipes all volumes and orphans, then performs a fresh installation. **(Destructive)** |
| **3** | 📊 **Check Status** | Displays the current running state of the GPU dashboard container. |
| **4** | 🚪 **Exit** | Closes the manager. |

---

## ⚙️ Technical Configuration

### Network & Access
- **Port**: The dashboard is accessible on port `1312`.
- **URL**: `http://<your-server-ip>:1312`

### Resource Limits & Specifications
- **Image**: `ghcr.io/psalias2006/gpu-hot:1.9.0`
- **CPU Limit**: 1.0 Core
- **Memory Limit**: 512MB
- **GPU Access**: Full access to all available NVIDIA GPUs.
- **Host Integration**: Runs with `pid: "host"` and `init: true` to accurately monitor system-level GPU metrics.

### Healthcheck
The system automatically monitors the health of the dashboard via:
`GET http://localhost:1312/api/gpu-data`

---

## 🚨 Troubleshooting

**Container failing to start?**
Check if the NVIDIA Container Toolkit is installed by running:
```bash
docker run --rm --runtime=nvidia --gpus all nvidia/cuda:11.0.3-base-ubuntu20.04 nvidia-smi
```
If this command fails, the dashboard will not be able to access your GPUs.

**Logs**
To view real-time logs for debugging, run:
```bash
docker compose -f docker-compose/docker-compose.yaml logs -f
```

---

## ❤️ Acknowledgements

This deployment is based on the excellent work done by [psalias2006](https://github.com/psalias2006/gpu-hot). The dashboard image and core functionality are provided by the **gpu-hot** project.