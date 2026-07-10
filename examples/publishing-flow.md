# 示例：诊断完→出优化标题

## 用户输入
```
诊断完了吗？标题怎么优化？
```

## AI响应流程

### 前置：已完成诊断

假设诊断结果显示：
- 健康度：6.0/10
- 问题：标题过长（平均72字符）+ 点赞率偏低（1.2%）
- 诊断结论：标题钩子不足，需要优化

### Step 1: 确认优化方向

根据诊断结果，确定需要优化的维度：
1. 标题长度 → 控制在50字符内
2. 钩子数量 → 每个标题至少2个钩子
3. 反转词 → 必须有

### Step 2: 生成优化标题

**输入信息**：
- 剧名：霸总的小娇妻
- 题材：霸总甜宠
- 目标市场：印尼（id）
- 当前标题：【新剧】霸总的小娇妻完整版全集

**骨架选择**：身份落差打脸型（最适合霸总题材）

**钩子组合**：
- 身份钩子：CEO/Miliarder
- 冲突钩子：被赶出/diusir
- 反转词：Tak disangka/Ternyata

### Step 3: 输出方案

```json
{
  "drama_info": {
    "name": "霸总的小娇妻",
    "genre": "霸总甜宠",
    "target_market": "id"
  },
  "skeleton": "身份落差打脸型",
  "titles": [
    {
      "title": "Diusir dari keluarga, tak disangka gadis ini ternyata anak kandung CEO kaya raya!",
      "language": "id",
      "hooks": ["冲突钩子", "身份钩子", "反转钩子"],
      "score": {"hook": 85, "conflict": 90, "curiosity": 80, "total": 85}
    },
    {
      "title": "Semua merendahkan dia, ternyata wanita malang ini dicintai dan dimanjakan CEO Miliarder!",
      "language": "id",
      "hooks": ["集体钩子", "身份钩子", "反转钩子"],
      "score": {"hook": 80, "conflict": 85, "curiosity": 85, "total": 83}
    },
    {
      "title": "Gadis miskin ini dipermalukan, siapa sangka dia adalah pewaris tunggal perusahaan terbesar!",
      "language": "id",
      "hooks": ["身份钩子", "冲突钩子", "反转钩子"],
      "score": {"hook": 82, "conflict": 88, "curiosity": 78, "total": 83}
    }
  ],
  "cover_instruction": {
    "composition": "左右对比构图：左侧落魄女子蜷缩，右侧豪华场景（豪车/保镖/豪宅）",
    "figures": "2人：女主（低位身份）+ CEO（高位身份，戴墨镜站立）",
    "emotion": "女主震惊/委屈，CEO冷漠/霸气",
    "props": "破旧衣服 vs 西装/豪车/保镖",
    "colors": "左侧冷灰暗，右侧暖金亮",
    "text": "无需封面文字（标题已足够）"
  },
  "tags": {
    "title_tags": ["#Full", "#Minidrama", "#drama", "#cdrama"],
    "description_tags": ["drama", "ceo", "filmcina", "cinta", "chinesedrama", "drakor", "romansa", "dracin", "dramapendek"]
  },
  "description": "Gadis miskin ini dipermalukan oleh keluarganya, ternyata dia adalah pewaris tunggal perusahaan terbesar! CEO kaya raya langsung jatuh cinta dan memanjakan dia.\n\n#drama #ceo #cinta #romansa #dramachino\n\nSubscribe untuk menonton episode selanjutnya!",
  "publish_time": {
    "best_hours_utc": [10, 11, 12, 4],
    "best_weekdays": ["Friday", "Thursday", "Wednesday"]
  }
}
```

---

## 关键点

1. **诊断驱动优化**：先诊断问题，再针对性优化
2. **骨架+钩子组合**：不是随便写，是有结构的
3. **本地化**：针对印尼市场用印尼语，用当地高频词
4. **完整方案**：不只是标题，还有封面、标签、描述、发布时间
5. **可直接执行**：用户复制就能用，不需要再加工

---

## 标题优化检查清单

优化完标题后，AI自动检查：

- [ ] 长度 ≤ 60字符
- [ ] 命中 ≥ 2个钩子
- [ ] 有反转词
- [ ] 有情绪终点
- [ ] 身份标签具体（CEO > 有钱人）
- [ ] 无无意义后缀（"完整版全集"等）
- [ ] 符合目标语言习惯
