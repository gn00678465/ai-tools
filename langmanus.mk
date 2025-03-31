# === Langmanus 相關設定與命令 ===

# 環境與路徑設定
SHELL := /bin/bash
LANGMANUS_DIR = langmanus
LANGMANUS_VENV = $(LANGMANUS_DIR)/.venv
LANGMANUS_PYTHON = 3.12

# 執行 Langmanus
.PHONY: langmanus-run
langmanus-run: langmanus-setup
	@echo "執行 Langmanus"
	@source $(LANGMANUS_VENV)/bin/activate && cd $(LANGMANUS_DIR) && uv run main.py

# 初始化 Langmanus (如果不存在則 clone 代碼庫)
.PHONY: langmanus-init
langmanus-init:
	@echo "檢查 Langmanus 代碼庫"
	@if [ ! -d "$(LANGMANUS_DIR)" ]; then \
		echo "Langmanus 代碼庫不存在，正在克隆...";\
		git clone https://github.com/Darwin-lfl/langmanus.git $(LANGMANUS_DIR); \
		echo "Langmanus 代碼庫克隆完成";\
	else \
		echo "Langmanus 代碼庫已存在";\
	fi

# 建立 Langmanus 虛擬環境
.PHONY: langmanus-venv
langmanus-venv: langmanus-init
	@echo "為 Langmanus 建立虛擬環境"
	@mkdir -p $(LANGMANUS_DIR)
	@if [ ! -d "$(LANGMANUS_VENV)" ]; then \
		cd $(LANGMANUS_DIR) && uv python install $(LANGMANUS_PYTHON) && uv venv --python $(LANGMANUS_PYTHON); \
		echo "已建立 Langmanus 虛擬環境"; \
	else \
		echo "Langmanus 虛擬環境已存在"; \
	fi

# 安裝 Langmanus 依賴
.PHONY: langmanus-install
langmanus-install: langmanus-venv
	@echo "安裝 Langmanus 依賴"
	@source $(LANGMANUS_VENV)/bin/activate && cd $(LANGMANUS_DIR) && uv sync

# 完整設定 Langmanus
.PHONY: langmanus-setup
langmanus-setup: langmanus-install
	@echo "Langmanus 設定完成"

# 清理 Langmanus
.PHONY: langmanus-clean
langmanus-clean:
	@echo "清理 Langmanus 暫存檔和快取"
	@find $(LANGMANUS_DIR) -type d -name "__pycache__" -exec rm -rf {} +
	@find $(LANGMANUS_DIR) -type f -name "*.pyc" -delete
