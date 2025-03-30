# === 通用目標與說明 ===

# 預設目標 - 顯示幫助資訊
.PHONY: help
help:
	@echo "=== 專案腳本管理 ==="
	@echo ""
	@echo "LiteLLM 命令："
	@echo "  make litellm-run           - 執行 LiteLLM (使用預設配置)"
	@echo "  make litellm-run CONFIG=其他配置.yaml - 使用自訂配置執行"
	@echo "  make litellm-setup         - 設定 LiteLLM 環境"
	@echo ""
	@echo "Web-UI 命令："
	@echo "  make webui-run             - 執行 Web-UI 應用"
	@echo "  make webui-run IP=x.x.x.x PORT=xxxx - 使用自訂 IP 和端口執行"
	@echo "  make webui-setup           - 設定 Web-UI 環境"
	@echo ""
	@echo "Langmanus 命令："
	@echo "  make langmanus-run         - 執行 Langmanus"
	@echo "  make langmanus-setup       - 設定 Langmanus 環境"
	@echo ""
	@echo "環境管理："
	@echo "  make setup-all             - 設定所有環境"
	@echo "  make clean                 - 清理暫存檔和快取"

# 設定所有環境
.PHONY: setup-all
setup-all: litellm-setup webui-setup langmanus-setup
	@echo "所有環境設定完成"

# 清理
.PHONY: clean
clean: litellm-clean webui-clean langmanus-clean
	@echo "清理暫存檔和快取完成"

# 定義各應用的清理目標 (實際實現在各模組內)
.PHONY: litellm-clean webui-clean langmanus-clean
