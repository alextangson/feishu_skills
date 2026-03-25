---
name: feishu-task
description: "飞书任务管理。创建、更新、完成、删除任务，分配负责人和关注者，设置截止时间。Use when 用户需要在飞书中管理待办事项、创建任务、分配工作、跟踪任务进度，或提到 Feishu task、Lark 任务、飞书待办。"
---

# 飞书任务

通过 Task v2 API 管理任务的创建、更新、完成和删除。

**Base URL**: `https://open.feishu.cn/open-apis/task/v2`
**认证**: `Authorization: Bearer {tenant_access_token}`
**Content-Type**: `application/json`
**所需权限**: `task:task:write`

---

## 任务操作

| API | 端点 | 方法 | 说明 |
|-----|------|------|------|
| 创建任务 | `/tasks` | POST | 创建新任务 |
| 获取任务 | `/tasks/{task_guid}` | GET | 查询任务详情 |
| 更新任务 | `/tasks/{task_guid}` | PATCH | 修改任务属性 |
| 完成任务 | `/tasks/{task_guid}/complete` | POST | 标记任务为已完成 |
| 删除任务 | `/tasks/{task_guid}` | DELETE | 删除任务 |

---

## 常用工作流

### 创建并分配任务

```bash
curl -X POST "https://open.feishu.cn/open-apis/task/v2/tasks" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "summary": "任务标题",
    "description": "任务描述",
    "due": {"timestamp": "1770508800"},
    "members": [{"id": "ou_xxx", "role": "assignee"}]
  }'
```

**验证**: 创建后用 `GET /tasks/{task_guid}` 确认任务状态和分配信息。

### 更新任务截止时间

```bash
curl -X PATCH "https://open.feishu.cn/open-apis/task/v2/tasks/{task_guid}" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "due": {"timestamp": "1771118400"}
  }'
```

---

## 实测心法

1. **due 用秒级时间戳**（10 位），不是毫秒级（13 位），传错不会报错但截止时间会变成遥远未来
2. **members 必须指定 role**：`assignee`（负责人）或 `follower`（关注者），缺少 role 字段会报参数错误
3. **删除前先确认**：`DELETE` 操作不可逆，建议先 `GET` 查询确认再删除
4. **task_guid 是全局唯一 ID**，创建成功后从响应中获取并缓存
