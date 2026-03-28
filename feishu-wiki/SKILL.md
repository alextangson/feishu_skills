---
name: feishu-wiki
description: "飞书知识库管理。创建知识空间、添加/移动 Wiki 页面节点、管理知识库权限。Use when 用户需要在飞书中管理知识库、创建 Wiki 页面、组织文档结构，或提到 Feishu wiki、Lark 知识库、知识空间、文档管理。"
---

# 飞书知识库

通过 Wiki v2 API 管理知识空间和页面节点。

**Base URL**: `https://open.feishu.cn/open-apis/wiki/v2`
**认证**: `Authorization: Bearer {tenant_access_token}`
**Content-Type**: `application/json`
**所需权限**: `wiki:wiki`, `wiki:node:create`

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

## 知识空间

| API | 端点 | 方法 | 说明 |
|-----|------|------|------|
| 创建空间 | `/spaces` | POST | `{"name":"知识库名称"}` |
| 获取列表 | `/spaces` | GET | 查询所有知识空间 |
| 获取详情 | `/spaces/{space_id}` | GET | 查询空间信息 |

⚠️ **权限穿透**：空间创建后机器人默认无权维护。建议：
1. 创建包含机器人的群组
2. 在知识库【设置】添加该群组为"管理员"
3. 机器人通过群组身份获得操作权

**验证权限**: 创建空间后调用 `GET /spaces/{space_id}` 确认机器人有访问权，再进行后续操作。

---

## 页面节点

| API | 端点 | 方法 | 说明 |
|-----|------|------|------|
| 创建节点 | `/spaces/{space_id}/nodes` | POST | 创建 Wiki 页面 |
| 获取节点 | `/spaces/{space_id}/nodes/{node_token}` | GET | 查询节点详情 |
| 移动节点 | `/spaces/{space_id}/nodes/{node_token}/move` | POST | 移动页面位置 |

**obj_type 可选值**: `doc` / `sheet` / `mindnote` / `bitable` / `file` / `docx`

---

## 常用工作流

### 创建文档并关联到知识库

推荐先创建文档，再将其关联为 Wiki 节点（而非直接创建空节点）：

```bash
# 1. 先通过 docx API 创建文档，获取 document_id
# 2. 将文档关联为知识库节点
curl -X POST "https://open.feishu.cn/open-apis/wiki/v2/spaces/{space_id}/nodes" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "obj_type": "docx",
    "parent_node_token": "root",
    "node_type": "origin",
    "origin_node_token": "doxcnXXX",
    "title": "页面标题"
  }'
```

**验证**: 创建后用 `GET /spaces/{space_id}/nodes/{node_token}` 确认节点已正确挂载。

---

## 实测心法

1. **群组授权法是解决权限问题的关键**——机器人直接被加为空间管理员经常不生效，通过群组绕过最稳定
2. **先创建文档再关联**（用 `origin_node_token`），直接创建空节点后再写入内容容易出现权限不足
3. **移动节点时注意父节点权限**——目标位置的父节点必须对机器人可写，否则 403
4. **知识库适合知识沉淀场景**，频繁修改的内容建议用飞书文档（feishu-doc-writer）
