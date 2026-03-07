# 飞书 Skills 快速开始指南

## 前置准备

### 1. 创建飞书应用

1. 访问 [飞书开放平台](https://open.feishu.cn/)
2. 创建企业自建应用
3. 获取 App ID 和 App Secret

### 2. 配置应用权限

根据使用的 skills，在【权限管理】中开通对应权限：

#### feishu-contact（通讯录）
- `contact:user.base:readonly` - 获取用户基本信息
- `directory:department:read` - 读取部门信息
- `directory:employee.idconvert:read` - ID 转换
- `spark:directory.user.id_convert:read` - Spark ID 转换（推荐）

#### feishu-im（消息）
- `im:message` - 发送消息
- `im:chat:create` - 创建群聊
- `im:chat.members:write_only` - 管理群成员

#### feishu-bitable（多维表格）
- `bitable:app` - 操作多维表格
- `bitable:app:readonly` - 只读多维表格

#### feishu-drive（云空间）
- `drive:file:upload` - 上传文件
- `drive:file:download` - 下载文件
- `drive:drive:readonly` - 读取云空间

#### feishu-doc-writer（文档）
- `docx:document` - 操作文档
- `docx:document:readonly` - 只读文档

#### feishu-wiki（知识库）
- `wiki:wiki` - 操作知识库
- `wiki:node:create` - 创建页面节点

#### feishu-task（任务）
- `task:task:write` - 创建和管理任务

#### feishu-calendar（日历）
- `calendar:calendar` - 操作日历和日程

#### feishu-approval（审批）
- `approval:approval` - 创建和查询审批

### 3. 获取 Access Token

```bash
curl -X POST "https://open.feishu.cn/open-apis/auth/v3/tenant_access_token/internal" \
  -H "Content-Type: application/json" \
  -d '{
    "app_id": "YOUR_APP_ID",
    "app_secret": "YOUR_APP_SECRET"
  }'
```

### 4. 测试 API

使用获取的 `tenant_access_token` 调用 API：

```bash
curl -X POST "https://open.feishu.cn/open-apis/im/v1/messages?receive_id_type=open_id" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "receive_id": "ou_xxx",
    "msg_type": "text",
    "content": "{\"text\":\"Hello\"}"
  }'
```

## 使用 Skills

### 在 OpenClaw 中使用

1. 复制 skills 到 OpenClaw workspace：
```bash
cp -r feishu-* ~/.openclaw/workspace/skills/
```

2. 在对话中引用 skill：
```
使用 feishu-im skill 给用户发送消息
```

### 直接调用 API

参考各 skill 的 SKILL.md 文件中的 API 端点和参数说明。

## 常见问题

### Q: 如何获取用户的 open_id？

A: 使用 Contact API 的 batch_get_id 接口，通过邮箱或手机号查询。

### Q: 权限不足怎么办？

A: 检查应用是否开通了对应权限，并确保权限已生效（可能需要几分钟）。

### Q: Token 过期了怎么办？

A: tenant_access_token 有效期 2 小时，过期后需重新获取。

## 更多资源

- [飞书开放平台文档](https://open.feishu.cn/document/)
- [API 调试工具](https://open.feishu.cn/api-explorer/)
