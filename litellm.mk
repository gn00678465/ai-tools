# === LiteLLM 相關設定與命令 ===

# 環境與路徑設定
SHELL := /bin/bash
LITELLM_DIR = litellm
LITELLM_VENV = $(LITELLM_DIR)/.venv
LITELLM_CONFIG = config.yaml

# 執行 LiteLLM
.PHONY: litellm-run
litellm-run: litellm-setup
	@echo "執行 LiteLLM 腳本 (配置: $(or $(CONFIG),$(LITELLM_CONFIG)))"
	@source $(LITELLM_VENV)/bin/activate && cd $(LITELLM_DIR) && litellm --config $(or $(CONFIG),$(LITELLM_CONFIG))

# 初始化 LiteLLM
.PHONY: litellm-init
litellm-init:
	@echo "初始化 LiteLLM"
	@mkdir -p $(LITELLM_DIR)
	
	# 建立配置檔
	@if [ ! -f "$(LITELLM_DIR)/$(LITELLM_CONFIG)" ]; then \
		echo "LiteLLM 配置檔不存在，建立預設配置"; \
		echo "model_list: []" > $(LITELLM_DIR)/$(LITELLM_CONFIG); \
	else \
		echo "LiteLLM 配置檔已存在"; \
	fi
	
	# 處理環境變數檔案
	@if [ ! -f "$(LITELLM_DIR)/.env" ] && [ -f "$(LITELLM_DIR)/.env.example" ]; then \
		echo "複製 .env.example 到 .env"; \
		cp $(LITELLM_DIR)/.env.example $(LITELLM_DIR)/.env; \
	elif [ ! -f "$(LITELLM_DIR)/.env" ] && [ ! -f "$(LITELLM_DIR)/.env.example" ]; then \
		echo "建立空白 .env 檔案"; \
		touch $(LITELLM_DIR)/.env; \
	else \
		echo ".env 檔案已存在"; \
	fi
	
	# 檢查虛擬環境
	@if [ ! -d "$(LITELLM_VENV)" ]; then \
		echo "虛擬環境不存在，建立中..."; \
		cd $(LITELLM_DIR) && uv venv .venv; \
		echo "已建立 LiteLLM 虛擬環境"; \
	else \
		echo "LiteLLM 虛擬環境已存在"; \
	fi


# 建立 LiteLLM 虛擬環境
.PHONY: litellm-venv
litellm-venv:
	@echo "確認 LiteLLM 虛擬環境"
	@if [ ! -d "$(LITELLM_VENV)" ]; then \
		echo "錯誤：未找到虛擬環境，請先執行 make litellm-init"; \
		exit 1; \
	fi

# 安裝 LiteLLM 依賴
.PHONY: litellm-install
litellm-install: litellm-venv
	@echo "安裝 LiteLLM 依賴"
	@source $(LITELLM_VENV)/bin/activate && uv pip install "litellm[proxy]"

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
