---
name: feishu-contact
description: "飞书组织架构与 ID 转换。搜索成员、管理部门/用户组/角色/职级、在 OpenID/UserID/UnionID 之间互转。Use when 用户需要查询飞书用户信息、转换飞书 ID 格式、管理飞书部门或通讯录，或提到 Feishu contact、Lark 通讯录、组织架构。"
---

# 飞书组织架构与 ID 转换

通过 Contact v3 API 实现成员搜索、部门管理和 ID 转换。

---

## API 基础

**Base URL**: `https://open.feishu.cn/open-apis/contact/v3`  
**认证**: `Authorization: Bearer {tenant_access_token}`

---

## 成员查询

| API | 端点 | 说明 |
|-----|------|------|
| 搜索成员 | `GET /users/batch_get_id` | 通过邮箱/手机号获取 OpenID |
| 获取职务 | `GET /job_titles/{id}` | 需在管理后台预先维护 |

---

## 部门管理

| API | 端点 | 方法 | 请求体示例 | 说明 |
|-----|------|------|-----------|------|
| 获取部门 | `/departments/{department_id}` | GET | - | 查询单个部门详情 |
| 获取部门列表 | `/departments` | GET | - | 支持 `parent_department_id` 参数 |
| 获取父部门路径 | `/departments/{department_id}/parent` | GET | - | 获取部门层级路径 |
| 创建部门 | `/departments` | POST | `{"name":"新部门","parent_department_id":"0"}` | 需管理员权限 |
| 更新部门 | `/departments/{department_id}` | PUT | `{"name":"更新后的名称"}` | 修改部门信息 |
| 删除部门 | `/departments/{department_id}` | DELETE | - | 删除空部门 |
| 入职成员 | `/users` | POST | `{"name":"张三","mobile":"138...","department_ids":["od_xxx"]}` | 创建用户 |
| 更新用户 | `/users/{user_id}` | PUT | `{"name":"新名字"}` | 修改用户信息 |
| 删除用户 | `/users/{user_id}` | DELETE | - | 移除用户 |
| 获取用户列表 | `/users` | GET | - | 支持 `department_id` 过滤 |

⚠️ 创建部门和入职成员需最高权限，建议预发环境测试。

---

## 用户组管理

| API | 端点 | 方法 | 请求体示例 | 说明 |
|-----|------|------|-----------|------|
| 获取用户组列表 | `/groups` | GET | - | 查询所有用户组 |
| 获取用户组 | `/groups/{group_id}` | GET | - | 查询单个用户组 |
| 创建用户组 | `/groups` | POST | `{"name":"项目组","description":"描述"}` | 创建新用户组 |
| 更新用户组 | `/groups/{group_id}` | PUT | `{"name":"新名称"}` | 修改用户组 |
| 删除用户组 | `/groups/{group_id}` | DELETE | - | 删除用户组 |
| 获取组成员 | `/groups/{group_id}/members` | GET | - | 查询组成员列表 |
| 添加组成员 | `/groups/{group_id}/members` | POST | `{"member_id":"ou_xxx","member_type":"user"}` | 添加用户到组 |
| 移除组成员 | `/groups/{group_id}/members/{member_id}` | DELETE | - | 从组移除用户 |

---

## 职级管理

| API | 端点 | 方法 | 请求体示例 | 说明 |
|-----|------|------|-----------|------|
| 获取职级列表 | `/job_families` | GET | - | 查询所有职级 |
| 获取职级 | `/job_families/{job_family_id}` | GET | - | 查询单个职级 |
| 创建职级 | `/job_families` | POST | `{"name":"高级工程师"}` | 创建新职级 |
| 更新职级 | `/job_families/{job_family_id}` | PUT | `{"name":"资深工程师"}` | 修改职级 |
| 删除职级 | `/job_families/{job_family_id}` | DELETE | - | 删除职级 |

---

## 角色管理

| API | 端点 | 方法 | 请求体示例 | 说明 |
|-----|------|------|-----------|------|
| 获取角色列表 | `/roles` | GET | - | 查询所有角色 |
| 创建角色 | `/roles` | POST | `{"role_name":"管理员"}` | 创建新角色 |
| 更新角色 | `/roles/{role_id}` | PUT | `{"role_name":"超级管理员"}` | 修改角色名称 |
| 删除角色 | `/roles/{role_id}` | DELETE | - | 删除角色 |
| 获取角色成员 | `/roles/{role_id}/members` | GET | - | 查询角色下所有成员 |
| 批量添加角色成员 | `/roles/{role_id}/members/batch_create` | POST | `{"members":[{"member_id":"ou_xxx","member_type":"user"}]}` | 批量添加成员 |
| 批量删除角色成员 | `/roles/{role_id}/members/batch_delete` | POST | `{"members":[{"member_id":"ou_xxx"}]}` | 批量移除成员 |

---

## ID 转换（核心）

飞书三种 ID 体系：

| ID 类型 | 说明 | 使用场景 |
|---------|------|---------|
| `open_id` | 应用内唯一 | 同一应用内识别用户 |
| `user_id` | 企业内唯一 | 企业内部系统对接 |
| `union_id` | 跨应用唯一 | 同一开发者的多个应用间 |

### Contact v3 ID 转换

| API | 端点 | 方法 | 请求体示例 | 说明 |
|-----|------|------|-----------|------|
| 批量获取用户 ID | `/users/batch_get_id` | POST | `{"emails":["a@b.com"],"mobiles":["138xxx"]}` | 通过邮箱/手机获取 OpenID |
| 批量获取部门 ID | `/departments/batch_get_id` | POST | `{"department_ids":["od_xxx"]}` | 部门 ID 转换 |
| 获取用户 | `/users/{user_id}` | GET | - | 通过 ID 获取用户信息 |
| 获取用户信息（批量） | `/users/batch_get` | GET | - | 参数：`user_ids=ou_1,ou_2` |

**ID 转换最佳实践：**

通过 `GET /users/{user_id}` 接口可一次性获取用户的所有 ID 类型（open_id/user_id/union_id），无需单独转换。

**示例：**
```bash
GET /contact/v3/users/ou_xxx?user_id_type=open_id
```

**响应包含：**
```json
{
  "data": {
    "user": {
      "open_id": "ou_xxx",
      "user_id": "7c43cd5f",
      "union_id": "on_xxx"
    }
  }
}
```

---

## 其他

| API | 端点 | 方法 | 说明 |
|-----|------|------|------|
| 获取职务列表 | `/job_titles` | GET | 查询所有预设职务 |
| 获取职务 | `/job_titles/{job_title_id}` | GET | 查询单个职务详情 |
| 获取办公地点 | `/places` | GET | 用于人员地理分布分析 |
| 获取人员类型 | `/employee_types` | GET | 查询人员类型列表 |
| 获取自定义属性 | `/custom_attr_events` | GET | 查询自定义属性变更事件 |
| 获取授权范围 | `/scopes` | GET | 查询应用可访问的部门/用户范围 |
| 外部成员访问 | `/application/v1/applications/{app_id}/user_usable` | GET | 控制供应商/外包访问权限 |

## 事件订阅

通讯录支持 17 个变更事件：

| 事件类型 | 说明 |
|---------|------|
| `contact.user.created_v3` | 用户创建 |
| `contact.user.updated_v3` | 用户信息更新 |
| `contact.user.deleted_v3` | 用户删除 |
| `contact.dept.created_v3` | 部门创建 |
| `contact.dept.updated_v3` | 部门更新 |
| `contact.dept.deleted_v3` | 部门删除 |
| `contact.employee_type.created_v3` | 人员类型创建 |
| `contact.employee_type.updated_v3` | 人员类型更新 |
| `contact.employee_type.deleted_v3` | 人员类型删除 |
| `contact.job_family.created_v3` | 职级创建 |
| `contact.job_family.updated_v3` | 职级更新 |
| `contact.job_family.deleted_v3` | 职级删除 |

---

## 常用工作流

### 通过邮箱查找用户并获取所有 ID

```bash
# 1. 通过邮箱获取 open_id
curl -X POST "https://open.feishu.cn/open-apis/contact/v3/users/batch_get_id" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"emails":["user@company.com"]}'

# 2. 用 open_id 获取完整用户信息（包含所有 ID 类型）
curl -X GET "https://open.feishu.cn/open-apis/contact/v3/users/ou_xxx?user_id_type=open_id" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

**验证**: 检查响应中 `data.user` 包含 `open_id`、`user_id`、`union_id` 三个字段。

### 安全删除部门

```bash
# 1. 确认部门下无用户
curl -X GET "https://open.feishu.cn/open-apis/contact/v3/users?department_id=od_xxx" \
  -H "Authorization: Bearer YOUR_TOKEN"

# 2. 确认无子部门
curl -X GET "https://open.feishu.cn/open-apis/contact/v3/departments?parent_department_id=od_xxx" \
  -H "Authorization: Bearer YOUR_TOKEN"

# 3. 确认为空后再删除
curl -X DELETE "https://open.feishu.cn/open-apis/contact/v3/departments/od_xxx" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

---

## 实测心法

1. **ID 转换优先用 `GET /users/{user_id}` 一次获取所有 ID 类型**——比单独转换接口更简洁
2. **缓存常用 ID**（减少 API 调用），open_id 在同一应用内不变
3. **组织架构变更必须预发测试**——删除部门/用户不可逆，生产环境出错代价极高
4. **batch_get_id 可能返回部分结果**——邮箱或手机号匹配不到时该条目不在响应中，需检查返回数量
