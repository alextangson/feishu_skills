<p align="center">
  <h1 align="center">Feishu Skills for OpenClaw</h1>
  <p align="center">
    <strong>120+ 项飞书 API 实测经验，让你的 AI Agent 成为飞书自动化专家</strong>
  </p>
  <p align="center">
    <a href="https://github.com/alextangson/feishu_skills/stargazers"><img src="https://img.shields.io/github/stars/alextangson/feishu_skills?style=social" alt="Stars"></a>
    <a href="https://github.com/alextangson/feishu_skills/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License"></a>
  </p>
</p>

---

## 这是什么？

一套**开箱即用**的飞书 API Skill 库，专为 [OpenClaw](https://github.com/openclaw/openclaw) AI Agent 框架设计。

**不是 SDK，不是代码库** —— 而是 **Prompt 知识模板**，让 AI Agent 直接"学会"怎么正确调用飞书 API。

### 核心价值

- ✅ **实测验证**：所有 API 均通过实际调用测试
- ✅ **Token 优化**：2026-03-07 优化，减少 65% token 消耗（2229 行 → 790 行）
- ✅ **即插即用**：复制到 OpenClaw 即可使用
- ✅ **权限清单**：每个 skill 标注所需权限

### 更新日志

**2026-03-07**
- ✅ 优化所有 skills，token 减少 65%
- ✅ 添加 Spark v1 ID 转换 API（feishu-contact）
- ✅ 实测验证：Contact API、IM API、Token 获取
- ✅ 新增 [QUICKSTART.md](./QUICKSTART.md) 快速开始指南

---

## Skill 目录

| Skill | 能力 | API 数量 |
|-------|------|---------|
| [feishu-im](./feishu-im/SKILL.md) | 消息、群聊、卡片 | 25+ |
| [feishu-bitable](./feishu-bitable/SKILL.md) | 多维表格 | 30+ |
| [feishu-doc-writer](./feishu-doc-writer/SKILL.md) | 文档写入 | 15+ |
| [feishu-drive](./feishu-drive/SKILL.md) | 文件管理 | 10 |
| [feishu-task](./feishu-task/SKILL.md) | 任务管理 | 5 |
| [feishu-calendar](./feishu-calendar/SKILL.md) | 日历日程 | 5 |
| [feishu-approval](./feishu-approval/SKILL.md) | 审批流 | 5 |
| [feishu-contact](./feishu-contact/SKILL.md) | 通讯录 | 10 |
| [feishu-wiki](./feishu-wiki/SKILL.md) | 知识库 | 5 |
| [feishu-card](./feishu-card/SKILL.md) | 交互卡片 | 10 |

---

## 快速开始

### 1. 安装到 OpenClaw

```bash
# 克隆仓库
git clone https://github.com/alextangson/feishu_skills.git

# 复制到 OpenClaw skills 目录
cp -r feishu_skills/feishu-* ~/.openclaw/workspace/skills/

# 重启 OpenClaw
```

### 2. 配置飞书应用

1. 在 [飞书开放平台](https://open.feishu.cn/) 创建企业自建应用
2. 开通所需权限（每个 Skill 文件顶部有 `required_permissions` 列表）
3. 配置环境变量：

```bash
export FEISHU_APP_ID="your_app_id"
export FEISHU_APP_SECRET="your_app_secret"
```

详细配置请参考 [OpenClaw 文档](https://github.com/openclaw/openclaw)。

### 3. 复用本地 Token 缓存

从 `feishu_skills` 根目录执行：

```bash
TOKEN="$(./scripts/get_feishu_token.sh)"
```

- 脚本会把 token 写入 `./.feishu_token_cache.json`
- 缓存未过期时直接复用，不重复调用换 token 接口
- 默认在过期前 5 分钟自动刷新
- 若业务接口返回 token 无效或 401，执行 `./scripts/get_feishu_token.sh --force-refresh` 后重试一次原请求

---

## 使用示例

安装后，直接对话即可：

```
你：帮我在飞书群里发一条消息，通知大家明天开会

AI：（自动读取 feishu-im Skill）
好的，我会先读取本地 token 缓存，再发送消息...
```

```
你：在多维表格里新增一条记录

AI：（自动读取 feishu-bitable Skill）
好的，我来创建记录...
```

---

## 实测心法示例

每个 Skill 都包含实战经验，例如：

> **feishu-bitable**：日期字段必须转为 **13 位毫秒级时间戳**，这是最常踩的坑。

> **feishu-doc-writer**：严禁并发写入，必须串行执行，否则 Block 顺序会错乱。

> **feishu-im**：content 字段必须是**字符串化的 JSON**，不能直接传对象。

这些坑，官方文档不会告诉你。

---

## 典型应用场景

- **项目管理**：多维表格看板 + 任务管理 + 消息通知
- **知识管理**：文档写入 + 知识库 + 文件管理
- **审批自动化**：审批流 + 消息通知 + 数据记录
- **团队协作**：群聊管理 + 交互卡片 + 日历排期

---

## Token Helper

- 脚本路径：`./scripts/get_feishu_token.sh`
- 凭证来源：`FEISHU_APP_ID` / `FEISHU_APP_SECRET`
- 缓存文件：`./.feishu_token_cache.json`
- 强制刷新：`./scripts/get_feishu_token.sh --force-refresh`

---

## 贡献

欢迎提交 PR！详见 [CONTRIBUTING.md](CONTRIBUTING.md)。

---

## 关于

### 📖 延伸阅读

👉 [我的飞书知识库：AI Agent 实战经验分享](https://jvbmlo28x0.feishu.cn/wiki/YXOMw7tbIiFzIDkWj58cX9Sznsh)

### 🔗 相关项目

- [OpenClaw](https://github.com/openclaw/openclaw) - 开源 AI Agent 运行时

---

## License

MIT
