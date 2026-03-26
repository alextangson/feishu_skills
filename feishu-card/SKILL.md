---
name: feishu-card
description: 飞书交互卡片。构建和发送带按钮/选择器的消息卡片。
---

# 飞书交互卡片

构建、发送和处理飞书交互卡片。

**Base URL**: `https://open.feishu.cn/open-apis/im/v1`

**使用场景**: 晨报确认、告警处理、任务确认、状态更新

## 认证与 Token 获取

从 `feishu_skills` 根目录执行共享脚本：

```bash
TOKEN="$(./scripts/get_feishu_token.sh)"
```

请求头统一使用 `Authorization: Bearer ${TOKEN}`。

如果业务接口返回 token 无效、过期或 401，强制刷新后仅重试一次原请求：

```bash
TOKEN="$(./scripts/get_feishu_token.sh --force-refresh)"
```

**环境变量**:
- `FEISHU_APP_ID`
- `FEISHU_APP_SECRET`

**本地缓存**: `./.feishu_token_cache.json`（未过期直接复用，默认提前 5 分钟刷新）

---

## 发送卡片

```
POST /open-apis/im/v1/messages?receive_id_type=chat_id
```

```json
{
  "receive_id": "<chat_id>",
  "msg_type": "interactive",
  "content": "<card_json_string>"
}
```

⚠️ `content` 必须是字符串化的 JSON。

---

## 卡片结构

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
      {"tag": "button", "text": {"tag": "plain_text", "content": "确认"}, "type": "primary", "value": {"action": "confirm"}}
    ]}
  ]
}
```

---

## 常用元素

| 元素 | 说明 | 示例 |
|------|------|------|
| `div` | 文本块 | `{"tag":"div","text":{"tag":"lark_md","content":"文本"}}` |
| `hr` | 分割线 | `{"tag":"hr"}` |
| `action` | 按钮组 | 见下方 |
| `note` | 备注 | `{"tag":"note","elements":[{"tag":"plain_text","content":"备注"}]}` |

---

## 按钮

```json
{
  "tag": "action",
  "actions": [
    {
      "tag": "button",
      "text": {"tag": "plain_text", "content": "确认"},
      "type": "primary",
      "value": {"action": "confirm", "data": "extra_info"}
    }
  ]
}
```

**按钮类型**: `default` / `primary` / `danger`

---

## 选择器

```json
{
  "tag": "select_static",
  "placeholder": {"tag": "plain_text", "content": "请选择"},
  "options": [
    {"text": {"tag": "plain_text", "content": "选项1"}, "value": "opt1"},
    {"text": {"tag": "plain_text", "content": "选项2"}, "value": "opt2"}
  ],
  "value": {"key": "select_result"}
}
```

---

## 回调处理

用户点击按钮后，飞书会发送 WebSocket 事件：

```json
{
  "type": "card.action.trigger",
  "action": {
    "value": {"action": "confirm", "data": "extra_info"}
  }
}
```

处理回调后可更新卡片：

```
PATCH /open-apis/im/v1/messages/{message_id}
```

---

## 最佳实践

1. **按钮带 value**（用于回调识别）
2. **卡片更新代替新消息**（减少刷屏）
3. **危险操作用 danger 类型**
