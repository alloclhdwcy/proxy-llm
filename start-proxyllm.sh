#!/usr/bin/env bash
# 启动 ProxyLLM 容器。
# 使用前请确保:
#   1. 已准备好 config.yaml 配置文件
#   2. （可选）已启动 PostgreSQL 容器
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/env.sh"

CONFIG_PATH="${1:-$SCRIPT_DIR/config.yaml}"

if [ ! -f "$CONFIG_PATH" ]; then
  echo "错误: 配置文件不存在: $CONFIG_PATH" >&2
  echo "用法: $0 [config.yaml 路径]" >&2
  exit 1
fi

# 获取容器可访问的宿主机地址
HOST_IP=$(podman inspect "$PG_CONTAINER_NAME" --format '{{.NetworkSettings.Gateway}}' 2>/dev/null || true)
if [ -z "$HOST_IP" ]; then
  HOST_IP="host.containers.internal"
fi

DATABASE_URL="postgresql://${PG_USER}:${PG_PASSWORD}@${HOST_IP}:${PG_HOST_PORT}/${PG_DB}"

echo "启动 ProxyLLM 容器 ($PROXYLLM_CONTAINER_NAME)..."
echo "DATABASE_URL=$DATABASE_URL"

podman run -d \
  --name "$PROXYLLM_CONTAINER_NAME" \
  --replace \
  --userns=keep-id \
  --add-host=host.containers.internal:host-gateway \
  -p 4000:4000 \
  -v "$CONFIG_PATH:/etc/litellm/config.yaml:ro,Z" \
  -v proxyllm-data:/home/litellm:Z \
  -e DATABASE_URL="$DATABASE_URL" \
  -e LITELLM_MASTER_KEY="$PROXY_MASTER_KEY" \
  chaoseternal/proxyllm:latest

echo "等待 ProxyLLM 就绪..."
for i in $(seq 1 180); do
  if curl -sf "http://localhost:4000/health/liveliness" >/dev/null 2>&1; then
    echo "ProxyLLM 已就绪，访问地址: http://localhost:4000"
    exit 0
  fi
  sleep 2
done

echo "错误: ProxyLLM 未能在规定时间内就绪。" >&2
echo "容器日志:"
podman logs "$PROXYLLM_CONTAINER_NAME" 2>&1 | tail -30
exit 1
