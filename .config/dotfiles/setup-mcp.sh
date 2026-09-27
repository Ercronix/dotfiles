#!/usr/bin/env sh
# Registers user-scope MCP servers for Claude Code.
# Tokens are fetched at run time (never stored in this repo). Requires: claude, gh (logged in).
set -e

token="${GITHUB_MCP_TOKEN:-$(gh auth token)}"
claude mcp remove --scope user github >/dev/null 2>&1 || true
claude mcp add --scope user --transport http github https://api.githubcopilot.com/mcp/ \
  --header "Authorization: Bearer $token"

claude mcp list
