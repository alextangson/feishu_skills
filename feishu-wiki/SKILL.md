---
name: feishu-wiki
description: 飞书知识库。创建知识空间、Wiki 页面节点。
required_permissions:
  - wiki:wiki
  - wiki:node:create
---

# 飞书知识库

通过 Wiki v2 API 管理知识空间和页面节点。

**Base URL**: `https://open.feishu.cn/open-apis/wiki/v2`

---

## 知识空间

| API | 端点 | 说明 |
|-----|------|------|
| 创建空间 | `POST /spaces` | `{"name":"知识库名称"}` |
| 获取列表 | `GET /spaces` | - |
| 获取详情 | `GET /spaces/{space_id}` | - |

⚠️ **权限穿透**：空间创建后机器人默认无权维护。建议：
1. 创建包含机器人的群组
2. 在知识库【设置】添加该群组为"管理员"
3. 机器人通过群组身份获得操作权

---

## 页面节点

| API | 端点 | 说明 |
|-----|------|------|
| 创建节点 | `POST /spaces/{space_id}/nodes` | 创建 Wiki 页面 |
| 获取节点 | `GET /spaces/{space_id}/nodes/{node_token}` | - |
| 移动节点 | `POST /spaces/{space_id}/nodes/{node_token}/move` | - |

**创建节点**:
```json
{
  "obj_type": "docx",
  "parent_node_token": "root",
  "node_type": "origin",
  "origin_node_token": "doxcnXXX",
  "title": "页面标题"
}
```

**obj_type**: `doc` / `sheet` / `mindnote` / `bitable` / `file` / `docx`

---

## 最佳实践

1. **群组授权法**（解决权限问题）
2. **先创建文档再关联**（`origin_node_token`）
3. **适合知识沉淀场景**
