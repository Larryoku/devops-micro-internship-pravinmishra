#!/bin/bash
# pre-tool-guard.sh - Intercepts bash commands before execution
#
# PreToolUse hooks receive their payload as JSON on stdin (not as argv), e.g.
#   {"tool_name":"Bash","tool_input":{"command":"terraform destroy",...},...}
# Exit 0 = allow the tool call; exit 2 = block it and surface stderr to Claude.

INPUT=$(cat)

# Extract tool_input.command from the JSON payload (best-effort, no jq needed).
COMMAND_STR=$(printf '%s' "$INPUT" \
    | grep -oP '"command"\s*:\s*"(\\.|[^"\\])*"' \
    | head -1 \
    | sed -E 's/^"command"[[:space:]]*:[[:space:]]*"//; s/"$//')

# Log for debugging visibility.
echo "[PreToolGuard] Checking command: $COMMAND_STR" >&2

# Block dangerous infrastructure commands.
if [[ "$COMMAND_STR" == *"terraform destroy"* ]] || [[ "$COMMAND_STR" == *"rm -rf"* ]]; then
    echo "❌ [Security Rail] Tool execution blocked: '$COMMAND_STR' matches a forbidden pattern (terraform destroy / rm -rf)." >&2
    exit 2
fi

exit 0
