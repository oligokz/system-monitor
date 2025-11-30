# SysSnapshot  
*A Modular Linux System Monitoring & Backup Utility*

![Status](https://img.shields.io/badge/Status-Active-brightgreen)
![Shell](https://img.shields.io/badge/Shell-Bash-blue)
![Platform](https://img.shields.io/badge/Platform-Linux-lightgrey)
![Project](https://img.shields.io/badge/Course-CIML019-orange)

SysSnapshot is a modular Bash-based toolkit that monitors system health, tracks user activity, performs incremental backups, verifies backup integrity, generates filesystem usage reports, and analyses running processes.

---

## Table of Contents

1. [Overview](#overview)
2. [Project Structure](#project-structure)
3. [Installation](#installation)
4. [Configuration](#configuration)
5. [Features](#features)
6. [Notes / Limitations](#notes--limitations)
7. [Conclusion](#conclusion)

---

## Overview

SysSnapshot provides the following core functions:

- System resource monitoring  
- User session tracking with multi-session detection  
- Incremental backups using `rsync`  
- Trash-based deleted file retention  
- Backup integrity verification via content comparison  
- Filesystem usage reports  
- Process analysis (top CPU/memory usage and long-running detection)  
- Centralised logging with timestamps  
- Clean, colour-coded ASCII UI layout

All modules are organised under `/lib` for clarity and maintainability.

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
│   └── process.sh              # Process monitoring (CPU/MEM/ETIME)
│
├── config/
│   └── settings.conf           # Configuration overrides
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
├── tests/                      # Test scripts & outputs
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

### 3. Install dependencies (recommended)

```bash
sudo apt install rsync procps coreutils
```

All required directories (`backups`, `logs`, `reports`) are created automatically on first run.

---

## Configuration

SysSnapshot reads its default values from:

```
config/settings.conf
```

This file allows users to customise:

- Default backup source  
- Default backup destination  
- Default filesystem scan path  
- Log file path  
- Logging verbosity  
- Verbose mode for debugging  

Here is the full configuration file:

```
# SysSnapshot configuration file

# Default source for backups (can be any directory you want to demo)
BACKUP_SOURCE="/home/$USER/documents"

# Default destination for backups (relative to project root or absolute path)
BACKUP_DEST="backups"

# Default path for filesystem report (option 5)
FS_DEFAULT_PATH="/"

# Log file location (relative to project root or absolute)
LOG_FILE="logs/system_monitor.log"

# Log level: ERROR, WARN, INFO, DEBUG
LOG_LEVEL="INFO"

# Verbose mode: "true" or "false"
VERBOSE="false"
```

### How configuration works

- When prompted for input, pressing **ENTER** automatically uses the value from `settings.conf`.
- You may edit this file to customise the behaviour of backups, logs, reporting, and verbosity.
- The script always loads this file first before running any module.

---

## Features

### 1. System Resource Monitoring (`check_system_resources`)

Displays:

- CPU load (1/5/15 min averages)  
- Memory usage (GB and %)  
- Disk usage of `/`  
- Threshold warnings  

![System Resources](screenshots/system-resources.png)

---

### 2. User Activity Tracking (`track_user_activity`)

Displays:

- Logged-in users  
- Terminal type (pts/tty)  
- Login duration  
- Multi-session detection  

![User Activity](screenshots/user-activity.png)

---

### 3. Incremental Backup (`create_incremental_backup`)

Features:

- Incremental syncing via `rsync -av`  
- Trash retention of deleted files  
- Timestamped backup folders  
- Smart detection of changed/missing files  

![Backup Start](screenshots/backup-start.png)  
![Backup Success](screenshots/backup-success.png)

---

### 4. Backup Integrity Verification (`verify_backup_integrity`)

Checks:

- File presence comparison  
- File counts  
- Content matching via `cmp -s`  

![Verify Pass](screenshots/verify-pass.png)  
![Verify Fail](screenshots/verify-fail.png)

---

### 5. Filesystem Usage Report (`generate_filesystem_report`)

Includes:

- Top 10 largest directories  
- Directory with the most files  
- Filesystem type summary  
- Disk usage overview  

![Filesystem Report](screenshots/filesystem-report.png)

---

### 6. Process Analysis (`analyze_running_processes`)

Displays:

- Top CPU processes  
- Top memory processes  
- Process state summary  
- Detection of processes running > 24 hours  

![Process Analysis](screenshots/process-analysis.png)

---

## Notes / Limitations

- Filesystem scans may run slowly on large paths.  
- Trash folder may grow indefinitely; cleanup is manual.  
- Backup verification may fail if files change mid-scan.  
- Symlink and device file behaviour may vary.  
- No automatic cleanup of old logs or backups.  
- Log file resets on each run (`logging.sh`).  

---

## Conclusion

SysSnapshot is a modular, maintainable, and fully functional Bash-based monitoring and backup utility.  
It meets the requirements for **CIML019 Assignment 1** and demonstrates:

- Modular scripting practices  
- System data parsing  
- Filesystem operations  
- Incremental backup strategies  
- Process and resource analysis  
- Logging and reporting mechanisms  

You may extend the project with notifications, scheduling, or a richer terminal UI in future iterations.

---
