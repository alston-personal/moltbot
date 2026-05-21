# Workspace Manager Skill

一个用于管理工作空间（workspaces）的 Moltbot skill，可以快速创建新项目并自动安装全局 skills。

## 功能特点

- ✨ 快速创建新的工作空间
- 📦 自动安装全局 skills 到新工作空间
- 📁 自动创建标准目录结构（.agent, workflows, skills）
- 📝 生成基础项目文件（README.md, .gitignore）
- 🔗 通过符号链接共享 skills，节省磁盘空间
- 📊 列出所有现有工作空间

## 使用方法

### 创建新的工作空间

直接告诉 AI:

```
帮我创建一个新的 workspace 叫 my-new-project
```

或者手动运行：

```bash
skills/workspace-manager/scripts/create_workspace.sh my-new-project
```

### 自定义项目根目录

```bash
skills/workspace-manager/scripts/create_workspace.sh my-app --root /home/ubuntu/custom-projects
```

### 安装 skills 到现有项目

```bash
skills/workspace-manager/scripts/install_global_skills.sh /home/ubuntu/my-existing-project
```

### 列出所有工作空间

```bash
skills/workspace-manager/scripts/list_workspaces.sh
```

## 配置

### 默认项目根目录

默认情况下，新的 workspace 会创建在 `/home/ubuntu/projects/`。

要更改默认路径，可以设置环境变量：

```bash
export PROJECTS_ROOT=/your/custom/path
```

或者在创建时使用 `--root` 参数。

## 创建的目录结构

```
my-new-project/
├── .agent/
│   ├── global-skills/      # 符号链接到 /home/ubuntu/moltbot/skills
│   ├── skills/             # 项目特定的 skills
│   └── workflows/          # 项目特定的 workflows
├── .gitignore              # Git 忽略文件
└── README.md               # 项目说明文档
```

## 下一步

创建工作空间后，您可以：

1. **在 VS Code 中打开**
   - 按 `Ctrl+Shift+P` (或 Mac 上的 `Cmd+Shift+P`)
   - 输入 "File: Open Folder"
   - 选择新创建的工作空间路径

2. **初始化版本控制**
   ```bash
   cd /home/ubuntu/projects/my-new-project
   git init
   ```

3. **开始编码！**

## 示例场景

### 场景 1: 创建 Web 应用项目

```bash
skills/workspace-manager/scripts/create_workspace.sh my-web-app
cd /home/ubuntu/projects/my-web-app
npm init -y
```

### 场景 2: 创建 Python 数据分析项目

```bash
skills/workspace-manager/scripts/create_workspace.sh data-analysis
cd /home/ubuntu/projects/data-analysis
python -m venv venv
source venv/bin/activate
```

### 场景 3: 管理多个客户项目

```bash
# 在自定义目录下创建
skills/workspace-manager/scripts/create_workspace.sh client-acme --root /home/ubuntu/clients
skills/workspace-manager/scripts/create_workspace.sh client-globex --root /home/ubuntu/clients

# 查看所有客户项目
skills/workspace-manager/scripts/list_workspaces.sh --root /home/ubuntu/clients
```

## 技术细节

### Global Skills 链接

Global skills 通过符号链接实现：
- 节省磁盘空间（不复制文件）
- 自动同步更新（链接指向源目录）
- 位置：`.agent/global-skills -> /home/ubuntu/moltbot/skills`

### 工作空间识别

脚本通过检查 `.agent` 目录来识别"受管理的工作空间"：
- ● (绿点) = 受管理的工作空间（有 .agent 目录）
- ○ (黄点) = 未受管理的工作空间

## 常见问题

**Q: 我可以修改默认的项目根目录吗？**
A: 可以！设置 `PROJECTS_ROOT` 环境变量或使用 `--root` 参数。

**Q: 如果工作空间已存在会怎样？**
A: 脚本会检测并拒绝覆盖现有工作空间，确保数据安全。

**Q: Global skills 会占用额外空间吗？**
A: 不会！使用符号链接，不会复制文件。

**Q: 我可以在工作空间中添加自定义 skills 吗？**
A: 可以！将自定义 skills 放在 `.agent/skills/` 目录中。

## 贡献

这是 Moltbot 的一个 skill。如果您有改进建议，欢迎提交！

## 许可

与 Moltbot 项目保持一致。
