---
name: feishu-approval
description: 飞书审批。创建审批实例、查询审批状态。
required_permissions:
  - approval:approval
---

# 飞书审批

通过 Approval API 创建和查询审批实例。

**Base URL**: `https://open.feishu.cn/open-apis/approval/v4`

---

## 审批实例

| API | 端点 | 说明 |
|-----|------|------|
| 创建实例 | `POST /instances` | 发起审批 |
| 查询实例 | `GET /instances/{instance_id}` | 获取审批状态 |
| 审批操作 | `POST /instances/{instance_id}/approve` | 同意/拒绝 |
| 撤回审批 | `POST /instances/{instance_id}/cancel` | - |

**创建实例**:
```json
{
  "approval_code": "7C468A54-8745-2245-9675-08B7C63E7A85",
  "user_id": "ou_xxx",
  "form": "{\"widget1\":\"value1\"}"
}
```

---

## 审批定义

| API | 端点 | 说明 |
|-----|------|------|
| 获取定义列表 | `GET /approvals` | - |
| 获取定义详情 | `GET /approvals/{approval_code}` | - |

---

## 最佳实践

1. **先获取审批定义**（确认 form 字段）
2. **form 必须字符串化 JSON**
3. **审批操作需审批人权限**
