#!/usr/bin/env bash
# 为用户生成 API 密钥
# 用法: ./create-key.sh [用户ID]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/env.sh"

USER_ID="${1:-test-user-001}"

echo "为用户 $USER_ID 生成 API 密钥..."

curl -s -X POST "${PROXY_BASE_URL}/key/generate" \
  -H "Authorization: Bearer ${PROXY_MASTER_KEY}" \
  -H "Content-Type: application/json" \
  -d "{
    \"user_id\": \"${USER_ID}\",
    \"duration\": \"30d\",
    \"key_alias\": \"${USER_ID}-key\",
    \"max_budget\": 50
  }" | python3 -m json.tool

# 预期输出:
# {
#     "key": "sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
#     "key_name": "sk-...xxxx",
#     "expires": "2026-05-30T00:00:00+00:00",
#     "user_id": "test-user-001",
#     "max_budget": 50.0,
#     "token_id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
# }
