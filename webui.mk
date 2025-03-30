# === Web-UI 相關設定與命令 ===

# 環境與路徑設定
WEBUI_DIR = web-ui
WEBUI_VENV = $(WEBUI_DIR)/.venv
WEBUI_IP = 127.0.0.1
WEBUI_PORT = 7788

# 執行 Web-UI
.PHONY: webui-run
webui-run: webui-setup
	@echo "執行 Web-UI 應用 (IP: $(or $(IP),$(WEBUI_IP)), 端口: $(or $(PORT),$(WEBUI_PORT)))"
	@source $(WEBUI_VENV)/bin/activate && cd $(WEBUI_DIR) && python webui.py --ip $(or $(IP),$(WEBUI_IP)) --port $(or $(PORT),$(WEBUI_PORT))

# 初始化 Web-UI (如果不存在則 clone 代碼庫)
.PHONY: webui-init
webui-init:
	@echo "檢查 Web-UI 代碼庫"
	@if [ ! -d "$(WEBUI_DIR)" ]; then \
		echo "Web-UI 代碼庫不存在，正在克隆...";\
		git clone https://github.com/browser-use/web-ui.git $(WEBUI_DIR); \
		echo "Web-UI 代碼庫克隆完成";\
	else \
		echo "Web-UI 代碼庫已存在";\
	fi

# 建立 Web-UI 虛擬環境
.PHONY: webui-venv
webui-venv: webui-init
	@echo "為 Web-UI 建立虛擬環境"
	@mkdir -p $(WEBUI_DIR)
	@if [ ! -d "$(WEBUI_VENV)" ]; then \
		cd $(WEBUI_DIR) && uv venv --python 3.11 .venv; \
		echo "已建立 Web-UI 虛擬環境"; \
	else \
		echo "Web-UI 虛擬環境已存在"; \
	fi

# 安裝 Web-UI 依賴
.PHONY: webui-install
webui-install: webui-venv
	@echo "安裝 Web-UI 依賴"
	@source $(WEBUI_VENV)/bin/activate && cd $(WEBUI_DIR) && uv pip install -r requirements.txt

# 安裝 Playwright
.PHONY: webui-playwright
webui-playwright: webui-install
	@echo "安裝 Playwright"
	@source $(WEBUI_VENV)/bin/activate && cd $(WEBUI_DIR) && playwright install

# 完整設定 Web-UI
.PHONY: webui-setup
webui-setup: webui-playwright
	@echo "Web-UI 設定完成"

# 清理 Web-UI
.PHONY: webui-clean
webui-clean:
	@echo "清理 Web-UI 暫存檔和快取"
	@find $(WEBUI_DIR) -type d -name "__pycache__" -exec rm -rf {} +
	@find $(WEBUI_DIR) -type f -name "*.pyc" -delete
