---
name: feishu-task
description: 飞书任务。创建任务、更新任务、查询任务。
required_permissions:
  - task:task:write
---

# 飞书任务

通过 Task API 管理任务。

**Base URL**: `https://open.feishu.cn/open-apis/task/v2`

---

## 任务操作

| API | 端点 | 说明 |
|-----|------|------|
| 创建任务 | `POST /tasks` | - |
| 获取任务 | `GET /tasks/{task_guid}` | - |
| 更新任务 | `PATCH /tasks/{task_guid}` | - |
| 完成任务 | `POST /tasks/{task_guid}/complete` | - |
| 删除任务 | `DELETE /tasks/{task_guid}` | - |

**创建任务**:
```json
{
  "summary": "任务标题",
  "description": "任务描述",
  "due": {"timestamp": "1770508800"},
  "members": [{"id": "ou_xxx", "role": "assignee"}]
}
```

---

## 最佳实践

1. **due 用秒级时间戳**
2. **members 指定角色**（assignee/follower）
