#!/bin/bash
# user-prompt-guard.sh - Validates user prompt before sending to LLM

# Read prompt from argument or stdin
PROMPT="$1"
if [ -z "$PROMPT" ]; then
    PROMPT=$(cat)
fi

# Convert to lowercase for case-insensitive checking
LOWERS_PROMPT=$(echo "$PROMPT" | tr '[:upper:]' '[:lower:]')

# Define destructive patterns
if [[ "$LOWERS_PROMPT" =~ "delete production" ]] || [[ "$LOWERS_PROMPT" =~ "drop database" ]] || [[ "$LOWERS_PROMPT" =~ "wipe clean" ]]; then
    echo "❌ [Security Rail] Request blocked: Destructive intent detected in prompt." >&2
    exit 1
fi

exit 0-