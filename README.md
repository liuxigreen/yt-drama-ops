# yt-drama-ops · YouTube 短剧运营 AI 技能包

> AI-powered toolkit for YouTube short drama channel operations.
> 从7个语言、322个频道、3000+视频蒸馏的跨语言运营方法论。

[English](#english) | [中文](#中文)

---

## English

### What's Inside

| Skill | Description | Trigger |
|-------|-------------|---------|
| 🔍 **channel-diagnosis** | Channel health scoring, bottleneck detection, per-video analysis aggregation | "Diagnose this channel: {URL}" |
| 🎬 **video-optimization** | Hook analysis, skeleton matching, cover synergy, title rewriting | "Optimize this title: {title}" |
| 📝 **publishing** | Title generation, cover design, tag optimization, publish timing | "Generate titles for: {drama info}" |
| 🎭 **persona** | Expert personality layer with judgment and style | Auto-activates with other skills |

### Architecture

```
publishing (generate)              video-optimization (atomic diagnosis)
  │ title generation                 │ hook/skeleton/mode/score
  │ cover design                     │ cover 4D + synergy
  │ tag optimization                 │ per-video JSON output
  │                                  │
  └──── shared references ───────────┘
         hooks.md (non-exhaustive)
         covers.md (synergy rules)
                │
                ▼
     channel-diagnosis (aggregate)
       │ consumes per-video JSON
       │ channel-level aggregation
       │ CTR×AVD quadrant (A/B+ tier)
       └→ structured report
```

### Installation

#### Hermes Agent
```bash
# Clone the repo
git clone https://github.com/liuxigreen/yt-drama-ops.git

# Copy skills to Hermes
cp -r yt-drama-ops/skills/* ~/.hermes/skills/

# Copy knowledge templates (optional - for learning loop)
cp -r yt-drama-ops/knowledge ~/.hermes/skills/channel-diagnosis/
cp -r yt-drama-ops/knowledge ~/.hermes/skills/video-optimization/
cp -r yt-drama-ops/knowledge ~/.hermes/skills/publishing/
```

#### Claude Code / Claude Projects
```bash
# Copy skills to Claude's skill directory
cp -r yt-drama-ops/skills/* ~/.claude/skills/

# Or paste SKILL.md content into Project Knowledge
```

#### ChatGPT / Any LLM
Copy the relevant SKILL.md content and paste as system prompt or custom instructions.

#### Standalone (No Agent Framework)
Each SKILL.md is self-contained. Paste directly into any chat as context.

### Quick Start

**Channel Diagnosis:**
```
Diagnose this channel: https://youtube.com/@channelname
```

**Title Optimization:**
```
Optimize this title: "Useless man mocked like dog, unexpectedly trillion-dollar heir"
```

**Publishing:**
```
Generate titles for: CEO drama, female lead kicked out then discovers she's the real heiress, target market: Indonesia
```

### Data Tiers

| Tier | Data Available | Confidence |
|------|---------------|------------|
| **A** | YouTube Analytics (CTR, retention, traffic) | High |
| **B+** | YouTube Studio screenshots/CSV | Medium-High |
| **B** | Public data (views, likes, comments) | Medium |
| **C** | Title + thumbnail only | Low |

### Learning Loop

Each skill includes a learning protocol:
- `knowledge/lessons.md` — Mistakes and corrections
- `knowledge/validated.md` — Proven conclusions with evidence
- `knowledge/pending.md` — Hypotheses to test

After each use, new findings are logged. Conclusions validated 3+ times get promoted to official rules.

### Dependencies

| Skill | References Used |
|-------|----------------|
| channel-diagnosis | hooks.md, covers.md, quadrant.md, retention.md, degradation.md, batch-execution.md |
| video-optimization | hooks.md, covers.md |
| publishing | hooks.md, covers.md, cover-template-cards.md, cover-reference-prompts.md, cover-prompt-guide.md, short-drama-youtube-3.3.md, tags.md, timing.md, description.md |

**Shared references** (in `skills/publishing/references/`):
- `hooks.md` — Hook types + 13 skeleton formulas + reversal words (non-exhaustive)
- `covers.md` — Cover-title synergy rules + 4D scoring

---

## 中文

### 包含什么

| 技能 | 描述 | 触发词 |
|------|------|--------|
| 🔍 **channel-diagnosis** | 频道健康评分、瓶颈定位、单视频分析聚合 | "诊断这个频道: {URL}" |
| 🎬 **video-optimization** | 钩子分析、骨架匹配、封面协同、标题改写 | "优化这个标题: {标题}" |
| 📝 **publishing** | 标题生成、封面设计、标签优化、发布时间 | "帮我出标题：{剧名+剧情}" |
| 🎭 **persona** | 有判断、有风格的专家人格层 | 自动激活 |

### 架构

```
publishing（生成侧）              video-optimization（原子诊断）
  │ 标题生成                        │ 钩子/骨架/mode/评分
  │ 封面设计                        │ 封面四维+协同
  │ 标签优化                        │ 输出标准 per-video JSON
  │                                 │
  └──── 共享 references ────────────┘
         hooks.md（非穷尽骨架体系）
         covers.md（协同规则）
                │
                ▼
     channel-diagnosis（频道聚合）
       │ 消费 per-video JSON
       │ 频道级聚合分析
       │ CTR×AVD 四象限（A/B+档）
       └→ 结构化报告
```

### 安装

#### Hermes Agent
```bash
# 克隆仓库
git clone https://github.com/liuxigreen/yt-drama-ops.git

# 复制技能到 Hermes
cp -r yt-drama-ops/skills/* ~/.hermes/skills/

# 复制知识模板（可选 - 用于学习回路）
cp -r yt-drama-ops/knowledge ~/.hermes/skills/channel-diagnosis/
cp -r yt-drama-ops/knowledge ~/.hermes/skills/video-optimization/
cp -r yt-drama-ops/knowledge ~/.hermes/skills/publishing/
```

#### Claude Code / Claude Projects
```bash
# 复制技能到 Claude 技能目录
cp -r yt-drama-ops/skills/* ~/.claude/skills/

# 或将 SKILL.md 内容粘贴到 Project Knowledge
```

#### ChatGPT / 任意 LLM
将相关 SKILL.md 内容复制粘贴为系统提示词或自定义指令。

#### 独立使用（无 Agent 框架）
每个 SKILL.md 都是自包含的。直接粘贴到任何聊天中作为上下文。

### 快速开始

**频道诊断：**
```
诊断这个频道: https://youtube.com/@channelname
```

**标题优化：**
```
优化这个标题: "Useless man mocked like dog, unexpectedly trillion-dollar heir"
```

**上架出标题：**
```
帮我出标题：霸总短剧，女主被赶出家门后发现自己是真千金，目标市场印尼
```

### 数据档位

| 档位 | 可用数据 | 置信度 |
|------|----------|--------|
| **A 完整** | YouTube Analytics（CTR、留存、流量来源） | 高 |
| **B+ 人工报表** | YouTube Studio 截图/CSV 导出 | 中高 |
| **B 部分** | 公开数据（播放量、点赞、评论） | 中 |
| **C 最低** | 仅标题 + 封面 | 低 |

### 学习回路

每个技能内置学习协议：
- `knowledge/lessons.md` — 错误和修正
- `knowledge/validated.md` — 已验证的结论（附证据）
- `knowledge/pending.md` — 待验证的假设

每次使用后记录新发现。同一结论被验证≥3次后晋升为正式规则。

### 依赖关系

| 技能 | 使用的 References |
|------|-------------------|
| channel-diagnosis | hooks.md, covers.md, quadrant.md, retention.md, degradation.md, batch-execution.md |
| video-optimization | hooks.md, covers.md |
| publishing | hooks.md, covers.md, cover-template-cards.md, cover-reference-prompts.md, cover-prompt-guide.md, short-drama-youtube-3.3.md, tags.md, timing.md, description.md |

**共享 references**（位于 `skills/publishing/references/`）：
- `hooks.md` — 钩子类型 + 13种骨架公式 + 反转词（非穷尽体系）
- `covers.md` — 封面×标题协同规则 + 四维评分

### 骨架体系

骨架是**非穷尽**的坐标系，不是封闭模具：
- **已知家族**（13种）：跨语言验证的高频模式
- **Emergent模式**：标题连贯但不匹配已知家族 → 自述新骨架
- **Contrarian模式**：故意不匹配任何已知框架 → 独立评分通道

三种都是合法的 mode。把 contrarian 判为"失败"是系统性错误。

### 语言支持

跨语言验证覆盖：English, Spanish, Indonesian, Japanese, Portuguese, Turkish, 繁體中文

非核心语种可借用邻近市场数据（如韩语→日语+繁中，印地语→印尼+英文）。

---

## Structure / 目录结构

```
yt-drama-ops/
├── skills/
│   ├── channel-diagnosis/        # 频道诊断
│   │   ├── SKILL.md              # 主协议
│   │   └── references/           # 四象限、留存、降级、hooks、covers
│   ├── video-optimization/       # 单视频优化
│   │   ├── SKILL.md              # 主协议
│   │   └── references/           # hooks、covers、cover-reference-prompts
│   ├── publishing/               # 上架策略
│   │   ├── SKILL.md              # 主协议
│   │   └── references/           # 母版、模板卡、标签、时间、描述
│   └── persona/                  # 人格层
│       └── SKILL.md
├── knowledge/                    # 学习回路模板
│   ├── lessons.md
│   ├── validated.md
│   └── pending.md
├── examples/                     # 使用示例
│   ├── diagnosis-from-link.md
│   ├── diagnosis-from-screenshot.md
│   └── publishing-flow.md
├── templates/                    # 报告模板
│   └── report-template.md
├── scripts/                      # 工具脚本
│   └── scrape-channel.sh
├── distill/                      # 蒸馏数据
├── CHANGELOG.md                  # 版本历史
├── INSTALL.md                    # 安装指南
└── README.md                     # 本文件
```

## License

MIT
