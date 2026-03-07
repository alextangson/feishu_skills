---
name: feishu-im
description: 飞书消息与群管理。发送消息、建群、置顶、加急、撤回、群菜单/Tab/公告。
required_permissions:
  - im:message
  - im:chat:create
  - im:chat.members:write_only
---

# 飞书消息与群管理

通过 IM API 发送消息、管理群聊和配置群功能。

**Base URL**: `https://open.feishu.cn/open-apis/im/v1`

---

## 消息操作

| API | 端点 | 说明 |
|-----|------|------|
| 发送消息 | `POST /messages?receive_id_type=open_id` | 支持文本/卡片/图片/文件 |
| 批量发送 | `POST /messages/batch_send` | 最多 200 人 |
| 回复消息 | `POST /messages/{message_id}/reply` | - |
| 撤回消息 | `DELETE /messages/{message_id}` | 24 小时内 |
| 加急消息 | `PATCH /messages/{message_id}/urgent_app` | - |
| 置顶消息 | `POST /pins` | - |
| 添加表情 | `POST /messages/{message_id}/reactions` | - |

**发送文本消息**:
```json
{
  "receive_id": "ou_xxx",
  "msg_type": "text",
  "content": "{\"text\":\"Hello\"}"
}
```

⚠️ `content` 必须是字符串化的 JSON。

**receive_id_type**: `open_id` / `user_id` / `email` / `chat_id`

---

## 交互卡片

**发送卡片**:
```json
{
  "receive_id": "ou_xxx",
  "msg_type": "interactive",
  "content": "<card_json_string>"
}
```

**卡片结构**:
```json
{
  "config": {"wide_screen_mode": true},
  "header": {
    "title": {"tag": "plain_text", "content": "标题"},
    "template": "blue"
  },
  "elements": [
    {"tag": "div", "text": {"tag": "lark_md", "content": "**加粗**"}},
    {"tag": "action", "actions": [
      {"tag": "button", "text": {"tag": "plain_text", "content": "确认"}, "type": "primary"}
    ]}
  ]
}
```

**常用元素**:
- `div`: 文本块（支持 `lark_md` / `plain_text`）
- `hr`: 分割线
- `action`: 按钮组
- `img`: 图片
- `note`: 备注

---

## 群聊管理

| API | 端点 | 说明 |
|-----|------|------|
| 创建群聊 | `POST /chats` | - |
| 获取群信息 | `GET /chats/{chat_id}` | - |
| 更新群信息 | `PUT /chats/{chat_id}` | 修改群名/描述/头像 |
| 解散群聊 | `DELETE /chats/{chat_id}` | - |
| 搜索群聊 | `GET /chats/search` | - |

**创建群聊**:
```json
{
  "name": "项目群",
  "description": "项目讨论",
  "user_id_list": ["ou_xxx", "ou_yyy"]
}
```

---

## 群成员管理

| API | 端点 | 说明 |
|-----|------|------|
| 获取成员列表 | `GET /chats/{chat_id}/members` | - |
| 添加成员 | `POST /chats/{chat_id}/members` | 最多 50 人/次 |
| 移除成员 | `DELETE /chats/{chat_id}/members` | - |
| 转让群主 | `PUT /chats/{chat_id}/owner` | - |

---

## 群功能配置

| API | 端点 | 说明 |
|-----|------|------|
| 群公告 | `PATCH /chats/{chat_id}/announcement` | - |
| 群置顶 | `POST /chats/{chat_id}/top_notice/put_top_notice` | - |
| 群菜单 | `POST /chats/{chat_id}/menu_tree` | - |
| 群 Tab | `POST /chats/{chat_id}/chat_tabs` | - |

**设置群公告**:
```json
{
  "content": "群公告内容",
  "i18n_contents": {
    "zh_cn": "中文公告",
    "en_us": "English Announcement"
  }
}
```

---

## 最佳实践

1. **批量发送优先**（减少 API 调用）
2. **卡片 content 必须字符串化**
3. **群成员操作最多 50 人/次**
4. **消息撤回限 24 小时内**
