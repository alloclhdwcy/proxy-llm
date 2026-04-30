#!/usr/bin/env bash
# 创建新用户
# 用法: ./create-user.sh [用户ID]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/env.sh"

USER_ID="${1:-test-user-001}"

echo "创建用户: $USER_ID"

curl -s -X POST "${PROXY_BASE_URL}/user/new" \
  -H "Authorization: Bearer ${PROXY_MASTER_KEY}" \
  -H "Content-Type: application/json" \
  -d "{
    \"user_id\": \"${USER_ID}\",
    \"max_budget\": 100
  }" | python3 -m json.tool

# 预期输出:
# {
#     "user_id": "test-user-001",
#     "max_budget": 100.0,
#     "user_email": null,
#     "user_role": null,
#     "teams": [],
#     "models": [],
#     "tpm_limit": null,
#     "rpm_limit": null,
#     "budget_duration": null,
#     "spend": 0.0
# }
