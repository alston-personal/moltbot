# Moltbot 設置指南 (繁體中文)

## 簡介

Moltbot 是一個個人 AI 助理系統，可以在您自己的設備上運行。它可以通過您已經使用的聊天平台（WhatsApp、Telegram、Slack、Discord、Google Chat、Signal、iMessage、Microsoft Teams、WebChat 等）與您互動。

## 系統架構

### 核心組件

```
WhatsApp / Telegram / Slack / Discord / Google Chat / Signal / iMessage / WebChat
               │
               ▼
┌───────────────────────────────┐
│            Gateway            │
│       (控制平面)              │
│     ws://127.0.0.1:18789      │
└──────────────┬────────────────┘
               │
               ├─ Pi agent (RPC)
               ├─ CLI (moltbot)
               ├─ WebChat UI
               ├─ macOS app
               └─ iOS / Android nodes
```

### 關鍵子系統

1. **Gateway WebSocket 網絡**
   - 單一 WebSocket 控制平面
   - 管理客戶端、工具和事件
   - 提供操作界面和儀表板

2. **多通道收件箱**
   - 支持多個消息平台
   - 統一的消息處理接口
   - 靈活的路由配置

3. **AI Agent 引擎**
   - 基於 Pi agent 的 RPC 模式
   - 工具流式傳輸
   - 會話管理

4. **瀏覽器控制**
   - Moltbot 管理的 Chrome/Chromium
   - CDP 控制協議
   - 網頁自動化能力

5. **持久化記憶**
   - 會話歷史記錄
   - 用戶偏好設置
   - 上下文保持

## 系統需求

### 硬件需求
- **CPU**: 2核或更多
- **內存**: 至少 4GB RAM (推薦 8GB)
- **存儲空間**: 至少 2GB 可用空間
- **網絡**: 穩定的互聯網連接

### 軟件需求
- **操作系統**: 
  - Linux (Ubuntu 20.04+ / Debian 10+ / CentOS 8+)
  - macOS 12+
  - Windows 10/11 (通過 WSL2)
- **Node.js**: >= 22.12.0
- **pnpm**: >= 10.23.0
- **Git**: 任何最新版本

### 必需的 API 訪問（二選一）
- **Anthropic Claude API** (推薦 Pro/Max + Opus 4.5)
- **OpenAI API** (ChatGPT/Codex)

## 安裝步驟

### 1. 系統準備

#### Linux (Ubuntu/Debian)
```bash
# 更新系統包
sudo apt update && sudo apt upgrade -y

# 安裝必要的構建工具
sudo apt install -y build-essential git curl
```

#### macOS
```bash
# 安裝 Homebrew (如果尚未安裝)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 安裝 Git
brew install git
```

### 2. 安裝 Node.js 22

#### 使用 NodeSource (Linux)
```bash
# 添加 Node.js 22.x 存儲庫
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -

# 安裝 Node.js
sudo apt install -y nodejs
```

#### 使用 Homebrew (macOS)
```bash
brew install node@22
```

#### 驗證安裝
```bash
node --version  # 應顯示 v22.x.x
npm --version
```

### 3. 安裝 pnpm

```bash
# 全局安裝 pnpm
npm install -g pnpm@10.23.0

# 驗證安裝
pnpm --version
```

### 4. 克隆 Moltbot 存儲庫

```bash
# 選擇一個目錄，例如 home 目錄
cd ~

# 克隆存儲庫
git clone https://github.com/moltbot/moltbot.git
cd moltbot
```

### 5. 安裝依賴項

```bash
# 安裝項目依賴
pnpm install

# 構建 UI
pnpm ui:build

# 構建項目
pnpm build
```

### 6. 配置 Moltbot

#### 創建配置文件
```bash
# 創建配置目錄
mkdir -p ~/.clawdbot

# 創建基本配置文件
cat > ~/.clawdbot/moltbot.json << 'EOF'
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "anthropic/claude-3-5-sonnet-latest"
      }
    }
  },
  "commands": {
    "native": "require-approval",
    "nativeSkills": "require-approval"
  },
  "gateway": {
    "mode": "local",
    "auth": {
      "mode": "token",
      "token": "在此處輸入隨機的長字串_TOKEN"
    }
  }
}
EOF
```

#### 設置環境變量

創建 `.env` 文件：
```bash
# 在 moltbot 目錄中創建 .env 文件
cat > .env << 'EOF'
# Anthropic API 密鑰 (如果使用 Anthropic)
ANTHROPIC_API_KEY=your_anthropic_api_key_here

# 或者 OpenAI API 密鑰 (如果使用 OpenAI)
# OPENAI_API_KEY=your_openai_api_key_here

# Telegram Bot Token (如果使用 Telegram)
# TELEGRAM_BOT_TOKEN=your_telegram_bot_token

# Discord Bot Token (如果使用 Discord)
# DISCORD_BOT_TOKEN=your_discord_bot_token

# Slack Bot Token 和 App Token (如果使用 Slack)
# SLACK_BOT_TOKEN=your_slack_bot_token
# SLACK_APP_TOKEN=your_slack_app_token
EOF
```

**注意**: 請將上述佔位符替換為您的實際 API 密鑰。

### 7. 運行安裝向導

```bash
# 運行交互式安裝向導
pnpm moltbot onboard --install-daemon
```

向導將引導您完成以下步驟：
- 選擇 AI 模型提供商
- 配置消息通道
- 設置工作區
- 安裝技能插件
- 配置守護進程（可選）

## 啟動 Moltbot

### 方式一：前台運行（用於測試）

```bash
# 在 moltbot 目錄中
pnpm moltbot gateway --port 18789 --verbose
```

### 方式二：後台守護進程運行（推薦用於生產）

如果在安裝向導中選擇了安裝守護進程：

#### Linux (使用 systemd)
```bash
# 啟動服務
systemctl --user start moltbot-gateway

# 設置開機啟動
systemctl --user enable moltbot-gateway

# 檢查狀態
systemctl --user status moltbot-gateway

# 查看日誌
journalctl --user -u moltbot-gateway -f
```

#### macOS (使用 launchd)
```bash
# 服務會自動啟動
# 檢查狀態
launchctl list | grep moltbot
```

## 配置通道

### WhatsApp

1. 登錄設備：
```bash
pnpm moltbot channels login whatsapp
```

2. 掃描終端中顯示的 QR 碼

3. 配置允許列表（在 `~/.clawdbot/moltbot.json` 中）：
```json
{
  "channels": {
    "whatsapp": {
      "allowFrom": ["+1234567890"],
      "groups": ["*"]
    }
  }
}
```

### Telegram

1. 從 [@BotFather](https://t.me/botfather) 創建機器人並獲取 token

2. 在 `.env` 或配置文件中設置：
```json
{
  "channels": {
    "telegram": {
      "botToken": "YOUR_BOT_TOKEN",
      "allowFrom": ["*"]
    }
  }
}
```

### Discord

1. 創建 Discord 應用程序：
   - 訪問 [Discord Developer Portal](https://discord.com/developers/applications)
   - 創建新應用
   - 添加機器人
   - 複製 Bot Token

2. 配置：
```json
{
  "channels": {
    "discord": {
      "token": "YOUR_DISCORD_BOT_TOKEN"
    }
  }
}
```

### Slack

1. 創建 Slack 應用並獲取 Bot Token 和 App Token

2. 配置：
```json
{
  "channels": {
    "slack": {
      "botToken": "xoxb-...",
      "appToken": "xapp-..."
    }
  }
}
```

## 使用說明

### 基本命令

```bash
# 發送消息
pnpm moltbot message send --to +1234567890 --message "Hello"

# 與助手對話
pnpm moltbot agent --message "你好，請幫我總結今天的新聞"

# 檢查系統狀態
pnpm moltbot doctor

# 查看配置
pnpm moltbot config show
```

### 聊天命令

在與機器人的對話中，您可以使用以下命令：

- `/status` - 查看會話狀態（模型、令牌數、成本）
- `/new` 或 `/reset` - 重置會話
- `/compact` - 壓縮會話上下文（摘要）
- `/think <level>` - 設置思考等級（off|minimal|low|medium|high|xhigh）
- `/verbose on|off` - 切換詳細模式
- `/usage off|tokens|full` - 設置使用情況反饋
- `/restart` - 重啟網關（僅群組所有者）

### Web 界面

訪問控制儀表板：
```
http://localhost:18789
```

### 安全配置

#### DM（私信）配對模式

默認情況下，Moltbot 使用配對模式保護您的助手：

```bash
# 批准新用戶
pnpm moltbot pairing approve <channel> <code>

# 列出待批准的用戶
pnpm moltbot pairing list
```

#### 沙箱模式（用於群組）

為群組聊天啟用 Docker 沙箱：
```json
{
  "agents": {
    "defaults": {
      "sandbox": {
        "mode": "non-main"
      }
    }
  }
}
```

## 資安加固建議 (Security Hardening)

Moltbot 具備直接執行系統指令的能力，因此安全性至關重要。以下是建議的加固措施：

### 1. 設置指令執行審核
**強烈建議**將指令執行模式設定為 `require-approval`。這樣當 Moltbot 試圖執行任何 Shell 指令或敏感操作時，都必須在聊天視窗中經過您的點擊確認。
- 設定項：`"commands": { "native": "require-approval" }`

### 2. 使用強效 Token
不要使用簡單的單詞作為 Gateway Token。建議使用生成的隨機十六進制字串。
- 生成指令：`openssl rand -hex 16`

### 3. 限制監聽介面
確保 Gateway 僅在 `127.0.0.1` (本地) 監聽。除非您搭配 Tailscale 等 VPN 工具，否則不應將其暴露於 `0.0.0.0`。

### 4. 最小權限 Token (GitHub/API)
如果您使用 `shared-agent-skills` 中的回報器，請為其建立專屬的 **Fine-grained Personal Access Token**，並僅授予特定倉庫的存取權限，避免使用具備全權限的 Classic Token。

### 5. 文件權限
確保您的配置文件權限正確，防止系統其他用戶讀取：
```bash
chmod 600 ~/.moltbot/moltbot.json
chmod 600 ~/.gh_token
```

## 故障排除

### 查看日誌

```bash
# 查看實時日誌（systemd）
journalctl --user -u moltbot -f

# 查看 Gateway 日誌（如果前台運行）
# 日誌會直接輸出到終端
```

### 健康檢查

```bash
# 運行診斷工具
pnpm moltbot doctor

# 檢查 Gateway 連接
curl http://localhost:18789/health
```

### 常見問題

#### Node.js 版本不正確
```bash
# 檢查版本
node --version

# 如果版本低於 22，重新安裝 Node.js 22
```

#### 端口被佔用
```bash
# 檢查端口 18789 是否被佔用
sudo lsof -i :18789

# 或更改配置中的端口
```

#### 無法連接到 AI 服務
```bash
# 驗證 API 密鑰
echo $ANTHROPIC_API_KEY
# 或
echo $OPENAI_API_KEY

# 測試 API 連接
curl -H "x-api-key: $ANTHROPIC_API_KEY" https://api.anthropic.com/v1/messages
```

## 更新 Moltbot

```bash
# 進入 moltbot 目錄
cd ~/moltbot

# 拉取最新更改
git pull

# 重新安裝依賴
pnpm install

# 重新構建
pnpm ui:build
pnpm build

# 重啟服務
systemctl --user restart moltbot  # Linux
# 或重新打開應用（macOS）
```

## 高級配置

### 遠程訪問（使用 Tailscale）

Moltbot 支持通過 Tailscale 安全地暴露 Gateway：

```json
{
  "gateway": {
    "tailscale": {
      "mode": "serve"  // 或 "funnel" 用於公共訪問
    },
    "auth": {
      "mode": "password",
      "password": "your-secure-password"
    }
  }
}
```

### 多代理路由

為不同通道配置不同的代理：

```json
{
  "routing": {
    "routes": [
      {
        "channel": "whatsapp",
        "account": "+1234567890",
        "workspace": "~/clawd-personal"
      },
      {
        "channel": "slack",
        "workspace": "~/clawd-work"
      }
    ]
  }
}
```

### 技能擴展

安裝社區技能：

```bash
# 搜索技能
pnpm moltbot skills search <keyword>

# 安裝技能
pnpm moltbot skills install <skill-name>

# 列出已安裝的技能
pnpm moltbot skills list
```

## 資源鏈接

- **官方網站**: https://molt.bot
- **完整文檔**: https://docs.molt.bot
- **GitHub 倉庫**: https://github.com/moltbot/moltbot
- **Discord 社區**: https://discord.gg/clawd
- **FAQ**: https://docs.molt.bot/start/faq

## 貢獻

歡迎貢獻！請查看 [CONTRIBUTING.md](CONTRIBUTING.md) 了解詳細指南。

## 許可證

MIT License - 詳見 [LICENSE](LICENSE) 文件

---

**注意**: 本指南是基於 Moltbot 2026.1.29 版本編寫的。請確保查看官方文檔以獲取最新信息。
