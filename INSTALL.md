# Installation Guide / 安装指南

[English](#english) | [中文](#中文)

---

## English

### Prerequisites

- An LLM-based agent framework (Hermes, Claude Code, etc.) or direct access to an LLM (ChatGPT, Claude, etc.)
- (Optional) `yt-dlp` for public YouTube data scraping
- (Optional) YouTube Data API key for faster data fetching

### Platform-Specific Installation

#### 1. Hermes Agent (Recommended)

Hermes is the native platform for this skill package. Full support including cron jobs, learning loop, and multi-channel diagnosis.

```bash
# Step 1: Clone the repo
git clone https://github.com/liuxigreen/yt-drama-ops.git ~/yt-drama-ops

# Step 2: Copy skills to Hermes skills directory
cp -r ~/yt-drama-ops/skills/channel-diagnosis ~/.hermes/skills/
cp -r ~/yt-drama-ops/skills/video-optimization ~/.hermes/skills/
cp -r ~/yt-drama-ops/skills/publishing ~/.hermes/skills/
cp -r ~/yt-drama-ops/skills/persona ~/.hermes/skills/

# Step 3: Initialize knowledge directories for learning loop
for skill in channel-diagnosis video-optimization publishing; do
  mkdir -p ~/.hermes/skills/$skill/knowledge
  cp ~/yt-drama-ops/knowledge/*.md ~/.hermes/skills/$skill/knowledge/
done

# Step 4: Verify installation
ls ~/.hermes/skills/channel-diagnosis/SKILL.md
ls ~/.hermes/skills/video-optimization/SKILL.md
ls ~/.hermes/skills/publishing/SKILL.md
```

**Post-installation:**
- The skills auto-detect when activated via trigger words
- No configuration needed for basic usage
- For YouTube Data API support, set `YOUTUBE_API_KEY` environment variable

#### 2. Claude Code

```bash
# Copy skills to Claude's directory
cp -r ~/yt-drama-ops/skills/* ~/.claude/skills/

# Or for Claude Projects, paste SKILL.md content into Project Knowledge
```

#### 3. ChatGPT / Claude.ai (Web)

No installation needed. Copy the relevant SKILL.md content and use as:

1. **Custom Instructions**: Paste into "Custom Instructions" → "How would like ChatGPT to respond?"
2. **System Prompt**: Paste at the beginning of a new conversation
3. **Project Knowledge**: Paste into Claude Projects → Project Knowledge

#### 4. Any Agent Framework

Each SKILL.md is self-contained. To integrate:

1. Copy the SKILL.md file to your agent's skill/instruction directory
2. Copy the `references/` directory alongside it
3. Ensure the agent can read the referenced files when the skill is activated

### References Setup

The skills reference files in `references/` directories. Ensure the relative paths work:

```
skills/
├── channel-diagnosis/
│   ├── SKILL.md          # References: ./references/*.md
│   └── references/
│       ├── hooks.md
│       ├── covers.md
│       ├── quadrant.md
│       ├── retention.md
│       ├── degradation.md
│       └── batch-execution.md
├── video-optimization/
│   ├── SKILL.md          # References: ./references/*.md
│   └── references/
│       ├── hooks.md
│       ├── covers.md
│       └── cover-reference-prompts.md
└── publishing/
    ├── SKILL.md          # References: ./references/*.md
    └── references/
        ├── hooks.md
        ├── covers.md
        ├── short-drama-youtube-3.3.md
        ├── cover-template-cards.md
        ├── cover-reference-prompts.md
        ├── cover-prompt-guide.md
        ├── tags.md
        ├── timing.md
        └── description.md
```

**Important**: `hooks.md` and `covers.md` are shared across all three skills. They live in `publishing/references/` as the canonical source, and are copied to `channel-diagnosis/references/` and `video-optimization/references/` for self-containment.

### Optional: yt-dlp Setup

For public YouTube data scraping:

```bash
# Install yt-dlp
pip install yt-dlp

# Verify
yt-dlp --version
```

### Optional: YouTube Data API Setup

For faster, structured data fetching:

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a project or select existing
3. Enable "YouTube Data API v3"
4. Create an API key
5. Set the environment variable:
```bash
export YOUTUBE_API_KEY="your-api-key-here"
```

### Verification

After installation, test with:

```
# Test channel-diagnosis
诊断这个频道: https://youtube.com/@channelname

# Test video-optimization
优化这个标题: "Useless man mocked like dog, unexpectedly trillion-dollar heir"

# Test publishing
帮我出标题：霸总短剧，女主被赶出家门后发现自己是真千金，目标市场印尼
```

---

## 中文

### 前置条件

- 基于 LLM 的 Agent 框架（Hermes、Claude Code 等）或直接使用 LLM（ChatGPT、Claude 等）
- （可选）`yt-dlp` 用于抓取 YouTube 公开数据
- （可选）YouTube Data API 密钥，用于更快获取数据

### 分平台安装

#### 1. Hermes Agent（推荐）

Hermes 是本技能包的原生平台，完整支持定时任务、学习回路和多频道诊断。

```bash
# 步骤1：克隆仓库
git clone https://github.com/liuxigreen/yt-drama-ops.git ~/yt-drama-ops

# 步骤2：复制技能到 Hermes 技能目录
cp -r ~/yt-drama-ops/skills/channel-diagnosis ~/.hermes/skills/
cp -r ~/yt-drama-ops/skills/video-optimization ~/.hermes/skills/
cp -r ~/yt-drama-ops/skills/publishing ~/.hermes/skills/
cp -r ~/yt-drama-ops/skills/persona ~/.hermes/skills/

# 步骤3：初始化知识目录（用于学习回路）
for skill in channel-diagnosis video-optimization publishing; do
  mkdir -p ~/.hermes/skills/$skill/knowledge
  cp ~/yt-drama-ops/knowledge/*.md ~/.hermes/skills/$skill/knowledge/
done

# 步骤4：验证安装
ls ~/.hermes/skills/channel-diagnosis/SKILL.md
ls ~/.hermes/skills/video-optimization/SKILL.md
ls ~/.hermes/skills/publishing/SKILL.md
```

**安装后**：
- 技能通过触发词自动激活，无需额外配置
- 如需 YouTube Data API 支持，设置 `YOUTUBE_API_KEY` 环境变量

#### 2. Claude Code

```bash
# 复制技能到 Claude 目录
cp -r ~/yt-drama-ops/skills/* ~/.claude/skills/

# 或在 Claude Projects 中，将 SKILL.md 内容粘贴到 Project Knowledge
```

#### 3. ChatGPT / Claude.ai（网页版）

无需安装。将相关 SKILL.md 内容复制后使用：

1. **自定义指令**：粘贴到"自定义指令"→"你希望 ChatGPT 如何回复？"
2. **系统提示词**：在新对话开头粘贴
3. **Project Knowledge**：粘贴到 Claude Projects → Project Knowledge

#### 4. 任意 Agent 框架

每个 SKILL.md 都是自包含的。集成方法：

1. 将 SKILL.md 文件复制到 Agent 的技能/指令目录
2. 将 `references/` 目录一起复制
3. 确保 Agent 在激活技能时能读取引用的文件

### References 配置

技能引用 `references/` 目录下的文件，确保相对路径正确：

```
skills/
├── channel-diagnosis/
│   ├── SKILL.md          # 引用: ./references/*.md
│   └── references/
│       ├── hooks.md       # 钩子+骨架（共享）
│       ├── covers.md      # 封面协同（共享）
│       ├── quadrant.md    # 四象限分类
│       ├── retention.md   # 留存诊断
│       ├── degradation.md # 数据降级
│       └── batch-execution.md
├── video-optimization/
│   ├── SKILL.md          # 引用: ./references/*.md
│   └── references/
│       ├── hooks.md       # 钩子+骨架（共享）
│       ├── covers.md      # 封面协同（共享）
│       └── cover-reference-prompts.md
└── publishing/
    ├── SKILL.md          # 引用: ./references/*.md
    └── references/
        ├── hooks.md       # 钩子+骨架（规范源）
        ├── covers.md      # 封面协同（规范源）
        ├── short-drama-youtube-3.3.md  # 母版
        ├── cover-template-cards.md
        ├── cover-reference-prompts.md
        ├── cover-prompt-guide.md
        ├── tags.md
        ├── timing.md
        └── description.md
```

**重要**：`hooks.md` 和 `covers.md` 是三个技能共享的核心文件。规范源在 `publishing/references/`，同时复制到其他两个技能的 `references/` 目录以保证自包含。

### 可选：安装 yt-dlp

用于抓取 YouTube 公开数据：

```bash
pip install yt-dlp
yt-dlp --version
```

### 可选：配置 YouTube Data API

用于更快、更结构化的数据获取：

1. 访问 [Google Cloud Console](https://console.cloud.google.com/)
2. 创建或选择项目
3. 启用"YouTube Data API v3"
4. 创建 API 密钥
5. 设置环境变量：
```bash
export YOUTUBE_API_KEY="your-api-key-here"
```

### 验证

安装后测试：

```
# 测试频道诊断
诊断这个频道: https://youtube.com/@channelname

# 测试标题优化
优化这个标题: "Useless man mocked like dog, unexpectedly trillion-dollar heir"

# 测试上架出标题
帮我出标题：霸总短剧，女主被赶出家门后发现自己是真千金，目标市场印尼
```

---

## Troubleshooting / 常见问题

### "References not found" / "找不到引用文件"
Ensure the `references/` directory is alongside the SKILL.md file. The skills use relative paths like `./references/hooks.md`.

### "yt-dlp not found"
Install with `pip install yt-dlp` or use YouTube Data API instead.

### "YouTube API quota exceeded"
The YouTube Data API has daily quotas. Use yt-dlp as fallback, or wait for quota reset.

### "Cover analysis fails"
Cover analysis requires a vision-capable model (GPT-4V, Claude 3, etc.). Without vision, covers are skipped with "需封面数据".

### Skills not auto-detecting
Ensure trigger words match. Check skill descriptions for trigger word lists.
