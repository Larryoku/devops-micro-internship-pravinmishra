#!/bin/bash

# CI/CD Pipeline Failure Triage Script
# Fetches the latest pipeline run and categorizes any failure
# Supports both Azure DevOps (az pipelines) and GitHub Actions (gh run)

set -euo pipefail

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Defaults
PROVIDER=""  # "azure" or "github"
ORG=""
PROJECT=""
REPO=""
OUTPUT_FILE="/tmp/pipeline_triage.log"

# Parse arguments
while getopts "p:o:j:r:" opt; do
  case $opt in
    p) PROVIDER="$OPTARG" ;;
    o) ORG="$OPTARG" ;;
    j) PROJECT="$OPTARG" ;;
    r) REPO="$OPTARG" ;;
    *)
      echo "Usage: $0 -p <azure|github> -o <org> -j <project> -r <repo>"
      exit 1
      ;;
  esac
done

if [[ -z "$PROVIDER" ]]; then
  echo "Error: Must specify -p <azure|github>"
  exit 1
fi

# Function to fetch and analyze Azure DevOps run
analyze_azure_devops() {
  local org="$1"
  local project="$2"

  echo -e "${BLUE}Fetching latest Azure DevOps run...${NC}"

  # Get latest run
  local run_data=$(az pipelines runs list \
    --organization "https://dev.azure.com/$org" \
    --project "$project" \
    --top 1 \
    --query "[0]" -o json)

  local run_id=$(echo "$run_data" | jq -r '.id')
  local run_status=$(echo "$run_data" | jq -r '.status')
  local result=$(echo "$run_data" | jq -r '.result // empty')

  echo "Run ID: $run_id"
  echo "Status: $run_status"
  echo "Result: ${result:-pending}"

  # Get detailed logs
  az pipelines runs show \
    --organization "https://dev.azure.com/$org" \
    --project "$project" \
    --id "$run_id" \
    --query "url" -o json > "$OUTPUT_FILE" 2>&1 || true

  # Get run logs
  az pipelines runs artifact list \
    --organization "https://dev.azure.com/$org" \
    --project "$project" \
    --run-id "$run_id" > "$OUTPUT_FILE" 2>&1 || true
}

# Function to fetch and analyze GitHub Actions run
analyze_github_actions() {
  local repo="$1"

  echo -e "${BLUE}Fetching latest GitHub Actions run...${NC}"

  # Get latest failed run
  local run_data=$(gh run list \
    --repo "$repo" \
    --limit 1 \
    --json "databaseId,name,conclusion,status,createdAt" \
    --template '{{range .}}{{json .}}{{end}}')

  local run_id=$(echo "$run_data" | jq -r '.databaseId')
  local status=$(echo "$run_data" | jq -r '.status')
  local conclusion=$(echo "$run_data" | jq -r '.conclusion // empty')

  echo "Run ID: $run_id"
  echo "Status: $status"
  echo "Conclusion: ${conclusion:-in_progress}"

  # Get run logs
  gh run view "$run_id" \
    --repo "$repo" \
    --log-failed > "$OUTPUT_FILE" 2>&1 || true
}

# Categorization functions
categorize_failure() {
  local log_file="$1"

  local category="UNKNOWN"
  local evidence=""

  # Check for dependency errors
  if grep -iE "npm ERR|pip.*no matching|package not found|version conflict|ENOTFOUND" "$log_file" > /dev/null 2>&1; then
    category="DEPENDENCY"
    evidence=$(grep -iE "npm ERR|pip.*no matching|package not found" "$log_file" | head -3)
  # Check for build errors
  elif grep -iE "SyntaxError|TypeError|CompileError|error TS|cargo error" "$log_file" > /dev/null 2>&1; then
    category="BUILD"
    evidence=$(grep -iE "SyntaxError|TypeError|CompileError|error TS" "$log_file" | head -3)
  # Check for test failures
  elif grep -iE "FAIL|failed.*test|assertion|expect.*to.*be" "$log_file" > /dev/null 2>&1; then
    category="TEST"
    evidence=$(grep -iE "FAIL|failed.*test|assertion" "$log_file" | head -3)
  # Check for authentication errors
  elif grep -iE "unauthorized|invalid.*token|401|403|permission denied|credentials" "$log_file" > /dev/null 2>&1; then
    category="AUTHENTICATION"
    evidence=$(grep -iE "unauthorized|invalid.*token|401|403|permission denied" "$log_file" | head -3)
  # Check for agent/runner issues
  elif grep -iE "agent.*offline|agent.*timeout|runner.*fail|disk.*full|out of memory" "$log_file" > /dev/null 2>&1; then
    category="AGENT_RUNNER"
    evidence=$(grep -iE "agent.*offline|agent.*timeout|runner.*fail" "$log_file" | head -3)
  fi

  echo "$category"
}

# Main execution
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}CI/CD PIPELINE FAILURE TRIAGE REPORT${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}\n"

if [[ "$PROVIDER" == "azure" ]]; then
  if [[ -z "$ORG" || -z "$PROJECT" ]]; then
    echo "Error: Azure DevOps requires -o <org> -j <project>"
    exit 1
  fi
  analyze_azure_devops "$ORG" "$PROJECT"
elif [[ "$PROVIDER" == "github" ]]; then
  if [[ -z "$REPO" ]]; then
    echo "Error: GitHub requires -r <owner/repo>"
    exit 1
  fi
  analyze_github_actions "$REPO"
else
  echo "Error: Unknown provider $PROVIDER"
  exit 1
fi

echo -e "\n${BLUE}Analyzing logs...${NC}\n"

# Categorize the failure
FAILURE_CATEGORY=$(categorize_failure "$OUTPUT_FILE")

# Determine risk and recommendation
if [[ "$FAILURE_CATEGORY" == "AUTHENTICATION" ]]; then
  SEVERITY="CRITICAL"
  RECOMMENDATION="Check: Is your PAT/token expired or revoked? Verify credentials in Azure DevOps/GitHub settings."
elif [[ "$FAILURE_CATEGORY" == "AGENT_RUNNER" ]]; then
  SEVERITY="HIGH"
  RECOMMENDATION="Check: Is the agent/runner online? Has it timed out? Restart it or check for disk space/memory issues."
elif [[ "$FAILURE_CATEGORY" == "BUILD" ]]; then
  SEVERITY="MEDIUM"
  RECOMMENDATION="Check: Fix the syntax/type error in your code. Review the compiler output above."
elif [[ "$FAILURE_CATEGORY" == "DEPENDENCY" ]]; then
  SEVERITY="MEDIUM"
  RECOMMENDATION="Check: Does the package exist? Is the version correct? Update package.json or requirements.txt."
elif [[ "$FAILURE_CATEGORY" == "TEST" ]]; then
  SEVERITY="MEDIUM"
  RECOMMENDATION="Check: Is the test assertion correct? Does the code match the test expectations? Fix the code or test logic."
fi

echo -e "${BLUE}Failure Category:${NC} ${RED}${FAILURE_CATEGORY}${NC}"
echo -e "${BLUE}Severity:${NC} ${RED}${SEVERITY}${NC}\n"

echo -e "${BLUE}Recommendation:${NC}"
echo -e "  ${RECOMMENDATION}\n"

echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo -e "Full logs saved to: ${YELLOW}$OUTPUT_FILE${NC}\n"

# Exit code based on failure
if [[ "$FAILURE_CATEGORY" == "UNKNOWN" ]]; then
  echo -e "${GREEN}✓ No clear failure detected. Pipeline may be healthy.${NC}"
  exit 0
else
  echo -e "${RED}✗ Failure detected. Review the recommendation above and fix manually.${NC}"
  exit 1
fi
