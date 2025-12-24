#!/bin/bash

# GitHub Actions Pipeline Monitor
# Continuously polls for workflow status

REPO="moradom/TaskManage"
BRANCH="claude/task-manager-full-stack-QSw8o"
MAX_WAIT=600  # 10 minutes
CHECK_INTERVAL=15  # Check every 15 seconds

echo "🔍 Monitoring GitHub Actions Pipeline for ${REPO}"
echo "📌 Branch: ${BRANCH}"
echo "⏰ Will check every ${CHECK_INTERVAL} seconds for up to ${MAX_WAIT} seconds"
echo ""

elapsed=0
last_status=""

while [ $elapsed -lt $MAX_WAIT ]; do
    echo "⏱️  Checking status (${elapsed}s elapsed)..."

    # Try to fetch workflow status
    response=$(curl -s -H "Accept: application/vnd.github+json" \
        "https://api.github.com/repos/${REPO}/actions/runs?per_page=3&branch=${BRANCH}" 2>&1)

    if echo "$response" | grep -q "workflow_runs"; then
        # Parse the response
        status=$(echo "$response" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    if 'workflow_runs' in data and len(data['workflow_runs']) > 0:
        run = data['workflow_runs'][0]
        print(f\"{run['status']}|{run['conclusion'] or 'running'}|{run['html_url']}\")
    else:
        print('no_runs||')
except:
    print('error||')
" 2>/dev/null)

        workflow_status=$(echo "$status" | cut -d'|' -f1)
        conclusion=$(echo "$status" | cut -d'|' -f2)
        url=$(echo "$status" | cut -d'|' -f3)

        if [ "$workflow_status" != "$last_status" ]; then
            echo ""
            echo "📊 Status: ${workflow_status}"
            echo "🎯 Conclusion: ${conclusion}"
            echo "🔗 URL: ${url}"
            echo ""
            last_status="$workflow_status"
        fi

        # Check if completed
        if [ "$workflow_status" = "completed" ]; then
            echo ""
            if [ "$conclusion" = "success" ]; then
                echo "✅ Pipeline completed successfully!"
                echo "🎉 Docker images have been built and pushed to GHCR"
                echo ""
                echo "Images available at:"
                echo "  - ghcr.io/${REPO,,}/backend:latest"
                echo "  - ghcr.io/${REPO,,}/frontend:latest"
                exit 0
            else
                echo "❌ Pipeline failed with conclusion: ${conclusion}"
                echo "🔗 Check logs at: ${url}"
                exit 1
            fi
        fi
    else
        echo "⚠️  Cannot access GitHub API (repository might be private)"
        echo "📍 Check manually at: https://github.com/${REPO}/actions"
        echo ""
        echo "Waiting ${CHECK_INTERVAL} more seconds..."
    fi

    sleep $CHECK_INTERVAL
    elapsed=$((elapsed + CHECK_INTERVAL))
    echo "."
done

echo ""
echo "⏰ Timeout reached (${MAX_WAIT}s)"
echo "🔗 Check status manually at: https://github.com/${REPO}/actions"
exit 2
