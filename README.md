# system-monitor  
*A Modular Linux System Monitoring & Backup Utility*

![Status](https://img.shields.io/badge/Status-Active-brightgreen)
![Shell](https://img.shields.io/badge/Shell-Bash-blue)
![Platform](https://img.shields.io/badge/Platform-Linux-lightgrey)
![Project](https://img.shields.io/badge/Course-CIML019-orange)

**system-monitor** is a modular Bash-based toolkit designed to monitor system health, track user activity, perform incremental backups, verify backup integrity, generate filesystem usage reports, and analyse running processes.

This project was developed for **CIML019 – Software-Defined Infrastructure & Services (Assignment 1)**.

---

## Table of Contents

1. [Overview](#overview)  
2. [Project Structure](#project-structure)  
3. [Installation](#installation)  
4. [Module Overview](#module-overview)  
5. [Settings Configuration](#settings-configuration)  
6. [Features](#features)  
7. [Notes / Limitations](#notes--limitations)  

---

## Overview

system-monitor provides the following core functions:

- System resource monitoring  
- User session tracking with multi-session detection  
- Incremental backups using `rsync`  
- Trash-based deleted file retention  
- Backup integrity verification  
- Filesystem usage reports  
- Process analysis (CPU, memory, long-running processes)  
- Centralised logging with timestamps  
- Clean, colour-coded ASCII UI layout

---

## Project Structure

```
system-monitor/
├── monitor.sh                  # Main launcher & menu controller
│
├── lib/                        # Functional modules
│   ├── ui.sh                   # UI helpers (boxes, colours, formatting)
│   ├── resources.sh            # CPU, RAM, disk monitoring
│   ├── users.sh                # User session tracking
│   ├── backup.sh               # Incremental backup + trash + verification
│   ├── filesystem.sh           # Filesystem usage analysis
│   ├── process.sh              # Process monitoring (CPU/MEM/ETIME)
│   └── logging.sh              # Logging helper + VERBOSE debug mode
│
├── config/
│   └── settings.conf           # User configuration overrides
│
├── backups/
│   ├── data/                   # Timestamped backups
│   └── trash/                  # Deleted files with timestamps
│
├── logs/
│   └── system_monitor.log      # Centralised log file
│
├── reports/                    # Filesystem usage reports (.txt)
├── screenshots/                # Screenshot images used in README
└── README.md                   # Documentation
```

---

## Installation

### 1. Clone the project

```bash
git clone https://github.com/oligokz/system-monitor.git
cd system-monitor
```

### 2. Make the main script executable

```bash
chmod +x monitor.sh
```

### 3. Install dependencies

```bash
sudo apt install rsync procps coreutils
```

All required directories (`backups`, `logs`, `reports`) are created automatically on first run.

---

## Module Overview

### ui.sh  
Provides UI helpers (boxes, colours, formatting).

### resources.sh  
CPU load, RAM usage, disk usage monitoring.

### users.sh  
Displays logged-in users, session duration, and multi-session detection.

### backup.sh  
Handles incremental backups, trash retention, timestamping, and verification.

### filesystem.sh  
Generates filesystem usage reports.

### process.sh  
Shows top CPU/memory usage processes and detects long-running processes.

### logging.sh  
Logging helper (timestamps) + `VERBOSE=1` debug mode support.

---

## Settings Configuration

Configuration file:

```
config/settings.conf
```

Default:

```ini
BACKUP_SOURCE="/home"
BACKUP_DEST="/backups/data"
VERBOSE=0
```

### Setting Descriptions

- **BACKUP_SOURCE** – Folder to back up  
- **BACKUP_DEST** – Destination folder for incremental backups  
- **VERBOSE** – Enables debug output (0 = off, 1 = on)

### Example screenshot

![Settings Example](screenshots/settings.png)

---

## Features

### 1. System Resource Monitoring  
Shows CPU load, RAM usage, disk usage, warnings.  
![System Resources](screenshots/system-resources.png)

---

### 2. User Activity Tracking  
Displays users, login durations, multi-session detection.  
![User Activity](screenshots/user-activity.png)

---

### 3. Incremental Backup  
Uses rsync for safe, timestamped backups.  
![Backup Start](screenshots/backup-start.png)  
![Backup Success](screenshots/backup-success.png)

---

### 4. Backup Integrity Verification  
Detects missing files, mismatches, and inconsistencies.  
![Verify Pass](screenshots/verify-pass.png)  
![Verify Fail](screenshots/verify-fail.png)

---

### 5. Filesystem Usage Report  
Generates largest directory lists, file counts, summaries.  
![Filesystem Report](screenshots/filesystem-report.png)

---

### 6. Process Analysis  
Shows CPU/memory top processes and long-running ones.  
![Process Analysis](screenshots/process-analysis.png)

---

## Notes / Limitations

- Filesystem report may run slowly on large paths  
- Trash folder grows indefinitely (manual cleanup required)  
- Verification may fail if files change during comparison  
- Symlink/device file behaviour may vary  
- No automatic cleanup of logs/backups  
- Log file resets on each run  

---
