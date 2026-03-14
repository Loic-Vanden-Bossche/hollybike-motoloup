#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:?Version is required}"
OUTPUT_FILE="${2:-RELEASE_NOTES.md}"
MODE="${3:-full}" # full | app | image
OPENAI_MODEL="${OPENAI_MODEL:-gpt-4o-mini}"

previous_tag="$({
  git tag --merged HEAD --sort=-v:refname \
    | grep -E '^v?[0-9]' \
    | grep -vx "${VERSION}" \
    | head -n 1
} || true)"

if [ -n "${previous_tag}" ]; then
  range="${previous_tag}..HEAD"
  range_label="${range}"
  commit_count="$(git rev-list --count "${range}" || echo 0)"
  commit_log="$(git log --no-merges --pretty=format:'- %s (%h)' "${range}")"
  changed_files="$(git diff --name-only "${range}" | sed 's/^/- /' | head -n 300)"
else
  range="HEAD~200..HEAD"
  range_label="last 200 commits"
  commit_count="$(git rev-list --count HEAD~200..HEAD 2>/dev/null || git rev-list --count HEAD || echo 0)"
  commit_log="$(git log --no-merges --pretty=format:'- %s (%h)' -n 200)"
  changed_files="$(git diff --name-only HEAD~200..HEAD 2>/dev/null | sed 's/^/- /' | head -n 300 || true)"
fi

if [ "${MODE}" = "app" ]; then
  app_commit_log=""
  while IFS=$'\t' read -r hash subject; do
    [ -z "${hash}" ] && continue
    files="$(git show --name-only --pretty='' "${hash}" | tr -d '\r' || true)"
    if printf '%s\n' "${files}" | grep -Eq '^(packages/app/|packages/backend/src/main/kotlin/.*/(route|routes|routing|controller|controllers|api|dto|model)/|packages/backend/src/main/resources/openapi)'; then
      app_commit_log="${app_commit_log}"$'\n'"- ${subject} (${hash:0:7})"
    fi
  done < <(git log --no-merges --pretty=format:'%H%x09%s' "${range}" 2>/dev/null || true)

  app_changed_files="$(
    printf '%s\n' "${changed_files}" \
      | sed 's/^- //' \
      | grep -E '^(packages/app/|packages/backend/src/main/kotlin/.*/(route|routes|routing|controller|controllers|api|dto|model)/|packages/backend/src/main/resources/openapi)' \
      | sed 's/^/- /' \
      | head -n 150 || true
  )"

  if [ -n "${app_commit_log}" ]; then
    commit_log="${app_commit_log#"$'\n'"}"
    commit_count="$(printf '%s\n' "${commit_log}" | sed '/^[[:space:]]*$/d' | wc -l | tr -d ' ')"
  else
    commit_count=0
    commit_log=""
  fi

  changed_files="${app_changed_files}"
fi

if [ -z "${commit_log}" ]; then
  commit_log="- Internal changes and maintenance updates."
fi

if [ -z "${changed_files}" ]; then
  changed_files="- (No file list available)"
fi

prompt_file="$(mktemp)"
if [ "${MODE}" = "image" ]; then
  cat > "${prompt_file}" <<EOF
You are generating a Docker/OCI image description for version ${VERSION}.
Use this commit range: ${range_label}
Commit count: ${commit_count}

Commits:
${commit_log}

Changed files:
${changed_files}

Requirements:
- Output plain text only (no markdown).
- One paragraph only.
- Maximum 500 characters.
- Focus on concrete runtime/user-facing impact.
- Mention backend, frontend, and app only if relevant.
EOF
elif [ "${MODE}" = "app" ]; then
  cat > "${prompt_file}" <<EOF
You are generating APP-ONLY release notes for version ${VERSION}.
Use this commit range: ${range_label}
Matching app-impact commit count: ${commit_count}

App-impact commits:
${commit_log}

App-impact files:
${changed_files}

Scope constraints:
- Include only mobile Flutter changes and backend API updates that can affect the mobile app (routes, controllers, DTO/contracts, auth/session behavior).
- Ignore infrastructure, docs, tooling, CI-only, and unrelated web/admin changes.

Output requirements:
- Output plain text only (no Markdown, no headings).
- Prefer one concise paragraph or short sentence list.
- Maximum 500 characters total.
- Keep wording concrete and user-oriented.
- If there are no app-impact commits, output exactly:
  No user-visible mobile changes in this release.
EOF
else
  cat > "${prompt_file}" <<EOF
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
fi

if [ -n "${OPENAI_API_KEY:-}" ]; then
  PROMPT_FILE="${prompt_file}" OUTPUT_FILE="${OUTPUT_FILE}" OPENAI_MODEL="${OPENAI_MODEL}" COMMIT_COUNT="${commit_count}" COMMIT_LOG="${commit_log}" MODE="${MODE}" VERSION="${VERSION}" python - <<'PY'
import json
import os
import urllib.request

api_key = os.environ["OPENAI_API_KEY"]
model = os.environ.get("OPENAI_MODEL", "gpt-4o-mini")
prompt = open(os.environ["PROMPT_FILE"], "r", encoding="utf-8").read()
output_file = os.environ["OUTPUT_FILE"]
commit_count = int(os.environ.get("COMMIT_COUNT", "0") or "0")
commit_log = os.environ.get("COMMIT_LOG", "")
mode = os.environ.get("MODE", "full")
version = os.environ.get("VERSION", "")

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
    chunks = []
    for item in data.get("output", []):
        if item.get("type") != "message":
            continue
        for content in item.get("content", []):
            if content.get("type") in ("output_text", "text") and isinstance(content.get("text"), str):
                chunks.append(content["text"].strip())
            elif isinstance(content.get("text"), str):
                chunks.append(content["text"].strip())
    text = "\n".join(c for c in chunks if c).strip()

if not text:
    commits = [line for line in commit_log.splitlines() if line.strip()]
    if mode == "image":
        if commit_count > 0:
            text = f"Release {version}: updates across backend, frontend, and app with fixes, performance improvements, and deployment hardening."
        else:
            text = "Maintenance release with internal improvements and fixes."
    elif mode == "app":
        if commit_count > 0:
            text = f"Includes {commit_count} app-impact updates across Flutter features and backend API contracts used by the app."
        else:
            text = "No user-visible mobile changes in this release."
    else:
        if commit_count > 0:
            top_commits = commits[:20]
            commit_section = "\n".join(top_commits) if top_commits else "- Internal changes and maintenance updates."
            text = (
                "## ✨ Highlights\n"
                f"- This release includes {commit_count} commits.\n\n"
                "## 🚀 User-Facing Changes\n"
                "- Improvements were shipped across app, backend, frontend, and infrastructure layers.\n\n"
                "## 🛠️ Technical Improvements\n"
                f"{commit_section}\n\n"
                "## ⚠️ Upgrade Notes\n"
                "- Review the commit list for migration-sensitive changes before production rollout."
            )
        else:
            text = (
                "## ✨ Highlights\n- No notable changes.\n\n"
                "## 🚀 User-Facing Changes\n- No notable changes.\n\n"
                "## 🛠️ Technical Improvements\n- No notable changes.\n\n"
                "## ⚠️ Upgrade Notes\n- No notable changes."
            )

if mode == "image":
    text = " ".join(text.replace("\r", "\n").splitlines()).strip()
    text = " ".join(text.split())
    if len(text) > 500:
        text = text[:497].rstrip() + "..."
elif mode == "app":
    text = " ".join(text.replace("\r", "\n").splitlines()).strip()
    text = " ".join(text.split())
    text = text.replace("#", "").replace("*", "")
    text = text.replace("`", "")
    text = text.replace("- ", "")
    if len(text) > 500:
        text = text[:497].rstrip() + "..."

with open(output_file, "w", encoding="utf-8") as fh:
    fh.write(text + "\n")
PY
else
  if [ "${MODE}" = "image" ]; then
    {
      printf 'Release %s: updates across services with fixes, performance improvements, and deployment hardening.\n' "${VERSION}"
    } > "${OUTPUT_FILE}"
  elif [ "${MODE}" = "app" ]; then
    {
      echo "OpenAI key not configured. App-impact updates are included in this release; review app and backend API commits for details."
    } > "${OUTPUT_FILE}"
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
    } > "${OUTPUT_FILE}"
  fi
fi
