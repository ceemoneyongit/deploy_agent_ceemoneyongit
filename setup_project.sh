#!/bin/bash

read -p "Enter project name: " input

PROJECT_DIR="attendance_tracker_${input}"

cleanup() {
    echo ""
    echo "Interrupted! Archiving and cleaning up..."
    tar -czf "attendance_tracker_${input}_archive.tar.gz" "$PROJECT_DIR" 2>/dev/null
    rm -rf "$PROJECT_DIR"
    echo "Archive saved as: attendance_tracker_${input}_archive.tar.gz"
    echo "Incomplete directory removed."
    exit 1
}

trap cleanup SIGINT

echo "Creating project structure..."

mkdir -p "$PROJECT_DIR/Helpers"
mkdir -p "$PROJECT_DIR/reports"

cp attendance_checker.py "$PROJECT_DIR/attendance_checker.py"
cp assets.csv "$PROJECT_DIR/Helpers/assets.csv"
cp config.json "$PROJECT_DIR/Helpers/config.json"
cp reports.log "$PROJECT_DIR/reports/reports.log"

echo "Directory structure created."

read -p "Do you want to update attendance thresholds? (y/n): " update_choice

if [[ "$update_choice" == "y" || "$update_choice" == "Y" ]]; then
    read -p "Enter Warning threshold (default 75): " warning
    read -p "Enter Failure threshold (default 50): " failure

    warning=${warning:-75}
    failure=${failure:-50}

    if ! [[ "$warning" =~ ^[0-9]+$ ]] || ! [[ "$failure" =~ ^[0-9]+$ ]]; then
        echo "Invalid input — using defaults (75/50)."
        warning=75
        failure=50
    fi

    sed -i "s/\"warning\": [0-9]*/\"warning\": $warning/" "$PROJECT_DIR/Helpers/config.json"
    sed -i "s/\"failure\": [0-9]*/\"failure\": $failure/" "$PROJECT_DIR/Helpers/config.json"

    echo "Config updated: warning=${warning}%, failure=${failure}%"
else
    echo "Keeping default thresholds (warning=75%, failure=50%)."
fi

echo ""
echo "Running environment health check..."

if python3 --version &>/dev/null; then
    PY_VERSION=$(python3 --version)
    echo "Python3 found: $PY_VERSION"
else
    echo "WARNING: python3 is not installed."
fi

echo ""
echo "Verifying directory structure..."

REQUIRED_FILES=(
    "$PROJECT_DIR/attendance_checker.py"
    "$PROJECT_DIR/Helpers/assets.csv"
    "$PROJECT_DIR/Helpers/config.json"
    "$PROJECT_DIR/reports/reports.log"
)

ALL_OK=true
for f in "${REQUIRED_FILES[@]}"; do
    if [[ -f "$f" ]]; then
        echo "  OK: $f"
    else
        echo "  MISSING: $f"
        ALL_OK=false
    fi
done

if $ALL_OK; then
    echo ""
    echo "Setup complete! Project is ready at: $PROJECT_DIR"
else
    echo ""
    echo "Setup finished with warnings. Check missing files above."
fi
