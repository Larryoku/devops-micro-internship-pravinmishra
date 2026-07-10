#!/bin/bash
# post-tool-logger.sh - Logs successful terraform actions
#
# PostToolUse hooks receive their payload as JSON on stdin (not as argv), e.g.
#   {"tool_name":"Bash","tool_input":{"command":"terraform apply",...},...}
# so the executed command must be parsed out of stdin.

INPUT=$(cat)
LOG_FILE=".claude/deploy.log"

# Extract tool_input.command from the JSON payload (best-effort, no jq needed).
COMMAND_STR=$(printf '%s' "$INPUT" \
    | grep -oP '"command"\s*:\s*"(\\.|[^"\\])*"' \
    | head -1 \
    | sed -E 's/^"command"[[:space:]]*:[[:space:]]*"//; s/"$//')

# Log only terraform commands.
if [[ "$COMMAND_STR" == *terraform* ]]; then
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$TIMESTAMP] Executed: $COMMAND_STR" >> "$LOG_FILE"
fi

exit 0
