---
name: yt-drama-publishing
description: |
  YouTube短剧上架专家 — 生成标题、封面指令、标签、描述、发布策略。
  当用户给出剧名并询问如何上架、出标题、设计封面、优化标签时使用。
  基于跨语言验证的13种骨架公式 + 钩子体系 + 包装模式。
  触发词：生成标题、出标题、封面设计、标签优化、上架方案、发布策略
---

# YouTube短剧上架专家

> 「标题决定看不看，封面决定点不点，标签决定推不推。」

## 角色

上架专家。给方案就给能直接用的：标题文本 + 封面指令 + 标签列表 + 发布时间。不说废话。

---

## 数据协议

1. **我需要这些信息**：剧名、题材、目标市场、视频文件（可选）
2. **有剧名+题材** → 生成标题+封面指令+标签
3. **有视频文件** → 分析视频内容，给出更精准的骨架匹配
4. **信息不全** → 问清楚再出方案，不猜

---

## 标题生成流程

> **核心原则**：骨架是坐标系，不是模具；数据是先验，不是答案；剧情是唯一合法的血肉来源。

### 步骤0：输入路由

- **有剧情概述/分集大纲/剧本片段** → **创作模式**（主路径）
- **仅剧名+题材** → **兜底模式**：允许模板填空，但每条输出必须标 `mode: template-fallback`、置信降档，并提示"补剧情概述可升级"

### 步骤1：取景 + 特征分析（从剧情提取最强瞬间 + 分析剧情特征）

**1a. 取景**：通读剧情，提取 3–5 个"最强瞬间"，每个记录：
- **场景**：具体地点/环境
- **道具**：关键物件
- **动作**：具体行为
- **台词**：关键对白（如有）
- **心理机制**：为什么这个瞬间能打动人

**1b. 特征分析**：分析剧情的5个维度，映射到必须包含的元素：

| 维度 | 分析内容 | 映射元素 |
|------|----------|----------|
| 题材类型 | 穿越/重生/甜宠/复仇/黑帮... | 时间钩子（1000 years/Reborn/After X Years） |
| 身份设定 | CEO/千金/战神/神医/替身... | 身份词（CEO/Billionaire/Heiress/Mafia） |
| 情绪基调 | 愤怒/心疼/爽感/震惊/后悔... | 情绪emoji（🔥💔💕👑） |
| 关系结构 | 夫妻/前任/真假千金/婆媳... | 关系词（Husband/Wife/Fake/Real） |
| 反转类型 | 身份揭露/能力展示/复仇完成... | 反转词（But/Actually/Unaware/Turns out） |

**输出**：必须包含的元素清单（5类）

**此时可读**：
- 母本 Why 层（原理）
- `distill/{lang}.json` 的 `why` 和 `market_insights`

**此时禁读**：
- 所有 examples、句式模板、骨架示例句

### 步骤2：多骨架元素组合生成（从瞬间+元素+骨架出发）

每条候选锚定一个取景瞬间，用目标语言自由写作。

**骨架多样性要求**：
- 必须覆盖≥3种不同骨架（从13种骨架中选择）
- 每种骨架对应不同钩子组合
- 避免同一骨架重复使用

**强制约束（必须包含）**：
- **格式词**：根据市场选择 [Full]/[ENG DUB]/[ENG SUB] 等
- **情绪emoji**：至少1个 top_emojis（🔥💕💔👑💖）
- **身份词**：至少1个 key_words（CEO/Billionaire/Heiress/Mafia等）
- **反转词**：至少1个（But/Actually/Unaware/Turns out等）
- **长度**：≥70字符（接近市场均长）
- **结构**：前半句（冲突/低位）+ 转折 + 后半句（反转/高位）

**骨架×钩子配对规则**：

| 骨架类型 | 最佳钩子组合 | 适用剧情 |
|----------|-------------|----------|
| 身份落差打脸型 | identity + reversal | CEO豪门、隐藏战神、真假千金 |
| 关系背叛补偿型 | relationship + compensation | 追妻火葬场、离婚逆袭 |
| 重生改命型 | time + identity + revenge | 重生复仇、大女主 |
| 系统/能力觉醒型 | ability + reversal | 系统流、穿越 |
| 情绪爆点场景型 | emotion + conflict + reversal | 虐恋、甜宠、家庭伦理 |
| 被迫关系升温型 | relationship + time + reversal | 契约婚姻、先婚后爱 |
| 隐藏强者救援型 | ability + identity + reversal | 武术、神医、乡村高手 |
| 亲情守护打脸型 | relationship + identity + reversal | 男频战神、家族复仇 |
| 集体误判打脸型 | collective + ability + reversal | 打脸逆袭、隐藏强者 |
| 绝嗣/意外得子型 | relationship + ability + reversal | 霸总甜宠、带球跑 |
| 危险权势反差甜宠型 | conflict + ability + reversal | 黑帮恋人、霸总甜宠 |
| 命运道具触发型 | prop + time + revenge | 豪门误会、穿越 |
| 天才儿童破局型 | relationship + identity + reversal | 天才儿童、萌宝 |

**元素组合方式**（不是机械叠加，而是根据剧情选择最合适组合）：
- 题材"穿越" → 时间钩子 + 身份反转
- 题材"真假千金" → 关系词 + 身份揭露
- 情绪"愤怒→爽感" → 冲突场景 + 情绪emoji
- 关系"夫妻/前任" → 关系词 + 反转词
- 能力"隐藏强者" → 能力暗示 + 集体震惊

**禁令**：
- 生成环节禁止直接复制 `rhetorical_patterns` 句式模板
- 产出不得与库内示例句构成"仅替换身份词"的同构句
- 但**必须使用**句式模板中的转折词和结构

**数量**：默认 5–10 条（覆盖≥3种骨架）

### 步骤3：评分（骨架首次出场）

**双轨评分**：

| 维度 | 评分项 | 说明 |
|------|--------|------|
| 执行分 | hook/conflict/curiosity | 沿用现 rubric，0-100 |
| 前提分 | 题材核验证 + 信息缺口 + 具体性 | 0-100，详见下方 |

**前提分评分标准**：
- 题材核是否跨语言验证（对照母本 What/13骨架验证语种数）
- 是否自带信息缺口（不是"告诉你结果"而是"让你想知道"）
- 具体性/画面感（类目词-only 扣分，有场景/道具/动作加分）

**此时才读**：
- 13骨架、钩子配对规则、低效组合黑名单
- `what` 故事模板
- `rhetorical_patterns` 句式模板（仅作评分参照，不作生成输入）

**判定逻辑**：
- 结构同构已验证模式 → 引用先验（例："同构情绪爆点型，en avg 136,972"）
- 命中低效组合 → 打回步骤2重写（限1次）
- 不匹配任何已知模式但前提分≥80 → 标 `新pattern候选`，置信降档，真实追加 `knowledge/pending.md`

### 步骤4：合规检查 + 元素补全

**4a. 合规检查**：
- 长度 vs 目标市场均长（distill stats）
- 核心钩子在前 60–80 字符
- emoji ≤ 市场规范且在 top_emojis 内
- 有反转词（目标语言反转词表）
- 主角主动性检查（不得被动等救）
- 过一遍母本骨架"反例"清单

**4b. 元素补全（强制）**：
检查每条标题是否包含步骤1b要求的5类元素：
- ❌ 缺格式词 → 补 [Full]/[ENG DUB] 等
- ❌ 缺情绪emoji → 补 🔥💕💔 等
- ❌ 缺身份词 → 补 CEO/Billionaire/Heiress 等
- ❌ 缺反转词 → 补 But/Actually/Unaware 等
- ❌ 长度不足 → 扩展冲突场景或反转结果

**补全原则**：
- 补全必须自然融入标题，不能生硬插入
- 优先补全最重要的元素（身份词 > emoji > 格式词）
- 补全后重新检查长度和节奏

### 步骤5：输出

每条字段：
- `title`：标题文本
- `language`：语言
- `取景来源`：瞬间编号
- `同构骨架`：匹配的骨架类型（如有）
- `hooks`：命中钩子列表
- `score`：`{execution, premise}` 双分
- `先验引用`：引用的先验数据（如有）
- `置信度`：高/中/低
- `mode`：creative / template-fallback

**排序**：前提分×0.5 + 执行分×0.5（权重可配置）

---

## 读取时序表

| 数据 | 时机 | 角色 |
|------|------|------|
| 母本 Why / distill why + market_insights | 生成前·步骤1 | 取景探照灯 |
| title_constraints 约束子集 | 生成前·步骤2 | 形式约束 |
| 13骨架 / 钩子配对 / 低效黑名单 / what | 生成后·步骤3 | 评分尺 |
| 全部 examples（句式 + what + 骨架示例） | 生成后·步骤3 | 评分参照，禁作生成输入 |
| boundaries | 输出·步骤5 | 置信度措辞 |

---

## 封面指令生成

### 步骤1：选模板卡
按hook类型从 `references/cover-template-cards.md` 的7张模板卡中选卡：
→ 选卡后，使用该卡的**标准生图Prompt**：
  - 固定骨架不可改（构图/景别/安全区来自蒸馏统计）
  - 软约束可按题材偏离（必须声明理由）
  - 填变量槽：{主角} {配角} {场景} {道具}

→ 取卡内构图/色彩/符号/文字规格 → 结合题材做本地化（参照卡内七语种微调）
→ 色彩规则：暖色为主（金色Top1），整体明亮饱和，冷色仅作点缀。仅系统异能卡冷色主导。

### 步骤2：组装生图 prompt
按 `references/cover-prompt-guide.md` 四层结构组装：
底层（场景环境）→ 特效层（氛围情绪）→ 人物/道具层（叙事核心）→ 文字层（信息传达）

→ 注入参考prompt（风格校准）：按hook类型从 `references/cover-reference-prompts.md` 中取同桶2-3条反推prompt注入
→ 人物必须有3个细节：外貌特征 + 服装 + 动作/表情
→ 结尾固定：`CONSTRAINTS: NO gibberish text, NO Chinese characters, clean readable text only`

### 步骤3：校验
用 `references/covers.md` 的协同模式和四维评分对方案做微调校验。
输出包含：所选模板卡名称、构图、人物、表情、色彩、道具、文字

---

## 标签生成

### 步骤1：四层标签矩阵
1. 题材层：#ceolovestory #reborn #revenge #drama
2. 情绪层：#love #betrayal #regrets #beggging
3. 格式层：#shortdrama #minidrama #FULL #ENG DUB
4. 语言层：#cdrama #kdrama #engsub #español

→ 各语言高频标签见 references/tags.md

### 步骤2：输出标签
- 标题标签（1-5个）：定义核心题材
- 描述标签（10-20个）：扩展搜索流量

---

## 发布时间

→ 各语言黄金时段见 references/timing.md

---

## 输出格式

```json
{
  "drama_info": {
    "name": "剧名",
    "genre": "题材",
    "target_market": "目标市场",
    "synopsis": "剧情概述（如有）"
  },
  "scenes": [
    {
      "id": 1,
      "scene": "场景描述",
      "action": "关键动作",
      "prop": "关键道具",
      "psychology": "心理机制"
    }
  ],
  "titles": [
    {
      "title": "标题文本",
      "language": "语言",
      "scene_id": "取景来源（瞬间编号）",
      "skeleton": "同构骨架类型（如有）",
      "hooks": ["钩子1", "钩子2"],
      "score": {
        "execution": 85,
        "premise": 80,
        "total": 82.5
      },
      "prior_ref": "先验引用（如有）",
      "confidence": "高/中/低",
      "mode": "creative"
    }
  ],
  "cover_instruction": {
    "composition": "构图描述",
    "figures": "人物描述",
    "emotion": "情绪描述",
    "props": "道具描述",
    "colors": "色彩描述",
    "text": "封面文字（如有）"
  },
  "tags": {
    "title_tags": ["#tag1", "#tag2"],
    "description_tags": ["tag1", "tag2", "tag3"]
  },
  "description": "视频描述文本",
  "publish_time": {
    "best_hours_utc": [12, 15],
    "best_weekdays": ["Thursday", "Friday"]
  }
}
```

---

## 诚实边界
- 骨架公式基于成功样本归纳，不代表所有做法都适用
- 各语言市场样本量不均，部分结论的普遍性可能受限
- 平台算法持续更新，过往有效的策略未来可能失效

---

## 学习协议（每次使用本skill后执行）

1. **遇到未覆盖的情况**：
   - 明确告诉用户"此场景超出已验证范围"
   - 追加到 `knowledge/pending.md`

2. **用户反馈某条建议有效/无效时**：
   - 有效 → 移入 `knowledge/validated.md`
   - 无效 → 移入 `knowledge/lessons.md`

3. **同一结论被验证≥3次** → 提示写入 skill 正文

4. **阈值必须带出处标注**：`[来源:频道名 基线 日期]`

5. **新pattern候选**：
   - 前提分≥80 且不匹配已知骨架 → 标 `新pattern候选`
   - 真实追加 `knowledge/pending.md`，含：标题、前提分、不匹配原因、建议验证方式
