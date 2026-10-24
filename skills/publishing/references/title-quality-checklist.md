# 标题质量诊断清单

> 每条生成的标题必须过此清单，不合格的打回重写。

## 五项强制检查（基于 distill 数据）

| # | 检查项 | 数据来源 | 合格标准 |
|---|--------|----------|----------|
| 1 | 格式词 | distill key_words / 高播放标题 | 有 [Full]/[ENG DUB]/[ENG SUB] 等 |
| 2 | 情绪emoji | distill top_emojis | 至少1个，且在 top_emojis 列表内 |
| 3 | 身份词 | distill key_words | 至少1个（CEO/Billionaire/Heiress/Mafia等） |
| 4 | 反转词 | distill rhetorical_patterns / hooks.md 反转词表 | 至少1个（But/Actually/Unaware等） |
| 5 | 长度 | distill stats.avg_title_length（高播放标题口径，含格式词） | ≥ 市场均长的80% |
|   |  | distill how.title_constraints.avg_length（全样本口径） | 长度硬门 60-90 字符以此为准 |

## 各语言速查

| 语言 | 均长(高播放) | 均长(全样本) | emoji 率 | top_emojis | 反转词 |
|------|------|-----------|---------|------------|--------|
| en | 97 | 86 | 35.5% | 🔥💕👑💖💔 | but, actually, unaware, turns out |
| es | 87 | 87 | 20.6% | 💔🔥💖💘💕 | pero, resulta que, inesperadamente |
| id | 88 | 88 | 18.5% | 🔥💖💕🤯😈 | Tak disangka, Ternyata, Malah |
| jp | 74 | 72 | 23.2% | 🔥💔😱🔸👑 | だが, ところが, 実は, 正体は |
| pt | 88 | 88 | 18.7% | 😭💌🎀💗🐼 | mas, however, até que, na verdade |
| tr | 88 | 88 | 1.3% | 🔥💞 | Ancak, ama, gerçeği öğrenince, aslında |
| zh-tw | 76 | 76 | 24.3% | 🔥💥💖💢🍊 | 豈料, 殊不知, 原来, 怎料, 不料 |

> 均长与 emoji 率来自原始标题重算（样本量 149-843 条/语种，2026-07-21，详见 distill-data-validation.md）。
> **两个均长口径不同**：均长(高播放)取自 `stats.avg_title_length`（高播放标题样本，含 [ENG DUB]/[Full] 等格式词，故偏长）；
> 均长(全样本)取自 `how.title_constraints.avg_length`（全量标题）。
> **长度硬门（60-90 字符）以全样本口径为准**，与 SKILL.md 步骤4 评分标准一致。
> **土耳其市场 emoji 率仅 1.3%** —— 不是脏值，土耳其观众不吃 emoji 堆砌，
> 该市场标题应少用或不用 emoji。其他 6 语种在 18%-36% 区间。

## 诊断流程

1. 逐条检查5项强制项
2. 缺失任何一项 → 标记 ❌ + 说明缺什么
3. 3条以上不合格 → 打回步骤2重写
4. 全部合格 → 进入步骤3评分

## 常见问题模式

| 问题 | 症状 | 原因 | 修复 |
|------|------|------|------|
| 模板化 | 8/10标题用同一个钩子 | 从模板出发而不是从剧情出发 | 回到步骤1取景 |
| 抽象化 | 只有身份词没有场景/动作 | 缺少具体瞬间 | 步骤1取景要更具体 |
| 短句化 | 长度<50字符 | 自由生成时没带约束 | 步骤2强制约束 |
| 机翻感 | 跨语言直译英文结构 | 没有本地化 | 读目标语言句式模板 |
