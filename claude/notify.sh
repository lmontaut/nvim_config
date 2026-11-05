#!/usr/bin/env bash
# Claude Code hook (Stop / Notification): forward the event to the Neovim whose
# :terminal runs this Claude. Neovim sets $NVIM to its RPC socket in terminal jobs.
[ -n "$NVIM" ] || exit 0

input=$(cat)
event=$(printf '%s' "$input" | jq -r '.hook_event_name // empty')
# Single line, quotes doubled for a Vimscript single-quoted string.
msg=$(printf '%s' "$input" | jq -r '.message // empty' | tr '\n' ' ' | sed "s/'/''/g")

nvim --server "$NVIM" --remote-expr "v:lua.ClaudeNotify('$event', '$msg')" >/dev/null 2>&1
exit 0
