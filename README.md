# 🖥️ SysSnapshot – Linux System Monitoring & Backup Utility  
### By: Bernard Lim  
Assignment 1 – CIML019 (Software Defined Infrastructure & Services)

---

## 📌 Overview

**SysSnapshot** is a modular Linux monitoring and backup tool.  
It provides system reporting, incremental backup, verification, filesystem analysis, and process inspection.  
The project follows the required directory structure and supports configuration overrides via `settings.conf`.

---

## 📁 Project Structure

```
system-monitor/
│── monitor.sh             # Main script & menu system
│── lib/                   # Modular function files
│   ├── system.sh          # System resources & user activity
│   ├── backup.sh          # Backup + verification
│   ├── report.sh          # Filesystem reports
│   ├── process.sh         # Process analysis
│   └── ui.sh              # UI boxes, colours, formatting
│── config/
│   └── settings.conf      # Configuration defaults
│── logs/
│   └── system_monitor.log # Main runtime log
│── backups/               # Backup destination folder
│── reports/               # Generated filesystem reports
│── tests/                 # Test scripts & captured results
│── README.md              # Documentation (this file)
```

---

## ⚙️ Installation

1. **Copy the project**

```bash
cp -r system-monitor ~/system-monitor
cd ~/system-monitor
```

2. **Make the script executable**

```bash
chmod +x monitor.sh
```

3. **Ensure required folders exist**

```bash
mkdir -p lib config logs backups reports tests
```

---

## 🛠️ Configuration (`config/settings.conf`)

The script loads default values from:

```
config/settings.conf
```

Example:

```conf
BACKUP_SOURCE="/home/$USER/documents"
BACKUP_DEST="/home/$USER/system-monitor/backups"
FS_DEFAULT_PATH="/"
LOG_FILE="/home/$USER/system-monitor/logs/system_monitor.log"
LOG_LEVEL="INFO"

COLOR_HEADER=205
COLOR_SECTION1=51
COLOR_SECTION2=226
COLOR_SECTION3=46
COLOR_BORDER=208
```

### How configuration works

- User input **overrides** config values.  
- Pressing **ENTER** uses defaults from `settings.conf`.  
- Config values override hardcoded script defaults.  

---

## ▶️ Running the Program

Start the utility:

```bash
./monitor.sh
```

Menu options include:

1. System Resources  
2. User Activity  
3. Create Incremental Backup  
4. Verify Backup  
5. Filesystem Report  
6. Process Analysis  
0. Exit  

---

## 🎮 Controls

| Key | Meaning |
|-----|---------|
| **ENTER** | Accept the default setting.conf value |
| **M** | Return to main menu (backup & report prompts) |
| **A** | Analyse another directory (filesystem report only) |

---

## 🩺 Troubleshooting (Quick)

```
Issue                     | Solution
--------------------------|---------------------------------------------
Permission denied         | Run `chmod +x monitor.sh`
Backup path invalid       | Update values in `config/settings.conf`
Report empty              | Check directory permissions
Functions not loading     | Ensure the `/lib` folder remains intact
```

---

