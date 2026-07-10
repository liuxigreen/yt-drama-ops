# yt-drama-ops

AI-powered toolkit for YouTube short drama channel operations.

## What's Inside

| Skill | Capability | When to Use |
|-------|-----------|-------------|
| 🔍 **channel-diagnosis** | Channel health scoring, bottleneck detection, actionable recommendations | User gives channel link/screenshots and asks about performance |
| 🎬 **video-optimization** | Hook analysis, skeleton matching, cover synergy, title rewriting | User gives a video title/cover and asks how to improve |
| 📝 **publishing** | Title generation, cover design, tag optimization, publish timing | User gives drama info and asks for publishing strategy |
| 🎭 **persona** | Conversational expert with judgment and personality | Activated automatically when diagnosis or publishing skills are used |

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
| **B+** | YouTube Studio screenshots/CSV | Full diagnosis with manual data reading |
| **B** | Public data (views, likes, comments) | Title patterns, engagement, consistency |
| **C** | Title + thumbnail only | Basic pattern analysis |

No data? No problem. The skill auto-detects what's available and works with what you give it.

## Installation

### Claude Code
Copy the `skills/` directory to `~/.claude/skills/`:
```bash
cp -r skills/* ~/.claude/skills/
```

### Other Agents
Copy to your agent's skills directory, or paste SKILL.md content directly.

### Pure Chat (GPT/Claude web)
Copy the SKILL.md content and paste as system prompt.

## Learning Loop

This skill package includes a learning system:

- `knowledge/lessons.md` — Mistakes and corrections
- `knowledge/validated.md` — Proven conclusions with evidence
- `knowledge/pending.md` — Hypotheses to test

After each use, the skill logs new findings. When a conclusion is validated 3+ times, it gets promoted to official rules.

## Structure

```
yt-drama-ops/
├── skills/
│   ├── channel-diagnosis/    # Channel health diagnosis
│   │   ├── SKILL.md          # Main protocol
│   │   └── references/       # Quadrant rules, retention, degradation
│   ├── video-optimization/   # Single video optimization
│   │   ├── SKILL.md          # Main protocol
│   │   └── references/       # Hooks, skeletons, covers
│   └── publishing/           # Publishing strategy
│       ├── SKILL.md          # Main protocol
│       └── references/       # Tags, timing, description
├── knowledge/                # Learning loop
│   ├── lessons.md            # Mistakes and corrections
│   ├── validated.md          # Proven conclusions
│   └── pending.md            # Hypotheses to test
├── examples/                 # Real-world usage examples
├── templates/                # Report templates
└── CHANGELOG.md              # Version history
```

## No Server Required

Works in any AI chat:
- Claude (claude.ai)
- ChatGPT (chat.openai.com)
- Hermes (local)
- Any LLM that supports custom instructions

Just paste the SKILL.md content as a system prompt, or reference it in your conversation.

## License

MIT
