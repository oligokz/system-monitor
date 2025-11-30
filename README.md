# SysSnapshot — Linux System Monitoring & Backup Utility

**By:** Bernard Lim  
**Assignment:** CIML019 (Software-Defined Infrastructure & Services)

## ✅ Overview  
SysSnapshot is a modular Linux system-monitoring and backup toolkit written in Bash.  
It provides a unified command-line interface to:

- Monitor system resources (CPU load, memory, disk usage)  
- Track active user sessions  
- Perform incremental backups with a trash-based deletion tracking system  
- Verify backup integrity (file presence & content)  
- Generate filesystem usage reports  
- Analyze running processes (top CPU/memory, process states, long-running jobs)  

This project is ideal for students, sysadmins, or anyone who wants a lightweight, self-contained system monitoring and backup solution without installing heavy packages.

---

## 📁 Repository Structure

```
system-monitor/
│── monitor.sh              # Main script & menu system  
│── lib/                    # Modular function libraries  
│   ├── ui.sh               # UI formatting (colors, boxes)  
│   ├── logging.sh          # Multi-level logging engine  
│   ├── resources.sh        # System resource monitoring  
│   ├── users.sh            # User session tracking  
│   ├── backup.sh           # Backup & verification logic  
│   ├── filesystem.sh       # Filesystem reporting  
│   └── process.sh          # Process analysis functions  
│── config/                 
│   └── settings.conf       # Configuration defaults  
│── logs/                   
│   └── system_monitor.log  # Execution log  
│── backups/                
│   ├── data/               # Incremental backups  
│   └── trash/              # Deleted files from backups  
│── reports/                # Saved filesystem analysis reports  
│── tests/                  # (Optional) test scripts & output snapshots  
└── README.md               # Project documentation (this file)  
```

---

## ⚙️ Installation

Clone or download the repository:

```bash
git clone https://github.com/oligokz/system-monitor.git
cd system-monitor
```

Make the main script executable:

```bash
chmod +x monitor.sh
```

Ensure required directories exist (Git handles most automatically):

```bash
mkdir -p config logs backups/data backups/trash reports
```

---

## 🚀 Usage

Run the main menu script:

```bash
./monitor.sh
```

Then choose from the menu:

| Option | Action |
|--------|--------|
| 1 | Check system resources (CPU, memory, disk) |
| 2 | View active user sessions & durations |
| 3 | Create an incremental backup |
| 4 | Verify backup integrity |
| 5 | Generate filesystem usage report |
| 6 | Analyze running processes (CPU, Memory, States) |
| 0 | Exit the tool |

For backup or report options, follow on-screen prompts for source paths and settings.

---

## 🧰 Features & Highlights

- Modular architecture — easy to maintain and extend  
- Interactive box-style UI with colors & formatting  
- Incremental backup with “trash” for deleted files (safe file retention)  
- Backup verification: ensures both presence and content integrity  
- Detailed filesystem analysis and reporting  
- Process inspection including long-running job detection  
- Simple Bash-only implementation — no external dependencies beyond standard Linux utilities  

---

## ⚠️ Known Limitations

- `du`, `find`, and filesystem scans may be slow on large directories  
- Trash folder grows indefinitely — manual cleanup required  
- Script assumes GNU tools (e.g. `date`, `ps`) — may not work on minimalist distros  
- No automatic backup rotation or compression  
- Terminal must support colors & Unicode for optimal UI  

---

## 🧪 (Optional) Example Usage & Output

(Add your own terminal screenshots or sample output here — e.g., CPU check output, backup summary, filesystem report preview.)

---

## 📄 License

You can choose to add an open-source license — e.g., MIT or GPL.  
*(If you want, I can provide a `LICENSE` file template.)*

---

## 📝 Acknowledgments

- Built as part of the CIML019 module for the Diploma in ICT Systems, Services & Support  
- Bash + core utilities only — no external dependencies  
- Inspiration and guidance from classic Unix shell scripting practices  

