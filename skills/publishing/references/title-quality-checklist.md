# 标题质量诊断清单

> 每条生成的标题必须过此清单，不合格的打回重写。

## 五项强制检查（基于 distill 数据）

| # | 检查项 | 数据来源 | 合格标准 |
|---|--------|----------|----------|
| 1 | 格式词 | distill key_words / 高播放标题 | 有 [Full]/[ENG DUB]/[ENG SUB] 等 |
| 2 | 情绪emoji | distill top_emojis | 至少1个，且在 top_emojis 列表内 |
| 3 | 身份词 | distill key_words | 至少1个（CEO/Billionaire/Heiress/Mafia等） |
| 4 | 反转词 | distill rhetorical_patterns / hooks.md 反转词表 | 至少1个（But/Actually/Unaware等） |
| 5 | 长度 | distill stats.avg_title_length | ≥ 市场均长的80% |

## 各语言速查

| 语言 | 均长 | top_emojis | 反转词 |
|------|------|------------|--------|
| en | 86 | 🔥💕👑💖💔 | but, actually, unaware, turns out |
| es | 87 | 💔🔥💖💘💕 | pero, resulta que, inesperadamente |
| id | 88 | 🔥💖💕🤯😈 | Tak disangka, Ternyata, Malah |
| jp | 72 | 🔥💔😱🔸👑 | だが, ところが, 実は, 正体は |
| pt | 88 | 😭💌🎀💗🐼 | mas, however, até que, na verdade |
| tr | ~90 | 🔥💞 | Ancak, ama, gerçeği öğrenince, aslında |
| zh-tw | 76 | 🔥💥💖💢🍊 | 豈料, 殊不知, 原来, 怎料, 不料 |

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
