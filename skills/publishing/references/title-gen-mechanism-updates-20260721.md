# 标题生成机制更新 (2026-07-21)

## 反惯例机制 (Contrarian Mechanism)

**问题**：流程收敛太死——所有标题往"已爆过的公式"拉，句式同质化。YouTube奖励"跟别人不一样但又准"。

**方案**：每批强制1-2条 `mode: contrarian` 标题。

### 写作要求
- 不使用已验证的句式模板（如 "She was actually..."、"He didn't know she was..."）
- 不锚定任何已知骨架的叙事结构
- 从"这个剧情最让人意想不到的点是什么"出发写作
- 走emergent通道评分，不降置信

### 评分标准（不锚avg_views）
- **信息缺口强度**（0-30）：标题是否制造了"不点就难受"的悬念？
- **句式新颖度**（0-30）：句式是否跟distill高频模板有明显差异？
- **画面感**（0-20）：同正常评分标准
- **钩子数量**（0-20）：同正常评分标准（≥2为合格）

### 输出分组
- **公式化最优**：score最高的公式化标题（mode: creative）
- **反惯例最优**：score最高的contrarian标题（mode: contrarian）
- 两者并列，供人工选择

## 标题×封面组合对抗 (Combination Battle)

**问题**：标题和封面各走各的线，没有组合博弈。真实运营是"同一剧情出3组标题×封面组合，预测哪组CTR最高"。

### 组合规则
1. 从公式化最优和反惯例最优各取top 1-2条标题
2. 从封面步骤取1-2个变体
3. 组合成3组，每组标注：
   - 标题的钩子是什么
   - 封面放大了标题的哪个钩子
   - 两者是否讲同一个信息缺口的两个侧面

### 组合评分（0-100）
- **信息缺口一致性**（0-40）：标题和封面是否指向同一个悬念？
- **钩子叠加强度**（0-30）：标题钩子+封面钩子是否叠加（而非重复）？
- **缩略图辨识度**（0-30）：在手机320×180缩略图上是否比同题材竞品更抓眼？

## covers.md "NO text" bug修复

L77 `CONSTRAINTS: NO text, NO Chinese characters, NO gibberish in image` 与文字层规则矛盾。
修复为：`CONSTRAINTS: NO random text, NO Chinese characters, NO gibberish in image. Allowed: structured title text in bottom 15% zone only.`

## SKILL.md frontmatter更新

"13种骨架公式" → "基于跨语言蒸馏数据的骨架体系（非穷尽）+ 钩子体系 + 包装模式。支持emergent新骨架识别。"
