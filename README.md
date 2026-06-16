# deploy_agent_ceemoneyongit

## How to run the script
1. Clone this repository
2. Navigate into the folder
3. Make the script executable: chmod +x setup_project.sh
4. Run the script: ./setup_project.sh
5. Enter a project name when prompted
6. Choose whether to update attendance thresholds

## How to trigger the archive feature
1. Run the script: ./setup_project.sh
2. Enter a project name
3. Press Ctrl+C at any point during execution
4. The script will automatically archive the current state into attendance_tracker_{name}_archive.tar.gz
5. The incomplete directory will be deleted automatically
