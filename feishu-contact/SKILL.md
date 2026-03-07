---
name: feishu-contact
description: 飞书组织架构与 ID 转换。搜索成员、部门管理、ID 互转（OpenID/UserID/UnionID）、Spark ID 转换。
required_permissions:
  - contact:user.base:readonly
  - directory:department:read
  - directory:employee.idconvert:read
  - spark:directory.user.id_convert:read
---

# 飞书组织架构与 ID 转换

通过 Contact v3 和 Spark v1 API 实现成员搜索、部门管理和 ID 转换。

---

## API 基础

| 项目 | Contact v3 | Spark v1 |
|------|-----------|----------|
| Base URL | `https://open.feishu.cn/open-apis/contact/v3` | `https://open.feishu.cn/open-apis/spark/v1` |
| 认证 | `Authorization: Bearer {tenant_access_token}` | 同左 |

---

## 成员查询

| API | 端点 | 说明 |
|-----|------|------|
| 搜索成员 | `GET /users/batch_get_id` | 通过邮箱/手机号获取 OpenID |
| 获取职务 | `GET /job_titles/{id}` | 需在管理后台预先维护 |

---

## 部门管理

| API | 端点 | 请求体示例 |
|-----|------|-----------|
| 获取部门 | `GET /departments/{id}` | - |
| 创建部门 | `POST /departments` | `{"name":"新部门","parent_department_id":"0"}` |
| 入职成员 | `POST /users` | `{"name":"张三","mobile":"138...","department_ids":["od_xxx"]}` |

⚠️ 创建部门和入职成员需最高权限，建议预发环境测试。

---

## ID 转换（核心）

飞书三种 ID 体系：

| ID 类型 | 说明 | 使用场景 |
|---------|------|---------|
| `open_id` | 应用内唯一 | 同一应用内识别用户 |
| `user_id` | 企业内唯一 | 企业内部系统对接 |
| `union_id` | 跨应用唯一 | 同一开发者的多个应用间 |

### Contact v3 ID 转换

```
POST /open-apis/contact/v3/users/batch_get_id
POST /open-apis/contact/v3/departments/batch_get_id
```

### Spark v1 ID 转换（推荐）

```
POST /open-apis/spark/v1/directory/user/id_convert
```

**请求示例：**
```json
{
  "source_id_type": "open_id",
  "source_id": "ou_xxx",
  "target_id_type": "user_id"
}
```

**响应示例：**
```json
{
  "code": 0,
  "data": {
    "target_id": "7f2a1b3c"
  }
}
```

**支持的 ID 类型：**
- `open_id` / `user_id` / `union_id`

**权限要求：**
- `spark:directory.user.id_convert:read`

💡 Spark API 更简洁，推荐用于新项目。

---

## 其他

| API | 端点 | 说明 |
|-----|------|------|
| 办公地点 | `GET /places` | 用于人员地理分布分析 |
| 外部成员访问 | `GET /application/v1/applications/{app_id}/user_usable` | 控制供应商/外包访问权限 |

---

## 最佳实践

1. **ID 转换优先用 Spark API**（更简洁）
2. **缓存常用 ID**（减少 API 调用）
3. **组织架构变更必须预发测试**
