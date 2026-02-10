<p align="center">
  <h1 align="center">Feishu Skills for AI Agents</h1>
  <p align="center">
    <strong>120+ 项飞书 API 实测经验，让你的 AI Agent 成为飞书自动化架构师</strong>
  </p>
  <p align="center">
    <a href="#快速开始">快速开始</a> · <a href="#skill-目录">Skill 目录</a> · <a href="#贡献">贡献指南</a>
  </p>
  <p align="center">
    <a href="https://github.com/alextangson/feishu_skills/stargazers"><img src="https://img.shields.io/github/stars/alextangson/feishu_skills?style=social" alt="Stars"></a>
    <a href="https://github.com/alextangson/feishu_skills/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License"></a>
    <a href="https://github.com/alextangson/feishu_skills/issues"><img src="https://img.shields.io/github/issues/alextangson/feishu_skills" alt="Issues"></a>
  </p>
</p>

---

> 📖 **延伸阅读**：想了解更多 AI Agent 实战经验？查看我的 [飞书知识库文章](https://jvbmlo28x0.feishu.cn/wiki/YXOMw7tbIiFzIDkWj58cX9Sznsh)，分享了实际项目中的应用案例和最佳实践。

---

## 这是什么？

一套**开箱即用**的飞书 API Skill 库，专为 [OpenClaw](https://github.com/nicepkg/openclaw) AI Agent 框架设计。

**不是 SDK，不是代码库** —— 而是一套经过实战验证的 **Prompt 知识模板**，让 AI Agent 直接"学会"怎么正确调用飞书 API。

### 为什么需要它？

| 没有 Skills | 有 Skills |
|------------|-----------|
| AI 每次都要探索飞书 API 文档 | AI 直接读取正确的调用方式 |
| 反复踩坑：格式错、权限错、顺序错 | 120+ 条"实测心法"帮你避坑 |
| 每次对话烧大量 Token 在试错上 | 一次加载，精准执行 |
| **实测消耗 $400+ Token** | **几乎零额外消耗** |

> 我们花了 $400+ 的 Token 和数周时间，把飞书 120+ 项 API 全部实测了一遍。每一条"实测心法"都是真金白银踩出来的坑。现在你可以免费用。

---

## Skill 目录

| Skill | 能力 | API 数量 |
|-------|------|---------|
| [feishu-im](./feishu-im/SKILL.md) | 消息发送、群聊管理、置顶/加急、群菜单/Tab/Widget | 25+ |
| [feishu-doc-writer](./feishu-doc-writer/SKILL.md) | 云文档写入、Markdown→Block 转换、并发顺序保证 | 15+ |
| [feishu-drive](./feishu-drive/SKILL.md) | 文件上传/下载/移动/搜索、安全审计 | 10 |
| [feishu-bitable](./feishu-bitable/SKILL.md) | 多维表格 CRUD、字段管理、视图、角色权限、公式 | 30+ |
| [feishu-task](./feishu-task/SKILL.md) | 任务创建/完成、评论、附件 | 5 |
| [feishu-calendar](./feishu-calendar/SKILL.md) | 日历/日程、空闲查询、日历订阅 | 5 |
| [feishu-approval](./feishu-approval/SKILL.md) | 审批提交、评论、转办、撤回 | 5 |
| [feishu-contact](./feishu-contact/SKILL.md) | 成员搜索、部门管理、ID 互转 | 10 |
| [feishu-wiki](./feishu-wiki/SKILL.md) | 知识空间、Wiki 页面节点 | 5 |
| [feishu-card](./feishu-card/SKILL.md) | 交互卡片、按钮、选择器、状态指示器 | 10 |

---

## 快速开始

### 安装到 OpenClaw

本项目专为 [OpenClaw](https://github.com/nicepkg/openclaw) AI Agent 框架设计。

```bash
# 1. 克隆本仓库
git clone https://github.com/alextangson/feishu_skills.git

# 2. 复制到 OpenClaw skills 目录
cp -r feishu_skills/feishu-* ~/.openclaw/workspace/skills/

# 3. 重启 OpenClaw
# OpenClaw 会自动加载新的 Skills
```

### 其他 AI Agent 框架

Skill 本质是 Markdown 文档，理论上可用于任何支持自定义 Prompt 的 AI Agent 框架。

但**强烈建议使用 OpenClaw**，因为：
- OpenClaw 原生支持 Skill 加载和管理
- 自动处理飞书 API 认证和调用
- 提供完整的飞书集成能力

---

## 配置飞书应用

使用这些 Skills 前，需要先创建飞书应用：

### 1. 创建应用

1. 打开 [飞书开放平台](https://open.feishu.cn/)
2. 创建企业自建应用
3. 记下 `App ID` 和 `App Secret`

### 2. 开通权限

每个 Skill 文件顶部的 `required_permissions` 列出了所需权限。

在应用管理后台开通对应权限，然后发布应用版本。

### 3. 配置到 OpenClaw

在 OpenClaw 的配置文件中添加：

```yaml
feishu:
  app_id: "your_app_id"
  app_secret: "your_app_secret"
```

详细配置请参考 [OpenClaw 文档](https://github.com/nicepkg/openclaw)。

---

## 使用方式

这些 Skill 是**知识文档 + Prompt 模板**，不是可执行代码。它们告诉 AI Agent：

- 调用哪个 API 端点
- 请求体怎么构造
- 有哪些坑需要避免（实测心法）
- 字段类型怎么映射

### 示例对话

**示例 1：发送消息**
```
你：帮我在飞书群里发一条卡片消息，通知大家明天 10 点开会

AI Agent：（自动读取 feishu-im Skill）
好的，我来发送一张交互卡片...
```

**示例 2：操作多维表格**
```
你：在飞书多维表格里新增一条记录，项目名称是"AI助手"，状态是"进行中"

AI Agent：（自动读取 feishu-bitable Skill）
好的，我来创建记录...
已成功添加到多维表格。
```

**示例 3：写入文档**
```
你：把这篇 Markdown 文章同步到飞书文档

AI Agent：（自动读取 feishu-doc-writer Skill）
正在将 Markdown 转换为飞书 Block 结构，串行写入...
文档已创建，链接：https://xxx.feishu.cn/docx/xxx
```

---

## Skill 之间的协作

这些 Skills 可以组合使用，实现更强大的自动化流程：

```
📱 feishu-im（消息/群管理）
    ↓ 发送通知卡片
    
📋 feishu-task（任务管理）──→ 📁 feishu-drive（文件管理）
    ↓ 任务附件                    ↓ 文件上传
    
📊 feishu-bitable（多维表格）←──┘
    ↓ 数据统计
    
📝 feishu-doc-writer（文档写入）
    ↓ 生成报告
    
📚 feishu-wiki（知识沉淀）

其他 Skills：
• feishu-calendar - 智能排会
• feishu-contact - ID 转换与成员管理
• feishu-approval - 审批流程自动化
• feishu-card - 交互式消息卡片
```

**典型应用场景**：
1. **项目管理**：bitable（看板）+ task（任务）+ im（通知）+ calendar（排期）
2. **知识管理**：doc-writer（文档）+ wiki（知识库）+ drive（文件）
3. **审批自动化**：approval（审批）+ im（通知）+ bitable（记录）
4. **团队协作**：contact（成员）+ im（群聊）+ card（交互卡片）

---

## 实测心法示例

每个 Skill 都包含从实战中总结的"实测心法"，这是本项目最有价值的部分。举几个例子：

> **feishu-doc-writer**：严禁并发 append。必须等待前一个请求返回成功后再发起下一段写入，否则 Block 顺序会随机错乱。

> **feishu-bitable**：日期字段必须转为 13 位毫秒级时间戳。这是最常踩的坑。

> **feishu-im**：content 字段必须是字符串化的 JSON，不能直接传对象。

> **feishu-calendar**：时间戳必须为秒级字符串（不是毫秒，不是数字）。

这些坑，官方文档不会告诉你。

---

## 贡献

欢迎提交 PR 贡献新的 Skill 或改进现有 Skill！

详细贡献指南请查看 [CONTRIBUTING.md](CONTRIBUTING.md)。

---

## 关于

本项目是一套开源的飞书 API Skill 库，旨在帮助开发者快速构建飞书自动化应用。

### 📖 延伸阅读

想了解更多关于如何使用 AI Agent 提升工作效率的实践经验？

👉 [**我的飞书知识库：AI Agent 实战经验分享**](https://jvbmlo28x0.feishu.cn/wiki/YXOMw7tbIiFzIDkWj58cX9Sznsh)

这篇文章分享了：
- 如何用 AI Agent 自动化飞书操作
- 实际项目中的应用案例
- 更多实用技巧和最佳实践

### 💡 支持项目

如果你觉得这个项目有用，请给我一个 Star ⭐，这是对我最大的支持！

### 🔗 相关项目

- [OpenClaw](https://github.com/nicepkg/openclaw) - 开源 AI Agent 运行时，本项目的灵感来源

---

## License

MIT
