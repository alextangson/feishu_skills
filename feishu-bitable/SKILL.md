---
name: feishu-bitable
description: 飞书多维表格操作。记录 CRUD、字段管理、视图、权限、公式、关联。
required_permissions:
  - bitable:app
  - bitable:app:readonly
---

# 飞书多维表格

通过 Bitable API 操作数据、字段、视图和权限。

**Base URL**: `https://open.feishu.cn/open-apis/bitable/v1`

**关键参数**:
- `app_token`: 多维表格 URL 中 `/base/` 后的字符串
- `table_id`: 调用列表 API 获取

---

## 记录操作

| API | 端点 | 说明 |
|-----|------|------|
| 新增单条 | `POST /apps/{app_token}/tables/{table_id}/records` | - |
| 批量新增 | `POST .../records/batch_create` | 最多 500 条，支持 Upsert |
| 更新 | `PUT .../records/{record_id}` | - |
| 批量更新 | `POST .../records/batch_update` | 最多 500 条 |
| 批量删除 | `POST .../records/batch_delete` | 最多 500 条 |
| 查询 | `POST .../records/search` | 支持 filter/sort/分页 |

**请求示例**:
```json
{
  "fields": {
    "名称": "测试",
    "金额": 100,
    "日期": 1770508800000,
    "状态": "进行中"
  }
}
```

⚠️ 数值不要传字符串，日期必须是 13 位毫秒时间戳。

---

## 字段类型格式

| type | 中文名 | 写入格式 | 示例 |
|------|--------|---------|------|
| 1 | 文本/邮箱 | 字符串 | `"test@example.com"` |
| 2 | 数字/货币/进度 | 数值 | `100` / `0.25` |
| 3 | 单选 | 字符串 | `"支出"` |
| 4 | 多选 | 字符串数组 | `["餐饮","交通"]` |
| 5 | 日期 | 毫秒时间戳 | `1770508800000` |
| 7 | 复选框 | 布尔值 | `true` |
| 11 | 人员 | 对象数组 | `[{"id":"ou_xxx"}]` |
| 15 | 超链接 | 对象 | `{"text":"名称","link":"https://..."}` |
| 17 | 附件 | 对象数组 | `[{"file_token":"xxx"}]` |
| 18/21 | 关联 | 字符串数组 | `["recuxxx"]` |

**不支持 API 写入**: 公式、查找引用、创建时间、修改人、自动编号

---

## 字段管理

| API | 端点 | 说明 |
|-----|------|------|
| 获取字段列表 | `GET .../fields` | 返回 type 和 ui_name |
| 新增字段 | `POST .../fields` | `{"field_name":"新字段","type":1}` |
| 更新字段 | `PUT .../fields/{field_id}` | 修改单选需提供完整 property |
| 删除字段 | `DELETE .../fields/{field_id}` | - |

**公式字段示例**:
```json
{
  "type": 20,
  "field_name": "利润",
  "property": {"formula_expression": "[营收]-[成本]"}
}
```

**关联字段示例**:
```json
{
  "type": 18,
  "field_name": "关联客户",
  "property": {"table_id": "tblXXX", "multiple": true}
}
```

---

## 数据表管理

| API | 端点 | 说明 |
|-----|------|------|
| 创建多维表格 | `POST /apps` | `{"name":"数据库名称"}` |
| 列出数据表 | `GET /apps/{app_token}/tables` | - |
| 新增数据表 | `POST /apps/{app_token}/tables` | `{"table":{"name":"表名"}}` |
| 批量新增表 | `POST .../tables/batch_create` | 最多 10 张表 |
| 删除数据表 | `DELETE .../tables/{table_id}` | - |
| 复制数据表 | `POST .../tables/{table_id}/copy` | - |

---

## 视图管理

| API | 端点 | 说明 |
|-----|------|------|
| 列出视图 | `GET .../tables/{table_id}/views` | - |
| 创建视图 | `POST .../tables/{table_id}/views` | `{"view_name":"新视图","view_type":"grid"}` |
| 删除视图 | `DELETE .../views/{view_id}` | - |

**视图类型**: `grid`(表格) / `kanban`(看板) / `gallery`(画册) / `gantt`(甘特图)

---

## 权限管理

| API | 端点 | 说明 |
|-----|------|------|
| 创建协作者 | `POST /apps/{app_token}/roles/{role_id}/members/batch_create` | - |
| 删除协作者 | `POST .../members/batch_delete` | - |
| 更新权限 | `PUT /apps/{app_token}/roles/{role_id}` | - |

**角色类型**: `owner` / `editor` / `reader`

---

## 最佳实践

1. **批量操作优先**（减少 API 调用）
2. **字段类型严格匹配**（避免写入失败）
3. **日期用毫秒时间戳**（Python: `int(datetime.timestamp() * 1000)`）
4. **关联字段实现关系型能力**
