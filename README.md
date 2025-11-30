```markdown
# SysSnapshot — Linux System Monitoring & Backup Utility

**Author:** Bernard Lim  
**Module:** CIML019 – Software-Defined Infrastructure & Services  

SysSnapshot is a modular Bash-based toolkit designed to provide essential system monitoring and safe incremental backups on Linux systems.  
It offers a structured menu-driven interface, detailed resource insights, backup verification, and filesystem analytics — all without installing heavy external packages.

---

## 📁 Project Structure

```
system-monitor/
│── monitor.sh                # Main script & menu
│── lib/                      # Feature modules
│   ├── ui.sh
│   ├── logging.sh
│   ├── resources.sh
│   ├── users.sh
│   ├── backup.sh
│   ├── filesystem.sh
│   └── process.sh
│── backups/                  # Backup + Trash system
│── logs/                     # Log output
│── reports/                  # Filesystem analysis reports
│── config/settings.conf      # Default settings
│── screenshots/              # Images used in this README
└── README.md
```

---

## ⚙️ Installation

Clone the repository:

```bash
git clone https://github.com/oligokz/system-monitor.git
cd system-monitor
```

Make the main script executable:

```bash
chmod +x monitor.sh
```

Run the tool:

```bash
./monitor.sh
```

---

## 🚀 Features

### 🔹 System Health Monitoring  
Check CPU load, RAM usage, disk consumption, and receive OK/WARN/ERR status indicators.

### 🔹 User Activity Tracking  
View who is logged in, session duration, and detect multiple sessions.

### 🔹 Incremental Backup System  
Safely back up files with automatic trashing of deleted items — no silent overwrite or loss.

### 🔹 Backup Integrity Verification  
Detect missing, edited, or mismatched files between source and backup.

### 🔹 Filesystem Usage Reporting  
Analyze directory sizes, largest folders, most populated paths, and filesystem type usage.

### 🔹 Process Analysis  
Identify top CPU/memory consumers, process states, and long-running jobs.

---

# 🧪 Example Usage & Output  
Below are the actual outputs from SysSnapshot, showing its capabilities in action.

---

## 🟦 1. Main Menu  
![Main Menu](screenshots/main_menu.png)

---

## 🟦 2. System Resources (Option 1)
![System Resources](screenshots/system_resources.png)

---

## 🟦 3. User Activity & Sessions (Option 2)
![User Activity](screenshots/user_activity.png)

---

## 🟦 4. Incremental Backup – Start Prompt (Option 3)
![Backup Start](screenshots/backup_start.png)

---

## 🟦 5. Incremental Backup – Successful Backup
![Backup Success](screenshots/backup_success.png)

---

## 🟦 6. Backup Verification – PASS (Option 4)
![Verify PASS](screenshots/verification_pass.png)

---

## 🟦 7. Deleted File in Trash
![Trash Folder](screenshots/trash_folder.png)

---

## 🟦 8. Backup Verification – FAIL
![Verify FAIL](screenshots/verification_fail.png)

---

## 🟦 9. Filesystem Report (Option 5)
![Filesystem Report](screenshots/filesystem_report.png)

---

## 🟦 10. Process Analysis (Option 6)
![Process Analysis](screenshots/process_analysis.png)

---

# 📝 Notes

- Scripts use only standard Linux tools (`ps`, `du`, `find`, `rsync`, etc.).  
- Designed for Ubuntu/Debian-based systems but should work on most Linux distributions.  
- All functions are modular, easy to extend, and well-commented for learning purposes.

---

# 🎯 Conclusion

SysSnapshot successfully meets the requirements of the CIML019 assignment by delivering a robust, modular, and user-friendly system monitoring toolkit.  
Its incremental backup with a trash mechanism, detailed filesystem analysis, and clear UI make it both practical and educational — ideal for environments where lightweight, transparent tools are preferred.
```
