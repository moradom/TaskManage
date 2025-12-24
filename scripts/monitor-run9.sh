#!/bin/bash

sleep 15

for i in {1..100}; do
  result=$(curl -s "https://api.github.com/repos/moradom/TaskManage/actions/runs?per_page=1&branch=claude/task-manager-full-stack-QSw8o" | python3 -c "
import sys, json
data = json.load(sys.stdin)
if 'workflow_runs' in data and len(data['workflow_runs']) > 0:
    run = data['workflow_runs'][0]
    print(f\"{run['run_number']}|{run['status']}|{run['conclusion'] or 'running'}|{run['id']}\")
")

  run_num=$(echo "$result" | cut -d'|' -f1)
  status=$(echo "$result" | cut -d'|' -f2)
  conclusion=$(echo "$result" | cut -d'|' -f3)
  run_id=$(echo "$result" | cut -d'|' -f4)

  echo "[Check $i] Run #$run_num: $status - $conclusion"

  if [ "$status" = "completed" ]; then
    if [ "$conclusion" = "success" ]; then
      echo ""
      echo "🎉🎉🎉 SUCCESS! 🎉🎉🎉"
      echo ""
      echo "Pipeline completed successfully!"
      echo "Docker images: ghcr.io/moradom/taskmanage/backend:latest"
      echo "              ghcr.io/moradom/taskmanage/frontend:latest"
      exit 0
    else
      echo ""
      echo "❌ Run #$run_num failed: $conclusion"
      echo "URL: https://github.com/moradom/TaskManage/actions/runs/$run_id"
      exit 1
    fi
  fi

  sleep 15
done

echo "Timeout"
exit 2
