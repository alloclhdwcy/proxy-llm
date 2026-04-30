#!/usr/bin/env bash
# 重置或增加用户配额
# 用法: ./reset-quota.sh [用户ID] [新配额]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/env.sh"

USER_ID="${1:-test-user-001}"
NEW_BUDGET="${2:-200}"

echo "=== 重置用户 $USER_ID 的配额为 \$${NEW_BUDGET} ==="

curl -s -X POST "${PROXY_BASE_URL}/user/update" \
  -H "Authorization: Bearer ${PROXY_MASTER_KEY}" \
  -H "Content-Type: application/json" \
  -d "{
    \"user_id\": \"${USER_ID}\",
    \"max_budget\": ${NEW_BUDGET},
    \"spend\": 0
  }" | python3 -m json.tool

# 预期输出:
# {
#     "user_id": "test-user-001",
#     "max_budget": 200.0,
#     "spend": 0.0,
#     "user_email": null,
#     "models": [],
#     "tpm_limit": null,
#     "rpm_limit": null,
#     "budget_duration": null
# }

echo ""
echo "=== 增加密钥配额 ==="
echo "提示: 如需更新特定密钥的配额，请使用以下命令:"
echo ""
echo "  curl -s -X POST '${PROXY_BASE_URL}/key/update' \\"
echo "    -H 'Authorization: Bearer \${PROXY_MASTER_KEY}' \\"
echo "    -H 'Content-Type: application/json' \\"
echo "    -d '{\"key\": \"sk-...\", \"max_budget\": 100}'"

# 预期输出:
# {
#     "key": "sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
#     "max_budget": 100.0,
#     "spend": 0.0,
#     "expires": "2026-05-30T00:00:00+00:00"
# }
