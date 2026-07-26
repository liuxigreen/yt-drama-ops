# Distill数据验证 — 从原始数据重算统计值

## 问题

distill.json中的统计值（avg_length、emoji_rate、top_emojis）在LLM合并时经常被污染：
- avg_length被改为0
- emoji_rate被虚高2-4倍（如en从35.5%被改成70%）
- top_emojis被替换

## 验证方法

### 1. 找到原始数据

```bash
# 原始title数据
ls ~/duanju/distill/evidence/*/titles.json

# 语言映射
# 英文=en, 土耳其=tr, 印尼=id, 日语=jp, 西语=es, 繁中=繁中, 葡萄牙=葡萄牙
```

### 2. Python重算

```python
import json
from collections import Counter
from pathlib import Path

evidence_dir = Path("~/duanju/distill/evidence").expanduser()

for cn_name, code in [("英文","en"), ("土耳其","tr"), ("印尼","id"), 
                        ("日语","jp"), ("西语","es"), ("繁中","繁中"), ("葡萄牙","葡萄牙")]:
    titles_file = evidence_dir / cn_name / "titles.json"
    with open(titles_file) as f:
        titles = json.load(f)
    
    all_titles = [t.get("title", "") for t in titles if t.get("title")]
    
    # avg_length
    avg_len = round(sum(len(t) for t in all_titles) / len(all_titles))
    
    # emoji_rate
    emoji_count = sum(1 for t in all_titles if any(ord(c) > 0x1F000 for c in t))
    emoji_rate = round(emoji_count / len(all_titles) * 100, 1)
    
    # top_emojis
    all_emojis = []
    for t in all_titles:
        all_emojis.extend(c for c in t if ord(c) > 0x1F000)
    top_emojis = [e for e, _ in Counter(all_emojis).most_common(5)]
    
    print(f"{code}: avg={avg_len}, emoji={emoji_rate}%, top={top_emojis}")
```

### 3. 修正distill.json

```python
knowledge_dir = Path("~/.hermes/knowledge").expanduser()

for lang in ["en", "tr", "id", "jp", "es", "繁中", "葡萄牙"]:
    distill_file = knowledge_dir / lang / "distill.json"
    with open(distill_file) as f:
        data = json.load(f)
    
    # 用重算值覆盖
    data['how']['title_constraints']['avg_length'] = computed_avg
    data['how']['title_constraints']['emoji_rate'] = computed_emoji
    data['how']['title_constraints']['top_emojis'] = computed_top
    
    with open(distill_file, 'w') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
```

## 已知脏值模式

| 模式 | 原因 | 修复 |
|------|------|------|
| avg_length=0 | LLM合并时丢失 | 从titles.json重算 |
| emoji_rate>100 | LLM合并时虚高 | 从titles.json重算 |
| top_emojis全变 | LLM合并时替换 | 从titles.json重算 |

## 参考值（2026-07-21从原始数据重算）

| 语言 | 样本数 | avg_length | emoji_rate |
|------|--------|-----------|------------|
| en | 843 | 86 | 35.5% |
| tr | 149 | 88 | 1.3% |
| id | 557 | 88 | 18.5% |
| jp | 155 | 72 | 23.2% |
| es | 340 | 87 | 20.6% |
| 繁中 | 571 | 76 | 24.3% |
| 葡 | 358 | 88 | 18.7% |

**关键发现**：tr的emoji率确实只有1.3%（土耳其市场不爱emoji），不是脏值。
