#!/usr/bin/env bash
# 启动 PostgreSQL 容器，用于 ProxyLLM 持久化存储。
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/env.sh"

echo "启动 PostgreSQL 容器 ($PG_CONTAINER_NAME)..."

podman run -d \
  --name "$PG_CONTAINER_NAME" \
  --replace \
  -p "${PG_HOST_PORT}:5432" \
  -e POSTGRES_USER="$PG_USER" \
  -e POSTGRES_PASSWORD="$PG_PASSWORD" \
  -e POSTGRES_DB="$PG_DB" \
  -v proxyllm-pgdata:/var/lib/postgresql/data:Z \
  docker.io/library/postgres:16-alpine

echo "等待 PostgreSQL 就绪..."
for i in $(seq 1 30); do
  if podman exec "$PG_CONTAINER_NAME" pg_isready -U "$PG_USER" -d "$PG_DB" >/dev/null 2>&1; then
    echo "PostgreSQL 已就绪。"
    exit 0
  fi
  sleep 1
done

echo "错误: PostgreSQL 未能在规定时间内就绪。" >&2
exit 1
