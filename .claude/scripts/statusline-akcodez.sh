#!/usr/bin/env bash
# Claude Code status line: RGB gradient, dynamic emoji, cost, code velocity
# source https://gist.github.com/AKCodez/ffb420ba6a7662b5c3dda2edce7783de#want-mine

input=$(cat)

# ── Colors ──
CYAN='\033[36m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
MAGENTA='\033[35m'
DIM='\033[2m'
BOLD='\033[1m'
RESET='\033[0m'

# ── Parse JSON fields ──
model=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
# used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')  # only the OLD %-based block used this
tokens_used=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
tokens_limit=$(echo "$input" | jq -r '.context_window.context_window_size // empty')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
lines_add=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
lines_del=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')

# ── Git info ──
branch=""
repo=""
if [ -n "$cwd" ]; then
  branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)
  repo=$(basename "$(git -C "$cwd" --no-optional-locks rev-parse --show-toplevel 2>/dev/null)" 2>/dev/null)
fi

# ── Context usage: token counts rounded to k ──
tok_fmt() {
  local n="$1"
  if [ -z "$n" ] || [ "$n" = "0" ]; then echo "0"; return; fi
  printf '%dk' "$(( (n + 500) / 1000 ))"
}

# ── Context thresholds: ABSOLUTE tokens, not % of window ─────────────────────
# Model reasoning quality degrades in the ~120-150k range ("dumb zone" / context
# rot) regardless of whether the window is 200k or 1M, so a % threshold fires far
# too late on large-context models (90% of 1M = 900k). Key off absolute tokens.
# Override via env if models improve. See Chroma "Context Rot" / Pocock "dumb zone".
CTX_WARN=${STATUSLINE_CTX_WARN:-120000}
CTX_CRIT=${STATUSLINE_CTX_CRIT:-180000}

# --- OLD (percentage-based on used_percentage: 20/70/90) — kept for reference ---
# if [ -n "$used" ]; then
#   used_int=$(printf '%.0f' "$used")
#   if [ "$used_int" -ge 90 ]; then status_emoji="🚨"; pct_color="$RED"
#   elif [ "$used_int" -ge 70 ]; then status_emoji="🔥"; pct_color="$YELLOW"
#   elif [ "$used_int" -ge 20 ]; then status_emoji="⚡"; pct_color="$GREEN"
#   else status_emoji="🟢"; pct_color="$GREEN"; fi
#   tok_used_fmt=$(tok_fmt "$tokens_used")
#   tok_limit_fmt=$(tok_fmt "$tokens_limit")
#   ctx_part="${status_emoji} ${pct_color}${tok_used_fmt}/${tok_limit_fmt}${RESET}"
# else
#   ctx_part="🟢 ${GREEN}--k/--k${RESET}"
# fi
# --- /OLD ---

if [[ "$tokens_used" =~ ^[0-9]+$ ]] && [ "$tokens_used" -gt 0 ]; then
  if   [ "$tokens_used" -ge "$CTX_CRIT" ];         then status_emoji="🚨"; pct_color="$RED"
  elif [ "$tokens_used" -ge "$CTX_WARN" ];         then status_emoji="🔥"; pct_color="$YELLOW"
  elif [ "$tokens_used" -ge "$((CTX_WARN / 2))" ]; then status_emoji="⚡"; pct_color="$GREEN"
  else status_emoji="🟢"; pct_color="$GREEN"; fi

  tok_used_fmt=$(tok_fmt "$tokens_used")
  tok_limit_fmt=$(tok_fmt "$tokens_limit")
  ctx_part="${status_emoji} ${pct_color}${tok_used_fmt}/${tok_limit_fmt}${RESET}"
else
  ctx_part="🟢 ${GREEN}--k/--k${RESET}"
fi

# ── Cost ──
cost_part="${YELLOW}$(printf '$%.2f' "$cost")${RESET}"

# ── Code velocity ──
velocity="${GREEN}+${lines_add}${RESET} ${RED}-${lines_del}${RESET}"

# ── Single line ──
out=""
[ -n "$repo" ] && out="${BOLD}${YELLOW}${repo}${RESET}"
[ -n "$branch" ] && out="${out:+$out }${BOLD}${CYAN}🌿 (${branch})${RESET}"
out="${out:+$out ${DIM}|${RESET} }${ctx_part}"
out="${out} ${DIM}|${RESET} ${cost_part}"
out="${out} ${DIM}|${RESET} ${velocity}"
out="${out} ${DIM}|${RESET} ${MAGENTA}🤖 ${model}${RESET}"

printf '%b' "$out"
