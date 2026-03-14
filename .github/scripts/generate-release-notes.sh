#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:?Version is required}"
OUTPUT_FILE="${2:-RELEASE_NOTES.md}"
OPENAI_MODEL="${OPENAI_MODEL:-gpt-4o-mini}"

# Choose the latest release tag reachable from HEAD, excluding current version.
previous_tag="$({
  git tag --merged HEAD --sort=-v:refname \
    | grep -E '^v?[0-9]' \
    | grep -vx "${VERSION}" \
    | head -n 1;
} || true)"

if [ -n "${previous_tag}" ]; then
  range="${previous_tag}..HEAD"
  range_label="${range}"
  commit_count="$(git rev-list --count "${range}" || echo 0)"
  commit_log="$(git log --no-merges --pretty=format:'- %s (%h)' "${range}")"
  changed_files="$(git diff --name-only "${range}" | sed 's/^/- /' | head -n 300)"
else
  range_label="last 200 commits"
  commit_count="$(git rev-list --count HEAD~200..HEAD 2>/dev/null || git rev-list --count HEAD || echo 0)"
  commit_log="$(git log --no-merges --pretty=format:'- %s (%h)' -n 200)"
  changed_files="$(git diff --name-only HEAD~200..HEAD 2>/dev/null | sed 's/^/- /' | head -n 300 || true)"
fi

if [ -z "${commit_log}" ]; then
  commit_log="- Internal changes and maintenance updates."
fi

if [ -z "${changed_files}" ]; then
  changed_files="- (No file list available)"
fi

prompt_file="$(mktemp)"
cat > "$prompt_file" <<EOF
You are generating release notes for version ${VERSION}.
Use this commit range: ${range_label}
Commit count: ${commit_count}

Commits:
${commit_log}

Changed files:
${changed_files}

Requirements:
- Output in Markdown.
- Keep it concise but detailed.
- Use tasteful emojis in section titles and major bullets (not on every line).
- Make it visually clean and easy to scan.
- Sections in this exact order:
  1) ✨ Highlights
  2) 🚀 User-Facing Changes
  3) 🛠️ Technical Improvements
  4) ⚠️ Upgrade Notes
- Use bullet points.
- If commit count is greater than 0, include concrete bullets sourced from commits/files.
- Only write "- No notable changes." for a section when truly empty.
EOF

if [ -n "${OPENAI_API_KEY:-}" ]; then
  PROMPT_FILE="$prompt_file" OUTPUT_FILE="$OUTPUT_FILE" OPENAI_MODEL="$OPENAI_MODEL" python - <<'PY'
import json
import os
import urllib.request

api_key = os.environ["OPENAI_API_KEY"]
model = os.environ.get("OPENAI_MODEL", "gpt-4o-mini")
prompt = open(os.environ["PROMPT_FILE"], "r", encoding="utf-8").read()
output_file = os.environ["OUTPUT_FILE"]

payload = {
    "model": model,
    "input": [
        {"role": "system", "content": "You write clear, professional release notes."},
        {"role": "user", "content": prompt},
    ],
}

req = urllib.request.Request(
    "https://api.openai.com/v1/responses",
    data=json.dumps(payload).encode("utf-8"),
    headers={
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json",
    },
    method="POST",
)

with urllib.request.urlopen(req) as resp:
    data = json.loads(resp.read().decode("utf-8"))

text = data.get("output_text", "").strip()
if not text:
    text = "## ✨ Highlights\n- No notable changes.\n\n## 🚀 User-Facing Changes\n- No notable changes.\n\n## 🛠️ Technical Improvements\n- No notable changes.\n\n## ⚠️ Upgrade Notes\n- No notable changes."

with open(output_file, "w", encoding="utf-8") as fh:
    fh.write(text + "\n")
PY
else
  {
    echo "## ✨ Highlights"
    echo "- OpenAI key not configured; using commit summary fallback."
    echo
    echo "## 🚀 User-Facing Changes"
    echo "- Review commit list below."
    echo
    echo "## 🛠️ Technical Improvements"
    echo "${commit_log}"
    echo
    echo "## ⚠️ Upgrade Notes"
    echo "- No manual action required unless noted in individual changes."
  } > "$OUTPUT_FILE"
fi
