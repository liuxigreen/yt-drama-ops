# Changelog

All notable changes to yt-drama-ops will be documented in this file.

## [1.3.0] - 2026-07-26 (标准化改造)

### Added
- **README.md**：中英文双语重写 — 架构图、多平台安装指南、快速开始、依赖关系
- **INSTALL.md**：详细分平台安装指南 — Hermes / Claude Code / ChatGPT / 任意 Agent 框架
- **各 SKILL.md frontmatter**：标准化字段 — version / tags / author / license / platform / triggers

### Standardized
- 所有 SKILL.md 增加 `version` 字段（channel-diagnosis: 1.2.2, video-optimization: 1.2.2, publishing: 3.3.0, persona: 1.0.0）
- 所有 SKILL.md 增加 `tags` 便于搜索和分类
- 所有 SKILL.md 增加 `triggers` 明确触发词列表
- 所有 SKILL.md 增加 `platform` 声明支持的平台
- video-optimization frontmatter 去掉对 publishing 母版的内部引用描述

## [1.2.2] - 2026-07-26 (Contrarian聚合 + Schema版本 + Emergent规范)

### Fixed
- **channel-diagnosis/SKILL.md**：contrarian 独立聚合 — 新增 contrarian_ratio / avg_score / avg_novelty / avg_info_gap 四个独立指标
- **channel-diagnosis/SKILL.md**：钩子命中率和平均评分只统计 creative+emergent，不混入 contrarian
- **channel-diagnosis/SKILL.md**：新增 contrarian 触发规则（占比>30%、新颖度<15、信息缺口<15）

### Added
- **video-optimization/SKILL.md**：per-video JSON 新增 `schema_version: "1.0"` 字段
- **video-optimization/SKILL.md**：per-video JSON 新增 `info_gap_strength` 字段（仅 contrarian）
- **video-optimization/SKILL.md**：emergent_desc 格式规范 — 必须包含"融合家族 + 新在哪 + 为什么连贯"
- **video-optimization/SKILL.md**：emergent 自动记录 pending.md — 含标题/融合家族/数据信号/验证建议

## [1.2.1] - 2026-07-26 (Bug修复 + 频道诊断流程重构)

### Fixed
- **video-optimization/SKILL.md**：Bug1 — 新增参考体系章节，明确引用 publishing 母版的句式模板/长度约束/反转词
- **video-optimization/SKILL.md**：Bug2 — 评分锚点从"(n, avg_views)"改为"骨架类型 + 播放范围"（来自 hooks.md）
- **video-optimization/SKILL.md**：改写标题时增加语言询问机制和长度/句式/反转词约束

### Redesigned
- **channel-diagnosis/SKILL.md**：频道诊断必须先跑 per-video 诊断（Step 0→1→2→3→4）
- **channel-diagnosis/SKILL.md**：新增 Step 0 取数协议（YouTube Data API + yt-dlp 双数据源）
- **channel-diagnosis/SKILL.md**：新增 Step 1 视频选择策略（头部+近期+问题，5-10条，按频道规模适配）
- **channel-diagnosis/SKILL.md**：新增 Step 2 逐条跑 video-optimization 诊断
- **channel-diagnosis/SKILL.md**：步骤2/9明确从 per-video 聚合，不再有"独立重做"路径

## [1.2.0] - 2026-07-26 (诊断侧对齐生成侧)

### Fixed
- **video-optimization/SKILL.md**：骨架体系从"13种封闭"改为"非穷尽 + emergent + contrarian"
- **video-optimization/SKILL.md**：钩子分类从"7种钩子"改为"6类 + 新发现钩子（非穷尽）"
- **video-optimization/SKILL.md**：新增 contrarian 独立评分通道（信息缺口强度，非"≥2钩子"规则）
- **video-optimization/SKILL.md**：钩子质量判断区分标准模式（合格/不足/失败）和 contrarian 模式（强/中/弱）
- **channel-diagnosis/SKILL.md**：步骤2从"自行重做标题分析"改为"聚合 per-video hooks/skeleton/mode"
- **channel-diagnosis/SKILL.md**：步骤9从"悬空协同分"改为"聚合 per-video 封面四维 + 协同判定"
- **channel-diagnosis/SKILL.md**：数值矛盾消除——长度标准统一引用 publishing distill（60-90字符），不再说"控制在50内"

### Added
- **video-optimization/SKILL.md**：新增标准 per-video 诊断 JSON 输出格式（mode/hooks/skeleton/score/cover），供 channel-diagnosis 消费
- **video-optimization/SKILL.md**：新增骨架匹配逻辑（creative → emergent → contrarian 三级判定）
- **video-optimization/SKILL.md**：新增评分体系（Creative/Emergent 评分 + Contrarian 独立评分）
- **channel-diagnosis/SKILL.md**：新增 per-video 诊断数据协议（设计意图 + 数据来源 + 消费方式）
- **channel-diagnosis/SKILL.md**：新增 title_aggregation 和 cover_aggregation 聚合字段
- **channel-diagnosis/SKILL.md**：新增 per_video_data 字段标注数据来源
- **channel-diagnosis/references/hooks.md**：从 publishing 同步，供频道级骨架/钩子参考
- **channel-diagnosis/references/covers.md**：从 publishing 同步，供封面协同参考

### Architecture
- **数据流接通**：video-optimization 输出标准 per-video JSON → 持久化 → channel-diagnosis 消费聚合
- **骨架本体统一**：publishing / video-optimization / channel-diagnosis 三处共享同一份 hooks.md（非穷尽 + emergent + contrarian）
- **评分口径统一**：封面评分以 video-opt 四维为唯一标准，channel 聚合不重做
- **数值同源**：长度、emoji、钩子策略均引用同一份 distill 数据

## [1.1.0] - 2026-07-12 (定版v3)

### Fixed
- **covers.md**：删除错误的"面部60%+"诊断标准，改为"中景/中近景为主，面部清晰可辨表情即可（爆款实测肤色占比仅~10%）"
- **SKILL.md**：封面诊断要素从"人物特写"改为"构图站位"，同步母本实测结论
- **SKILL.md**：JSON输出示例 `figure` → `composition`
- **channel-diagnosis/SKILL.md**：步骤3和步骤9同步删除"面部60%+"错误规则
- **channel-diagnosis/SKILL.md**：新增「新题材协议」——数据层不降级、内容层显式降置信、自动建档pending.md
- **knowledge/validated.md**：封面规则从🟡"人物特写占60%+"更正为🟢"爆款封面肤色占比仅~10%，场景叙事型更有效"
- **tags.md**：修正"#beggging"拼写错误为"#begging"
- **publishing/SKILL.md**：钩子引用从"7种"更新为"7类核心+5类新发现"
- **quadrant.md**：标题超卖分型从AVD改为hook_1pct（1分钟留存）
- **quadrant.md**：新增"数据异常待核实"桶（hook_1pct<5%），在所有象限判定之前执行
- **quadrant.md**：CTR阈值全文统一为6/2.5（48h表和速查表同步）

### Updated
- **short-drama-youtube-3.1.md**：新增「标准生图Prompt」章节——7张模板卡各一条蒸馏驱动的标准prompt，含固定骨架/软约束/变量槽/组装示例，基于267条封面按hook分桶统计
- **publishing/SKILL.md**：封面流程接入标准prompt（选卡→填槽→生图）
- **video-optimization/SKILL.md**：封面诊断步骤3接入标准prompt
- **covers.md**：顶部加"生产层vs校验层"说明，接入母本7张封面模板卡
- **publishing/SKILL.md**：封面指令生成流程重写为"选模板卡→组装prompt→校验"
- **video-optimization/SKILL.md**：封面诊断步骤3产出方案必须注明模板卡名称
- **hooks.md**：骨架公式从旧版13种对齐到母本 short-drama-youtube 3.1.0 的13种（新增：被迫关系升温型、隐藏强者救援型、亲情守护打脸型、集体误判打脸型、绝嗣/意外得子型、危险权势反差甜宠型、命运道具触发型、天才儿童破局型）
- **hooks.md**：新增5类新发现钩子（系统/异能觉醒、绝嗣总裁继承人、心声外泄公开处刑、穷人善举测试、AI标签权威框架）
- **hooks.md**：新增钩子配对规则（6种最强配对 + 5种低效组合）
- **SKILL.md**：钩子分析流程同步更新为12类钩子

## [1.0.0] - 2026-07-11

### Restructured
- Reorganized to standard agent skill package format
- Split diagnosis SKILL.md into main + 3 references (quadrant, retention, degradation)
- Split publishing SKILL.md into main + 3 references (tags, timing, description)
- Created video-optimization skill with hooks + covers references

### Added
- B+ data tier: YouTube Studio screenshot/CSV channel for manual report channel
- Learning protocol: knowledge/{lessons,validated,pending}.md for continuous improvement
- Frontmatter with trigger descriptions for auto-detection
- CHANGELOG.md for version tracking

### Content
- All 7 language markets covered (en/es/id/jp/pt/tr/zh-tw)
- 13 skeleton formulas with cross-language validation
- 7 hook types with psychological mechanisms
- CTR×AVD quadrant matrix with thresholds from diagnosis_engine.py
- Retention three-point diagnostics
- Cover synergy rules with gender-specific guidance

## [0.1.0] - 2026-07-10

### Initial
- Basic skill structure: diagnosis, publishing, persona
- References: hooks, skeletons, packaging
- Examples: diagnosis-from-link, diagnosis-from-screenshot, publishing-flow
- Templates: report-template
- Scripts: scrape-channel.sh
