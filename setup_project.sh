#!/bin/bash

echo "======================================"
echo "Student Attendance Deployment Utility"
echo "======================================"

read -p "Provide deployment name: " deploy_name

workspace="attendance_tracker_${deploy_name}"

handle_interrupt() {

    echo ""
    echo "Execution interrupted"

    if [ -d "$workspace" ]; then

        backup_name="${workspace}_backup.tar.gz"

        tar -czf "$backup_name" "$workspace"

        rm -rf "$workspace"

        echo "Backup generated: $backup_name"
        echo "Temporary workspace removed"
    fi

    exit 1
}

trap handle_interrupt SIGINT

echo ""
echo "Creating deployment workspace..."

mkdir -p "$workspace/Helpers"
mkdir -p "$workspace/reports"

echo "Workspace ready"

echo ""
echo "Generating configuration files..."

cat > "$workspace/Helpers/config.json" << END
{
    "thresholds": {
        "warning": 75,
        "failure": 50
    },
    "run_mode": "live",
    "total_sessions": 15
}
END

cat > "$workspace/Helpers/assets.csv" << END
Email,Names,Attendance Count,Absence Count
alice@example.com,Alice Johnson,14,1
bob@example.com,Bob Smith,7,8
charlie@example.com,Charlie Davis,4,11
diana@example.com,Diana Prince,15,0
END

touch "$workspace/reports/reports.log"

echo "Default resources created"

echo ""
echo "Attendance Threshold Setup"

read -p "New warning percentage (leave empty for default): " warn_value
read -p "New failure percentage (leave empty for default): " fail_value

if [[ -n "$warn_value" ]]; then

    if [[ "$warn_value" =~ ^[0-9]+$ ]]; then

        sed -i.bak \
        "s/\"warning\": 75/\"warning\": $warn_value/" \
        "$workspace/Helpers/config.json"

        echo "Warning threshold updated"

    else
        echo "Invalid warning value ignored"
    fi
fi

if [[ -n "$fail_value" ]]; then

    if [[ "$fail_value" =~ ^[0-9]+$ ]]; then

        sed -i.bak \
        "s/\"failure\": 50/\"failure\": $fail_value/" \
        "$workspace/Helpers/config.json"

        echo "Failure threshold updated"

    else
        echo "Invalid failure value ignored"
    fi
fi

rm -f "$workspace/Helpers/config.json.bak"

echo ""
echo "Running environment validation..."

python3 --version > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "Python3 detected successfully"
else
    echo "Python3 was not detected"
fi

echo ""
echo "Inspecting generated structure..."

required_files=(
"$workspace/Helpers/config.json"
"$workspace/Helpers/assets.csv"
"$workspace/reports/reports.log"
)

all_good=true

for item in "${required_files[@]}"
do
    if [ ! -f "$item" ]; then
        all_good=false
    fi
done

if [ "$all_good" = true ]; then
    echo "Deployment verification completed"
else
    echo "Some files are missing"
fi

echo ""
echo "Deployment completed successfully"
