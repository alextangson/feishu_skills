---
name: feishu-task
description: 飞书任务。创建任务、更新任务、查询任务。
required_permissions:
  - task:task:write
---

# 飞书任务

通过 Task API 管理任务。

**Base URL**: `https://open.feishu.cn/open-apis/task/v2`

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
