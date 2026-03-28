---
name: feishu-approval
description: "飞书审批流管理。创建审批实例、查询审批状态、同意/拒绝/撤回/转交审批、管理审批任务和评论。Use when 用户需要在飞书中发起审批、查看审批进度、处理审批请求，或提到 Feishu approval、Lark 审批、审批流程、审批单。"
---

# 飞书审批

通过 Approval API 创建和查询审批实例。

**Base URL**: `https://open.feishu.cn/open-apis/approval/v4`

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

## 审批实例

| API | 端点 | 方法 | 请求体示例 | 说明 |
|-----|------|------|-----------|------|
| 创建实例 | `/instances` | POST | `{"approval_code":"7C46...","user_id":"ou_xxx","form":"{\"widget1\":\"value1\"}"}` | 发起审批 |
| 查询实例 | `/instances/{instance_id}` | GET | - | 获取审批状态 |
| 审批操作 | `/instances/{instance_id}/approve` | POST | `{"comment":"同意","task_id":"xxx"}` | 同意/拒绝审批 |
| 撤回审批 | `/instances/{instance_id}/cancel` | POST | `{"user_id":"ou_xxx"}` | 申请人撤回 |
| 转交审批 | `/instances/{instance_code}/transfer` | POST | `{"user_id":"ou_xxx","transfer_user_id":"ou_yyy","comment":"转交"}` | 转交给他人 |
| 催办审批 | `/instances/{instance_id}/urge` | POST | - | 发送催办提醒 |
| 获取实例列表 | `/instances` | GET | 查询参数：`page_size=50&page_token=xxx&user_id=ou_xxx` | 支持筛选参数（分页） |
| 查询实例详情 | `/instances/detail` | POST | `{"instance_code":"xxx"}` | 查询完整详情 |

**创建实例**:
```json
{
  "approval_code": "7C468A54-8745-2245-9675-08B7C63E7A85",
  "user_id": "ou_xxx",
  "form": "{\"widget1\":\"value1\"}"
}
```

---

## 审批任务

| API | 端点 | 方法 | 请求体示例 | 说明 |
|-----|------|------|-----------|------|
| 获取任务列表 | `/tasks` | GET | - | 查询待办任务 |
| 获取任务详情 | `/tasks/{task_id}` | GET | - | 查询任务详情 |
| 审批任务 | `/tasks/{task_id}/approve` | POST | `{"comment":"同意"}` | 处理审批任务 |
| 转交任务 | `/tasks/{task_id}/transfer` | POST | `{"transfer_user_id":"ou_xxx"}` | 转交任务 |

---

## 审批定义

| API | 端点 | 方法 | 请求体示例 | 说明 |
|-----|------|------|-----------|------|
| 获取定义列表 | `/approvals` | GET | - | 查询所有审批模板 |
| 获取定义详情 | `/approvals/{approval_code}` | GET | - | 查询模板详情 |
| 获取定义表单 | `/approvals/{approval_code}/forms` | GET | - | 查询表单字段定义 |

---

## 审批抄送

| API | 端点 | 方法 | 请求体示例 | 说明 |
|-----|------|------|-----------|------|
| 获取抄送列表 | `/cc` | GET | - | 查询抄送我的审批 |
| 已读抄送 | `/cc/{instance_id}/read` | POST | - | 标记抄送已读 |

---

## 审批评论

| API | 端点 | 方法 | 请求体示例 | 说明 |
|-----|------|------|-----------|------|
| 添加评论 | `/instances/{instance_id}/comments` | POST | `{"content":"评论内容","user_id":"ou_xxx"}` | 添加审批评论 |
| 获取评论 | `/instances/{instance_id}/comments` | GET | - | 查询评论列表 |

---

## 常见参数说明

**user_id_type**: 用户 ID 类型
- `open_id`（默认）
- `user_id`
- `union_id`

**分页参数**:
- `page_size`: 每页数量（默认 20，最大 100）
- `page_token`: 分页标记

**实例状态**:
- `PENDING`: 审批中
- `APPROVED`: 已通过
- `REJECTED`: 已拒绝
- `CANCELED`: 已撤回
- `DELETED`: 已删除

---

## 测试示例

**获取审批定义列表**:
```bash
curl -X GET "https://open.feishu.cn/open-apis/approval/v4/approvals?page_size=10" \
  -H "Authorization: Bearer ${TOKEN}"
```

**创建审批实例**:
```bash
curl -X POST "https://open.feishu.cn/open-apis/approval/v4/instances" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "approval_code": "7C468A54-8745-2245-9675-08B7C63E7A85",
    "user_id": "ou_xxx",
    "form": "{\"widget1\":\"请假3天\"}"
  }'
```

**查询实例列表**:
```bash
curl -X GET "https://open.feishu.cn/open-apis/approval/v4/instances?page_size=20&user_id=ou_xxx" \
  -H "Authorization: Bearer ${TOKEN}"
```

---

## 常用工作流

### 创建审批实例（完整流程）

```bash
# 1. 获取审批定义，确认表单字段
curl -X GET "https://open.feishu.cn/open-apis/approval/v4/approvals/{approval_code}/forms" \
  -H "Authorization: Bearer YOUR_TOKEN"

# 2. 根据表单定义构造 form JSON 并创建实例
curl -X POST "https://open.feishu.cn/open-apis/approval/v4/instances" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "approval_code": "7C468A54-8745-2245-9675-08B7C63E7A85",
    "user_id": "ou_xxx",
    "form": "{\"widget1\":\"请假3天\"}"
  }'

# 3. 验证：查询实例状态确认创建成功
curl -X GET "https://open.feishu.cn/open-apis/approval/v4/instances/{instance_id}" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

---

## 实测心法

1. **先获取审批定义再创建实例**——form 字段必须严格匹配定义中的 widget 结构，否则报错
2. **form 必须是字符串化的 JSON**，不能直接传对象，这是最常踩的坑
3. **审批操作需审批人权限**——只有当前审批节点的审批人才能调用 approve/reject
4. **分页查询**：大量数据用 `page_token` 分页，单次最多 100 条
5. **user_id 必填**：创建实例和查询列表都需要指定 `user_id`，缺少会返回参数错误
