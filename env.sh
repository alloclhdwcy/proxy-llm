# ProxyLLM 共享环境变量
# 使用方法: source env.sh

PROXY_BASE_URL="${PROXY_BASE_URL:-http://localhost:4000}"
PROXY_MASTER_KEY="${PROXY_MASTER_KEY:-sk-your-master-key}"

PG_CONTAINER_NAME="proxyllm-pg"
PG_HOST_PORT="5432"
PG_USER="proxyllm"
PG_PASSWORD="proxyllm-pass"
PG_DB="proxyllm"

PROXYLLM_CONTAINER_NAME="proxyllm"
