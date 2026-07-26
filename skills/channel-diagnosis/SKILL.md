---
name: channel-diagnosis
description: |
  YouTube 短剧频道诊断专家 — 输入频道数据/链接/Studio截图，输出健康度评分 + 瓶颈定位 + 对症建议。
  当用户给出频道链接并询问频道表现、增长瓶颈、视频优化方向时使用。
  必须先跑单视频诊断（video-optimization），再聚合为频道级分析。
  支持 yt-dlp 和 YouTube Data API 两种数据源。
  支持四档数据降级：OAuth全量 / Studio截图 / 公开数据 / 纯标题封面。
  数据不足时自动压低置信，绝不硬下结论。
  骨架体系与 publishing / video-optimization 共享：非穷尽 + emergent + contrarian。
---

# YouTube 短剧频道诊断

> 「先说数据够不够，再说频道行不行。数据不足时闭嘴比乱说值钱。」

## 角色

诊断专家。直接用数据说话，每条结论必须带具体数字 + 可执行动作。数据不足就明说"样本不足"，不编。

---

## 数据协议（最高优先级）

1. **我不猜，我查。** 所有结论必须基于用户提供或工具获取的真实数据。
2. **禁止用训练语料编造频道数据；** 拿不到的数据标"数据缺失"并降档。
3. **数据分四档：** A档（OAuth全量）/ B+档（Studio截图）/ B档（公开数据）/ C档（纯标题封面）→ 详见 references/degradation.md

---

## 取数协议（收到频道后第一件事）

### 数据源选择

**优先级**：
1. **YouTube Data API v3**（如果配置了 `YOUTUBE_API_KEY` 环境变量）
   - 优势：批量获取、结构化JSON、含标签数据、速度快
   - 获取：标题、播放量、点赞、评论、时长、发布时间、标签、封面URL
   - 命令：`curl "https://www.googleapis.com/youtube/v3/search?part=snippet&channelId={id}&maxResults=30&order=viewCount&key={API_KEY}"`
2. **yt-dlp**（免费，无需API key）
   - 命令：`yt-dlp --dump-json --playlist-items 1:30 {频道URL}`
   - 获取：标题、播放量、点赞、评论、时长、发布时间、封面URL（无标签）
3. **用户提供数据**（降级）

**降级铁律**：
- 禁止用训练语料里的印象编造某频道的数据
- 数据缺失的维度进 skipped，不硬凑
- 每条结论必须能追溯到刚扒的真实数字

### 判为B/C档时：
不要直接开始低置信分析，先向用户发**数据自取清单**（升到B+档的路径）：
- 「内容」标签页截图（展示次数、点击率、平均观看时长）
- 1-3条重点视频的留存曲线截图
- 流量来源截图
- 详见 references/degradation.md 的"B+档"章节

---

## 诊断流程总览

```
Step 0: 取数（yt-dlp / YouTube API / 用户提供）
    ↓
Step 1: 选视频（按播放量+近期+问题视频，选出5-10条）
    ↓
Step 2: 逐条跑 video-optimization 诊断（钩子/骨架/mode/score/封面/改写）
    ↓
Step 3: 聚合 per-video 数据 → 频道级分析（步骤1-9）
    ↓
Step 4: 输出结构化报告
```

**铁律**：频道诊断必须先跑 per-video 诊断，再做频道级聚合。不跑 per-video 就不给频道诊断。

---

## Step 0：取数

### YouTube Data API 方式（推荐）

如果环境中有 `YOUTUBE_API_KEY`：
```bash
# 获取频道ID
curl "https://www.googleapis.com/youtube/v3/channels?part=contentDetails,snippet&forHandle={频道名}&key={API_KEY}"

# 获取最新30条视频（按发布时间）
curl "https://www.googleapis.com/youtube/v3/search?part=snippet&channelId={CHANNEL_ID}&maxResults=30&order=date&type=video&key={API_KEY}"

# 获取视频统计（播放量、点赞、评论）
curl "https://www.googleapis.com/youtube/v3/videos?part=statistics,contentDetails,snippet&id={VIDEO_IDS}&key={API_KEY}"
```

### yt-dlp 方式（默认）

```bash
yt-dlp --dump-json --playlist-items 1:30 {频道URL}
```

提取：标题、播放量、点赞、评论、时长、发布时间、封面URL

---

## Step 1：选视频（诊断深度设计）

频道诊断不需要分析所有视频。按以下策略选出**5-10条**代表性视频：

### 选择策略

| 类别 | 选几条 | 选择逻辑 | 目的 |
|------|--------|----------|------|
| **头部视频** | 3-5条 | 按播放量排序，取 top 5 | 识别爆款模式（骨架/钩子/封面），学习复制 |
| **近期视频** | 3-5条 | 最新发布的5条 | 识别当前趋势、是否在用正确策略 |
| **问题视频** | 0-2条 | 零点赞 / 播放量异常低 / 标题明显弱 | 定位频道瓶颈 |

### 去重规则

头部视频和近期视频可能重叠。重叠的只算一次，总数保持5-10条。

### 频道规模适配

| 频道规模 | 总视频数 | 诊断视频数 | 头部 | 近期 | 问题 |
|----------|----------|------------|------|------|------|
| 小型（<50条） | <50 | 4-6 | top 3 | 最新3 | 0-1 |
| 中型（50-200条） | 50-200 | 6-8 | top 5 | 最新5 | 0-2 |
| 大型（>200条） | >200 | 8-12 | top 5 | 最新5 | 1-2 |

### 用户可调深度

用户可以说"只诊断top 3"或"全部分析"来覆盖默认策略。

---

## Step 2：逐条跑 video-optimization 诊断

对 Step 1 选出的每条视频，调用 video-optimization skill 的完整流程：

### 诊断内容

对每条视频产出标准 per-video 诊断 JSON：
- `mode`：creative / emergent / contrarian
- `hooks`：found / quality / pairing / pairing_rating
- `skeleton`：match / multi_skeleton / view_range
- `score`：total + 5维明细
- `cover`：四维评分 + synergy_score + anti_patterns
- `optimized_titles`：改写方案（≥2条）
- `issues`：问题列表

### 执行方式

- **有 video-optimization skill**：按 skill 流程执行
- **没有 skill**（外部用户）：本 skill 内置简化版流程：
  1. 读 references/hooks.md 做钩子识别和骨架匹配
  2. 读 references/covers.md 做封面四维评分
  3. 按本 skill 的评分体系打分
  4. 产出标准 per-video JSON

### 持久化

每条视频的诊断结果保存，供 Step 3 聚合使用。

---

## 诊断前置：先判数据档位

拿到任何频道，第一步不是分析，是**判断数据够到哪一档**。档位决定能出什么结论、置信多高。

| 档位 | 拿到的数据 | 能诊断什么 | 置信上限 |
|---|---|---|---|
| **A 完整** | YouTube Analytics 授权（CTR/留存/流量来源/受众/8维度） | 全部维度 | 高 |
| **B+ 人工报表** | 用户提供YouTube Studio截图/CSV导出 | 全部维度（人工读数） | 中高 |
| **B 部分** | 公开播放/点赞/评论/时长/发布时间 + 标题标签 | 播放分布、标题、互动、一致性、节奏 | 中 |
| **C 最低** | 只有标题 + 封面 + 播放量（yt-dlp 可扒） | 标题模式、一致性、封面协同 | 低（单项≤6分） |

**降级铁律**：缺 CTR 和留存时，禁止对"点击率""完播"下任何结论，只标 `CTR: 样本不足`。

---

## Step 3：频道级诊断（9步，聚合版）

### 步骤 1：播放分布诊断
**看什么**：头部集中度、长尾、断崖、均匀度。
**算法**：
- `top3_ratio` = 前3条播放 / 总播放
- `cliff` = 最近5条均播 / 之前5条均播
**认知框架**：
- YouTube推荐系统遵循**幂律分布（Power-law Distribution）**，头部视频播放占比高是平台机制的必然结果，**严禁列为频道问题**。
- 诊断重点必须是：头部视频的叙事骨架是什么？封面×标题协同模式是什么？如何批量复制（Format Replication）？
**触发规则**：
- cliff < 0.3 → **critical**：近期流量断崖。动作：查最近3条是否违规词；对比断崖前后标题封面变化。

### 步骤 2：标题模式诊断（聚合 per-video 数据）

从 Step 2 的 per-video 诊断结果聚合以下频道级指标：

**标准指标**（creative + emergent 视频）：

| 指标 | 计算方式 | 含义 |
|------|----------|------|
| **骨架分布** | 各骨架类型的视频数占比 | 频道是否依赖单一骨架 |
| **mode分布** | creative/emergent/contrarian 各占比 | 创新程度 |
| **钩子命中率** | hooks.quality=合格 的视频占比（仅 creative+emergent） | 标题质量 |
| **平均评分** | score.total 的均值和标准差（仅 creative+emergent） | 整体质量+一致性 |
| **多骨架占比** | multi_skeleton.length>1 的视频占比 | 标题丰富度 |
| **低效组合命中率** | pairing_rating=低效组合 的视频占比 | 需要优化的比例 |

**Contrarian 独立指标**（仅 contrarian 视频）：

| 指标 | 计算方式 | 含义 |
|------|----------|------|
| **contrarian占比** | mode=contrarian 的视频数 / 总视频数 | 反惯例尝试频率 |
| **contrarian平均分** | contrarian 视频的 score.total 均值 | 反惯例标题质量 |
| **平均新颖度** | contrarian 视频的 novelty_score 均值（0-30） | 句式差异化程度 |
| **平均信息缺口** | contrarian 视频的 info_gap_strength 均值（0-30） | 悬念制造能力 |

**注意**：钩子命中率和平均评分只统计 creative+emergent 视频。contrarian 走独立评分通道，混入标准指标会导致失真。

**触发规则**：
- 单一骨架占比 > 60% → **major**：过度依赖单一模式。动作：尝试其他骨架类型。
- 钩子命中率 < 50% → **major**：多数标题钩子不足。动作：参考 hooks.md 配对规则优化。
- 低效组合命中率 > 30% → **info**：部分标题使用了低效钩子组合。
- contrarian 占比 = 0 → **info**：所有标题都是公式化，可尝试反惯例标题。
- contrarian 占比 > 30% → **info**：大量标题为反惯例，检查是否有足够数据验证效果。
- contrarian 平均新颖度 < 15 → **info**：反惯例标题句式差异化不够，可能只是换了骨架但句式雷同。
- contrarian 平均信息缺口 < 15 → **info**：反惯例标题悬念不足，需要强化"不点就难受"的缺口感。

**标题表层统计**（始终计算，不依赖 per-video）：
- 平均长度 vs 60-90 字符高播放带
- 重复 emoji 前缀（>50%视频相同）→ **major**
- 标题开头重复 >2次 → **major**

### 步骤 3：点赞漏斗诊断
**看什么**：点赞率、评论率、零互动比例。
**赞率计算**：必须用**加权平均**（总点赞/总播放×100）。
**触发规则**：
- 点赞率 < 0.5% → **critical**（行业基准1.5-2%）
- 点赞率 0.5-1% → **major**
- 评论/点赞比 < 5% → **info**

### 步骤 4：内容一致性诊断
**看什么**：题材检测、主类型占比。
**触发规则**：
- 一致性分 < 0.5 → **major**

### 步骤 5：订阅转化诊断
**看什么**：播放/订阅比、频道年龄 vs 订阅数。
**触发规则**：
- 播放/订阅比 > 100:1 且订阅<500 → **major**
- >30天 且 <100订阅 → **critical**

### 步骤 6：SEO 诊断
**看什么**：平均标签数、无标签视频数。
**触发规则**：
- 平均标签 < 5 或有无标签视频 → **info**

### 步骤 7：发布节奏诊断
**看什么**：weekday 分布、发布集中度。
**触发规则**：
- 单日发布占比 > 40% → **info**

### 步骤 8：时长/内容策略诊断
**看什么**：视频时长分布。
**触发规则**：
-（此维度暂无通用规则，待验证后补充）

### 步骤 9：封面×标题协同诊断（聚合 per-video 数据）

从 Step 2 的 per-video 诊断结果聚合以下频道级指标：

| 指标 | 计算方式 | 含义 |
|------|----------|------|
| **封面四维均值** | figure/emotion/props/text 各维度均值 | 整体封面质量 |
| **协同分均值** | synergy_score 的均值和标准差 | 封面×标题配合度 |
| **反模式命中率** | anti_patterns 非空的视频占比 | 需要修正的比例 |
| **门面拖累视频数** | CTR<2.5% 且 AVD≥15% 的视频数（需A/B+档） | 内容好但门面差 |
| **高CTR冻结视频数** | CTR≥4% 的视频数（需A/B+档） | 绝对禁止改动元数据 |

**触发规则**：
- 封面四维均值 < 5 → **major**
- 协同分均值 < 5 → **major**
- 反模式命中率 > 30% → **info**
- 门面拖累视频数 > 0 → **major**：策略**只准**"重置门面"
- 高CTR冻结视频数 > 0 → **info**：**绝对禁止改动元数据**

→ 完整协同规则和反模式见 references/covers.md

---

## 【仅 A/B+ 档】CTR 与留存深度诊断

有授权数据或Studio截图时才做，否则整段跳过并标注"需授权数据"。

### 四象限分类（CTR×AVD二维矩阵）
→ 完整规则见 references/quadrant.md

### 留存曲线诊断
→ 完整规则见 references/retention.md

---

## optimized_titles 生成规则

**同源原则**：从 Step 2 的 per-video 改写汇总，保证与 video-optimization 一致。

**选取方式**：
- 从 per-video 的 optimized_titles 中选取最佳改写
- 按 score.total 排序，取 top 3-5 条
- 每条保留原字段：title / mode / skeleton / hooks / score / reason

---

## 输出格式（结构化报告）

```json
{
  "data_tier": "A|B+|B|C",
  "per_video_count": 8,
  "per_video_data": true,
  "health_score": 6.5,
  "health_grade": "A|B|C|D",
  "confidence": "high|medium|low",
  "bottleneck": "一句话点出最致命的那个问题",
  "quadrant_summary": {
    "status": "ok|provisional|skipped",
    "total_classified": 0,
    "buckets": {
      "爆款基因": 0,
      "标题超卖_开头型": 0,
      "标题超卖_中段型": 0,
      "门面拖累": 0,
      "选题失败": 0,
      "表现平庸": 0
    }
  },
  "title_aggregation": {
    "skeleton_distribution": {"身份落差打脸型": 5, "关系背叛补偿型": 3},
    "mode_distribution": {"creative": 6, "emergent": 1, "contrarian": 1},
    "hook_hit_rate": 0.75,
    "avg_score_creative_emergent": 82.5,
    "multi_skeleton_rate": 0.25,
    "inefficient_pairing_rate": 0.12,
    "contrarian": {
      "ratio": 0.12,
      "avg_score": 78,
      "avg_novelty": 22,
      "avg_info_gap": 25
    }
  },
  "cover_aggregation": {
    "avg_figure": 6.5,
    "avg_emotion": 5.8,
    "avg_props": 4.2,
    "avg_text": 6.0,
    "avg_synergy": 5.5,
    "anti_pattern_rate": 0.25,
    "doorface_drag_count": 1,
    "high_ctr_frozen_count": 2
  },
  "issues": [
    {
      "severity": "critical|major|info",
      "category": "播放分布|标题|互动|封面协同|...",
      "issue": "问题（带具体数字）",
      "detail": "为什么（带数据）",
      "evidence": "支撑数据字段",
      "action": "①具体步骤 ②具体步骤"
    }
  ],
  "optimized_titles": [
    {
      "original": "原标题",
      "title": "优化后标题",
      "mode": "creative|emergent|contrarian",
      "skeleton": "用了哪个骨架",
      "hooks": ["钩子1", "钩子2"],
      "score": 90,
      "reason": "为什么这样改",
      "source": "video-optimization"
    }
  ],
  "skipped": ["因数据不足跳过的维度 + 原因"],
  "next_check": "24h|48h|1week"
}
```

**报告纪律**：
- 每条 issue 必须有 `evidence` 字段（具体数字），禁止"感觉不太行"。
- 数据不足的维度进 `skipped`，不进 issues，不硬凑分数。
- 健康度评分要扣掉 skipped 维度的权重。
- **诊断完必须给 2 条优化标题**，不能只诊断不给解法。
- **赞率必须用加权平均**（总赞/总播×100）。
- **播放分布遵循幂律分布**，头部集中是正常机制，严禁列为"爆款依赖症"。
- **门面拖累只准重置门面**（CTR<2.5%但AVD≥15%），严禁发散到剧情节奏或选题。
- **高CTR视频元数据冻结**（CTR≥4%），禁止改标题/封面/标签。

---

## 诊断标准速查

| 维度 | 标杆 | 健康 | 一般 | 差 |
|---|---|---|---|---|
| 赞率 | >3% | 1.5-3% | 1-1.5% | <1% |
| 播放分布 | <30%头部 | 30-50% | 50-60% | >60% |
| 留存（短剧1h） | 1%处>80% | 3分钟>30% | 5分钟>25% | 低于基准 |
| 流量（推荐） | >50% | 30-50% | 20-30% | <20% |
| CTR | >8% | 5-8% | 2.5-5% | <2.5% |

---

## 批量/Cron 执行

当以 cron job 或批量模式运行诊断时，关键注意事项：
→ 详见 references/batch-execution.md（超时要求、输出陷阱、JSON结构、幂等性）

**速记**：snapshot 先于 diagnosis；`diagnose_channel.py --all` 需 600s 超时；后台进程无法捕获 Python 输出，必须前台执行。

---

## 诚实边界
- 阈值来自特定频道基线（diagnosis_engine.py），不同频道有差异。
- CTR/完播阈值基于推断，非每个频道实测。
- 无授权数据时，点击率和完播率维度不可诊断。
- 骨架体系（非穷尽 + emergent + contrarian）与 publishing 共享。

---

## 学习协议（每次使用本skill后执行）

1. **遇到未覆盖的情况**（新指标/新场景/规则给不出答案）：
   - 不硬套现有规则，明确告诉用户"此场景超出已验证范围"
   - 把该场景+当次的处理方式追加到 `knowledge/pending.md`，格式：
     `日期 | 场景描述 | 当次采用的假设 | 验证方法 | 状态:待验证`

2. **用户反馈某条建议有效/无效时**：
   - 有效 → 移入 `knowledge/validated.md`（记录：结论/证据/样本量/日期）
   - 无效 → 移入 `knowledge/lessons.md`（记录：错误结论/为什么错/正确做法）

3. **validated.md 中同一结论被验证≥3次** → 提示用户批准将其写入 skill 正文（成为正式规则），并在 CHANGELOG.md 记录版本变更

4. **阈值类知识必须带出处标注**：`[来源:频道名 基线 日期]` ——防止特定频道的经验被误用为普适真理
