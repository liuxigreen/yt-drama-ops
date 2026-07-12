---
name: short-drama-youtube
version: 3.1.0
description: |
  短剧YouTube运营专家 — 从7个语言、322个频道、3000+视频蒸馏的跨语言通用规则。触发词：生成标题/封面/标签/上架方案/诊断/优化
---

# short-drama-youtube v3.0.0

> 从7个语言、322个频道、3000+视频中蒸馏的跨语言通用规则

## 身份来源

**SOUL.md 定义了本 skill 的身份**：`~/.hermes/SOUL.md`。被问到"你是谁""你的 soul"时，先读 SOUL.md，不要翻 skill 文件找。SOUL.md 是系统级身份定义，skill 是能力定义。

## 单一数据源规矩

**本文件（short-drama-youtube）是唯一知识母本。** 所有 skill/distill.json/代码中的规则都是它的投影，只能单向从本文件生成/同步。禁止在投影上直接改知识。改知识只改本文件，然后重新生成下游。

## 与其他 skill 的关系

| Skill | 职责 | 何时用 |
|-------|------|--------|
| **short-drama-youtube**（本skill） | 蒸馏知识库：13骨架/7钩子/封面模板卡/标签/诊断/Why | 标题生成、方案生成、蒸馏查询 |
| `duanju-youtube-expert` | 运营方法论+pitfalls+数据流+执行细节 | 频道诊断、面板排查、管线修复 |
| `duanju-title-generation` | 标题生成的快速入口 | 简单标题生成（被本skill覆盖） |

⚠️ 本skill和`duanju-youtube-expert`触发词高度重叠（"标题分析""频道诊断""运营建议"），任何会话可能双份注入。改规则时需同步。

## ⚠️ 已废除的旧规则

- **`generate_cover.py` 中的"面部60%+"规则**：已被竞品数据证伪。11张50万+播放爆款封面实测，肤色占比平均仅10%，人物估算12%。真实爆款封面是**场景叙事型**（展示冲突场景），不是面部特写型。旧版prompt中的面部60%+、100% bokeh背景等规则已废弃。
- **`generate_cover_structured.py` 中的"三幕合一构图"**：仅针对真假千金这一部剧写死，不通用。已废弃。
- 新封面生成层应基于3.0的7张模板卡+题材速查表重建。

## 封面生成四层结构（新框架）

封面prompt应按四层组装，不再堆砌通用铁律：

```
底层（场景环境）→ 特效层（氛围情绪）→ 人物/道具层（叙事核心）→ 文字层（信息传达）
```

| 层 | 作用 | 关键要素 |
|---|---|---|
| **底层** | 交代故事发生在哪里 | 场景类型（办公室/街道/豪宅）+ 色调 + 光影方向 |
| **特效层** | 强化情绪张力 | 逆光/雨/粉尘/玻璃碎片/烟雾/闪电（最多2种） |
| **人物/道具层** | 展示"谁在做什么" | 站位模式（对峙/高低/背对/围观/保护/独白）+ 表情 + 核心道具 |
| **文字层** | 补充标题信息 | 底部15%深色渐变 + 白色标题文字 + 左上角标 |

**生图工具**：以GPT/DALL-E为主。prompt用英文，含场景+人物+道具+光影+构图+技术参数。

**⚠️ 数据纪律（血泪教训）**：
1. 做封面分析前，**先查本机已有数据**——`distill/evidence/*/covers.json`（7语种×267条详细封面分析，每条含结构化枚举+10个中文描述字段+meta含views/title）。不要基于小样本（<50张）做全局结论。
2. 自己频道的cover分析在 `data/own/channel_diagnosis/*_covers.json`，竞品的在 `distill/evidence/*/covers.json`，不要混淆。
3. 267条竞品数据的实测结论（vs 直觉猜测差异巨大）：
   - 文字：**92.5%有文字**（直觉以为一半没有）
   - 构图：**中心构图73%绝对主导**（不是"多样"）
   - 色彩：金色36%最多，红色+黑色各26%（不是"冷暖混合"）
   - 人物：平均3-4人，多数是群体场景（不是"中景特写"）
   - 道具：花+西装各29次并列第一
   - 爆款分：各构图/色彩差异不大（7.3-7.5），说明**构图不是决定性因素**
4. 封面蒸馏脚本：`distill_cover_analysis.py`，输入`distill/evidence/*/covers.json`，输出`data/cover_distill_stats.json`（构图/色彩/文字/人物/道具/题材/语种偏好的统计+交叉分析）。
5. 封面分析prompt母本：`references/cover-analysis-prompt.md`（v2.0，蒸馏/诊断两套）。代码从.md文件按section header读取，不硬编码。
## ⚠️ 常见陷阱

0. **外部仓库 yt-drama-ops 会跟母本漂移**：`liuxigreen/yt-drama-ops` 是本skill的对外投影。当母本更新骨架公式、钩子分类、封面诊断规则时，外部仓库不会自动同步。已发现的漂移类型：骨架公式重命名（隐藏身份揭露型→被迫关系升温型等）、钩子数量扩展（7→12）、封面诊断规则修正（"面部60%+"已被实测推翻）、字段名变更（figure→composition）。**同步检查清单**：`skills/video-optimization/references/hooks.md`（骨架+钩子）、`skills/video-optimization/references/covers.md`（诊断标准）、`skills/video-optimization/SKILL.md`（流程+字段名）、`references/cover-prompt-guide.md`（prompt模板）。用户说"先修吧"时直接改+push，不要反复确认。
1. **补蒸馏≠跑自有频道**：用户说"补蒸馏"是指竞品封面数据（`distill/evidence/*/covers.json`），用`batch_cover_analysis.py`或`daily_pipeline.py --step 5b`。不是`cover_analysis_own.py`（那是自有频道诊断）。搞混会浪费token和时间。
2. **Vision模型不遵循复杂prompt**：doubao/mimo-v2.5对5部分JSON prompt（结构化+复现prompt+描述+评分+hook_type）只返回旧格式（中文描述字段），新字段全空。v2.0已精简为2部分，但仍需验证。结构化字段靠`distill_cover_analysis.py`后处理提取，不依赖LLM直接输出。
3. **section header提取Bug**：`raw.find("## 诊断prompt")`会匹配到表格里的文字（如`| 自有诊断 | \`## 诊断prompt\` |`），不是真正的section header。必须按行匹配`line.strip() == "## 诊断prompt"`。
8. **做分析前先查本机已有数据**：`distill/evidence/*/covers.json`有267条详细封面分析，`data/cover_distill_stats.json`有统计结果。不要用小样本（<50张）做全局结论——曾因只分析11张图就断言"文字一半没有"，实际数据显示92.5%有文字。
9. **封面数据没有hook_type，但标题有**：封面蒸馏的结构化字段只有emotion/composition/color_type，没有hook_type。但每条封面的`_meta.title`可以跟title_skeletons.json的hook关键词匹配来反向分桶。不要用emotion字段当hook_type的代理变量——直接用标题关键词匹配更准确。详见`references/cover-distillation-bucketing.md`。
10. **找代码/模块/提示词先查知识图谱**
6. **封面蒸馏数据≠自己频道数据**：竞品在`distill/evidence/*/covers.json`，自己频道在`data/own/channel_diagnosis/*_covers.json`。混淆会导致结论偏差。
7. **外部AI建议要验证再采纳**：Copilot说"面部60%"是错的、"title/cover命令不存在"也是错的（脚本存在）。先查代码再决定是否采纳建议。
8. **蒸馏prompt位置**：封面分析prompt在`references/cover-analysis-prompt.md`（v2.0，蒸馏/诊断两套）。旧版在`daily_pipeline.py` L1399已废弃。`distill/evidence/*/covers.json`是蒸馏产出物。`docs/code-knowledge-graph.json`可快速定位模块。
7. **封面蒸馏数据在.gitignore中**：`distill/` 目录被gitignore，蒸馏数据不会被commit。只有代码和prompt文件可以提交到git。
6. **封面分析prompt位置（2026-07统一）**：诊断和蒸馏共用统一母本 `references/cover-analysis-prompt.md`（共享核心+诊断附加+蒸馏附加），替代了旧的三处硬编码（cover_analysis_own.py 7维、daily_pipeline.py L1399 11字段、batch_cover_analysis.py 11字段）。改prompt只改母本，代码是投影。蒸馏产出物仍在 `distill/evidence/*/covers.json`。`docs/code-knowledge-graph.json`可快速定位模块。

## 不可编造信息

- README 中的架构名称（如"Nuwa双脑""专家脑"）必须来自用户实际告诉你的内容，不可自行包装美化
- 被问到"这个是你写的吗"时，诚实回答——git blame 可查

## 模块1: 骨架公式

跨语言验证的标题叙事原型（13种）

### 1. 身份落差打脸型

**叙事结构**：主角以低位/弱势/被误认身份登场，遭公开羞辱或集体轻视；中段真实身份或隐藏能力曝光；结尾反派震惊、全场跪服或高位人物主动承认。
**心理机制**：观众享受'所有人都看错了'的全知优越感，以及误判者被迫面对真相时的打脸快感。
**适用题材**：CEO豪门、隐藏战神、神医、校园逆袭、真假千金
**跨语言验证**：en, es, id, jp, pt, tr, zh-tw（7个语言）
**播放范围**：40000-200000

**示例**：
- [en] Useless man mocked like dog, unexpectedly trillion-dollar heir—3 strong beauties vie to pamper him!
- [es] Va a escuela con un saco y lo ridiculizan, resulta es heredero rico y reina del campus lo llama amo
- [id] Semua rendahkan satpam ini, dia ayah orang terkaya dunia, bahkan CEO cantik terpukau padanya.

**规则**：
- 低位身份必须具体可画面化：快递员、保洁员、卖菜小伙、鱼屋の娘、taksici、vendedor de bao比poor person更有效。
- 高位真相必须足够夸张：CEO、miliarder、trillion-dollar heir、Dewa Perang、隱世至尊、最強の達人。
- 反例：只写'他是CEO'但没有被误判场景，缺少打脸前提。
- 反例：低位身份写得太模糊如'普通人'，无法触发画面联想。
- 揭露后必须有人震惊或跪服，'全场震惊''Herkes Şoke Oldu''全世界震驚'是爽点兑现标志。

### 2. 关系背叛补偿型

**叙事结构**：主角在亲密关系（婚姻/恋爱/家族）中被背叛、替代、抛弃或利用；主角离开后获得更高价值的关系/身份/财富；原伤害者开始后悔、崩溃或跪求。
**心理机制**：背叛激发愤怒，离开激发尊严，后悔/跪求激发补偿快感——三段情绪形成连续点击动力。
**适用题材**：追妻火葬场、离婚逆袭、前任后悔、替身、婚约背叛
**跨语言验证**：en, es, id, jp, pt, tr, zh-tw（7个语言）
**播放范围**：45000-300000

**示例**：
- [en] Five years, no ring. I was just a pawn. When he proposed to his first love, I walked away.
- [es] 5 años de matrimonio, esposo duerme con pasante frente a ella; ella recupera bienes y lo hace pagar
- [id] 【IN DUB】Hancur hati lihat dia jemput cinta pertama! Aku pergi, dia baru sadar!

**规则**：
- 必须出现具体的背叛动作：出轨、当众羞辱、退婚、赶出家门、选择初恋、合谋陷害。
- 主角必须有明确的离开/转身/亮出身份动作，不能被动等待被救。
- 反例：只写'夫妻吵架'但没有第三者或身份误判，弱于有具体背叛画面的标题。
- 反例：标题只堆虐点没有补偿承诺——至少要有'regrets'、'後悔''跪求''積澱痛代價'等回报预告。

### 3. 重生改命型

**叙事结构**：主角前世/过去被消耗、欺骗、杀害或失去一切；获得重生/人生二周目/转生机会后，带着记忆/信息差不再走旧路，主动清算仇人或改写命运。
**心理机制**：全知视角带来信息差优势，观众期待主角如何提前布局、避开陷阱、让仇人自食其果。
**适用题材**：重生复仇、大女主、古装宫斗、家族清算
**跨语言验证**：en, es, id, jp, tr, zh-tw（6个语言）
**播放范围**：40000-120000

**示例**：
- [en] Drained in past life, reborn she threw away the demand list and lived for herself.
- [es] Renací… y esta vez elegí al hombre más temido del mundo #dramachino #cdrama
- [id] Dikhianati Suami dan Mertua, Ia Terlahir Kembali untuk Membalas Semuanya!

**规则**：
- 必须同时出现旧命运（前世惨败/被害）和新选择（拒绝旧路/主动清算），缺一不可。
- 反例：只写'她重生了'但不说明这次改变什么——缺少前世仇敌和今生改命动作，悬念不足。
- 重生标题最好同时出现旧敌人和新能力/新盟友：cheater、fake girl、太子、Saat tahu、新神力。

### 4. 系统/能力觉醒型

**叙事结构**：主角在事故、濒死、受辱或穿越后获得系统/读心/神力/超能力等规则外力量，能力不是展示用而是立刻改变财富、关系或权力格局。
**心理机制**：能力降低逆袭成本，观众预期快节奏打脸、升级和收割奖励，形成'下一个升级是什么'的连续观看动机。
**适用题材**：系统流、男频都市、玄幻、穿越、种田
**跨语言验证**：en, es, id, jp, tr（5个语言）
**播放范围**：20000-60000

**示例**：
- [en] My Family Lied for the Fake Heiress, So My System Made Every Lie Come True[ENG DUB | FULL]
- [es] Joven viaja a época de hambruna con sistema VIP, salva a familia del hambre y consigue esposa bella
- [id] Gila! Satpam miskin tersengat listrik bangunkan kemampuan kuno—siluman, tembus pandang, teleport!

**规则**：
- 能力必须具体：读心、空间、复制、返现、谎言成真、心声外泄——不要只写'变强'。
- 最好把能力和现实回报绑定：变富、被CEO爱上、揭穿假千金、家人翻身。
- 反例：系统设定太复杂但标题不说明爽点，会让非网文用户看不懂。
- 系统/异能钩子要和现实冲突绑定，避免变成纯设定说明。

### 5. 情绪爆点场景型

**叙事结构**：标题抓取一个极端情绪瞬间——婚礼夜、生日、求婚、公开场合被羞辱、救命现场——让观众在未看剧情前已经站队。
**心理机制**：强情绪事件让用户立刻代入'如果我是她/他'的情境，点击是为了获得情绪释放。
**适用题材**：虐恋、甜宠、家庭伦理、复仇、婚姻危机
**跨语言验证**：en, es, id, zh-tw（4个语言）
**播放范围**：80000-140000

**示例**：
- [en] 🔥💔She Saved Him On Their Wedding Night. He Repaid Her With Coldness. Now He's Begging #ceolovestory
- [es] 💖Al ver a la chica abrazar al CEO más poderoso, su exnovio traidor entra en pánico. ¡Se arrodilla!
- [id] 【INDO DUB】Suami, anak, dan mertua bersatu menindasku… sampai aku berhenti memberi mereka uang!

**规则**：
- 观众必须能立刻判断谁受委屈：被背叛的妻子、被赶出的孕妇、被羞辱的送餐员。
- 反例：情绪词很多但没有具体事件如'heartbreaking love story'——会显得空泛。
- 高效场景包括 wedding night、birthday、proposal、gala、reunion、hospital、airport、altar。

### 6. 被迫关系升温型

**叙事结构**：主角因替嫁、契约、救命之恩、家族安排或误会进入婚姻/同居关系；起初双方地位不平等或情感冷淡；后续因真心、能力或身份揭露转为独占宠爱。
**心理机制**：'非自愿关系变真爱'提供从压迫到被选择的安全幻想，冷漠强者只为她破例是永恒爽点。
**适用题材**：契约婚姻、先婚后爱、替嫁、残疾CEO、身代わり妻
**跨语言验证**：en, es, id, jp, pt（5个语言）
**播放范围**：20000-120000

**示例**：
- [en] 💍💕Flash Marriage To A Hearing‑Impaired CEO. From Icy Silence To Burning Love
- [es] 💖El frío CEO ciego rechaza a todos, pero se enamora de la chica que se casa con él por 300 millones!
- [id] Gadis tak sengaja menikah dengan CEO,setelah menikah CEO jatuh cinta!

**规则**：
- 必须写出初始不平等和后续反差：冷→暖、假→真、被迫→选择、contract→love。
- 反例：标题只写'契约结婚后相爱'但没有障碍、误会、前任或身份差，记忆点弱。

### 7. 隐藏强者救援型

**叙事结构**：高位人物（CEO/公主/女总裁）在危机中向看似低微的人求助；后者暴露武力、医术、财富或特殊能力完成救援；救援行为进一步触发婚恋、报恩或权力重排。
**心理机制**：观众享受'被低估者突然出手'的能力爽感，也期待被救者如何回报。
**适用题材**：武术、神医、乡村高手、CEO遇险、男频爽剧
**跨语言验证**：es, id, pt, zh-tw（4个语言）
**播放范围**：40000-150000

**示例**：
- [es] CEO cazada pide ayuda al vendedor de bao; inesperadamente es leyenda de artes marciales y la salva
- [id] CEO Wanita Dikejar minta tolong pada Penjual bakpao, ternyata ia legenda bela diri yang menolongnya!
- [pt] Após Acidente, CEO Fica Preso No Topo Do Outdoor—Ninguém Ousa! Só Garota Pobre Sobe & O Salva!

**规则**：
- 低位职业要足够具体：pescadera、vendedor de bao、mendigo、送外卖、卖菜小伙。
- 隐藏能力要足够强：expert marcial、leyenda、Médico Divino、隱世至尊。
- 反例：只写'普通人救了CEO'但没有能力反差，无法形成奇观和爽点。

### 8. 亲情守护打脸型

**叙事结构**：家人（父母/孩子/妹妹/妻子）被欺负，隐藏强者因亲情被迫出手，完成守护和复仇。
**心理机制**：亲情受辱比个人受辱更容易激发愤怒，'为了她/他'让暴力打脸更具正当性。
**适用题材**：男频战神、家族复仇、亲情救赎、天才儿童
**跨语言验证**：id, jp, zh-tw（3个语言）
**播放范围**：80000-210000

**示例**：
- [id] Baru turun gunung, keluarga dibully! Satu pukulan habisi semua, musuh terkapar!
- [id] Dewa Perang Pulang Kampung Dengan Sepeda Tua, Temukan Ayahnya Dihina Dan Dibuang Mantan Istri
- [jp] 日本語吹き替え：山から降りた最強の七歳児道士！五行が足りないなら「物理的」に叩き直す！

**规则**：
- 被伤害对象最好是父母、孩子、妹妹、妻子——能快速建立正义感。
- 反例：只有主角自己被骂，没有家人受害——亲情守护钩子就不存在。

### 9. 集体误判打脸型

**叙事结构**：公共场合中所有人嘲笑、害怕或不敢行动；主角做出唯一正确或惊人的行动，颠覆全场认知。
**心理机制**：旁观者的群体压力放大了主角的弱势，'全场只有他/她敢'的反转满足少数人推翻多数的快感。
**适用题材**：打脸逆袭、救援奇观、隐藏强者、职场
**跨语言验证**：pt, tr（2个语言）
**播放范围**：40000-60000

**示例**：
- [pt] Todos riram dela por casar com um "idiota". Quem diria: a família toda a trata como uma princesa!
- [pt] Após Acidente, CEO Fica Preso No Topo Do Outdoor—Ninguém Ousa! Só Garota Pobre Sobe & O Salva!
- [tr] Hakaret Ettikleri Taksi Şoförü Trilyonluk Mirasçı Çıkınca Herkes Donup Kaldı！

**规则**：
- 必须有'全场/所有人/所有人'的旁观压力词：Todos、Ninguém、Herkes、みんな。
- 必须有'唯一例外'：Só、只有、tüm ama。
- 反例：没有旁观压力的个人反转——爽感会弱一层。

### 10. 绝嗣/意外得子型

**叙事结构**：高位男性被设定为无后或无法生育，家族继承危机严重；低位女性因一夜意外怀孕生子；证据曝光后男主以豪门资源补偿并宠爱她。
**心理机制**：同时击中豪门幻想、母凭子贵、被选中、长期宠爱与血缘延续焦虑。
**适用题材**：霸总甜宠、带球跑、豪门认亲、灰姑娘
**跨语言验证**：id, zh-tw（2个语言）
**播放范围**：60000-120000

**示例**：
- [zh-tw] 38歲絕嗣總裁以為此生無子，怎料那一夜19歲女孩一胎三寶
- [zh-tw] 全城默認45歲絕嗣總裁無人繼承家業，怎料代班的20歲農村女孩那一夜懷孕讓他有了繼承人
- [id] CEO tidak bisa punya anak, dia terkejut melihat tiga anak mirip dirinya di taman kota!

**规则**：
- 必须有'无法生育/无后/绝嗣'的危机前提和'意外怀孕/孩子出现'的证据。
- 反例：只写总裁宠妻但没有继承危机——会变成普通甜宠，缺少强钩子。

### 11. 危险权势反差甜宠型

**叙事结构**：女主误入危险男性的秘密世界（黑帮/恶魔王/冷酷CEO）；开局是威胁、误会或契约；结局却转为独占、保护和宠爱。
**心理机制**：危险感带来刺激，宠爱反转消解恐惧，形成'只有她能软化强者'的幻想。
**适用题材**：黑帮恋人、霸总甜宠、超自然爱情
**跨语言验证**：pt, tr（2个语言）
**播放范围**：18000-50000

**示例**：
- [tr] Mafya patronunun cinayetini gördü, ölür sandı ama onunla evlenip onu çok şımarttı！
- [tr] Şeytan Kral, kurtardığı kızla hızla evlendi ve doğaüstü bir aşk hikayesi başladı!
- [pt] Ela é esposa do CEO. Ele é o irmão. Começa um amor proibido!

**规则**：
- 标题要同时出现危险前提和甜宠结果——否则会偏惊悚或偏平淡。
- 反例：男主只强不宠、只威胁无情感转向，会失去女频核心吸引力。

### 12. 命运道具触发型

**叙事结构**：用一个具体物件或小行为触发命运大转折——破碎名表、鸡腿、蛋炒饭、合同、婴儿车。这个物件既是冲突证据也是身份反转入口。
**心理机制**：小物件带来大命运变化，产生'接下来怎么可能'的悬念。
**适用题材**：豪门误会、办公室事故、穿越、隐藏身份
**跨语言验证**：pt, zh-tw（2个语言）
**播放范围**：40000-110000

**示例**：
- [pt] Quebrou o relógio milionário do CEO. Para pagar, virou sua empregada e o apaixonou!
- [pt] Uma simples sopa de rua conquistou o CEO mais exigente... e também o seu coração
- [zh-tw] 窮小夥擺攤躲城管竟意外穿越古戰場，憑藉一碗蛋炒飯讓女武神功力大增

**规则**：
- 道具必须连接冲突和反转——不能只作为装饰。
- 反例：道具只作为装饰、不改变关系或命运——会变成无效细节。

### 13. 天才儿童破局型

**叙事结构**：儿童、萌宝或看似弱小者拥有超常智力、神力、推理力或心声外泄能力，在成人世界的危机中揭穿反派、拯救家人或扭转命运。
**心理机制**：弱小外形与强大能力形成反差，心声公开或天才推理让反派无法狡辩，产生轻松又爽的观看体验。
**适用题材**：天才儿童、萌宝、心声暴露、奇幻家庭剧
**跨语言验证**：jp（1个语言）
**播放范围**：10000-20000

**示例**：
- [jp] 日本語吹き替え：もしIQ200の子供が名探偵だったら？凶悪犯を論破して家族の危機を救う
- [jp] 日本語吹き替え：山から降りた最強の七歳児道士！
- [jp] 転生九回の私が心声が全部バレてる！偽物公主がその場で大炎上！

**规则**：
- 儿童必须成为破局中心，不能只是可爱装饰。
- 反例：儿童只是装饰不参与打脸——会变成低龄萌图而非短剧钩子。


## 模块2: 钩子体系

跨语言验证的钩子类型体系

### identity

利用角色表面卑微与实际尊贵/强大之间的巨大落差制造核心悬念和打脸期待。身份反差越大、揭露越公开，爽感越强。

- **隐藏富豪型**：主角表面是快递员、保洁员、乞丐、渔家女等低位身份，实际是继承人、CEO、首富之子
  - [ENG SUB] I Fake-Married a Poor Single Dad... But He's Actually a Billionaire CEO!
  - Va a escuela con un saco y lo ridiculizan, resulta es heredero rico
  - Bilionário finge ser fazendeiro, espera desprezo e acaba pedindo CEO em casamento!
  - Hizmetçi Sanılan Gelin Aslında Milyarder Varis!
- **隐藏强者型**：主角表面是普通小子/卖菜小伙/配達員，实际是战神、至尊、神医、武林高手
  - CEO Wanita Dikejar minta tolong pada Penjual bakpao, ternyata ia legenda bela diri
  - 3米高惡霸攔路打劫賣菜小夥，殊不知他竟是隱世至尊！
  - 成金が美人社長を無理やり妻にしようとした——だが隣で食事していた貧乏青年は最強の達人だった！
- **能力/血统隐藏型**：主角拥有读心、神医、语言能力、血统等隐藏特质，在关键时刻揭露
  - He spoke to lover in a foreign language, unaware she was fluent in 3 languages. She walked away.
  - 人人看不起的的傻妻竟是神醫聖手，她一針救活將死的首富
  - 【日本語吹き替え】ペテン師と侮辱された女の正体は、世界最強の秘密CEOでした。
### emotion

直接触发愤怒、心疼、甜蜜、感动、震惊等强烈情绪反应，让观众在阅读标题瞬间就站队。

- **愤怒触发器**：通过背叛、当众羞辱、出轨、利用等场景直接激发观众愤怒
  - My daughter's B-day: wife & her first love looked more like a family; my cake was pushed down.
  - 5 años de matrimonio, esposo duerme con pasante frente a ella
  - 【INDO DUB】Suamiku mengupaskan udang untuk wanita lain... aku langsung ajukan cerai!
  - 結婚3年丈夫從不帶妻子回鄉下老家，直到妻子偷偷回去撞見這一幕
- **心疼触发器**：通过弱者被欺负、孩子受苦、孕妇被赶出等场景激发心疼
  - Expulsa grávida na tempestade, ela foi salva no hospital pelo CEO
  - 全家誣陷窮小夥偷睡岳母，將他活生生打殘丟出去餓狗！
  - Chica es humillada y echada de casa por familia, inesperadamente multimillonario la recoge
- **甜蜜/感动触发器**：通过宠爱、等待多年、唯一偏爱等场景直接制造心动
  - 彼は私をとことん甘やかしてくれて、クズなんてもうどうでもよくなった。ただただ毎日が幸せすぎる…！
  - Dub español💘Me esperó doce años sin dejar de amarme.
  - Tras ser abandonada por un canalla,se casó con un CEO discapacitado que la trató como a una princesa
### compensation

强调恶有恶报、善有善终——让前期受伤主角获得应得回报，让反派后悔、跪求、失去一切。

- **后悔跪求型**：伤害者在主角离开或身份曝光后开始后悔、崩溃、跪求原谅
  - Too Late to Cry! I Left My Toxic Fiancée and Found Someone Better🔥❌
  - 婚約者が浮気したので、隣の部屋で彼の権力あるCEOの敵と寝た。私は溺愛され、元彼は後悔。
  - 一通電話——大物CEO兄三人へ。裏切り者、その場で崩壊！
- **碾压复仇型**：主角用权力、财富、武力或能力直接碾压曾经的伤害者
  - 她不裝了恢復首富身份讓狗男女付出慘痛代價！
  - Baru turun gunung, keluarga dibully! Satu pukulan habisi semua, musuh terkapar!
  - Nuevo CEO chega y revela: é el ex que la abandonó! Ela foge, mas ele se ajoelha na frente de todos!
- **全场震惊型**：反转发生在公开场合，所有人目睹真相后集体震惊
  - Datang Reuni Dihina Teman, Gadis Miskin Bikin Semua Berlutut Saat Suami Miliarder Muncul!
  - Damatı Tam Nikâhta Şok Etti: Hizmetçi Sanılan Gelin Aslında Milyarder Varis!
  - A faxineira caiu nos braços do CEO! Achou que seria demitida, mas ele a protege diante de todos!
### relationship

聚焦夫妻、前任、家庭、闺蜜、父子等亲密关系中的冲突、背叛或纠葛作为核心驱动力。

- **婚姻背叛型**：丈夫/妻子出轨、与初恋纠缠、合谋陷害配偶
  - After seeing a photo of her husband kissing his first love, she vanished from his life forever.
  - Evliliği, kocası ve babasının başka bir kadın için kurduğu bir oyundu… o ise gitti！
  - Wife & lover set a deadly trap for insurance payout, but they don't know I've been reborn.
- **契约/替身关系型**：因契约、替身、误认等被迫进入的关系
  - Dub español💘Tres años de matrimonio por contrato... y nació el amor.
  - 【完結】「AIドラマ」契約結婚から始まり、最上級の深い愛情を掴み取った
  - Tras ser abandonada por un canalla,se casó con un CEO discapacitado
### reversal

设置意料之外的转折点，打破观众已有预期，制造'没想到'的观感。

- **身份反转**：观众/角色以为A但实际上是B
  - CEO pensaba que la mujer a la que salvó era pobre, ¡pero resultó ser la hija de un multimillonario!
  - Fakir taksici yaşlı adama yardım etti, adam milyarder çıktı
  - CEO kena racun es! Pemuda miskin rupa-rupanya tabib dewa
- **行为反转**：剧情走向与角色或观众预期相反
  - A cleaner bumped into the CEO! Instead of firing her, he defended her!
  - Kadınlara ilgisiz zengin adam onun deli olduğunu sandı… sonra bu kıza yavaş yavaş aşık oldu
  - Gadis pikir suami CEO membencinya, siap kabur malah ditangkap dan dibawa pulang untuk dimanjakan!
### time

引入重生、穿越、多年后重逢等时间维度，利用时间变化制造命运对比和信息差。

- **重生/转生型**：主角带着前世记忆回到过去/异时空，改写命运
  - Reborn at 22: He Fixes His Past, Saves Wife, Crushes Loan Sharks & Becomes Rich
  - Renací… y esta vez elegí al hombre más temido del mundo
  - 転生九回の私が心声が全部バレてる！
- **多年后重逢型**：多年后的重逢、归来或身份变化
  - Her Ex Became Her Boss. He Wore An Engagement Ring For Ten Years. She Never Knew.
  - 5 Yıl Sonra Ülkenin En Zengin CEO'su Oldu, Eski Karısının Gizli Çocuğunu Görünce
  - Após 10 Anos na Luta, Ele Casa com Bela Misteriosa… Mas Descobre que Ela é Bilionária

### 新发现钩子

- **系统/异能觉醒**：主角在雷击、车祸、濒死或穿越后获得系统、读心、复制、谎言成真、返现等能力，并以此推动逆袭、复仇或恋爱（en, es, id, jp, tr）
- **心声外泄公开处刑**：通过心声外泄或全员听见内心话的设定，让反派谎言持续暴露，形成连续打脸（jp）
- **绝嗣总裁继承人**：以无法生育的霸总为前提，通过意外怀孕生子制造血缘延续与豪门补偿（id, zh-tw）
- **穷人善举测试**：弱者用有限资源施予善意（鸡腿、一碗面），接受者实为隐藏强者，形成真心与财富的反差（pt）
- **AI标签权威框架**：标题以'AIドラマ'或AI作为内容标签，给传统短剧增加科技感、潮流感和实验感（jp）

### 钩子组合规则

**最强配对**：identity+reversal——全球最稳定的高频配对, emotion+reversal——先心疼再翻盘, emotion+identity——情绪+身份差双锚点, compensation+identity——身份揭露+碾压回报, relationship+reversal——关系冲突+意外结果, time+compensation——重生+复仇闭环
**低效组合**：只有romance没有冲突——缺少点击理由, 只有CEO身份没有误判——缺少打脸前提, 只有复仇结果没有前置伤害——缺少愤怒锚点, 单独使用time/时间钩子——变成背景设定而非剧情, 单独使用compensation——缺少为什么补偿的理由

**规则**：
- 先用emotion或relationship让观众站队，再用reversal或identity提供点击承诺。
- 女频优先：relationship+emotion+identity；男频优先：identity+reversal+compensation。
- 标题最多承载2-3个钩子，超过后会变成信息噪音。
- 至少组合两种钩子以增强叙事张力。
- reversal是万能加速器——与任何钩子组合都能提升均播。


## 模块3: 包装模式

### 句式模板

- **Unaware/Ternyata反转句**：`{角色做了某事}, unaware/ternyata/resulta/原来是{隐藏真相}. {结果}.`
  场景：身份隐藏、能力隐藏、语言能力、真实血统、秘密婚姻等信息差题材 | 播放：60000-190000 | en, es, id, zh-tw
- **But Actually身份句**：`{看似低位关系或身份}... But/但实际上/但是他其实是{高位身份}!`
  场景：闪婚、假婚、误认、救人、收留陌生人等会产生身份误判的剧情 | 播放：50000-65000 | en, es, zh-tw
- **Now Regrets/太迟了补偿句**：`{反派/伴侣} {伤害主角}—Now/然而 {反派/伴侣} Regrets/後悔/跪求!`
  场景：背叛、离婚、抛弃、误会、替身、假千金陷害后被清算 | 播放：35000-120000 | en, es, id, zh-tw
- **Reborn/Terlahir Kembali改命句**：`Reborn/重生/重活一世{时间/节点}: {主角} {改变旧选择}, {复仇/拯救/致富}.`
  场景：主角带着记忆回到关键人生节点，并主动改写命运 | 播放：40000-120000 | en, es, id, tr, zh-tw
- **目睹-以为-反转句**：`{主角} {看到危险行为}，{极端预期} sandı/认为 ama/但是 {完全相反的结果}！`
  场景：危险爱情/黑帮题材——用极端反转制造最大情绪落差 | 播放：50000-115000 | tr, es, id
- **Todos/みんな集体误判句**：`Todos/Herkes/みんな {误判行为}，mas/但/tapi {真相/强者反应}！`
  场景：集体打脸、公开羞辱、弱者逆袭，需要旁观压力时使用 | 播放：40000-60000 | pt, tr
- **不哭不闹亮出身份句**：`{被背叛的惨状}，她不哭不闹/不装了{亮出身份}，{让背叛者后悔的结果}`
  场景：被抛弃后身份觉醒，女频大女主、追妻火葬场 | 播放：100000-120000 | zh-tw
- **【前缀】+叙事句**：`【ENG SUB/INDO DUB/日本語吹き替え/完結】{高概念剧情梗概}`
  场景：标记内容质量、语言版本、完结状态，提升可信度和可搜索性 | 播放：50000-70000 | en, id, jp

### 标点策略

**通用**：感叹号用于强化情绪释放和打脸结果；破折号用于切开前因和反转；省略号用于悬念暂停和情绪延迟；逗号用于分隔因果句段。
**en**：省略号（...）用于身份反转前的停顿；but/unaware/actually是高频转折连接词；破折号（—）用于结果承诺
**es**：逗号和分号分隔受辱现场和反转结果；省略号用于第一人称经历；感叹号强调下跪/发现/被宠
**id**：感叹号高频用于Gila!/musuh terkapar!/dimanjakan!；省略号用于婚恋背叛的心碎感；破折号用于系统能力解释
**jp**：【】前缀标注观看属性和内容包装；——长破折号制造电影感停顿；！和!?用于强化情绪；冒号用于日本語吹き替え后接设定
**pt**：破折号切开前因和反转；感叹号强化打脸/爱情结果；冒号适合宣告台词；引号突出被嘲笑身份
**tr**：逗号串联因果事件链；分号分割前因和后果两幕；省略号在转折前悬停；感叹号仅放在标题最末尾；极少使用问号
**zh-tw**：感叹号使用率98.7%，通常多个；省略号制造悬念暂停；逗号分隔铺垫句和转折句；【】标注剧名或特别说明

### Emoji策略

**最佳位置**：开头用于标记情绪类型和题材；中间标记反转爆点（适用于长标题）；末尾强化情绪预期和点击转化。
- 🔥用于复仇、强冲突、爆款感——全球通用
- 💕💖💗💘用于甜宠、CEO爱情、闪婚——女频专属
- 💔用于背叛、虐恋、离开——全球通用
- 👑用于王室、豪门、女王式逆袭
- 开头emoji不要超过2-3个，否则降低可读性
- emoji要服务题材：背叛用💔比💕更一致，复仇用🔥或💥更直接
- 土耳其市场几乎不用emoji（4.2%），繁中市场几乎必用（98.7%）
- emoji不能替代强钩子——有emoji均播未必高于无emoji
- 格式词如[FULL]、【ENG DUB】与emoji可以共存，但核心钩子必须在前80个可见字符内出现

### 叙事递进

- **伤害→离开→后悔**：先写具体伤害事件，再写主角离开/转身，最后写反派后悔/跪求
- **低位→误判→高位揭露**：先给低位身份和被轻视，再制造嘲笑或误认，最后揭露真实身份和碾压结果
- **旧命运→重生→新选择**：先说明过去被消耗或死亡，再写重生/觉醒，最后写拒绝旧选择并清算
- **全员退缩→唯一敢→全场震惊**：先写所有人退缩/不敢/嘲笑，再写弱者完成不可能任务，最后全场震惊
- **偶然相遇→身份隐藏→爱情/继承人结果**：用救人、误进、收留等偶然事件触发隐藏身份关系，最后给甜宠或继承人结果
- **小事故→被迫关系→真爱**：用一个具体事故/冲突作为入口，把赔偿/雇佣/契约转化为爱情或身份揭露
- **情感强度递进**：情绪从最屈辱逐步升级到最爽的报复：受辱→反击→碾压→跪求

### 约束条件

**标题平均长度**：{"en": 80, "es": 87, "id": 88, "jp": 72, "pt": 88, "tr": 90, "zh-tw": 76}

**高频关键词**：
- en: CEO, Billionaire, Reborn, Marriage, Cheater, Husband, Wife, Heiress
- es: CEO, renacer, traicionada, humillada, matrimonio, esposo, millonario, pobre
- id: CEO, Gadis, Dewa Perang, Miliarder, Suami, Istri, Tak disangka, Ternyata
- jp: 日本語吹き替え, 社長, CEO, 結婚, 妻, 正体, 離婚, 初恋
- pt: CEO, bilionário, pobre, casamento, grávida, amor, vingança, marido
- tr: CEO, Mafya, Kurye, Taksi Şoförü, Milyarder, Varis, Evlendi, Boşanma
- zh-tw: 逆襲, drama, 情感, 爱情, 短劇, 爽劇, 甜寵, 都市


## 封面×标题协同规则

**rule**：封面与标题必须围绕同一个核心‘钩子’分工：标题负责提供信息密度（谁、为什么、结果如何），封面负责提供情绪密度（定格冲突、证明身份、可视化反转）。二者是互补关系，共同完成对观众3秒内的信息刺激和情绪刺激。

**hook_cover_mapping**：
- **identity**：低位身份标签（如穷人、女仆、清洁工、快递员）+ 被轻视/羞辱 + 真实高位身份揭露
  cover_pattern：将低位身份符号（破旧衣服、工装、菜篮）与高位身份符号（豪车、保镖、豪宅、直升机、精英人群）置于同一画面，形成强烈的视觉阶级反差。
  example：标题：Dihina dan diusir oleh Keluarganya, Tak disangka Gadis ini dipungut dan dimanjakan CEO Miliarder! | 封面：落魄女子蜷缩在地，白衣CEO戴墨镜站立，背景有直升机和黑西装团队。
- **relationship**：亲密关系角色（丈夫/妻子/前任/初恋）+ 背叛/误会/阴谋 + 主角离开/反击/后悔
  cover_pattern：用多人关系站位和肢体语言表达关系断裂与权力变化，如三角对峙、背对、求抱、摔物、前任跪地等。距离、位置和表情是核心。
  example：标题：After seeing a photo of her husband kissing his first love, she vanished from his life forever. | 封面：应定格女主看到亲密照片后的震惊和转身离开，男主与初恋在背景形成背叛证据。
- **emotion**：具体情绪伤害事件（如婚礼夜被冷落、生日被羞辱、为救他而受伤）+ 不公平回报 + 现在他/她后悔/求饶
  cover_pattern：定格受伤或反击的巅峰瞬间，如婚礼现场的冷漠对视、生日宴上的公开羞辱、医院病床前的绝望或觉醒。表情和场景道具（婚纱、蛋糕、病历）是关键。
  example：标题：🔥💔She Saved Him On Their Wedding Night. He Repaid Her With Coldness. Now He's Begging | 封面：最佳封面应有婚纱、婚床、冷脸男主、心碎女主，直接证明‘wedding night’的情绪爆点。
- **reversal**：包含转折词（but, however, unexpectedly, 实际上）或预示权力反转（The Boy Who Ruled the School Couldn’t Control Her）
  cover_pattern：定格冲突高潮或反转揭露的瞬间，如打斗中的惊愕表情、证据揭露的现场、情感爆发的一刻，或掌控者反被掌控的尴尬画面。
  example：标题：人人看不起的傻妻竟是神醫聖手，她一針救活將死的首富！ | 封面：傻妻/低位女性在病床前施针，周围豪门人物震惊，银针或病人苏醒成为视觉证据。
- **time**：时间跨度词（Reborn, Past life, After years, For ten years, 转生， 前世）+ 命运改写或新选择
  cover_pattern：用前后对比、坚定眼神、撕毁文件、旧人重逢、特殊时间符号（孕检单、孩子、雷电）来呈现时间带来的变化和‘知晓未来’者的掌控感。
  example：标题：19歲女孩鑽進39歲絕嗣總裁車里躲債，他認出她是白月光...瘋找4年把母子帶回豪門寵！ | 封面：夜色车内总裁伸手护住害怕女孩，背景有追债者，车灯聚焦两人形成危机与保护感。
- **compensation**：受辱/被害/被抛弃 + 获得力量/地位/真相 + 让背叛者/加害者付出代价（破产、跪求、后悔）
  cover_pattern：视觉上完成权力位置转换：将处于高位（冷静、站立、被保护）的主角与处于低位（跪地、惊恐、慌乱）的反派/背叛者并置，通常伴随证据道具（文件、戒指、信物）。
  example：标题：Esposa revela provas da traição do marido e destrói a vida dele e da amante! | 封面：女主手持证据或文件站在高光位，丈夫和情人表情慌乱，形成公开审判感。
- **system/special_power**：事故/雷击/谎言/读心 + 获得系统/能力 + 逆袭结果（掌控世界、成为强者、报复）
  cover_pattern：主角居中，周围加入夸张的能量视觉元素（闪电、数据面板、金光、神兽、魔法光束），直观展示能力来源和战力上限。奇观必须服务于‘变强’。
  example：标题：Boşanmaya Kalktı, CEO Düşüncelerini Okuyunca Şoke Oldu ve Onu Kraliçe Gibi Şımarttı! | 封面：病房中女主伸手发光，男主震惊后退，医生在背景见证异常事件。

**patterns**：
- **标题给反差，封面给证据**：标题揭示隐藏身份或能力，封面必须用环境、服装、人物关系等视觉证据来证明这种身份反差是真实可信的。
  example：标题：Padre super rico viste humilde... | 封面：婚礼厅中衣着朴素父亲被家人轻视。
- **封面定格冲突，标题补全因果**：封面只需呈现冲突最高潮、最富张力的一幕（如跪地、拥抱、对峙、羞辱），标题则负责解释这一幕为何发生以及之后反转为何。
  example：标题：The Judge Gave Us 30 Days to Fall in Love Again | 封面：旧爱在黄昏中近距离凝视，补足强制复合后的暧昧。
- **情绪反转视觉化**：标题描述从冷漠到后悔、从被弃到被宠的情绪转变，封面用人物的表情（冷脸vs甜蜜）、距离（疏远vs亲密）和姿态（站立vs依偎）来可视化这种反转。
  example：标题：From Icy Silence To Burning Love | 封面：冷脸CEO与受伤女主转向亲密保护姿态。
- **奇观服务战力/结果**：封面中的夸张视觉元素（龙、闪电、金光、魔法）不是纯装饰，必须直接指向标题中承诺的能力获得、身份揭露或逆袭结果。
  example：标题：雷击得系统 | 封面：闪电、金龙、光剑围绕主角，显示能力升级。

**anti_patterns**：
- **题材错位**：标题讲社会逆袭，封面却像奇幻冒险；标题是离婚背叛，封面却像甜蜜婚纱照。导致用户预期混乱，点击后快速划走，损害完播率和频道标签。
- **只美不钩**：男女主颜值很高，但没有身份符号、冲突动作、关系张力或情绪状态，画面平静无奇。观众无法在3秒内判断"我为什么要点开这个"。
- **标题有爆点，封面无证据**：标题写了cheating、reborn、secret billionaire、神医，但封面只有普通合照、风景或静态摆拍，缺乏视觉证据来支持标题的承诺，降低点击可信度。
- **信息过散**：封面中人物过多（>5人）、文字过多、符号堆砌、场景杂乱。核心钩子在手机端缩略图上无法被一眼识别，分散注意力。

## ⚠️ 封面生产流程（2026-07-12对齐）

**生产层 vs 校验层**：
- **生产层**：按hook类型从下方7张模板卡中选卡 → 取卡内构图/色彩/符号/文字规格 → 结合题材做本地化（参照卡内七语种微调）→ 按四层结构组装生图prompt
- **校验层**：用封面×标题协同规则和四维评分（构图站位/情绪表达/关键道具/文字标签）对方案做微调校验

封面重做/新做时，必须先选卡再出方案，产出必须注明所选模板卡名称。禁止跳过模板卡用零散规则现场拼装。

## 封面模板卡（7张，按钩子纵切）

> 以下7张卡是封面制作的"直接下单模板"。每张卡从 hook_cover_mapping、patterns、female_vs_male、by_language、封面指南、anti_patterns 六处纵切拼装，AI 出封面时只需选卡→填空→出图。
> 
> **单一数据源规矩**：本文件（short-drama-youtube 3.1）是唯一知识母本。所有 skill/distill.json 都是它的投影，只能单向从本文件生成/同步。禁止在投影上直接改知识。改知识只改本文件，然后重新生成下游。版本号见文件头。

---

### 模板卡1：身份反差局（identity）

**适用题材**：CEO豪门、隐藏战神、神医、真假千金、校园逆袭、豪门闯入
**匹配骨架**：#1身份落差打脸型、#6隐藏身份揭露型、#8低位闯高位型、#9全员退缩唯一敢型
**配对标题句式**：【低位身份+被羞辱】+【反转词】+【高位身份+碾压结果】

**变量槽（5个剧情事实类，填空即出图）**：
| 变量 | 说明 | 示例 |
|------|------|------|
| `{主角性别+服装}` | 主角身份的视觉锚点 | 穿破旧工装的女主 / 穿外卖服的男主 |
| `{配角动作}` | 配角对主角的动作，表达权力落差 | 推搡她跪下 / 冷笑着指向门口 |
| `{场景}` | 默认值：豪华办公室/豪宅客厅；可从标题提取 | 法庭门口 / 酒店大堂 |
| `{具体冲突}` | 从标题提取的剧情核心事件 | 被赶出家门 / 当众被扇耳光 |
| `{题材色彩变体}` | 默认值：冷蓝灰+暖金；可按题材微调 | 复仇：冷蓝+红 / 甜宠：暖金+粉 |

> **软约束**：emotion/symbols等保持现有默认值，偏离时需声明理由。

**构图**：左右/前后对比构图。将低位身份符号（破旧衣服、工装、菜篮）与高位身份符号（豪车、保镖、豪宅、直升机）置于同一画面，形成强烈视觉阶级反差。景别中景，确保表情和道具清晰。

**人物/表情**：
- 女频：2人构图，主角在低位（蜷缩/被推/跪地），反派/强者在高位（站立/戴墨镜/冷脸）。肢体距离表达权力落差。
- 男频：1位强主角居中（冷静/不屑），反派在侧（嘲笑/跪地）。战力符号（西装团队、保镖）在背景。

**色彩**：冷蓝灰背景（底层场景）+ 暖金高光（高位身份揭露瞬间）。用环境色（冷）与人物光（暖）制造对比，让人物从背景中"跳"出来。

**视觉符号**：低位：工装、外卖服、破衣、街头、雨夜。高位：西装团队、豪车、直升机、黑卡、皇冠。每张封面固定1-2个身份锚点，放在视觉中心。

**文字规格**：极简2-4词，只提炼身份标签。如"Secret CEO""Satpam Miliarder""正体判明""真千金"。文字放边角，不遮挡表情。

**真实范例**：
- 标题：Dihina dan diusir oleh Keluarganya, Tak disangka Gadis ini dipungut dan dimanjakan CEO Miliarder!
- 封面：落魄女子蜷缩在地，白衣CEO戴墨镜站立，背景有直升机和黑西装团队。
- 变量填充：`{主角性别+服装}`=穿破旧衣服的女主, `{配角动作}`=CEO站立俯视, `{场景}`=豪宅门口, `{具体冲突}`=被家人赶出, `{题材色彩变体}`=冷蓝灰+暖金（默认）

**七语种微调**：
- en：封面情感表达相对含蓄，侧重构图张力（对峙、距离）而非过度夸张表情。喜欢使用具体场景道具（电梯、办公室、豪车）。
- es：色彩运用大胆，冷暖对比鲜明，不避讳高饱和色调。封面常伴随明确冲突动作（指、推、跪）。
- id：象征财富的符号被高度推崇（直升机、黑卡、保镖团队、豪宅）。需加【INDO DUB】角标。
- jp：画面质感、光影、构图都需精致。常用日式视觉符号（牢房铁栏、听筒、肖像画）。
- pt：色彩偏好暖色调和豪华感（金、米白、棕）。需加PT DUB角标。
- tr：封面文字极少，善用天气元素（雨夜、雪地）增强情绪氛围。常用结婚证、枪、轮椅等高冲突密度道具。
- zh-tw：男频强调体型与气场压制，女频强调肢体亲密与保护感。封面文字极少用，若用则为极简核心词（"逆袭""复仇"）。

**禁区**：题材错位（标题讲社会逆袭，封面像奇幻冒险）；只美不钩（颜值高但无身份符号）；标题有爆点封面无证据；信息过散（人物>5人）。

**证据等级**：[来源:7语种市场共性总结 v3.0]

---

### 模板卡2：撞破背叛局（relationship）

**适用题材**：追妻火葬场、离婚逆袭、前任后悔、替身、婚姻背叛、豪门虐恋
**匹配骨架**：#2关系背叛补偿型、#7契约/被迫关系型、#11复仇清算型
**配对标题句式**：【背叛事件具体化】+【主角离开/反击】+【背叛者后悔/代价】

**构图**：多人关系站位构图。用三角对峙、背对、求抱、摔物、前任跪地等肢体语言表达关系断裂与权力变化。距离、位置和表情是核心。

**人物/表情**：
- 女频：3人构图（女主+男主+第三者），聚焦女主的震惊/决绝表情。用肢体距离表达关系断裂（推离、背对、转身）。
- 男频：主角在中心（冷脸/决绝），反派在侧（慌乱/跪地/求饶）。

**色彩**：冷色调为主（蓝黑、冷灰）表达背叛的冰冷感。用红色点缀（结婚证、戒指、血迹）作为情感爆点。暖色仅在回忆/甜蜜flashback中出现。

**视觉符号**：婚戒、离婚协议、亲密照片、破碎花瓶、婚纱、第三者、雨夜。核心道具必须能一眼识别"背叛"。

**文字规格**：极简2-4词，提炼背叛/离开关键词。如"TRAICIÓN""Begging""後悔""离婚"。

**真实范例**：
- 标题：After seeing a photo of her husband kissing his first love, she vanished from his life forever.
- 封面：定格女主看到亲密照片后的震惊和转身离开，男主与初恋在背景形成背叛证据。

**七语种微调**：
- en：封面情感表达相对含蓄，侧重构图张力。喜欢用具体场景道具（卧室、酒店、手机照片）。
- es：标题喜用感叹号和强烈情绪词。常用"TRAICIÓN""HEREDERO""SE ARRODILLA"等西语强词。
- id：情绪表达直接，常见哭泣、争吵、举离婚协议等夸张画面。需加【IndoSub】角标。
- jp：封面精细度要求高。文字精准，常用「正体判明」「全員絶句」等日式短语。
- pt：标题和封面常围绕"孕妇""单亲妈妈""破碎名表"等具体道具展开叙事。
- tr：封面文字极少。善用天气元素（雨夜、雪地）增强情绪氛围。
- zh-tw：标题常用"殊不知""岂料""竟是"等文言反转词。封面需可视化"隐藏身份"。

**禁区**：只美不钩（男女主颜值高但无冲突动作）；信息过散（人物>5人）；风格与标题背离（甜美风配背叛标题）。

**证据等级**：[来源:7语种市场共性总结 v3.0]

---

### 模板卡3：情绪爆点局（emotion）

**适用题材**：虐恋、甜宠、家庭伦理、婚姻危机、婚礼夜被冷落、生日被羞辱
**匹配骨架**：#5情绪爆点场景型、#12甜宠溺爱型
**配对标题句式**：【具体情绪伤害事件】+【不公平回报】+【现在他/她后悔/求饶】

**构图**：中心构图，定格受伤或反击的巅峰瞬间。如婚礼现场的冷漠对视、生日宴上的公开羞辱、医院病床前的绝望或觉醒。表情和场景道具是关键。

**人物/表情**：
- 女频：2人近景，聚焦女主的震惊/含泪/绝望表情。男主在旁（冷脸/转身/无动于衷）。用表情外露传递情绪张力。
- 男频：主角在中心（隐忍/觉醒），反派在侧（得意/羞辱）。

**色彩**：浪漫甜宠用暖金、粉、柔光。复仇/虐恋用红黑、冷蓝金、强对比。核心技巧：用环境色（冷）与人物光（暖）制造对比。

**视觉符号**：婚纱、婚床、蛋糕、病历、蛋糕、破碎礼物、眼泪。定格冲突峰值而非和解画面。

**文字规格**：极简2-4词，提炼情绪关键词。如"Begging""Regrets""溺愛""後悔"。

**真实范例**：
- 标题：🔥💔She Saved Him On Their Wedding Night. He Repaid Her With Coldness. Now He's Begging
- 封面：婚纱、婚床、冷脸男主、心碎女主，直接证明"wedding night"的情绪爆点。

**七语种微调**：
- en：封面情感表达相对含蓄，侧重构图张力（对峙、距离）。
- es：标题喜用感叹号和强烈情绪词。色彩运用大胆，冷暖对比鲜明。
- id：情绪表达直接，常见哭泣、争吵等夸张画面。
- jp：封面精细度要求高。文字精准，常用「溺愛」「後悔」等日式短语。
- pt：色彩偏好暖色调和豪华感。围绕"孕妇""单亲妈妈"等具体道具。
- tr：善用天气元素（雨夜、雪地）增强情绪氛围。
- zh-tw：男频强调体型与气场压制，女频强调肢体亲密与保护感。

**禁区**：静态美图（只有颜值无冲突）；封面情绪与标题不一致（讲复仇只用甜美）；信息过散。

**证据等级**：[来源:7语种市场共性总结 v3.0]

---

### 模板卡4：翻脸打脸局（reversal）

**适用题材**：身份揭露、能力碾压、众人震惊、公开审判、隐藏富豪/神医/战神
**匹配骨架**：#1身份落差打脸型、#6隐藏身份揭露型、#9全员退缩唯一敢型
**配对标题句式**：【众人看不起】+【反转词】+【真实身份/能力揭露+全场震惊】

**构图**：定格冲突高潮或反转揭露的瞬间。打斗中的惊愕表情、证据揭露的现场、情感爆发的一刻，或掌控者反被掌控的尴尬画面。center构图（核心冲突放画面几何中心）。

**人物/表情**：
- 女频：主角在中心（冷脸/自信），围观者在周围（震惊/跪地/后退）。用围观人群强化"打脸"的群体爽感。
- 男频：主角居中（冷静/碾压姿态），反派在侧（惊恐/跪地/求饶）。战力符号（龙、闪电、金光）围绕主角。

**色彩**：高饱和金、红、蓝。用金光/闪电/能量特效展示能力揭露的瞬间。背景冷色调衬托主角的"发光"感。

**视觉符号**：震惊表情、跪地、证据文件、能力特效（闪电、金光、系统面板）、围观人群。核心是"所有人都没想到"的视觉冲击。

**文字规格**：极简2-4词，提炼身份/能力标签。如"DEWA PERANG""神医""正体判明""全員絶句"。

**真实范例**：
- 标题：人人看不起的傻妻竟是神醫聖手，她一針救活將死的首富！
- 封面：傻妻/低位女性在病床前施针，周围豪门人物震惊，银针或病人苏醒成为视觉证据。

**七语种微调**：
- en：侧重构图张力（对峙、距离）。喜欢使用具体场景道具（电梯、办公室、豪车）。
- es：色彩运用大胆，不避讳高饱和色调。封面常伴随明确冲突动作。
- id：象征财富的符号被高度推崇。情绪表达直接。
- jp：画面质感、光影、构图都需精致。常用日式视觉符号。
- pt：色彩偏好暖色调和豪华感。
- tr：封面文字极少。善用天气元素增强情绪氛围。
- zh-tw：男频强调体型与气场压制。封面文字极少用。

**禁区**：题材错位；只美不钩；标题有爆点封面无证据；信息过散。

**证据等级**：[来源:7语种市场共性总结 v3.0]

---

### 模板卡5：时空改命局（time）

**适用题材**：重生复仇、大女主、古装宫斗、绝嗣总裁、带球跑、追妻火葬场
**匹配骨架**：#3重生改命型、#13穿越/重生改命型、#10绝嗣/意外得子型
**配对标题句式**：【时间跨度词+前世/过去被伤害】+【重生/回到节点】+【带着记忆改写命运】

**构图**：前后对比构图。用坚定眼神、撕毁文件、旧人重逢、特殊时间符号（孕检单、孩子、雷电）来呈现时间带来的变化和"知晓未来"者的掌控感。

**人物/表情**：
- 女频：2人构图，主角在前景（坚定/觉醒/重生后冷脸），过去伤害者在背景（后悔/跪地/震惊）。用前后对比表达"重生后不同"。
- 男频：主角居中（掌控感），时间符号（日历、雷电、系统面板）在周围。

**色彩**：前世用冷灰/暗淡色调，重生后用暖金/明亮色调。用色温对比表达"命运改写"。

**视觉符号**：孕检单、孩子、雷电、破碎时钟、旧照片、重生光效。时间符号必须清晰可识别。

**文字规格**：极简2-4词，提炼时间/重生关键词。如"Reborn""重生""前世""After 5 Years""一胎三宝"。

**真实范例**：
- 标题：19歲女孩鑽進39歲絕嗣總裁車里躲債，他認出她是白月光...瘋找4年把母子帶回豪門寵！
- 封面：夜色车内总裁伸手护住害怕女孩，背景有追债者，车灯聚焦两人形成危机与保护感。

**七语种微调**：
- en：侧重构图张力。喜欢使用具体场景道具。
- es：色彩运用大胆。标题喜用感叹号。
- id：象征财富的符号被高度推崇。需加【INDO DUB】角标。
- jp：画面精致度要求高。文字精准。
- pt：色彩偏好暖色调和豪华感。
- tr：善用天气元素（雨夜、雪地）。
- zh-tw：time钩子均播61,433全市场最高。标题常用"殊不知""岂料"。

**禁区**：题材错位；只美不钩；信息过散；时间符号不清晰。

**证据等级**：[来源:7语种市场共性总结 v3.0, 繁中time钩子均播61,433验证]

---

### 模板卡6：巨额补偿局（compensation）

**适用题材**：复仇清算、打脸逆袭、被抛弃后逆袭、公开审判、证据揭露
**匹配骨架**：#11复仇清算型、#2关系背叛补偿型、#1身份落差打脸型
**配对标题句式**：【受辱/被害/被抛弃】+【获得力量/地位/真相】+【让背叛者付出代价（破产/跪求/后悔）】

**构图**：视觉上完成权力位置转换。将处于高位（冷静、站立、被保护）的主角与处于低位（跪地、惊恐、慌乱）的反派/背叛者并置，通常伴随证据道具（文件、戒指、信物）。

**人物/表情**：
- 女频：2-3人构图，女主在高位（站立/手持证据/冷脸），反派在低位（跪地/惊恐/求饶）。用位置高低表达权力反转。
- 男频：主角居中（冷静/碾压），反派在侧（跪地/惊恐/破产）。

**色彩**：红黑、冷蓝金、强对比。用冷色调衬托主角的冷静和反派的慌乱。高光打在主角和证据道具上。

**视觉符号**：证据文件、离婚协议、破碎婚戒、破产通知、跪地、围观人群。核心是"公开审判"的仪式感。

**文字规格**：极简2-4词，提炼复仇/代价关键词。如"Regrets""Begging""後悔""跪地求饒""arrepentirse"。

**真实范例**：
- 标题：Esposa revela provas da traição do marido e destrói a vida dele e da amante!
- 封面：女主手持证据或文件站在高光位，丈夫和情人表情慌乱，形成公开审判感。

**七语种微调**：
- en：侧重构图张力。喜欢使用具体场景道具（法庭、办公室、酒店）。
- es：色彩运用大胆。标题喜用感叹号和强烈情绪词。
- id：象征财富的符号被高度推崇。情绪表达直接。
- jp：画面精致度要求高。文字精准。
- pt：色彩偏好暖色调和豪华感。围绕具体道具展开叙事。
- tr：封面文字极少。善用天气元素。
- zh-tw：标题常用"殊不知""岂料"。封面需可视化"隐藏身份"。

**禁区**：题材错位；只美不钩；标题有爆点封面无证据；信息过散。

**证据等级**：[来源:7语种市场共性总结 v3.0]

---

### 模板卡7：异能觉醒局（system/special_power）

**适用题材**：系统流、男频都市、玄幻、穿越、职场反击、都市异能
**匹配骨架**：#4系统/能力觉醒型、#13穿越/重生改命型
**配对标题句式**：【事故/受辱/濒死】+【获得系统/超能力】+【能力立刻改变财富/关系格局】

**构图**：主角居中，周围加入夸张的能量视觉元素（闪电、数据面板、金光、神兽、魔法光束），直观展示能力来源和战力上限。奇观必须服务于"变强"。

**人物/表情**：
- 女频：主角在中心（觉醒/发光），反派在周围（震惊/后退/跪地）。能量元素围绕主角。
- 男频：主角居中（掌控/碾压姿态），反派在侧（惊恐/被碾压）。系统面板/金光/龙纹在背景。

**色彩**：高饱和金色能量、闪电蓝、火焰红、深蓝背景。用能量光效展示能力觉醒的瞬间。

**视觉符号**：闪电、数据面板、金光、神兽、魔法光束、系统界面、冠军服。符号要清晰、辨识度高，且在手机缩略图上可见。

**文字规格**：极简2-4词，提炼能力/系统关键词。如"System""觉醒""異能""Kemampuan Kuno"。男频封面可放系统界面/光效等视觉化能力来源。

**真实范例**：
- 标题：Boşanmaya Kalktı, CEO Düşüncelerini Okuyunca Şoke Oldu ve Onu Kraliçe Gibi Şımarttı!
- 封面：病房中女主伸手发光，男主震惊后退，医生在背景见证异常事件。

**七语种微调**：
- en：侧重构图张力。喜欢使用具体场景道具。
- es：色彩运用大胆。标题喜用感叹号。
- id：象征财富的符号被高度推崇。需加【INDO DUB】角标。
- jp：画面精致度要求高。常用日式视觉符号（闪电光环）。
- pt：色彩偏好暖色调和豪华感。
- tr：封面文字极少。善用天气元素。
- zh-tw：穿越类均播108,688全市场最高之一。封面需可视化"能力获得"。

**禁区**：题材错位（系统题材配甜宠封面）；只美不钩；能量元素纯装饰不指向能力；信息过散。

**证据等级**：[来源:7语种市场共性总结 v3.0, 繁中穿越类均播108,688验证]


## 标准生图 Prompt（蒸馏驱动，7张模板卡各一条）

> **数据来源**：267条竞品封面蒸馏数据，按hook分桶统计（2026-07-12）。
> 每条prompt的固定骨架编码了桶内构图/色彩/站位/道具的统计显著项。
> 桶内样本<15的字段标[全局回退]，使用267条全局统计。
> [来源:竞品Top封面共性,未经CTR因果验证]

### 使用规则

1. **标准流程**：按hook类型选卡 → 填变量槽 → 生图。禁止绕过标准prompt手拼。
2. **软约束偏离**：可基于剧情替换软约束项，但产出中必须声明"偏离默认:XX改为YY,理由ZZ"。
3. **实验位**：每批封面允许1-2张完全跳出模板的自由创作，标注[实验]，CTR单独跟踪。
4. **盲区**：题材不在蒸馏范围内时，借用hook心理最近的卡，声明"借用XX卡,题材细节为临场推断"。
5. **战绩回流**：封面上线后CTR记入对应卡；连续3次跑输频道均值→该卡prompt进pending重修。

### Prompt结构说明

每条prompt分四层（对应封面prompt指南的四层结构）：
- 【固定骨架】构图+镜头+安全区 — 蒸馏统计显著项，不许改
- 【软约束】色彩+道具+背景 — 给默认值，可按题材偏离
- 【变量槽】{主角} {配角} {场景} {道具} — 每次填
- 【组装示例】一条填好的完整英文prompt（80-120词）

---

### 卡1：身份反差局（identity）· 标准prompt

**桶内统计**：102条 | 构图: contrast 49% / center 45% | 色彩: mixed 61% / warm 33% | 有文字: 77% | 平均人数: 4.2

**【固定骨架】**（不可改）
- 构图：对角线对比构图（contrast），低位角色在左下，高位角色在右上
- 景别：中景（mid shot），展示姿态和关系，肤色占比~10%
- 画幅：16:9 landscape, 1280×720
- 安全区：bottom 15% dark gradient, top-left badge, right-bottom blank
- 风格：photorealistic, cinematic depth of field, East Asian features

**【软约束】**（默认值，可偏离）
- 色彩基调：mixed（冷色环境+暖色人物光），桶内61%
- 核心道具：西装（桶内59%）+ 豪车/保镖（桶内13%）
- 背景：office building / luxury car / helicopter pad
- 文字：左上角半透明胶囊角标

**【变量槽】**
{低位角色+服装+姿态} / {高位角色+服装+姿态} / {场景} / {核心冲突道具}

**【组装示例】**
```
A humble delivery worker in worn uniform kneeling on the ground, looking up in shock;
a tall CEO in black tailored suit standing above with arms crossed, cold expression;
black luxury sedan and bodyguards in blurred background, office building entrance;
dramatic rim light from behind creating golden edge glow on CEO, cool blue shadows on delivery worker;
scattered delivery packages on wet ground;
Text overlay area: bottom 15% dark gradient with white title text,
top-left semi-transparent capsule badge reading "FULL EPISODES",
right-bottom corner blank for YouTube timestamp,
16:9 landscape, photorealistic, cinematic depth of field, East Asian features
```

---

### 卡2：撞破背叛局（relationship）· 标准prompt

**桶内统计**：59条 | 构图: contrast 53% / center 42% | 色彩: mixed 59% / warm 31% | 有文字: 81% | 平均人数: 3.2

**【固定骨架】**（不可改）
- 构图：对比构图（contrast），用肢体距离表达关系断裂（推离/背对/转身）
- 景别：中近景（medium close-up），聚焦表情和肢体语言
- 画幅+安全区+风格：同卡1

**【软约束】**（默认值）
- 色彩基调：mixed（冷灰为主，红色点缀），桶内59%
- 核心道具：西装（58%）+ 花/玫瑰（34%）+ 文件/离婚协议（19%）
- 背景：bedroom / hotel corridor / rainy street

**【变量槽】**
{主角+表情} / {背叛者+姿态} / {第三者（如有）} / {背叛证据道具}

**【组装示例】**
```
Close-up of a young woman in elegant dress, shocked expression with tears forming,
holding a torn wedding photo; behind her a man in black suit turns his back, walking away;
a red lipstick mark visible on his collar as betrayal evidence;
dim bedroom with cold blue moonlight through window, shattered glass on the floor;
Text overlay area: bottom 15% dark gradient with white text reading "BETRAYED",
top-left badge "FULL EPISODES", right-bottom blank for timestamp,
16:9 landscape, photorealistic, cinematic, East Asian features
```

---

### 卡3：情绪爆点局（emotion）· 标准prompt

**桶内统计**：9条[全局回退] | 全局构图: contrast 49% / center 43% | 全局色彩: mixed 56% / warm 33% | 全局有文字: 78% | 平均人数: 3.9

**【固定骨架】**（不可改）
- 构图：对比构图（contrast），定格受伤或反击的巅峰瞬间
- 景别：中近景，聚焦极端情绪表情（震惊/含泪/绝望/觉醒）
- 画幅+安全区+风格：同卡1

**【软约束】**（默认值，全局回退）
- 色彩基调：mixed（冷色环境+暖色人物光）
- 核心道具：西装（全局高频）+ 婚纱/蛋糕/病历（按剧情选）
- 背景：wedding venue / birthday party / hospital / gala

**【变量槽】**
{情绪主体+极端表情} / {施压者+姿态} / {场景} / {情绪爆点道具}

**【组装示例】**
```
A bride in white wedding dress standing alone at the altar, tears streaming down her face,
clutching a bouquet of white roses; the groom in black suit is walking away toward the exit;
wedding guests in background with shocked expressions, one covering her mouth;
warm golden chandelier light above, cold blue shadows on the bride;
wilted rose petals scattered on the marble floor;
Text overlay area: bottom 15% dark gradient, top-left badge "FULL MOVIE",
16:9 landscape, photorealistic, cinematic, East Asian features
```

---

### 卡4：翻脸打脸局（reversal）· 标准prompt

**桶内统计**：32条 | 构图: contrast 56% / center 34% | 色彩: warm 44% / mixed 44% | 有文字: 78% | 平均人数: 3.3

**【固定骨架】**（不可改）
- 构图：对比构图（contrast），定格冲突高潮或反转揭露瞬间
- 景别：中景，确保围观人群+主角+反派都在画面内
- 画幅+安全区+风格：同卡1

**【软约束】**（默认值）
- 色彩基调：warm 44%（此桶暖色比例高于其他桶，用于身份揭露的"发光"感）
- 核心道具：西装（44%）+ 跪地/震惊表情
- 背景：public venue / banquet hall / courtroom

**【变量槽】**
{主角+自信姿态} / {反派+震惊/跪地} / {围观人群} / {揭露证据}

**【组装示例】**
```
Center: a young woman in simple clothes standing tall with cold confident expression,
holding a DNA report document; around her three people in luxury suits kneeling in shock,
one covering his face in disbelief; crowd of 5-6 onlookers in background with open mouths;
warm golden spotlight on the woman, others in cooler tones;
Text overlay area: bottom 15% dark gradient, top-left badge "FULL EPISODES",
16:9 landscape, photorealistic, cinematic, East Asian features
```

---

### 卡5：时空改命局（time）· 标准prompt

**桶内统计**：11条[全局回退] | 构图: center 73% / contrast 27% | 色彩: mixed 55% / warm 36% | 有文字: 73% | 平均人数: 3.0

**⚠️ 此桶构图偏好与其他桶显著不同**：center构图73%远高于全局43%，说明时间/重生题材偏好单主角居中+时间符号环绕的构图。

**【固定骨架】**（不可改）
- 构图：中心构图（center），主角居中，时间符号环绕
- 景别：中景，主角占画面核心
- 画幅+安全区+风格：同卡1

**【软约束】**（默认值，全局回退）
- 色彩基调：mixed（旧时间线冷灰+新时间线暖金渐变）
- 核心道具：孕检单/孩子/雷电/破碎时钟/旧照片
- 背景：split timeline (past gray / present golden)

**【变量槽】**
{主角+觉醒后姿态} / {旧时间线元素} / {新时间线元素} / {时间符号道具}

**【组装示例】**
```
A determined woman in modern black dress standing center, arms crossed,
cold expression looking directly at viewer;
left background: dark gray rainy scene with a ghostly crying version of herself in wedding dress;
right background: warm golden light with luxury office;
a shattered clock and old wedding photo floating between past and present;
lightning crack separating the two timelines;
Text overlay area: bottom 15% dark gradient, top-left badge "FULL MOVIE",
16:9 landscape, photorealistic, cinematic, East Asian features
```

---

### 卡6：巨额补偿局（compensation）· 标准prompt

**桶内统计**：19条 | 构图: contrast 63% / center 32% | 色彩: mixed 47% / warm 37% | 有文字: 84% | 平均人数: 4.5

**⚠️ 此桶跪地出现率47%为全桶最高**——补偿题材的核心视觉是权力位置转换。

**【固定骨架】**（不可改）
- 构图：对比构图（contrast），主角高位+反派低位（跪地/惊恐）
- 景别：中景，展示权力位置转换
- 画幅+安全区+风格：同卡1

**【软约束】**（默认值）
- 色彩基调：mixed（冷色衬托冷静+暖色打在证据上）
- 核心道具：西装（42%）+ 文件/证据 + 跪地姿态（47%）
- 背景：courtroom / company lobby / banquet hall

**【变量槽】**
{主角+高位姿态} / {反派+低位姿态（跪地/惊恐）} / {证据道具} / {围观者}

**【组装示例】**
```
A woman in black power suit standing tall, holding a red folder of evidence,
cold triumphant expression; below her a man in expensive suit kneeling on the ground,
hands clasped begging, desperate expression; beside him a younger woman cowering in fear;
corporate lobby with marble floors, security guards in background;
dramatic overhead lighting casting long shadows;
Text overlay area: bottom 15% dark gradient, top-left badge "FULL EPISODES",
16:9 landscape, photorealistic, cinematic, East Asian features
```

---

### 卡7：异能觉醒局（system）· 标准prompt

**桶内统计**：19条 | 构图: center 53% / contrast 47% | 色彩: mixed 63% / warm 26% | 有文字: 74% | 平均人数: 4.6

**【固定骨架】**（不可改）
- 构图：中心构图（center），主角居中，能量元素环绕
- 景别：中景，主角+能量特效占据视觉中心
- 画幅+安全区+风格：同卡1

**【软约束】**（默认值）
- 色彩基调：mixed（深蓝背景+金色/闪电能量光效），桶内63%
- 核心道具：武器（11%）+ 系统面板/闪电/金光
- 背景：virtual space / lightning sky / energy field

**【变量槽】**
{主角+觉醒姿态} / {能量特效类型} / {反派+震惊姿态} / {能力视觉符号}

**【组装示例】**
```
A young man in torn clothes standing center with arms spread, glowing golden aura around his body,
determined expression with eyes glowing; lightning bolts crackling around him;
three muscular fighters in background stumbling backward in shock;
dark stormy sky with electric blue energy swirling, ground cracking beneath his feet;
a holographic system panel floating beside him showing level-up indicators;
Text overlay area: bottom 15% dark gradient, top-left badge "FULL EPISODES",
16:9 landscape, photorealistic, cinematic, East Asian features
```

---

### 战绩跟踪表

| 模板卡 | 样本数 | 默认构图 | 默认色彩 | 上线次数 | 平均CTR | 状态 |
|--------|--------|---------|---------|---------|---------|------|
| identity | 102 | contrast | mixed | — | — | 待使用 |
| relationship | 59 | contrast | mixed | — | — | 待使用 |
| emotion | 9[回退] | contrast | mixed | — | — | 待使用 |
| reversal | 32 | contrast | warm | — | — | 待使用 |
| time | 11[回退] | center | mixed | — | — | 待使用 |
| compensation | 19 | contrast | mixed | — | — | 待使用 |
| system | 19 | center | mixed | — | — | 待使用 |

## 标签策略

**universal_rules**：



## ⚠️ 封面分析prompt统一状态（2026-07-11）

### 现状：三套prompt并行，统一母本为规格文档

| 脚本 | prompt位置 | 维度 | 用途 |
|------|-----------|------|------|
| `cover_analysis_own.py` | 从 `references/cover-analysis-prompt.md` 读取，fallback旧7维 | 7维+打分(0-10) | 自有频道诊断 |
| `daily_pipeline.py` | 从母本读取，fallback旧11字段 | 11维+结构化 | 竞品蒸馏 |
| `batch_cover_analysis.py` | 从母本读取，fallback旧11字段 | 11维+结构化 | 批量竞品分析 |

母本 `references/cover-analysis-prompt.md` 是规格文档（5部分：结构化枚举+复现prompt+中文描述+诊断评分+hook_type），不是直接喂给vision模型的prompt。

### Vision模型prompt复杂度硬上限（血泪教训）

doubao/ark-code-latest 和 mimo-v2.5 能稳定处理的JSON输出prompt约**600-800字符**。超过此限：
- JSON截断率显著升高
- LLM倾向返回"学过的"旧格式，忽略新指令
- 新增字段（结构化枚举/复现prompt/hook_type）全部为空

**正确的统一策略**：
1. **不替换原有prompt**——旧prompt经验证、稳定可靠
2. **在代码层统一输出格式**——`_convert_to_diagnosis_format()` 处理3种LLM输出变体
3. **母本作为规格文档**——不是直接喂给vision模型
4. **未来优化**：只追加1-2个简单枚举字段（如`scene_type`），不加复现prompt等复杂输出

### 统一prompt各部分的取舍（用户反馈）

- **hook_type**（钩子归类）：标题分析已做过，封面分析不需要重复。**删除。**
- **诊断评分**（7维打分）：给自有频道诊断用的，竞品蒸馏不需要。**分离。**
- **复现prompt**（80-120词英文）：太长LLM不遵循。**精简为关键词提取（场景+人物+色彩+道具）。**
- **结构化枚举**：机器可读，统计聚合核心。**保留，这是最有价值的部分。**

### API key注意

`batch_cover_analysis.py` 的 `load_config()` 查找 `XIAOMI_API_KEY`，但VPS环境变量名是 `XIAOMICODING_API_KEY`。需要 fallback。已修复。

### 下游数据依赖

`distill_cover_analysis.py` 从蒸馏JSON读取：
- 中文字段（人物/色彩/构图/道具）→ 关键词提取
- `结构化` 子对象（person_count/color_type/composition/has_text/emotion/identity_visible）→ 统计聚合

`diagnose_channel.py` 从诊断JSON读取：
- `avg_scores.avg_*_score` → 频道健康度
- `封面×标题协同.score` → 协同评分
- `details[].person_score` 等扁平字段 → 视频级评分

**改prompt时必须确保这两个下游消费者的字段名不被破坏。**

### 已知bug

- `cover_analysis_own.py` 旧版有 `"API异常: {}"`.format(e)` 的bug（.format在dict上调用而非string），已在v1.0修复为 `"API异常: {}".format(e)`

## 封面分析prompt v2.0（2026-07-11更新）

**母本**：`references/cover-analysis-prompt.md`（在duanju repo里，不在skill里）
**两套prompt**：
- **蒸馏prompt**（915字）：结构化枚举 + 11个中文描述字段。用于竞品封面分析（batch_cover_analysis.py / daily_pipeline.py step 5b）
- **诊断prompt**（1012字）：结构化枚举 + 7维打分。用于自有频道封面诊断（cover_analysis_own.py）
- 共用核心：结构化枚举（person_count/scene_type/composition/shot_scale/color_type/emotion/has_text/text_content/text_position/identity_visible/symbols）

**已删除的字段**：
- hook_type — 标题分析已覆盖，封面不重复
- 复现prompt — 80-120词太长，vision模型不遵循。用symbols字段（≤4字视觉符号）替代
- 诊断评分 — 只在诊断场景用，蒸馏不需要

**代码层**：`_load_cover_prompt_template(mode)` 按行匹配section header提取对应code block。`_convert_to_diagnosis_format()` 兼容3种LLM输出格式（新格式/旧嵌套/旧扁平）。

## 封面蒸馏按Hook分桶聚合

封面蒸馏数据结构化字段没有 `hook_type`。要按hook类型分别编码prompt，需用标题文本+中文描述字段反向匹配hook标签。

→ 完整方法和2026-07-12实测聚合结果见 `references/cover-distillation-bucketing.md`

**关键结论**：5个主桶（identity 103/relationship 57/reversal 32/system 20/compensation 19）样本充足可独立统计；time(11)和emotion(9)需全局回退。

## ⚠️ 待补：题材→符号映射层

7张模板卡覆盖的是"钩子心理"（为什么点），不是"题材视觉"（画什么场景）。目前缺少：
- 题材关键词→推荐模板卡的自动映射
- 各题材的场景符号（末世=废墟/武器、萌宝=婴儿/温馨客厅、职场=会议室/合同）

**蒸馏数据**：`distill/evidence/{7语种}/covers.json` 共267条（.gitignore不入git）。缺口：神医/末世/校园/替身题材（竞品库本身少）。`distill_cover_analysis.py` 从中文描述文本后处理提取结构化字段。

## 非核心语种降级策略

当目标市场不在7语种（en/es/id/jp/pt/tr/zh-tw）内时：

| 目标市场 | 降级参考 | 理由 |
|---------|---------|------|
| 印度(Hindi) | 印尼 + 英文 | 东南亚+南亚文化接近 |
| 中东(Arabic) | 土耳其 + 西语 | 宗教文化有交叉 |
| 韩国(Korean) | 日语 + 繁中 | 东亚文化圈 |
| 非洲 | 英文 | 英语覆盖 |
| 菲律宾 | 印尼 + 英文 | 东南亚+英文 |
| 法语 | 西语 + 葡萄牙 | 罗曼语系 |
| 俄语 | 土耳其 | 独联体/东欧接近 |

降级规则：用邻近市场数据 + 标注"参考降级，置信有限"。完全无参考时用全语种共性模式。

**female_vs_male**：
- female: 女频封面核心是‘关系张力’。优先使用2人构图，聚焦男女主。通过肢体距离（靠近/推离）、眼神（哀伤/愤怒/含情）、道具（婚戒、礼服、离婚协议、孕检单）来表达爱情、误会、背叛、宠爱等情绪。色调多用暖金、粉、浪漫冷蓝。
- male: 男频封面核心是‘低位受辱与力量碾压’。常用1位强主角居中，辅以反派或群众在侧。通过主角的冷静姿态、反派的震惊/跪地、以及战力符号（赛车、龙、闪电、武器、金光、冠军服）来展示爽点。构图更动态，色彩更强烈（高饱和金、红、蓝）。

**by_language**:
- en: {"special_patterns": ["标题常用[FULL]、[ENG DUB]等标签开头，封面文字可简洁补充如‘Secret Billionaire’。", "封面情感表达相对含蓄，侧重构图张力（对峙、距离）而非过度夸张表情。", "喜欢使用具体场景道具，如CEO题材的电梯、办公室、豪车，王室题材的皇冠、龙纹。"], "special_antipatterns": ["封面使用过多非拉丁字母，降低辨识度。", "标题核心钩子被格式标签挤到可见区域外，降低点击意愿。"]}
- es: {"special_patterns": ["标题喜用感叹号和强烈情绪词，封面常伴随明确冲突动作（如指、推、跪）。", "常用‘TRAICIÓN’、‘HEREDERO’、‘SE ARRODILLA’等西语强词作为封面文字。", "色彩运用大胆，冷暖对比鲜明，不避讳使用高饱和色调。"], "special_antipatterns": ["封面人物表情不够夸张或外露，不符合市场偏好。", "标题缺少具体背叛场景，只堆情绪词缺乏点击理由。"]}
- id: {"special_patterns": ["封面常用【INDO DUB】或【IndoSub】角标，增加本地信任度。", "象征财富的符号被高度推崇，如直升机、黑卡、保镖团队、豪宅。", "情绪表达直接，常见哭泣、争吵、举离婚协议等夸张画面。", "流行在标题开头使用emoji标记情绪类型，提升点击率。"], "special_antipatterns": ["封面没有明确的语种标识角标，可能被当作非本地化内容。", "冲突场景不够具体或贴近本地生活（如使用抽象背景替代具体场景）。", "标题缺少emoji情绪标记，在印尼市场点击率可能低于带emoji的同类作品。"]}
- jp: {"special_patterns": ["统一使用【日本語吹き替え】/【完結】前缀，明确配音和完结状态，提升信任度。", "封面精细度要求高，画面质感、光影、构图都需精致。", "常用日式视觉符号，如牢房铁栏、听筒、肖像画、闪电光环。", "文字精准，常用「正体判明」「全員絶句」「溺愛開始」等日式短语。", "互动性强，常使用投票型封面（如三个男性‘嘘’手势）。", "描述标签分层清晰：固定频道基线标签 + 当集题材尖刺标签。"], "special_antipatterns": ["画面粗糙、有廉价感，不符合日本观众对制作质量的期望。", "标题不标注「日本語吹き替え」，会降低本地用户点击意愿。"]}
- pt: {"special_patterns": ["标题和封面常围绕‘孕妇’、‘单亲妈妈’、‘破碎名表’等具体道具展开叙事。", "常用PT DUB或COMPLETO角标，强调完整观看体验。", "色彩偏好暖色调和豪华感（金、米白、棕）。"], "special_antipatterns": ["封面缺乏葡语市场特有的情感爆发力（如哭泣、愤怒）。", "符号使用不够直接，例如财富象征不如印尼市场那样极致夸张。"]}
- tr: {"special_patterns": ["标题内通常不放标签，标签全在描述区。", "封面文字极少，或仅使用身份/反转词如‘Gerçek Varis’、‘CEO Kurtardı’。", "善用天气元素（雨夜、雪地）增强情绪氛围。", "常用结婚证、枪、轮椅等高冲突密度道具。"], "special_antipatterns": ["在标题中堆砌大量#标签，破坏叙事流畅性，不符合当地习惯。", "emoji使用过度，土耳其市场偏好干净标题，极少使用emoji。"]}
- zh_tw: {"special_patterns": ["标题常用‘殊不知’、‘岂料’、‘竟是’等文言反转词，封面需可视化‘隐藏身份’。", "男频封面强调体型与气场压制（如恶霸vs普通小伙），女频强调肢体亲密与保护感。", "封面文字极少用，若用则为极简核心词如‘逆袭’、‘复仇’。", "善用奇观元素（如古战场炒饭）制造跨时空冲突感。", "几乎所有标题都会使用emoji，多放开头和结尾强化情绪。"], "special_antipatterns": ["封面风格过于接


## 封面指南

**⚠️ Vision模型prompt复杂度上限**：doubao/ark-code-latest 和 mimo-v2.5 能稳定处理的prompt约600-800字符输出JSON。超过此限JSON截断/格式错误率显著升高，LLM会倾向返回"学过的"旧格式。设计封面分析prompt时，优先保持简洁。复杂输出（如"复现prompt"80-120词、诊断评分7维、hook_type归类）应作为独立调用或后处理，不要塞进同一个prompt。

**composition**：核心构图原则是‘对比与聚焦’。优先使用‘左右/前后对比构图’（展示身份冲突）或‘中心三角/放射构图’（聚焦主角或关键冲突）。关系题材用双人紧密构图（拥抱、对峙），男频打脸用主角居中+背景压迫构图。景别以中景和中近景为主，确保人物表情和关键道具清晰可见。

**figures**：人物数量宜精不宜多，2-4人为主。必须有明确的主次关系：主角（受害者/逆袭者）与反派/旁观者。人物表情必须‘外露’且匹配情绪：震惊、含泪、愤怒、得意、冷漠、甜蜜。肢体语言要服务于关系叙事：保护、推离、跪求、依偎、对峙。

**colors**：运用色彩情绪编码：浪漫甜宠用暖金、粉、柔光；复仇、权力冲突用红黑、冷蓝金、强对比；奇幻、系统、男频用高饱和金色能量、闪电蓝、火焰红、深蓝背景。核心技巧：用环境色（冷）与人物光（暖）制造对比，让人物从背景中‘跳’出来。

**emotion**：封面情绪的核心是‘张力’，而非单纯的美。必须至少包含一种可命名的强烈情绪：背叛的震惊、被保护的安心、复仇的决绝、发现的惊喜、危险的压迫。情绪要通过表情、姿态、光影和场景共同营造。避免无情绪的静态摆拍。

**visual_symbols**：建立符号库并快速调用：身份类（西装、工装、豪门徽章）、情感类（婚戒、离婚协议、泪痕）、权力类（王座、龙纹、保镖）、冲突类（枪、破碎物、雨夜）、逆袭类（金光、闪电、系统面板）。符号要清晰、辨识度高，且在手机缩略图上可见。

**text**：封面文字是‘钩子的钩子’，应极简。建议不超过5-7个词（或3-5个中日韩字）。只提炼最核心的承诺或情绪词，如‘Secret CEO’、‘Reborn’、‘TRAICIÓN’、‘正体判明’。文字颜色需高对比，位置不遮挡关键表情和动作。不要将长标题复制到封面。


## 标签策略

**universal_rules**：
- 标签的核心功能是‘告诉算法和观众这是什么内容’，需围绕‘题材 + 情绪 + 格式 + 语言/文化’四层搭建。
- 标题标签少而精（1-5个），用于定义核心题材；描述标签多而广（10-20个），用于扩展搜索流量和细分受众。
- 大小写标签可共存但需有策略，标题用一种，描述可保留系统识别的不同形态。
- 定期更新标签库，关注新兴题材标签（如AI、心声、系统），但要确保与视频内容实质相关。

**title_tags**：
- #ceolovestory
- #cdrama
- #drama
- #minidrama
- #dramachino
- #短編ドラマ
- #逆襲
- #短劇

**description_tags**：
- shortdrama
- chinesedrama
- ceo
- romance
- love
- revenge
- engsub
- kdrama
- amor
- drama
- cinta
- dramachinês
- Короткая драма
- shortfilms

**combination_pattern**：采用‘基线标签 + 尖刺标签’组合模式。基线标签是每个视频固定使用的频道/品类标签（如 #shortdrama, #minidrama）。尖刺标签是根据当集剧情特化的题材和情绪标签（如 #cinderella, #reborn, #revenge）。在此之上，叠加跨文化截流标签（如 cdrama, kdrama）和语言标签（如 engsub, español）。

**by_language**：
- en: {"title_tags": ["#ceolovestory", "#drama", "#LOVE", "#minidrama"], "description_tags": ["shortdrama", "ceo", "cinderella", "romantic", "engsub", "kdrama", "romance", "revenge", "usa"]}
- es: {"title_tags": ["#dramachino", "#cdrama", "#amor", "#drama"], "description_tags": ["amor", "peliculacompleta", "drama", "kdrama", "romance", "ceo", "español", "artesmarciales", "Venganzafemenina"]}
- id: {"title_tags": ["#Full", "#Minidrama", "#drama", "#cdrama"], "description_tags": ["drama", "ceo", "filmcina", "cinta", "chinesedrama", "drakor", "romansa", "dracin", "dramapendek"]}
- jp: {"title_tags": ["#短編ドラマ", "#中国ドラマ", "#全話", "#日本語吹き替え"], "description_tags": ["短編ドラマ", "ショートドラマ", "逆襲", "中国ドラマ", "全話フル", "ラブコメ", "復讐", "溺愛婚", "電撃婚"]}
- pt: {"title_tags": ["#dorama", "#Reviravolta"], "description_tags": ["drama", "Romance", "Amor", "FilmeCompleto", "CEO", "dramachinês", "Vingança", "DoramaDublado", "Português"]}
- tr: {"title_tags": [], "description_tags": ["MiniDizi", "TürkçeDublaj", "KısaDizi", "RomantikDizi", "AşkDizisi", "CEO", "Cinderella", "Cdrama", "Kdrama"]}
- zh_tw: {"title_tags": ["#逆襲", "#短劇", "#爽劇", "#甜寵"], "description_tags": ["短劇", "霸總", "ChineseDrama", "追妻火葬場", "大陸短劇", "短劇全集", "重生", "穿越"]}


## 发布时间策略

**best_hours_utc**：
- 10
- 12
- 15
- 16
- 14

**best_weekdays**：
- Wednesday
- Thursday
- Friday

**rules**：
- 核心规律是覆盖目标市场观众的‘下班/放学后’和‘睡前’浏览时段。UTC时间换算为各语言市场当地时间后，应落在傍晚到夜间。
- 周三至周五是发布重点内容的黄金期，为周末追剧积累推荐信号。周末可复用或测试内容。
- 保持固定的更新节奏比偶尔选对‘完美时间’更重要，有助于培养观众期待和算法识别。
- 同一题材的内容应在相似时间段发布，避免将题材效果误判为时间效果。

**by_language**：
- en: {"best_hours": [10, 12, 15, 16], "best_weekdays": ["Thursday", "Friday", "Wednesday"]}
- es: {"best_hours": [16, 14, 12, 21], "best_weekdays": ["Thursday", "Friday", "Wednesday"]}
- id: {"best_hours": [10, 11, 12, 4], "best_weekdays": ["Friday", "Thursday", "Wednesday"]}
- jp: {"best_hours": [11, 10, 9, 8, 22], "best_weekdays": ["Thursday", "Friday", "Wednesday"]}
- pt: {"best_hours": [15, 14, 18, 13], "best_weekdays": ["Friday", "Wednesday", "Thursday"]}
- tr: {"best_hours": [15, 12, 10, 14], "best_weekdays": ["Friday", "Thursday", "Wednesday"]}
- zh_tw: {"best_hours": [9, 10, 11, 14], "best_weekdays": ["Wednesday", "Thursday", "Friday"]}


## 描述模板

**structure**：高播放描述遵循‘钩子前置，信任构建，流量沉淀’结构。首两行（移动端可见部分）必须包含剧情钩子或核心承诺，而非订阅链接。中间部分简要补充剧情或频道定位。结尾固定区域用于标签矩阵、订阅引导和社交媒体链接。

**template_types**：
- **剧情简介型**：用1-2句话复述并扩展标题的核心冲突和反转，聚焦‘谁受伤、谁反转、谁后悔’。
- **频道欢迎/定位型**：开头说明频道内容属性（如‘日本语吹替中国短剧’、‘Dramas Curtos Dublados em Português’），再接剧情简介或标签。
- **合规声明型**：开头提示‘Viewer discretion advised’或‘This content is fictional’，再进入剧情简介。
- **多语言/完整版导流型**：强调‘FULL’、‘Multi SUB’、‘PT DUB’、‘完结’等观看属性，并附上平台或合集链接。

**rules**：
- 描述前两行是黄金位置，必须放置最核心的剧情承诺或内容定位，不要被订阅链接或冗长欢迎语占据。
- 剧情简介要克制，讲清核心矛盾即可，不要剧透所有反转。
- 订阅和引导语放在剧情简介之后，逻辑上是‘看完简介感兴趣 -> 引导订阅看更多’。
- 标签是描述的‘尾部引擎’，按语义分组（题材、情绪、格式、语言），不要无序堆砌。


## 竞品频道深度分析工作流

### 日常追踪流程

1. **每日采集**：从YouTube采集最新频道数据，更新频道列表和基础指标（订阅数、视频数、层级划分）
2. **筛选新频道**：每个语种优先选择未分析过的新频道，累计到330个总池
3. **每日深度分析**：从新频道中选取5个（覆盖不同语种和层级）进行深度分析，输出：
   - 频道基础信息（ID、名称、订阅、层级）
   - 题材标签和标题模式总结
   - 播放量分布（平均、最高）
   - 增长原因分析
   - 热门标题示例
   - 标签策略总结
4. **数据存储**：分析结果存入 `data/competitor_insights/channel_{channel_id}.json`，总索引存入 `_analyzed_channels.json`
5. **生成日报**：整理最新5个频道分析结果，输出结构化报告

### ⚠️ distill_competitors.py 行为说明

脚本分三步：①五层筛选（filter_by_tier）→ ②每日追踪（track_daily，记录订阅+播放量）→ ③深度分析（只分析未在tracker中的新频道）。

**当所有频道都已分析过时**，脚本输出"所有筛选频道都已分析过，只做追踪"，不会触发新的深度分析。此时仍会执行筛选和追踪（更新面板数据），但不会有新的 `channel_*.json` 产生。

**数据结构参考**（2026-07实测）：
- `data/competitor_data/latest.json`：**list**（非dict），每条含 `channel_id, name, language, subscribers, tier, collected_at, video_count, avg_views, videos[], country, is_drama`
- `data/competitor_insights/channel_{id}.json`：每条含 `channel_id, name, language, subscribers, tier, url, total_videos, growth_reasons[], video_analysis{total_videos, breakout_count, sample_titles, top_videos, avg_views}, content_tags[], deep_analysis{}, videos_detail[], analysis_text[], thumbnail_url, analyzed_at, avg_views, top_covers[]`
- 注意：insight文件用 `videos_detail`（非 `videos`），`video_analysis.top_videos` 用于播放量排序

### 层级划分标准

- `顶级`：订阅 > 1,000,000
- `头部`：100,000 < 订阅 ≤ 1,000,000
- `中部`：10,000 < 订阅 ≤ 100,000
- `起步`：1,000 < 订阅 ≤ 10,000
- `新号`：订阅 ≤ 1,000

### 最新观察（2026-06）

- **印尼市场**：新号几乎全部主打霸总题材，emoji在标题开头标记情绪的做法开始流行，能有效提升点击率
- **日语市场**：已经形成成熟的套路：统一「【日本語吹き替え】」前缀，标签体系固定为「基线标签 + 尖刺标签」，题材分化明显——男频偏复仇逆袭，女频偏霸总甜宠
- **霸总题材**：在所有市场都是基本盘，印尼新号30个视频稳定布局，标签策略围绕 `Pembalikan`（反转）、`CEO`、`cinta`（爱情）重复强化
- **标题长度**：印尼市场平均标题长度约80-90字符，日语约70字符，均符合之前总结的跨语言规律

## Schema 文档（脱敏数据说明）

当需要向外部读者/审阅AI说明"系统用了什么数据"但又不暴露真实数据时，参照以下格式产出 schema 文档：

```
docs/data-schemas/
├── channel_diagnosis.schema.md      诊断JSON字段说明+脱敏样本
├── channel_analytics.schema.md      YT Analytics采集字段
├── channel_snapshot.schema.md       每周快照结构
├── ctr_reports.schema.md            Reporting API字段
├── retention.schema.md              留存曲线数据结构
├── distill.schema.md                蒸馏数据结构（每语种）
├── competitor.schema.md             竞品数据
└── proposal_history.schema.md       上架历史
```

**编写规则**：
- 每个 md 包含：数据来源（哪个API/脚本产出）、字段名+类型+含义、脱敏样本（1条JSON，video_id→VID_xxx，标题→示例，播放数→0）
- 脱敏变换：频道名→CHANNEL_A，视频ID→VID_001，标题→"示例标题（已脱敏）"，播放数→0，订阅数→0
- 保留字段结构、嵌套层级、字段名称，只替换数值和标识符
- 不包含 API keys、OAuth 凭证、真实 token 信息

## 增长策略

**universal**：
- 建立内容矩阵：明确主线题材（如CEO甜宠、重生复仇）和辅助/测试题材（如系统、萌宝），用不同封面风格区分受众。
- 每个视频至少设计一个主钩子和一个辅助钩子，形成‘钩子组合’，提供更丰富的点击理由。
- 封面制作前，先明确‘观众为什么会点击（好奇/愤怒/期待）’，再决定人物动作和道具。
- 实施A/B测试：同一内容测试不同标题钩子顺序（先写伤害还是身份）和封面风格（对峙型/亲密型/证据型）。
- 描述模板化以节省精力，创新资源集中在标题、封面和开头3秒。
- 利用‘完结’、‘全集’、‘配音’等词汇降低观众的观看门槛，提升信任感。
- 将爆款内容的‘故事骨架’（如低位受辱-隐藏身份-瞬间打脸）系列化复用，替换细节以保持新鲜感。

**by_language**：
- en: 用A/B思路测试同一素材的不同包装：身份反差版、关系背叛版、重生复仇版。, 标题先写完整故事承诺，再加格式词和标签，避免[FULL]等占据信息位。, 定期发布高频内容维持推荐，并积极回复评论以增强粘性。
- es: 建立三条稳定内容线：女频CEO甜虐、女频复仇重生、男频隐藏强者。, 用完结、配音、完整电影化描述提升信任感。, 复用高播放封面的视觉骨架（对峙、跪地、保护），但创新人物关系和场景。
- id: 频道初期先专注一个类型（CEO女频或战神男频）建立清晰算法标签。, 每周固定复用3类高验证钩子，只测试1类新兴钩子。, 描述区固定加入订阅链接和语种标签，将爆款流量沉淀为频道资产。
- jp: 建立固定标题前缀体系（如【日本語吹き替え】、【完結】）。, 内容排期采用‘女频关系爽剧为主，男频/萌宝为爆点插针’的结构。, 评论区引导需围绕具体钩子提问（如‘家族を許せる？’）。
- pt: 建立三条稳定线：CEO甜宠线、怀孕/单亲妈妈线、复仇打脸线。, 每周保留1-2条新兴钩子测试。, 对女频主线使用固定PT DUB角标、统一色调和稳定标签组合，建立剧场感。
- tr: 频道名包含‘kısa drama’或‘MiniDizi’，便于观众识别。, 积极使用Cdrama/Kdrama标签截取跨文化流量。, 每条描述必须包含剧情简介（显著提升均播）。, 封面建立道具库（结婚证、枪、轮椅等），按钩子快速组合。
- zh_tw: 双语运营：同时制作繁中+印尼/英文版本，利用多语言字幕覆盖多圈层。, 演員標籤截流：在描述中植入高播放演员名字。, 建立双栏内容池：男频（神医、战神、至尊）与女频（绝嗣总裁、带球跑、追妻）分开。


## 反模式黑名单

**cover**：
- 静态美图：只有人物颜值高但没有动态、冲突、表情或道具支撑，无法传递故事。
- 信息过载：人物>5人，文字过多，符号堆砌，导致手机端缩略图无法识别核心。
- 风格与标题背离：封面风格（如甜美、古风）与标题暗示的题材（如现代复仇、系统）不符。
- 关键证据缺失：标题承诺了身份（CEO）、能力（神医）或事件（背叛），封面无任何视觉证据。

**tags**：
- 标题标签过多：在标题正文中插入大量#标签，破坏句子流畅性和可读性。
- 标签与内容无关：使用与视频实质内容不相关的热门标签，会招致算法惩罚。
- 描述标签无序堆砌：标签之间没有逻辑关系，只是随机罗列，不利于算法识别。
- 忽略语言/文化标签：未使用目标市场的语言标签（如 español、日本語字幕）或文化截流标签（如 cdrama）。


## 外部仓库同步（yt-drama-ops）

**仓库**：`github.com/liuxigreen/yt-drama-ops`（SSH: `git@github.com:liuxigreen/yt-drama-ops.git`）

**关系**：本skill（short-drama-localhost.localdomain 3.1.0）是唯一母本。yt-drama-ops 是对外发布的 skill 包，内容是母本的投影。改知识只改母本，然后同步到外部仓库。

**仓库结构**：
```
yt-drama-ops/
├── skills/
│   ├── channel-diagnosis/    # 频道诊断（SKILL.md + references/{quadrant,retention,degradation}.md）
│   ├── video-optimization/   # 单视频优化（SKILL.md + references/{hooks,covers}.md）
│   ├── publishing/           # 上架策略（SKILL.md + references/{tags,timing,description}.md）
│   └── persona/              # 人格层（SKILL.md）
├── knowledge/{lessons,validated,pending}.md  # 学习回路
├── references/short-drama-youtube-3.1.md     # 母本完整副本（需手动同步）
├── references/cover-prompt-guide.md          # 封面生图prompt指南（四层结构）
├── examples/                 # 3个使用示例
├── templates/report-template.md
└── scripts/scrape-channel.sh
```

**同步检查清单**（母本改概念时必须遍历）：

| 母本改动 | 需同步的外部文件 |
|---------|----------------|
| 骨架公式 | `skills/video-optimization/references/hooks.md` |
| 钩子体系 | `skills/video-optimization/references/hooks.md` + `skills/publishing/SKILL.md`（钩子引用）+ `skills/video-optimization/SKILL.md` |
| 封面规则/模板卡 | `skills/video-optimization/references/covers.md` + `skills/channel-diagnosis/SKILL.md`（步骤3/9）+ `knowledge/validated.md` |
| 标签策略 | `skills/publishing/references/tags.md` |
| 发布时间 | `skills/publishing/references/timing.md` |
| 诊断标准/阈值 | `skills/channel-diagnosis/SKILL.md` + `skills/channel-diagnosis/references/quadrant.md` |
| 任何数据结论 | `knowledge/validated.md`（证据等级） |
| 母本版本号 | `references/short-drama-youtube-3.1.md`（完整副本） |

**⚠️ 概念残留陷阱**：同一个概念（如"面部60%"）会散布在5-6个文件中（SKILL.md、references/covers.md、channel-diagnosis步骤3/9、validated.md）。改母本时必须 grep 整个外部仓库找所有残留引用，不能只改一处。2026-07-12 实测：修了2处后又发现3处残留。

**⚠️ 同步执行顺序**：①先改母本 → ②grep外部仓库找所有变体引用（不只精确匹配，还要搜同义词如"面部特写"/"face"/"60%"） → ③逐个文件patch → ④更新CHANGELOG → ⑤commit+push。不要"先改一处看看反馈"再改其他处——用户期望一次修完。

**⚠️ SSH推送**：yt-drama-ops 用 SSH 推送（`git@github.com:liuxigreen/yt-drama-ops.git`），VPS 上有 `~/.ssh/id_ed25519`。clone 后需 `git remote set-url origin git@github.com:...` 切换到 SSH。

## 增量频道诊断引擎

### 执行流程

增量频道诊断是日常频道运营中每周/每日执行的质量检查流程：

```
1. 加载频道最新快照（已自动生成每日快照脚本）
2. 识别新增视频（跳过已诊断视频，只增量处理）
3. 补全缺失封面分析（调用MiMo封面分析API）
4. 对新增视频逐题打分（标题长度+钩子词+标签+发布时间+互动）
5. LLM深度分析：钩子强度评估+标题优化+封面协同评估
6. 频道级综合健康评分 + 输出问题列表 + 战略建议
7. 保存诊断结果到 data/own/channel_diagnosis/{name}_latest.json
```

## ⚠️ 四象限分类 v1.1 更新（2026-07-12）

**标题超卖分型改为hook_1pct**：旧版按AVD分开头型(<10%)/中段型(10-15%)——AVD低只说明流失严重，定位不了流失段。新版：
- hook_1pct < 80% → 开头型 → 行动：重剪前30秒cold open
- hook_1pct ≥ 80% → 中段型 → 行动：每3-5分钟加re-engagement hook，或压缩时长
- B/C档无留存数据 → 只标"标题超卖（未分型）"，禁止猜

**新增"数据异常待核实"桶**：hook_1pct < 5%的视频不进任何象限（尤其禁止进选题失败），在报告末尾单独列出。留存1%不是选题问题，是事故。

**CTR阈值统一为6/2.5**：全文统一——>6%健康，2.5-6%观察区，<2.5%预警，<1.5%严重预警。旧8%仅保留为"标杆"级别。此阈值来自1-2小时超长短剧基线，短视频频道需自行校准。

## 新题材协议（2026-07-12）

当检测到频道题材不在已验证范围内（如民国谍战、赛博朋克、丧尸、电竞等）时：

### 数据层（不降级）
- 四象限归类、瓶颈定位、订阅转化、发布节奏等数据层诊断照常运行，不受题材影响
- CTR/AVD/留存是物理指标，题材无关，结论置信不降

### 内容层（显式降置信）
- 封面/标题/标签建议必须显式声明："该题材未入库已验证数据，以下为通用模板卡 + 最近邻题材（注明借用哪个）的迁移推断，置信有限。"
- 封面符号：从通用模板卡出发，借用最相似的已验证题材符号（如"谍战"借"复仇/打脸"的冷色调+对峙构图），明确标注借源
- 标题句式：用通用骨架+反转词，题材行话由用户补充

### 自动建档
- 在 `knowledge/pending.md` 自动创建该题材条目
- 2-3轮CTR数据回流后：有效假设进 `validated.md`，失效进 `lessons.md`
- 同一题材被验证≥3次 → 提示写入母本 genre-symbols 映射表，题材从盲区转正

### 禁止项
- 禁止在无验证数据时给出高置信的题材特定建议
- 禁止跳过 pending.md 建档
- 禁止用训练语料中的印象代替真实数据

## 常见问题模式（跨语言验证）

按出现频率排序：

1. **3分钟留存率极低**：1%留存很高（90-98%）说明开头hook好，但3分钟留存骤降到15-20%——中段剧情拖沓、节奏崩塌，缺乏连续钩子拉住观众。**修复策略**：每3分钟必须安排一个小反转或小冲突，避免大段叙事无起伏。

2. **赞率过低**：赞率<1%在短剧品类都是不健康区间，赞率低说明内容未激发足够情绪共鸣或互动意愿，会影响算法推荐池扩大。**修复策略**：标题必须明确承诺情绪终点（"后悔"、"打脸"、"跪求"），封面必须定格最高张力瞬间，让观众看完后有表达情绪的冲动。

3. **爆款依赖严重**：头部3条视频贡献>60-75%总播放，其余视频播放极低——频道抗风险能力弱，爆款过期后迅速沉寂。**修复策略**：建立稳定题材矩阵，每个题材固定3-5个高验证钩子模式，持续测试新题材但保证基本盘稳定输出。

4. **系列化运营缺失**：标题中无Part/Episode/全集等系列标记，无法形成追剧心理，难以沉淀订阅和回访。**修复策略**：每部长剧拆分系列化更新，标题统一前缀如`Part 1/3: `，描述固定链接到下一集。

5. **标题钩子组合不全**：多数视频只有单一钩子（仅情绪/仅身份），缺乏至少两种钩子组合（情绪+反转、身份+关系），点击率无法突破。**修复策略**：强制每个标题至少组合两种钩子，常见最强配对：`identity + reversal`，`emotion + identity`，`relationship + reversal`。

6. **封面文字质量极低**：封面文字过多或过少，或者文字无法提炼核心钩子，降低视觉转化。**修复策略**：封面文字仅保留1-3个核心词（如"CEO"、"Reborn"、"TRAICIÓN"），放在边角不遮挡人物，文字对比要足够高，手机缩略图能一眼识别。

7. **SEO/搜索流量极低**：搜索流量占比<5%（健康门槛>15-20%），未能主动获取精准流量。**修复策略**：描述标签严格执行"基线标签 + 尖刺标签"模式，每条视频固定5个基线标签（品类+语言）+ 3-5个尖刺标签（当集剧情题材）。

### ⚠️ YouTube频道改名导致数据管道断裂（2026-07-10）

当YouTube频道在平台上改名时（如 Luna Drama Estudio → Macarons Drama），以下文件/目录全部失效：

1. **`our_channels.json` 注册表** — 频道名不匹配新名字
2. **`channel_analysis_latest.json`** — API按名字匹配诊断，找不到就跳过
3. **`channel_diagnosis/` 目录** — 诊断文件名用旧名字，面板找不到
4. **`channel_snapshots/` 目录** — 快照文件名用旧名字

**修复步骤**：
```bash
# 1. 更新注册表
python3 -c "
import json
fp = 'data/own/our_channels.json'
d = json.load(open(fp))
for ch in d['channels']:
    if ch['channel_id'] == '<NEW_CHANNEL_ID>':
        ch['name'] = '<New Name>'
json.dump(d, open(fp, 'w'), indent=2, ensure_ascii=False)
"

# 2. 重命名诊断文件
cd data/own/channel_diagnosis/
for f in Old_Name_*.json; do
    mv "$f" "$(echo $f | sed 's/Old_Name/New_Name/')"
done

# 3. 删除旧快照，重新跑快照
rm data/own/channel_snapshots/Old_Name_*.json
python3 scripts/channel_weekly_snapshot.py
```

**根因**：`_api_channel_analysis()` 遍历 `channels` 列表按名字查找诊断文件。名字不匹配→诊断丢失→面板显示空白。

### 健康度评分标准

| 分数区间 | 等级 | 含义 |
|---------|------|------|
| 8-10 | A | 优秀，策略正确，维持即可 |
| 7-7.9 | B+ | 良好，少量问题可优化 |
| 6-6.9 | B | 中等，存在2-3个关键问题需解决 |
| 5-5.9 | C+ | 一般，存在多个问题影响增长 |
| 4-4.9 | C | 不佳，多个核心问题需整改 |
| <4 | D | 很差，冷启动停滞或增长完全停止 |

### 健康度分级建议

- **A/B+**：维持更新节奏，持续小步测试新钩子/新题材
- **B/C+**：优先解决1-2个最高优先级问题（如赞率、爆款依赖），每批次优化3-5条低分视频
- **C及以下**：冷启动阶段建议重新梳理题材聚焦，严格执行系列化+标签优化，高频更新刺激算法重新评估

### 执行注意事项

- **推荐使用 `--all` 而非逐个指定频道名**：`diagnose_channel.py` 的 `--all` 参数已从 `our_channels.json` 注册表自动遍历所有频道，自动覆盖新增频道（如 Beer Anime）。修改 cron prompt 时应统一用 `--all`，而非硬编码频道列表。
- **推荐使用 `--all` 而非逐个指定频道名**：`diagnose_channel.py` 的 `--all` 参数已从 `our_channels.json` 注册表自动遍历所有频道，自动覆盖新增频道（如 Beer Anime）。修改 cron prompt 时应统一用 `--all`，而非硬编码频道列表。
- 脚本参数：使用 `--channel` 参数（频道名，非 slug），或直接用 `--all`。频道名映射：
  - 追劇姐妹 → hk/繁中
  - Apocalyptic Films → en_global/en
  - DramaCipher → id/印尼
  - Luna Drama Estudio → es_latam/西语
  - DramaVerve → br/葡萄牙
  - Moonlit Drama Studio → en_moonlit/en
  - Beer Anime → en_beeranime/en
- **`--slug` 参数不存在**：脚本只支持 `--channel` 和 `--all`。cron prompt 中用 `--slug` 会被 LLM 自行纠错，参数不可控且遗漏新频道。务必用 `--all`。
- 常见API问题：封面分析可能返回401 Unauthorized（token过期），不影响整体诊断，仅缺失单条封面数据；频道级战略诊断可能超时或服务不可用，保留已有诊断即可。
- **`--slug` 参数不存在**：脚本只支持 `--channel` 和 `--all`。cron prompt 中用 `--slug` 会被 LLM 自行纠错，参数不可控且遗漏新频道。务必用 `--all`。
- 常见API问题：封面分析可能返回401 Unauthorized（token过期），不影响整体诊断，仅缺失单条封面数据；频道级战略诊断可能超时或服务不可用，保留已有诊断即可。
- 增量执行：仅处理新增视频，跳过已分析内容，节省LLM成本和时间。

---

## 诚实边界

**data_sources**：以上规则提炼自7个语言市场（EN, ES, ID, JP, PT, TR, ZH_TW）的YouTube短剧频道封面、标题、标签、描述、发布时间及增长策略的原始样本数据。

**sample_sizes**：
- en: 中等偏上，覆盖了主流CEO、甜宠、重生题材，样本多样性较好。
- es: 中等，数据集中在女频情感和复仇题材。
- id: 较大，样本丰富，尤其女频和男频打脸题材。
- jp: 中等，对封面质感和精细度的分析有较好支撑。
- pt: 中等，数据涵盖了葡语市场的核心题材。
- tr: 中等偏小，但样本在关键指标（如封面情绪、发布时间）上趋势明显。
- zh_tw: 中等，样本在繁中市场的特定题材（如追妻火葬场、绝嗣总裁）上具有代表性。

**limitations**：
- 所有结论均为基于成功/高播放样本的归纳，不代表所有做法都适用于任何起步阶段的频道。
- 各语言市场的样本量不均，部分结论（如某些特殊反模式）的普遍性可能受限。
- 数据主要反映YouTube平台特性，直接迁移至TikTok、Instagram等平台需重新测试。
- 平台算法持续更新，过往有效的策略（如标签数量）未来可能失效。
- 增长策略部分包含经验推测，尤其是关于‘固定节奏’和‘系列化’的长期价值，缺乏严格的A/B测试数据支撑。
- 封面协同的分析基于人工观察归纳的模式，未能量化每种封面元素的具体点击率贡献。


## 原理（Why）

### title

- **身份落差必须绑定反转时刻，单纯身份标签无效**
  心理：人类大脑对'预期违背'高度敏感：当底层身份与顶层身份同时出现，认知冲突瞬间激活好奇心和补偿期待。7个语言市场均验证——观众点击的不是CEO/富豪本身，而是想看轻视者被打脸那一秒。身份落差越大，蔡格尼克效应越强（未完成的打脸悬念驱动点击）。
  应用：标题前半句放低位误判（poor/kurye/配達員/工地小夥/圣职/faxineira/fakir/gerçek mirasçı），后半句用反转词（but/Tak disangka/豈料/ternyata/mas/Ancak/كان يبدو）揭开高位身份（CEO/billionaire/隐世至尊/Dewa Perang/mafya patronu/神医）。后半句必须附带碾压结果（跪地求饶/后悔/şoke oldu/所有人后悔/大炎上）。反例：只写'CEO爱上女孩'——没有误判，缺乏认知冲突。
  验证：en, es, id, jp, pt, tr, 繁中
- **情绪伤害必须先于补偿结果出现，愤怒是点击的第一燃料**
  心理：愤怒和心疼是最强的情绪启动器——观众需要先代入受害者视角产生'这太不公平了'的共情，才会期待复仇和补偿。如果标题直接写主角成功，情绪燃料不足，观众没有点击理由。心理学上的'公正世界信念'被打破时，人会产生强烈的修复冲动，点击就是寻找补偿的行为。
  应用：标题结构：【背叛/羞辱/抛弃/诬陷事件】→【补偿结果/身份曝光/对方后悔】。关系伤害词前置（cheating/Dikhianati/裏切る/traicionado/i̇hanet/被抛弃/譲渡），再用反转连接（but/Tak disangka/豈料/ところが/gerçeği öğrenince/mas）。至少覆盖7种语言市场。
  验证：en, es, id, jp, pt, tr, 繁中
- **反转词是标题的节奏开关，驱动未完成信息缺口**
  心理：Tak disangka/Ternyata/豈料/殊不知/Ancak/gerçeği öğrenince/hommes Şoke Oldu这些词在每个语言中都高频出现，本质是利用蔡格尼克效应——大脑对未完成信息有强迫性关注。反转词在标题中间制造一个'悬念断崖'，观众必须点击才能补完信息。
  应用：每个语言市场都有自己的反转按钮：英文用but/turns out/actually/unaware；西语用结果/inesperadamente；印尼用Tak disangka/Ternyata/Malah；日语用だが/ところが/実は/正体は；葡语用mas/e/até que；土耳其用.../Ancak/gerçeği öğrenince；繁中用岂料/怎料/殊不知/原来。必须在标题中段插入。
  验证：en, es, id, jp, pt, tr, 繁中
- **时间词将普通冲突升级为命运叙事**
  心理：10年/After 5 Years/重活一世/38岁/那一夜等时间词让观众自动赋予故事'长期亏欠'和'命运补偿'的深层含义。人脑对时间跨度有天然的损失厌恶——'付出X年却被背叛'比'最近被背叛'更能激发愤怒。重生/时间回溯则满足'如果能重来'的普遍幻想。
  应用：适合重生、久别重逢、旧爱后悔、绝嗣焦虑题材。用具体数字强化冲击（19岁vs38岁/5年/10年/一胎三宝/four years）。繁中市场time钩子均播61,433为全市场最高。结构：时间词放在冲突事件前或中段，形成'过去受伤—现在翻盘'的纵深。
  验证：en, es, jp, tr, 繁中
- **集体误判比个人误会更有点击势能**
  心理：todos riram/nobody ousa/所有人/全城默認/herkes şoke oldu/全員絶句等集体词把观众放进围观者位置。人类有强烈的'围观心理'——如果只是一个人看不起主角，反转只有一个人被打脸；如果是所有人看不起主角，打脸就是群体性事件，爽感倍增。同时满足补偿心理和旁观者安全距离。
  应用：标题中加入群体压力词：everyone mocked/todos riram/semua orang/全員/ninguém ousa/herkes/tous rirent。配合封面中围观人群、众人震惊表情、跪地群体。结果用'全員后悔/todos se arrepintieron/herkes şoke oldu/让所有人震惊'收尾。
  验证：en, es, id, jp, pt, tr, 繁中
- **被迫进入关系比主动恋爱更有点击势能**
  心理：闪婚/契约/替身/误婚/impulsivamente marry等设定天然包含三个高点击要素：①身份误判（对方不知道真实身份）②情感升温预期（假戏真做的期待）③阶层反转（原来对方是顶级强者）。主动恋爱缺乏信息差，被迫结合才有多层叙事空间。日语和繁中市场此趋势尤为明显。
  应用：标题用'被迫/To escape/escape/为逃婚姻'开头→中间写看似普通的配偶→结尾揭露对方真实身份。覆盖CEO甜宠、契约婚姻、先婚后爱、残疾CEO题材。日语用スピード結婚/契約結婚；繁中用绝嗣总裁+意外怀孕；英文用fake married/Impulsively married。
  验证：en, es, id, jp, pt, tr, 繁中
- **标题信息密度要高但因果链必须是单线推进**
  心理：7个语言市场的高播放标题均长60-90字符，说明用户接受较长标题。但高播放标题不是堆元素，而是形成'受辱/误判→真相/逆袭'的单线因果。多线叙事超过一条主线就会增加认知负荷，降低3秒判断效率。
  应用：用逗号/分号/省略号拆成两段：前段放冲突现场（谁被谁怎么了），后段放反转结果（然后怎样了）。土耳其市场尤其典型：标题用逗号串联3-4个情节节点。西语均长87字符，接受最高密度。结构模板：【低位+羞辱场景】+【反转词】+【高位身份+碾压结果】。
  验证：en, es, id, jp, pt, tr, 繁中
- **具体身份标签自带人设预期，是0.5秒归类捷径**
  心理：CEO=权力+财富+冷漠，kurye=卑微+善良+勤劳，配達員=底层+被看不起，faxineira=弱势+辛苦。每个标签在观众大脑中预装了一套人设剧本。使用泛化描述（有钱人/漂亮女孩）会让观众多花0.5秒理解，降低点击效率。具体标签+能力结果绑定才能加速点击。
  应用：优先使用具体职业/身份标签：英文CEO/billionaire/bartender/janitor；西语heredero/hija de multimillonario；印尼CEO/Dewa Perang/satpam/pengemis；日语社長/配達員/家政婦/農夫；葡语faxineira/taksici/gerçek mirasçı；土耳其mafya patronu/kurye/stajyer；繁中神医/战神/至尊/工地小伙。能力词要绑定结果：düşüncelerini okuyunca onu kraliçe gibi şımarttı。
  验证：en, es, id, jp, pt, tr, 繁中
- **情绪词必须指向具体观看回报，不能空喊**
  心理：观众看到'感人''甜蜜'不会点击，但看到'Mocked/Regrets/Begging/溺愛/後悔/跪地求饒/Şoke oldu/大炎上'会立即产生情绪预期。这些词不是形容词，而是情绪承诺——承诺观看后会获得特定情绪体验。日语市场尤为明显：甘やかす/溺愛/後悔/切り捨てる/大炎上都是情绪终点词。
  应用：每个标题至少包含一个明确的情绪终点：甜宠用'宠/甘やかす/溺愛/şımarttı/dimanjakan'；复仇用'后悔/悔断肠/跪地求饶/後悔/arrepentirse/son pişman'；反转用'震惊/大炎上/绝句/Şoke oldular/herkes dondu'。情绪词放在标题结尾，作为最后的点击触发器。
  验证：en, es, id, jp, tr, 繁中
### thumbnail

- **封面定格'冲突即将爆发或身份即将揭露'的那一秒，不要复述标题**
  心理：短剧用户滑动时给封面的时间不到1秒。能让人停下来的是'发生了大事'的视觉冲击——枪口、跪地、结婚证、破碎手表、围观人群。互补加工理论：标题负责'解释发生了什么'，封面负责'那一刻的样子'。两者分工才能最大化信息密度。
  应用：标题写'被赶出家门'→封面展示被CEO团队接走的结果；标题写'打碎CEO手表'→封面展示破碎手表+CEO质问；标题写'目睹杀人后被宠爱'→封面给枪和结婚证。封面选冲突峰值而非和解画面。7个语言市场均验证此原则。
  验证：en, es, id, jp, pt, tr, 繁中
- **对比构图比中心美照更适合复仇和打脸题材**
  心理：左右对立/前后对比/站立与跪地能让观众一眼看出'谁压迫谁、谁即将翻盘'——这个判断过程本身就是吸引力。单人精修照即使好看也缺乏叙事张力。但土耳其市场数据显示center构图在特定场景（身份揭露、英雄救美）均播38,645高于contrast，说明两种构图要根据钩子类型选择。
  应用：复仇、背叛、退婚用对比构图（左=施压者，右=受害者/隐藏强者，中间=导火索道具）；身份揭露、英雄救美、危险宠爱用center构图（核心冲突放画面几何中心）；甜宠用2人近景亲密构图。背景保持简洁，避免信息过载。
  验证：en, es, id, jp, pt, tr, 繁中
- **身份差必须有视觉锚点：服装、道具、场景符号化**
  心理：观众在3秒内无法理解抽象设定，必须通过衣服/场景/姿态/道具判断谁低位、谁高位、谁即将反转。人类对'符号'的理解比文字快3倍——西装团队=CEO权力，破衣=底层，直升机=极致财富，银针=神医，结婚证=婚姻反转。没有锚点的身份差只存在于标题中，封面无法证明。
  应用：高位符号：西装、保镖、豪宅、豪车、直升机、皇冠、军装、黑卡。低位符号：工装、出租车、外卖服、破衣、街头、医院、雨夜。每张封面固定1-2个身份锚点，放在视觉中心。不要只用人脸——道具比表情更有识别效率。
  验证：en, es, id, jp, pt, tr, 繁中
- **封面情绪必须与标题一致：暖色给溺爱，冷色给压迫，混合给反转**
  心理：土耳其市场数据显示冷色封面均播45,664是暖色的2.8倍——冷蓝/灰/黑与'未知/危险/深度'关联，触发探索欲。但甜宠题材必须用暖色（粉/金/暖橘）提供亲密感。如果标题讲复仇而封面只甜美，会削弱点击承诺，产生预期偏差。
  应用：虐恋/复仇/身份揭露用冷色基调（蓝黑雨夜、雪地、监狱冷白），用暖色点缀焦点（红结婚证、暖黄灯光）；甜宠/被宠用粉色、金色、暖橘；男频打脸用黑金红。封面与标题情绪对齐，不要跨情绪错配。
  验证：en, es, id, jp, tr
- **封面文字要少而强，只提炼一个核心视觉词**
  心理：封面文字和画面应该互补不重复。标题已说清'她被赶出家门'，封面再只写'赶出家门'是信息浪费。更好的做法是封面放2-4个最强词（CEO/MILIARDER/正体判明/DIHINA/DEWA PERANG），配合视觉证据强化身份反差。过多文字会遮挡画面核心冲突。
  应用：封面角标放1个核心标签词或质量信号（CEO、FULL、PT DUB、INDO DUB、正体判明、绝对总裁）。文字放在画面边角，不要遮挡人物表情和肢体冲突。男频封面可放系统界面/光效等视觉化能力来源。
  验证：en, es, id, jp, pt, tr, 繁中
### tag

- **标题标签少而准，描述标签多而分层**
  心理：标题标签影响第一印象，过多显得廉价；描述标签承担搜索和推荐语义扩展。观众通过#drama/#cdrama/#短編ドラマ/#MiniDizi快速判断内容类型和语言适配性，然后通过描述标签中的题材词决定是否匹配兴趣。两层标签分工不同，不能互相替代。
  应用：标题保留1-3个强识别标签（英文#ceolovestory/#drama；西语#dramachino/#cdrama/#amor；印尼#Full/#Minidrama；日语#中国ドラマ/#短編ドラマ/#日本語吹き替え；葡语#dorama；土耳其无标题内嵌标签；繁中#逆袭/#短剧/#甜宠）。描述按'题材核心+情绪类型+语言版本+平台格式'组合扩展。
  验证：en, es, id, jp, pt, tr, 繁中
- **语种适配标签是降低点击犹豫的信任信号**
  心理：ENG DUB/ENG SUB/IndoSub/日本語吹き替え/PT DUB/TürkçeDublaj/繁中字幕等标签的核心功能不是SEO，而是降低语言理解门槛。用户看到这些词会确认'我能看懂'，从而降低点击犹豫。FULL/完整版/全集则承诺'一次看完，不用等更新'，降低完播风险预期。
  应用：配音版本用【INDO DUB】【PT DUB】【ENG DUB】【日本語吹き替え】【TürkçeDublaj】；字幕版本用【ENG SUB】【IndoSub】【日本語字幕】；完整版用【FULL】【完整版】【全集】【FilmeCompleto】。放在标题前缀或描述首行，但核心钩子必须紧随其后。
  验证：en, es, id, jp, pt, tr, 繁中
- **题材标签成组出现比单个宽泛词更有效**
  心理：推荐系统更容易识别稳定内容簇。ceo+shortdrama+romantic比单个drama更明确，能提高搜索可见性和同类推荐匹配度。土耳其和日语市场数据显示算法更偏好稳定语义簇，而不是每条视频随意换一批标签。
  应用：每条视频描述标签按组合铺设：女频用ceo+romantic+shortdrama+revenge或amor+drama+ceo+cenicienta；男频用action+reborn+system+drama。建立固定的标签底座（平台词+语种词），每条视频更换剧情词和情绪词。不要堆无关热词。
  验证：en, es, id, jp, pt, tr, 繁中
- **跨剧种热词可截流，但不能替代本地语言标签**
  心理：Cdrama/ChineseDrama/Kdrama/KoreanDrama等标签在土耳其、葡语、西语市场均表现突出，说明用户会通过亚洲剧种心智进入内容。但标题和核心标签仍需本地语言承接，否则观众会因语言不匹配而流失。
  应用：描述标签组合使用：英文用shortdrama+chinesedrama+ceo+engsub；西语用dramachino+cdrama+kdrama+amor+peliculacompleta；印尼用drama+filmcina+chinesedrama+dracin；日语用中国ドラマ+短編ドラマ+職場ドラマ；葡语用doramas+Kdrama+cdrama+dramachinês；土耳其用Cdrama+ChineseDrama+Türkçe+MiniDizi。标题保持本地语言。
  验证：en, es, id, jp, pt, tr, 繁中
- **趋势标签截流热点，但必须与内容高度相关**
  心理：viralvideo/relationshipgoals等趋势标签能让视频出现在趋势页面，吸引泛娱乐观众。但无关标签会降低推荐精准度，平台算法会惩罚标签与内容不匹配的视频。地域标签（usa/uk/canada）可帮助进入英语受众池。
  应用：监控当前趋势标签如viralvideo、relationshipgoals并谨慎添加。地域标签适合英文配音/英文字幕/欧美题材包装的视频。描述中可加入usa、unitedstates、uk、canada、australia。但不要堆满，保持1-3个相关趋势词即可。
  验证：en, es, id


## 故事模板（What）

### 隐藏身份即时打脸

**模板**：所有人嘲笑/欺负【低位身份主角】，殊不知他/她其实是【隐藏高位身份】，一出手/一揭露让所有欺辱者当场跪地/后悔/破产。
**为什么有效**：它把羞辱、身份误判和打脸兑现压缩在一句话里。认知落差越大（破衣少年=至尊仙医，乞丐=世界首富），蔡格尼克效应越强，观众必须点击才能看到打脸那一刻。7个语言市场验证：identity钩子在繁中均播50,129、土耳其均播21,978，均为最高。
**适用题材**：男频逆袭、都市打脸、隐藏身份、校园、豪门、真假千金、古装
**验证**：en, es, id, jp, pt, tr, 繁中

**示例**：
- [en] Useless man mocked like dog, unexpectedly trillion-dollar heir—3 strong beauties vie to pamper him!
- [es] Va a escuela con un saco y lo ridiculizan, resulta es heredero rico y reina del campus lo llama amo
- [id] Pengemis yang sering dihina ternyata Dewa Pedang, kalahkan 100 pria kuat, putri jatuh cinta padanya!

### 背叛后离开，前任追悔/被更强者宠爱

**模板**：伴侣/家人/前任选择第三者/利益背叛了主角→主角不哭不闹转身离开→遇到更高价值对象被极致宠爱/亮出隐藏身份让背叛者付出惨痛代价。
**为什么有效**：先制造关系伤害（愤怒+心疼），再用'你不要的被更强的人珍惜'或'冷静反杀'完成双重补偿。观众获得三层情绪：对背叛的愤怒、对主角尊严的认同、对报复的期待。女频关系钩子在所有市场都占主导。
**适用题材**：婚姻背叛、前妻前夫、重生复仇、豪门虐恋、替身、追妻火葬场
**验证**：en, es, id, jp, pt, tr, 繁中

**示例**：
- [en] After seeing a photo of her husband kissing his first love, she vanished from his life forever.
- [es] Renuncié a mi trabajo después de la traición de mi esposo… y lo perdieron todo #dramachino #cdrama
- [id] 【IN DUB】Hancur hati lihat dia jemput cinta pertama! Aku pergi, dia baru sadar!

### 误婚/闪婚遇真大佬

**模板**：为逃避危机/羞辱/婚约，主角和看似普通的陌生人结婚→婚后发现对方竟是顶级身份（CEO/总裁/战神），而且已经暗中爱了主角很久。
**为什么有效**：用'错误选择'包装'命中注定'，让偶然婚姻同时具备爽感和甜感。假戏真做的浪漫+身份揭露的反转=双重点击动机。契约/闪婚设定天然包含信息差（观众知道/不知道对方真实身份），制造持续追看动力。
**适用题材**：CEO甜宠、闪婚、契约婚姻、先婚后爱、残疾CEO、古装
**验证**：en, es, id, jp, pt, tr, 繁中

**示例**：
- [en] [ENG SUB] I Fake-Married a Poor Single Dad... But He's Actually a Billionaire CEO!
- [es] Tras ser abandonada por un canalla, se casó con un CEO discapacitado que la trató como a una princesa
- [id] Gadis tak sengaja menikah dengan CEO, setelah menikah CEO jatuh cinta! Memberinya sayang tanpa batas!

### 绝嗣总裁一夜得子/怀孕触发豪门认亲

**模板**：全城以为某个年龄大/条件特殊的强者此生无后→低位女孩因一夜意外/误会发生关系怀孕→总裁拿着证据上门把母子接回豪门狠狠宠。
**为什么有效**：把继承焦虑（华人文化深层集体无意识）、意外亲密、身份差和豪门补偿压缩在一个钩子里。数字强化冲击力（38岁/19岁/一胎三宝/4年疯找）。繁中time钩子均播61,433全市场最高，验证继承焦虑+甜宠是顶级流量密码。
**适用题材**：女频甜宠、霸总灰姑娘、豪门带球跑、萌宝认亲、单亲妈妈
**验证**：en, es, id, jp, pt, tr, 繁中

**示例**：
- [en] I Spent One Night With a Stranger… 3 Years Later, I Found Out He's a Billionaire & My Son Looks Just Like Him!
- [es] Engravida de gêmeos numa noite, no dia seguinte bilionário aparece: esses filhos são meus!#dorama
- [id] CEO tidak bisa punya anak, dia terkejut melihat tiga anak mirip dirinya di taman kota! #drama

### 重生换命复仇

**模板**：前世被亲近之人/假千金/渣男设局害死→重生回到关键节点→不再隐忍，一步步揭穿所有人真面目，让所有亏欠她的人付出惨痛代价。
**为什么有效**：重生给受害者第二次改写命运的机会，观众提前知道反派会被清算，形成强烈的命运修正期待。全知视角的掌控快感+从被动受害者到主动猎人的身份转换，满足'如果能重来一定不会再犯同样的错'的普遍幻想。
**适用题材**：重生复仇、大女主、逆袭打脸、古装权谋、婚姻修复、宫廷
**验证**：en, es, id, jp, pt, tr, 繁中

**示例**：
- [en] Drained in past life, reborn she threw away the demand list and lived for herself.
- [es] Tras renacer, ella no lloró más y recuperó todo lo que le robaron
- [id] Lahir kembali setelah mati mengenaskan, kali ini dia tidak akan membiarkan siapa pun menginjaknya!

### 系统/异能/穿越降维打击

**模板**：底层角色因事故/濒死/穿越激活系统/异能/金手指→用超现实能力打脸所有欺负者→获得财富/权力/爱情。
**为什么有效**：系统把逆袭速度合法化——观众不用等待漫长的成长过程，直接期待开挂结果。提供超越现实的可能性和逆袭捷径，满足对'超能力改变命运'的幻想。穿越类（现代技能在异世界封神）在繁中均播108,688为全市场最高之一。
**适用题材**：男频爽文、都市异能、玄幻、穿越、系统流、职场反击
**验证**：en, es, id, jp, pt, tr, 繁中

**示例**：
- [en] My Family Lied for the Fake Heiress, So My System Made Every Lie Come True [ENG DUB | FULL]
- [es] Joven viaja a época de hambruna con sistema VIP, salva a familia del hambre y consigue esposa bella
- [id] Gila! Satpam miskin tersengat listrik bangunkan kemampuan kuno—siluman, tembus pandang, teleport!

### 被家族/众人抛弃的弱者是唯一救星

**模板**：真实身份者/养女/被赶走的家人遭遇不公对待→当家族/组织陷入危机→被抛弃的她才是唯一能拯救所有人的存在→抛弃者悔断肠。
**为什么有效**：家族背叛带来的委屈在华人/亚洲文化中尤其强烈（孝道/血缘/传承的集体无意识被打破）。'唯一救星'反转比普通打脸更强——不仅报复了不公，还证明了被抛弃者不可替代的价值。日本、繁中、印尼市场此类题材高播。
**适用题材**：家庭复仇、真假千金、神医、养女逆袭、古装
**验证**：en, es, id, jp, tr, 繁中

**示例**：
- [en] My Family Lied for the Fake Heiress, So My System Made Every Lie Come True [ENG DUB | FULL]
- [es] Padre super rico viste humilde en boda de su hijo, inesperadamente es humillado y echado por suegros
- [id] Dihina dan diusir oleh Keluarganya, Tak disangka Gadis ini dipungut dan dimanjakan CEO Miliarder!

### 危险强者反向宠爱/善意触发命运回报

**模板**：弱势角色意外卷入危险强者的致命秘密/向落难陌生人施以善举→本以为会死/没有回报→却被强者保护宠爱/发现对方是顶级身份并获得巨大回报。
**为什么有效**：①恐惧+甜宠的反差组合（危险浪漫）是土耳其和西语市场的高播题材；②'善有善报'是跨文化的底层道德信念，不知真实身份施以善意→命运回报是'灰姑娘'原型的现代变体；③比主动追求更有'命运感'——无心插柳比有意栽花更能打动人心。
**适用题材**：黑帮爱情、CEO甜宠、慈善反差、隐藏身份、豪门灰姑娘
**验证**：en, es, id, jp, pt, tr

**示例**：
- [en] Poor bartender mocked by all. Unexpectedly saves beautiful CEO, life counterattacks to the peak!
- [es] CEO cazada pide ayuda al vendedor de bao; inesperadamente es leyenda de artes marciales y la salva
- [id] Petugas kebersihan jatuh ke pelukan CEO, tapi CEO malah membelanya, semua terkejut!
