#!/usr/bin/env bash
# 发起 LLM API 调用
# 用法: ./llm-call.sh [API密钥] [模型名]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/env.sh"

API_KEY="${1:-$PROXY_MASTER_KEY}"
MODEL="${2:-gpt-4}"

echo "使用模型 $MODEL 发起 API 调用..."
echo ""

curl -s -X POST "${PROXY_BASE_URL}/v1/chat/completions" \
  -H "Authorization: Bearer ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d "{
    \"model\": \"${MODEL}\",
    \"messages\": [
      {
        \"role\": \"user\",
        \"content\": \"请用一句话介绍你自己。\"
      }
    ],
    \"max_tokens\": 100
  }" | python3 -m json.tool

# 预期输出:
# {
#     "id": "chatcmpl-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
#     "object": "chat.completion",
#     "created": 1714470000,
#     "model": "gpt-4",
#     "choices": [
#         {
#             "index": 0,
#             "message": {
#                 "role": "assistant",
#                 "content": "我是一个人工智能助手，旨在帮助用户回答问题和完成任务。"
#             },
#             "finish_reason": "stop"
#         }
#     ],
#     "usage": {
#         "prompt_tokens": 15,
#         "completion_tokens": 25,
#         "total_tokens": 40
#     }
# }
