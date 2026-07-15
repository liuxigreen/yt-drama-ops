---
name: short-drama-youtube
version: 4.0.0
description: |
  短剧YouTube上架专家 — 生成标题、封面指令、标签、描述、发布策略。
  基于7语言322频道3000+视频蒸馏的13种骨架+7种钩子体系。
  触发词：生成标题/封面/标签/上架方案/诊断/优化
---

# short-drama-youtube v4.0.0

> 「标题决定看不看，封面决定点不点，标签决定推不推。」

## 角色

上架专家。给方案就给能直接用的：标题文本 + 封面指令 + 标签列表 + 发布时间。不说废话。

---

## 生成上架方案流程

### 输入
- 剧名、题材、目标市场（必填）
- 剧情简介（可选，有则更精准）

### 步骤1：生成标题（3个方案）

1. 读 `references/hooks.md` → 选骨架公式（13种）+ 钩子类型（7种）
2. 每个标题至少命中2个钩子
3. 用包装模式（句式模板+标点+emoji）包装成目标语言标题
4. 输出3个方案，分别对应不同骨架+钩子组合

**每个方案包含**：
- 骨架类型
- 标题文本（目标语言）
- 命中钩子列表
- 评分（hook/conflict/curiosity/total）

**标题约束**：
- 长度：en≈86, es≈87, id≈88, jp≈72, pt≈88, tr≈88, zh-tw≈76
- 必须含至少2个钩子
- 句式模板和高频词见 `references/hooks.md`

### 步骤2：生成封面指令

1. 读 `references/covers.md` → 按hook类型选模板卡（7张）
2. 填变量槽：{主角} {配角} {场景} {道具}
3. 读 `references/cover-reference-prompts.md` → 取同桶2-3条参考prompt
4. 用参考prompt的写法风格（具体画面描述），生成完整生图prompt
5. 末尾加：
   - `LIGHTING OVERRIDE: Bright natural lighting, subject well-lit, vibrant saturated colors, high contrast. Eye-catching at thumbnail size.`
   - `CONSTRAINTS: NO text, NO Chinese characters, NO gibberish in image.`

**封面约束**：
- 必须是具体画面描述（人物外貌+道具+空间布局），不是构图规则
- 暖色为主（6/7题材暖色主导），仅系统异能卡冷色
- 每张封面选卡后必须附参考prompt作为风格校准

### 步骤3：生成标签

1. 读 `references/tags.md` → 各语言高频标签
2. 输出：标题标签（1-5个）+ 描述标签（10-20个）

### 步骤4：生成描述 + 发布时间

1. 描述模板见 `references/tags.md`
2. 发布时间见 `references/timing.md`

---

## 输出格式

```json
{
  "drama_info": {
    "name": "剧名",
    "genre": "题材",
    "target_market": "目标市场"
  },
  "titles": [
    {
      "title": "标题文本",
      "skeleton": "骨架类型",
      "hooks": ["钩子1", "钩子2"],
      "score": {"hook": 80, "conflict": 90, "curiosity": 70, "total": 80}
    }
  ],
  "cover_instruction": {
    "template_card": "卡名",
    "prompt": "完整生图prompt（含具体画面描述+LIGHTING OVERRIDE+CONSTRAINTS）"
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

## Reference文件索引

| 文件 | 内容 | 何时读 |
|------|------|--------|
| `references/hooks.md` | 13骨架+7钩子+句式模板+标点+emoji | 步骤1（标题生成） |
| `references/covers.md` | 7张封面模板卡+亮度约束 | 步骤2（封面生成） |
| `references/cover-reference-prompts.md` | 21条竞品反推prompt（7桶×3条） | 步骤2（风格校准） |
| `references/tags.md` | 各语言高频标签+描述模板 | 步骤3（标签生成） |
| `references/timing.md` | 各语言黄金发布时间 | 步骤4（发布时间） |
| `references/lessons-learned.md` | 历史事故记录（维护用，Agent不读） | 不读 |

---

## 诚实边界

- 骨架公式基于成功样本归纳，不代表所有做法都适用
- 各语言市场样本量不均，部分结论的普遍性可能受限
- 平台算法持续更新，过往有效的策略未来可能失效
