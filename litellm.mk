# === LiteLLM 相關設定與命令 ===

# 環境與路徑設定
LITELLM_DIR = litellm
LITELLM_VENV = $(LITELLM_DIR)/.venv
LITELLM_CONFIG = config.yaml

# 執行 LiteLLM
.PHONY: litellm-run
litellm-run: litellm-setup
	@echo "執行 LiteLLM 腳本 (配置: $(or $(CONFIG),$(LITELLM_CONFIG)))"
	@source $(LITELLM_VENV)/bin/activate && cd $(LITELLM_DIR) && litellm --config $(or $(CONFIG),$(LITELLM_CONFIG))

# 建立 LiteLLM 虛擬環境
.PHONY: litellm-venv
litellm-venv:
	@echo "為 LiteLLM 建立虛擬環境"
	@mkdir -p $(LITELLM_DIR)
	@if [ ! -d "$(LITELLM_VENV)" ]; then \
		cd $(LITELLM_DIR) && uv venv .venv; \
		echo "已建立 LiteLLM 虛擬環境"; \
	else \
		echo "LiteLLM 虛擬環境已存在"; \
	fi

# 安裝 LiteLLM 依賴
.PHONY: litellm-install
litellm-install: litellm-venv
	@echo "安裝 LiteLLM 依賴"
	@source $(LITELLM_VENV)/bin/activate && uv pip install litellm

# 完整設定 LiteLLM
.PHONY: litellm-setup
litellm-setup: litellm-install
	@echo "LiteLLM 設定完成"

# 清理 LiteLLM
.PHONY: litellm-clean
litellm-clean:
	@echo "清理 LiteLLM 暫存檔和快取"
	@find $(LITELLM_DIR) -type d -name "__pycache__" -exec rm -rf {} +
	@find $(LITELLM_DIR) -type f -name "*.pyc" -delete
