# yt-drama-ops

AI-powered toolkit for YouTube short drama channel operations.

## What's Inside

| Skill | Capability | Input |
|-------|-----------|-------|
| 🔍 **diagnosis** | Channel health scoring, bottleneck detection, actionable recommendations | Channel link / screenshots / manual data |
| 📝 **publishing** | Skeleton-based title generation, cover design, tag optimization | Drama info + target language |
| 🎭 **persona** | Conversational expert with judgment and personality | Any of the above |

## Quick Start

### Option 1: Channel Link
Just give me a YouTube channel URL and I'll diagnose it:
```
诊断这个频道: https://youtube.com/@channelname
```

### Option 2: Screenshots
Upload YouTube Studio screenshots and I'll extract the data:
```
[上传后台截图]
帮我看看这个频道怎么样
```

### Option 3: Title Generation
Tell me about your drama and get optimized titles:
```
帮我出标题：霸总短剧，女主被赶出家门后发现自己是真千金，目标市场印尼
```

## Data Tiers

| Tier | Data Available | What You Get |
|------|---------------|--------------|
| **A** | YouTube Analytics (CTR, retention, traffic) | Full diagnosis + quadrant analysis |
| **B** | Public data (views, likes, comments) | Title patterns, engagement, consistency |
| **C** | Title + thumbnail only | Basic pattern analysis |

No data? No problem. The skill auto-detects what's available and works with what you give it.

## No Server Required

Works in any AI chat:
- Claude (claude.ai)
- ChatGPT (chat.openai.com)
- Hermes (local)
- Any LLM that supports custom instructions

Just paste the SKILL.md content as a system prompt, or reference it in your conversation.

## License

MIT
