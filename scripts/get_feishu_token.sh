#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
ROOT_DIR="$(CDPATH= cd -- "${SCRIPT_DIR}/.." && pwd)"
CACHE_FILE="${FEISHU_TOKEN_CACHE_FILE:-${ROOT_DIR}/.feishu_token_cache.json}"
LOCK_DIR="${CACHE_FILE}.lock"
REFRESH_WINDOW_SECONDS="${FEISHU_TOKEN_REFRESH_WINDOW_SECONDS:-300}"
AUTH_URL="${FEISHU_AUTH_URL:-https://open.feishu.cn/open-apis/auth/v3/tenant_access_token/internal}"

usage() {
  cat >&2 <<'EOF'
Usage: get_feishu_token.sh [--force-refresh]

Reads FEISHU_APP_ID and FEISHU_APP_SECRET from the environment.
Prints the tenant_access_token to stdout on success.
EOF
}

fail() {
  printf 'feishu token helper: %s\n' "$*" >&2
  exit 1
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || fail "missing required command: $1"
}

read_cached_token() {
  python3 - "$CACHE_FILE" "$APP_ID" "$REFRESH_WINDOW_SECONDS" <<'PY'
import json
import sys
import time

cache_file, app_id, refresh_window = sys.argv[1], sys.argv[2], int(sys.argv[3])

try:
    with open(cache_file, "r", encoding="utf-8") as fh:
        data = json.load(fh)
except FileNotFoundError:
    sys.exit(1)
except Exception:
    sys.exit(2)

token = data.get("tenant_access_token")
cached_app_id = data.get("app_id")
expire_at = data.get("expire_at_epoch")

if not token or cached_app_id != app_id:
    sys.exit(3)

try:
    expire_at = int(expire_at)
except (TypeError, ValueError):
    sys.exit(4)

if int(time.time()) + refresh_window >= expire_at:
    sys.exit(5)

print(token)
PY
}

acquire_lock() {
  local attempts=0

  while ! mkdir "$LOCK_DIR" 2>/dev/null; do
    attempts=$((attempts + 1))
    if [ "$attempts" -ge 100 ]; then
      fail "timed out waiting for token cache lock"
    fi
    sleep 0.1
  done

  trap 'rmdir "$LOCK_DIR" >/dev/null 2>&1 || true' EXIT
}

refresh_token() {
  local response tmp_file token

  response="$(
    curl -sS -X POST "$AUTH_URL" \
      -H "Content-Type: application/json" \
      -d "{\"app_id\":\"${APP_ID}\",\"app_secret\":\"${APP_SECRET}\"}"
  )" || fail "failed to request tenant_access_token"

  tmp_file="$(mktemp "${CACHE_FILE}.tmp.XXXXXX")"

  token="$(
    RESPONSE_PAYLOAD="$response" python3 - "$tmp_file" "$APP_ID" <<'PY'
import json
import os
import sys
import time

tmp_file, app_id = sys.argv[1], sys.argv[2]

try:
    payload = json.loads(os.environ["RESPONSE_PAYLOAD"])
except Exception as exc:
    print(f"invalid auth response: {exc}", file=sys.stderr)
    sys.exit(1)

code = payload.get("code")
if code != 0:
    msg = payload.get("msg") or payload.get("message") or f"code={code}"
    print(f"auth request rejected: {msg}", file=sys.stderr)
    sys.exit(1)

token = payload.get("tenant_access_token")
expire = payload.get("expire")

if not token:
    print("auth response missing tenant_access_token", file=sys.stderr)
    sys.exit(1)

try:
    expire_seconds = int(expire)
except (TypeError, ValueError):
    print("auth response missing expire", file=sys.stderr)
    sys.exit(1)

cache_payload = {
    "tenant_access_token": token,
    "expire_at_epoch": int(time.time()) + expire_seconds,
    "app_id": app_id,
}

with open(tmp_file, "w", encoding="utf-8") as fh:
    json.dump(cache_payload, fh)
    fh.write("\n")

os.chmod(tmp_file, 0o600)
print(token)
PY
  )" || {
    rm -f "$tmp_file"
    fail "failed to parse auth response"
  }

  mv -f "$tmp_file" "$CACHE_FILE"
  chmod 600 "$CACHE_FILE"

  printf '%s\n' "$token"
}

FORCE_REFRESH=0

case "${1:-}" in
  "")
    ;;
  --force-refresh)
    FORCE_REFRESH=1
    ;;
  -h|--help)
    usage
    exit 0
    ;;
  *)
    usage
    fail "unknown argument: $1"
    ;;
esac

[ "$#" -le 1 ] || {
  usage
  fail "too many arguments"
}

APP_ID="${FEISHU_APP_ID:-}"
APP_SECRET="${FEISHU_APP_SECRET:-}"

[ -n "$APP_ID" ] || fail "FEISHU_APP_ID is not set"
[ -n "$APP_SECRET" ] || fail "FEISHU_APP_SECRET is not set"

require_command curl
require_command python3

umask 077

if [ "$FORCE_REFRESH" -eq 0 ]; then
  if cached_token="$(read_cached_token 2>/dev/null)"; then
    printf '%s\n' "$cached_token"
    exit 0
  fi
fi

acquire_lock

if [ "$FORCE_REFRESH" -eq 0 ]; then
  if cached_token="$(read_cached_token 2>/dev/null)"; then
    printf '%s\n' "$cached_token"
    exit 0
  fi
fi

refresh_token
