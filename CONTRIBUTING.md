# 贡献指南

感谢你考虑为 Feishu Skills 项目做出贡献！🎉

## 📋 目录

- [行为准则](#行为准则)
- [如何贡献](#如何贡献)
- [提交 Issue](#提交-issue)
- [提交 Pull Request](#提交-pull-request)
- [Skill 编写规范](#skill-编写规范)
- [开发流程](#开发流程)

---

## 行为准则

本项目采用 [Contributor Covenant](https://www.contributor-covenant.org/) 行为准则。参与本项目即表示你同意遵守其条款。

简而言之：
- 尊重所有贡献者
- 接受建设性的批评
- 专注于对社区最有利的事情

---

## 如何贡献

有很多方式可以为这个项目做出贡献：

### 1. 报告 Bug 🐛
发现问题？请提交 Issue 告诉我们。

### 2. 提出新功能 💡
有好的想法？欢迎在 Issue 中讨论。

### 3. 改进文档 📝
发现文档错误或不清楚的地方？帮我们改进它。

### 4. 贡献新的 Skill ⭐
这是最有价值的贡献！添加新的飞书 API Skill。

### 5. 分享使用经验 🎯
在 Discussions 中分享你的使用案例和最佳实践。

---

## 提交 Issue

### Bug 报告

提交 Bug 时，请包含：

```markdown
**描述问题**
简要描述遇到的问题。

**复现步骤**
1. 使用哪个 Skill
2. 执行了什么操作
3. 出现了什么错误

**期望行为**
你期望发生什么？

**实际行为**
实际发生了什么？

**环境信息**
- AI Agent 框架：Cursor / Claude / 其他
- 飞书版本：企业版 / 个人版
- 操作系统：macOS / Windows / Linux

**额外信息**
其他有助于解决问题的信息。
```

### 功能请求

提交功能请求时，请包含：

```markdown
**功能描述**
你希望添加什么功能？

**使用场景**
这个功能解决什么问题？

**替代方案**
你考虑过哪些替代方案？

**额外信息**
其他补充说明。
```

---

## 提交 Pull Request

### 基本流程

1. **Fork 本仓库**
   ```bash
   # 在 GitHub 上点击 Fork 按钮
   ```

2. **克隆你的 Fork**
   ```bash
   git clone https://github.com/你的用户名/feishu_skills.git
   cd feishu_skills
   ```

3. **创建分支**
   ```bash
   git checkout -b feature/your-feature-name
   # 或
   git checkout -b fix/your-bug-fix
   ```

4. **进行修改**
   - 编写代码/文档
   - 遵循项目规范

5. **提交更改**
   ```bash
   git add .
   git commit -m "feat: 添加 xxx 功能"
   ```

6. **推送到你的 Fork**
   ```bash
   git push origin feature/your-feature-name
   ```

7. **创建 Pull Request**
   - 在 GitHub 上创建 PR
   - 填写 PR 模板
   - 等待审核

### Commit 规范

我们使用 [Conventional Commits](https://www.conventionalcommits.org/zh-hans/) 规范：

```
<类型>(<范围>): <描述>

[可选的正文]

[可选的脚注]
```

**类型**：
- `feat`: 新功能
- `fix`: Bug 修复
- `docs`: 文档更新
- `style`: 代码格式（不影响功能）
- `refactor`: 重构
- `test`: 测试相关
- `chore`: 构建/工具相关

**示例**：
```bash
feat(feishu-im): 添加批量发送消息功能
fix(feishu-bitable): 修复日期字段格式错误
docs(readme): 更新安装说明
```

---

## Skill 编写规范

### 文件结构

```
feishu-xxx/
├── SKILL.md          # 主文档（必需）
├── examples/         # 示例代码（可选）
└── references/       # 参考资料（可选）
```

### SKILL.md 模板

```markdown
---
name: feishu-xxx
description: 飞书 XXX Skill。[具体能力描述]。当需要 [触发场景] 时使用此 Skill。
required_permissions:
  - xxx:xxx
  - yyy:yyy
---

# 飞书 XXX

你是飞书 XXX 自动化专家，负责通过 XXX API 实现 [核心功能]。

---

## 一、API 基础信息

| 项目 | 值 |
|------|---|
| Base URL | `https://open.feishu.cn/open-apis/xxx` |
| 认证方式 | `Authorization: Bearer {tenant_access_token}` |
| Content-Type | `application/json` |

---

## 二、核心操作

### 1. 操作名称

\```
HTTP_METHOD /path/to/endpoint
\```

\```json
{
  "key": "value"
}
\```

**实测心法**：[这里写实际使用中的经验和避坑指南]

---

## 三、最佳实践

1. **实践 1**：说明
2. **实践 2**：说明
```

### 编写要点

#### 1. YAML Frontmatter（必需）
- `name`: Skill 名称，格式：`feishu-xxx`
- `description`: 简短描述（1-2 句话）+ 使用场景
- `required_permissions`: 所需的飞书权限列表

#### 2. API 基础信息（必需）
- Base URL
- 认证方式
- Content-Type
- 关键参数获取方式

#### 3. 核心操作（必需）
每个操作包含：
- HTTP 方法和端点
- 请求体示例（JSON 格式）
- **实测心法**（最重要！）

#### 4. 实测心法（核心价值）

这是最有价值的部分！必须包含：
- ✅ 实际使用中的经验
- ✅ 常见错误和避坑指南
- ✅ 性能优化建议
- ✅ 最佳实践

**好的实测心法示例**：
```markdown
**实测心法**：
- 日期字段必须转为 **13 位毫秒级时间戳**，这是最常踩的坑
- 数值类型不要传字符串，否则会报错
- 单次批量操作建议控制在 500 条以内
```

**不好的示例**：
```markdown
**实测心法**：按照文档操作即可。
```

#### 5. 最佳实践（推荐）
- 使用场景
- 性能优化
- 安全建议
- 与其他 Skill 的协作

#### 6. 错误处理（推荐）
常见错误码和解决方案。

---

## 开发流程

### 1. 准备工作

- 确保你有飞书开发者账号
- 创建测试应用
- 准备测试环境

### 2. 实测 API

**重要**：不要只看文档，必须实际调用 API！

```bash
# 示例：测试发送消息 API
curl -X POST 'https://open.feishu.cn/open-apis/im/v1/messages' \
  -H 'Authorization: Bearer YOUR_TOKEN' \
  -H 'Content-Type: application/json' \
  -d '{
    "receive_id": "ou_xxx",
    "msg_type": "text",
    "content": "{\"text\":\"测试消息\"}"
  }'
```

记录：
- ✅ 成功的调用
- ❌ 失败的调用和错误信息
- 💡 发现的坑和解决方案

### 3. 编写文档

根据实测经验编写 SKILL.md：
1. 填写 YAML frontmatter
2. 编写 API 基础信息
3. 记录每个操作的请求/响应
4. **重点：编写实测心法**
5. 总结最佳实践

### 4. 自我检查

提交前检查：
- [ ] YAML frontmatter 完整
- [ ] 所有 API 都有示例
- [ ] **每个操作都有实测心法**
- [ ] 代码格式正确（JSON 缩进、Markdown 语法）
- [ ] 没有敏感信息（Token、真实 ID）
- [ ] 文档清晰易懂

### 5. 提交 PR

- 填写 PR 描述
- 说明测试情况
- 附上测试截图（如有）

---

## 审核标准

我们会从以下方面审核 PR：

### 必需项（不满足会被拒绝）
- ✅ 包含实测心法
- ✅ API 示例可用
- ✅ 无敏感信息
- ✅ 遵循模板格式

### 加分项
- ⭐ 提供多个使用场景
- ⭐ 包含错误处理说明
- ⭐ 与其他 Skill 的协作示例
- ⭐ 附带测试截图

---

## 常见问题

### Q: 我不会写代码，可以贡献吗？
A: 当然可以！你可以：
- 改进文档
- 报告 Bug
- 分享使用经验
- 翻译文档

### Q: 我的 PR 多久会被审核？
A: 通常在 1-3 个工作日内。复杂的 PR 可能需要更长时间。

### Q: 我的 PR 被拒绝了怎么办？
A: 不要气馁！根据反馈修改后可以重新提交。

### Q: 我可以添加非飞书的 Skills 吗？
A: 本项目专注于飞书 API。其他平台的 Skills 请考虑创建独立项目。

---

## 获得帮助

遇到问题？可以通过以下方式获得帮助：

- 📖 查看 [README.md](README.md)
- 💬 在 [Discussions](https://github.com/alextangson/feishu_skills/discussions) 提问
- 🐛 提交 [Issue](https://github.com/alextangson/feishu_skills/issues)
- 📧 联系维护者

---

## 致谢

感谢你的贡献！每一个贡献都让这个项目变得更好。🙏

你的名字将会出现在：
- [CHANGELOG.md](CHANGELOG.md) - 更新日志
- README.md 贡献者列表
- GitHub Contributors 页面

---

**让我们一起让 AI Agent 更好地使用飞书 API！** 🚀
