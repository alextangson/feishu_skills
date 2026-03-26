---
name: feishu-calendar
description: 飞书日历。创建日程、查询日程、更新日程。
required_permissions:
  - calendar:calendar
---

# 飞书日历

通过 Calendar API 管理日程。

**Base URL**: `https://open.feishu.cn/open-apis/calendar/v4`

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

## 日程操作

| API | 端点 | 方法 | 请求体示例 | 说明 |
|-----|------|------|-----------|------|
| 创建日程 | `/calendars/{calendar_id}/events` | POST | `{"summary":"会议标题","start_time":{"timestamp":"1770508800"},"end_time":{"timestamp":"1770512400"}}` | 创建新日程 |
| 获取日程 | `/calendars/{calendar_id}/events/{event_id}` | GET | - | 查询日程详情 |
| 更新日程 | `/calendars/{calendar_id}/events/{event_id}` | PATCH | `{"summary":"新标题"}` | 修改日程 |
| 删除日程 | `/calendars/{calendar_id}/events/{event_id}` | DELETE | - | 删除日程 |
| 搜索日程 | `/calendars/{calendar_id}/events/search` | POST | `{"query":"关键词","start_time":{"timestamp":"1770508800"}}` | 条件搜索 |
| 获取日程列表 | `/calendars/{calendar_id}/events` | GET | - | 查询日历下所有日程 |

**创建日程**:
```json
{
  "summary": "会议标题",
  "start_time": {"timestamp": "1770508800"},
  "end_time": {"timestamp": "1770512400"},
  "attendees": [{"type": "user", "attendee_id": "ou_xxx"}]
}
```

**attendees type**: `user` / `chat` / `resource`(会议室)

---

## 日程参与人

| API | 端点 | 方法 | 请求体示例 | 说明 |
|-----|------|------|-----------|------|
| 获取参与人 | `/calendars/{calendar_id}/events/{event_id}/attendees` | GET | - | 查询参与人列表 |
| 添加参与人 | `/calendars/{calendar_id}/events/{event_id}/attendees` | POST | `{"attendees":[{"type":"user","attendee_id":"ou_xxx"}]}` | 邀请参与人 |
| 删除参与人 | `/calendars/{calendar_id}/events/{event_id}/attendees/{attendee_id}` | DELETE | - | 移除参与人 |
| 获取参与群成员 | `/calendars/{calendar_id}/events/{event_id}/attendees/chat_members` | GET | - | 查询群参与成员 |

---

## 日历管理

| API | 端点 | 方法 | 请求体示例 | 说明 |
|-----|------|------|-----------|------|
| 获取日历列表 | `/calendars` | GET | 查询参数：`page_size=50&page_token=xxx` | 查询所有日历（分页） |
| 获取主日历 | `/calendars/primary` | GET | - | 查询用户主日历 |
| 创建日历 | `/calendars` | POST | `{"summary":"日历名称","description":"描述","permissions":"public"}` | 创建共享日历 |
| 获取日历 | `/calendars/{calendar_id}` | GET | - | 查询日历详情 |
| 更新日历 | `/calendars/{calendar_id}` | PATCH | `{"summary":"新名称"}` | 修改日历 |
| 删除日历 | `/calendars/{calendar_id}` | DELETE | - | 删除日历 |
| 搜索日历 | `/calendars/search` | POST | `{"query":"关键词"}` | 搜索日历 |

---

## 日历订阅与 ACL

| API | 端点 | 方法 | 请求体示例 | 说明 |
|-----|------|------|-----------|------|
| 获取 ACL 列表 | `/calendars/{calendar_id}/acls` | GET | - | 查询日历权限 |
| 创建 ACL | `/calendars/{calendar_id}/acls` | POST | `{"role":"reader","scope":{"type":"user","user_id":"ou_xxx"}}` | 添加权限 |
| 删除 ACL | `/calendars/{calendar_id}/acls/{acl_id}` | DELETE | - | 移除权限 |
| 订阅日历 | `/calendars/{calendar_id}/subscribe` | POST | - | 订阅日历变更 |
| 取消订阅 | `/calendars/{calendar_id}/unsubscribe` | POST | - | 取消日历订阅 |
| 订阅日程事件 | `/calendars/{calendar_id}/events/subscribe` | POST | - | 订阅日程变更 |
| 取消日程订阅 | `/calendars/{calendar_id}/events/unsubscribe` | POST | - | 取消日程订阅 |

**ACL role**: `none` / `free_busy_reader` / `reader` / `writer` / `owner`

---

## 会议室管理

| API | 端点 | 方法 | 请求体示例 | 说明 |
|-----|------|------|-----------|------|
| 获取会议室列表 | `/rooms` | GET | - | 查询所有会议室 |
| 获取会议室 | `/rooms/{room_id}` | GET | - | 查询会议室详情 |
| 查询会议室忙闲 | `/rooms/{room_id}/freebusy` | GET | - | 查询会议室可用时间 |

### 创建日程并占用会议室

占用会议室的关键：在 `attendees` 中添加 `type: "resource"` 的参与人，`attendee_id` 填会议室的 `room_id`。

**完整流程**：

```bash
# 1. 获取会议室列表，拿到 room_id
curl -X GET "https://open.feishu.cn/open-apis/calendar/v4/rooms?page_size=50" \
  -H "Authorization: Bearer YOUR_TOKEN"

# 2. （可选）查询会议室在目标时间段是否空闲
curl -X GET "https://open.feishu.cn/open-apis/calendar/v4/rooms/{room_id}/freebusy?start_time=1770508800&end_time=1770512400" \
  -H "Authorization: Bearer YOUR_TOKEN"

# 3. 创建日程，attendees 中加入会议室
curl -X POST "https://open.feishu.cn/open-apis/calendar/v4/calendars/primary/events" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "summary": "团队会议",
    "start_time": {"timestamp": "1770508800"},
    "end_time": {"timestamp": "1770512400"},
    "attendees": [
      {"type": "user", "attendee_id": "ou_xxx"},
      {"type": "resource", "attendee_id": "omcxxxxxxxxxxxxx"}
    ]
  }'
```

⚠️ 若会议室在该时段已被占用，创建请求会返回冲突错误，请先查询忙闲再预订。

---

## 常见参数说明

**时间格式**:
- `timestamp`: 秒级时间戳（如 `"1770508800"`）
- `date`: 日期字符串（如 `"2026-03-07"`）

**分页参数**:
- `page_size`: 每页数量（默认 50，最大 500）
- `page_token`: 分页标记（从上次响应获取）

**user_id_type**: 用户 ID 类型
- `open_id`（默认）
- `user_id`
- `union_id`

---

## 测试示例

**获取日历列表**:
```bash
curl -X GET "https://open.feishu.cn/open-apis/calendar/v4/calendars?page_size=10" \
  -H "Authorization: Bearer ${TOKEN}"
```

**创建日程**:
```bash
curl -X POST "https://open.feishu.cn/open-apis/calendar/v4/calendars/primary/events" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "summary": "团队会议",
    "start_time": {"timestamp": "1709798400"},
    "end_time": {"timestamp": "1709802000"}
  }'
```

---

## 最佳实践

1. **时间用秒级时间戳**
2. **attendees 指定类型**（user/chat/resource）
3. **分页查询**：大量数据用 page_token 分页
4. **主日历**：用户个人日历用 `primary` 作为 calendar_id
