---
name: feishu-calendar
description: 飞书日历。创建日程、查询日程、更新日程。
required_permissions:
  - calendar:calendar
---

# 飞书日历

通过 Calendar API 管理日程。

**Base URL**: `https://open.feishu.cn/open-apis/calendar/v4`

---

## 日程操作

| API | 端点 | 说明 |
|-----|------|------|
| 创建日程 | `POST /calendars/{calendar_id}/events` | - |
| 获取日程 | `GET /calendars/{calendar_id}/events/{event_id}` | - |
| 更新日程 | `PATCH /calendars/{calendar_id}/events/{event_id}` | - |
| 删除日程 | `DELETE /calendars/{calendar_id}/events/{event_id}` | - |
| 搜索日程 | `POST /calendars/{calendar_id}/events/search` | - |

**创建日程**:
```json
{
  "summary": "会议标题",
  "start_time": {"timestamp": "1770508800"},
  "end_time": {"timestamp": "1770512400"},
  "attendees": [{"type": "user", "attendee_id": "ou_xxx"}]
}
```

---

## 日历操作

| API | 端点 | 说明 |
|-----|------|------|
| 获取日历列表 | `GET /calendars` | - |
| 创建日历 | `POST /calendars` | `{"summary":"日历名称"}` |

---

## 最佳实践

1. **时间用秒级时间戳**
2. **attendees 指定类型**（user/chat/resource）
