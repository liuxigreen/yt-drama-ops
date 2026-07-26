# 仓库脏数据审计 Checklist

> 每次大规模修改前后执行。发现问题立即修，不留到下次。

## 版本一致性

- [ ] SKILL.md frontmatter `version` ≠ 文件名中的版本号？
- [ ] 知识母本版本 ≠ SKILL.md引用的版本？
- [ ] 多个副本（local skill vs repo SKILL.md）版本不同步？

## 幽灵引用

- [ ] `grep "references/" SKILL.md` 提取的路径，逐个 `ls` 检查存在性
- [ ] `grep "scripts/" SKILL.md` 提取的路径，逐个检查
- [ ] `grep "data/" SKILL.md` 提取的路径，逐个检查
- [ ] `grep "distill/" SKILL.md` 提取的路径，逐个检查

## 数据纯度

- [ ] 目录/文件中出现未验证语言？（7语种：en/es/id/jp/pt/tr/zh-tw）
- [ ] 目录名编码不一致？（如 `繁中` vs `zh-tw`，应统一为 `zh-tw`）
- [ ] distill数据中混入手写偏见？（对比母本确认）

## Git状态

- [ ] `git status` 有 untracked 文件？是否应该提交或删除？
- [ ] `git status` 有 modified 文件？是否应该提交？
- [ ] `.gitignore` 是否覆盖了敏感文件？

## 引用链完整性

- [ ] SKILL.md → references/ → 每个文件都存在？
- [ ] publishing/references/ vs video-optimization/references/ 有重复？
- [ ] 根目录 references/ vs skills/*/references/ 需要同步？

## 常见脏数据模式

| 模式 | 发现方法 | 修复 |
|------|---------|------|
| 文件名版本≠内容版本 | `head -5 *.md` 检查version字段 | 改名或改内容 |
| 幽灵引用 | grep+ls逐个验证 | 删除引用或补文件 |
| 未验证语言数据 | `ls` 目录名，grep语言代码 | 删除或标记为实验性 |
| 编码不一致 | `ls` 目录名 | 统一命名规范 |
| 重复文件 | `diff` 两个目录 | 删除副本，保留母本 |
