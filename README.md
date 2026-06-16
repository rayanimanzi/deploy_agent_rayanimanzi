# Attendance Tracker Deployment Utility

## Project Description

This project is an automated deployment system created using Bash scripting.

The purpose of the project is to automatically generate the complete structure required for a Student Attendance Tracker application while applying Infrastructure as Code (IaC) principles.

The script minimizes manual setup and ensures all deployments follow the same consistent structure.

---

# Features

## Automated Workspace Creation

The script automatically creates:

attendance_tracker_<project_name>

with the following structure:

attendance_tracker_<project_name>/
│
├── Helpers/
│   ├── config.json
│   └── assets.csv
│
├── reports/
│   └── reports.log

---

## Dynamic Threshold Configuration

The system allows users to customize:

- Warning threshold
- Failure threshold

The values are updated dynamically inside config.json using the sed command.

---

# Signal Handling

The project implements SIGINT handling using trap.

If the user presses CTRL + C during execution:

- The current workspace is archived
- A .tar.gz backup is created
- The incomplete project directory is deleted
- The script exits safely

This prevents incomplete deployments and keeps the environment clean.

---

# Environment Validation

The script validates whether Python3 is installed by using:

python3 --version

This ensures the environment is ready before completing deployment.

---

# Technologies Used

- Bash Shell Scripting
- Linux Commands
- sed
- tar
- mkdir
- trap
- Python3

---

# How To Run

## Give execution permission

chmod +x setup_project.sh

## Run the script

./setup_project.sh

---

# Example

Provide deployment name: school_project

New warning percentage (leave empty for default): 80

New failure percentage (leave empty for default): 45

---

# Learning Outcomes

This project demonstrates:

- Shell scripting fundamentals
- Linux automation
- Infrastructure as Code
- Signal handling
- Process management
- Environment validation
- File and directory automation

---

# Author

Linux System Administration Individual Lab Project
