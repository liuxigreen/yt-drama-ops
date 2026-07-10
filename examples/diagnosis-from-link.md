# 示例：诊断从频道链接

## 用户输入
```
诊断这个频道: https://youtube.com/@example-drama
```

## AI响应流程

### Step 1: 取数协议执行
```bash
yt-dlp --dump-json --playlist-items 1:30 https://youtube.com/@example-drama
```

提取数据：
- 标题 × 30条
- 播放量 × 30条
- 点赞数 × 30条
- 评论数 × 30条
- 时长 × 30条
- 发布时间 × 30条
- 封面URL × 30条

### Step 2: 判档
只有公开数据 → **C档**（无CTR/留存，置信有限）

### Step 3: 运行诊断流程

**步骤1：播放分布**
- top3_ratio = 45% → 健康（30-50%区间）
- cliff = 0.8 → 正常

**步骤2：标题模式**
- 平均长度 = 72字符 → 偏长（最佳40-60）
- emoji比例 = 0.6 → 正常
- 重复emoji = false → 正常
- 钩子词：CEO(8次), reborn(5次), revenge(3次)

**步骤3：点赞漏斗**
- 点赞率 = 1.2% → 一般（基准1.5-2%）
- 评论/点赞比 = 8% → 正常

**步骤4：内容一致性**
- 主类型：霸总甜宠（占比65%）→ 一致性良好

**步骤5：订阅转化**
- 播放/订阅比 = 80:1 → 偏高（正常<50:1）

**步骤9：封面协同**
- 人物特写 = 7分 → 正常
- 情绪表达 = 5分 → 偏低

### Step 4: 输出报告

```json
{
  "data_tier": "C",
  "health_score": 6.0,
  "health_grade": "B-",
  "confidence": "low",
  "bottleneck": "点赞率偏低+封面情绪表达不足",
  "quadrant_summary": {
    "status": "skipped",
    "reason": "无CTR数据，四象限不适用"
  },
  "issues": [
    {
      "severity": "major",
      "category": "标题",
      "issue": "标题过长（平均72字符，最佳40-60）",
      "detail": "YouTube标题超过60字符会被截断，关键信息丢失。",
      "evidence": "30条视频平均长度72字符",
      "action": "① 控制在50字符内 ② 删掉无意义后缀"
    },
    {
      "severity": "major",
      "category": "互动率",
      "issue": "点赞率偏低 1.2%",
      "detail": "低于行业基准1.5%，说明内容能被看到但无法引发互动。",
      "evidence": "总播放125,000 / 总点赞1,500 = 1.2%",
      "action": "① 标题前10字加冲突钩子 ② 封面加情绪张力"
    },
    {
      "severity": "major",
      "category": "封面",
      "issue": "情绪表达不足（5分）",
      "detail": "封面缺乏情绪张力，无法吸引点击。",
      "evidence": "30条封面平均情绪分5/10",
      "action": "① 加惊讶/愤怒/甜蜜表情 ② 使用冷暖对比光"
    },
    {
      "severity": "info",
      "category": "订阅转化",
      "issue": "播放/订阅比 80:1",
      "detail": "总播放125,000但仅1,560订阅，观众看完不订阅。",
      "evidence": "125,000/1,560 = 80:1",
      "action": "① 开头3秒口播订阅引导 ② End Screen加订阅按钮"
    }
  ],
  "optimized_titles": [
    {
      "original": "【新剧】霸总总裁的小娇妻完整版全集",
      "new_title": "被赶出家门当天，她发现自己是真千金，霸总后悔跪求",
      "skeleton": "身份落差打脸型",
      "hooks": ["身份钩子", "冲突钩子", "反转钩子"],
      "reason": "原标题无钩子，纯描述。新标题加了身份反差+冲突+反转"
    },
    {
      "original": "Sweet Wife CEO Drama Episode 1",
      "new_title": "She was mocked as a poor wife, but he turned out to be a billionaire CEO",
      "skeleton": "关系背叛补偿型",
      "hooks": ["冲突钩子", "身份钩子", "反转钩子"],
      "reason": "原标题太泛，新标题加了具体冲突和身份反差"
    }
  ],
  "skipped": [
    "CTR分析（无YouTube Analytics授权）",
    "留存分析（无分段留存数据）",
    "流量来源分析（无OAuth数据）",
    "受众分析（无OAuth数据）"
  ],
  "next_check": "1week"
}
```

---

## 关键点

1. **取数先于诊断**：先扒数据，再下结论
2. **C档诚实标注**：明确告诉用户"无CTR/留存，置信有限"
3. **证据链**：每条issue必须有evidence字段
4. **给改写方案**：诊断完必须给2条优化标题
5. **skipped透明**：数据不足的维度明确列出
