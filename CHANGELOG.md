# Changelog

All notable changes to yt-drama-ops will be documented in this file.

## [1.1.0] - 2026-07-12 (定版)

### Fixed
- **covers.md**：删除错误的"面部60%+"诊断标准，改为"中景/中近景为主，面部清晰可辨表情即可（爆款实测肤色占比仅~10%）"
- **SKILL.md**：封面诊断要素从"人物特写"改为"构图站位"，同步母本实测结论
- **SKILL.md**：JSON输出示例 `figure` → `composition`
- **channel-diagnosis/SKILL.md**：步骤3和步骤9同步删除"面部60%+"错误规则
- **knowledge/validated.md**：封面规则从🟡"人物特写占60%+"更正为🟢"爆款封面肤色占比仅~10%，场景叙事型更有效"
- **tags.md**：修正"#beggging"拼写错误为"#begging"
- **publishing/SKILL.md**：钩子引用从"7种"更新为"7类核心+5类新发现"
- **quadrant.md**：标题超卖分型从AVD改为hook_1pct（1分钟留存）
- **quadrant.md**：新增"数据异常待核实"桶（hook_1pct<5%），在所有象限判定之前执行
- **quadrant.md**：CTR阈值全文统一为6/2.5（48h表和速查表同步）

### Updated
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
