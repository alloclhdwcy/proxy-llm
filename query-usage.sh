#!/usr/bin/env bash
# 查询用户用量信息
# 用法: ./query-usage.sh [用户ID]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/env.sh"

USER_ID="${1:-test-user-001}"

echo "=== 用户信息 ==="
curl -s -X GET "${PROXY_BASE_URL}/user/info?user_id=${USER_ID}" \
  -H "Authorization: Bearer ${PROXY_MASTER_KEY}" | python3 -m json.tool

# 预期输出:
# {
#     "user_id": "test-user-001",
#     "max_budget": 100.0,
#     "spend": 0.012,
#     "user_email": null,
#     "models": [],
#     "tpm_limit": null,
#     "rpm_limit": null,
#     "budget_duration": null,
#     "keys": [
#         {
#             "token": "xxxxxxxx...",
#             "key_alias": "test-user-001-key",
#             "spend": 0.012,
#             "max_budget": 50.0,
#             "expires": "2026-05-30T00:00:00+00:00"
#         }
#     ]
# }

echo ""
echo "=== 全局用量 ==="
curl -s -X GET "${PROXY_BASE_URL}/global/spend/logs?api_key=&user_id=${USER_ID}" \
  -H "Authorization: Bearer ${PROXY_MASTER_KEY}" | python3 -m json.tool

# 预期输出:
# [
#     {
#         "request_id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
#         "api_key": "sk-...xxxx",
#         "model": "gpt-4",
#         "spend": 0.006,
#         "startTime": "2026-04-30T10:00:00+00:00",
#         "endTime": "2026-04-30T10:00:01+00:00",
#         "user": "test-user-001"
#     }
# ]
