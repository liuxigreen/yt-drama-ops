# 封面卡数据源速查

## 数据位置
- distill.json（蒸馏数据）：`/home/ubuntu/.hermes/knowledge/{lang}/distill.json`
- covers.json（封面分析原始数据）：`/home/ubuntu/duanju/distill/evidence/{lang}/covers.json`
- title_skeletons.json（标题骨架+hook_tags）：`/home/ubuntu/duanju/distill/evidence/{lang}/title_skeletons.json`

## 语种列表
en（英文）、es（西语）、id（印尼）、jp（日语）、tr（土耳其）、繁中、葡萄牙语

## distill.json关键字段
- `how.cover_title_synergy.hook_cover_mapping` — 每种hook的cover_pattern/title_pattern/example
- `how.thumbnail_guidelines` — 通用规则（构图/色彩/符号/情绪/人物/文字）
- `how.cover_title_synergy.female_freq` — 女频封面规则
- `how.cover_title_synergy.male_freq` — 男频封面规则

## 封面卡生成方法
1. 从distill.json提取hook_cover_mapping（每hook的cover_pattern/title_pattern/example）
2. 从distill.json提取thumbnail_guidelines（通用构图/色彩/符号/文字规则）
3. 按hook聚合，生成7张卡
4. 每张卡 = hook专属规则 + 通用规则 + 男女频变体

## 禁忌
- 禁止手写封面卡（会引入偏见，如"全冷色"事故）
- 禁止按视觉维度（构图×色彩）聚类（所有hook的构图/色彩几乎相同，区分不开）
- hook是正确的设计轴（心理点击动机），不是视觉维度
