---
name: feishu-doc-writer
description: 飞书文档写入。Markdown 转 Block、创建文档块、处理并发，支持 Mermaid 绘图块。
---

# 飞书文档写入

通过 Docx API 写入内容到飞书云文档。飞书文档使用 **Block 树模型**，不接受原始 Markdown。

**Base URL**: `https://open.feishu.cn/open-apis/docx/v1`

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

## 推荐方式：转换 API

飞书提供官方 **Markdown → Blocks** 转换端点：

```
POST /documents/{document_id}/convert
```

```json
{
  "content": "# 标题\n\n正文\n\n- 列表项",
  "content_type": "markdown"
}
```

✅ 无需手动构建 Block JSON，支持标准 Markdown
⚠️ 不支持飞书特有块（Callout 等）— 需手动创建

---

## Block 类型

| block_type | 名称 | JSON Key | 说明 |
|-----------|------|----------|------|
| 1 | 页面 | `page` | 文档根节点 |
| 2 | 文本 | `text` | 段落 |
| 3-11 | 标题1-9 | `heading1`-`heading9` | - |
| 12 | 无序列表 | `bullet` | 每项单独一个 block |
| 13 | 有序列表 | `ordered` | - |
| 14 | 代码块 | `code` | 需指定 `style.language` |
| 15 | 引用 | `quote` | - |
| 17 | 待办 | `todo` | 带 `style.done` |
| 19 | 高亮块 | `callout` | 飞书特有，容器块 |
| 22 | 分割线 | `divider` | - |
| 27 | 图片 | `image` | 两步：创建占位 + 上传 |
| 31 | 表格 | `table` | - |

---

## 创建 Blocks

```
POST /documents/{document_id}/blocks/{block_id}/children?document_revision_id=-1
```

```json
{
  "children": [...],
  "index": 0
}
```

- `block_id`: 父块 ID（根节点用 `document_id`）
- `index`: 插入位置（0=开头，-1=末尾）

## 删除 Blocks

删除父块下指定范围的子块：

```
DELETE /documents/{document_id}/blocks/{block_id}/children/batch_delete?document_revision_id=-1
```

```json
{
  "start_index": 3,
  "end_index": 4
}
```

- `block_id`: 要操作的父块 ID
- `start_index`: 起始子块下标（包含）
- `end_index`: 结束子块下标（不包含）
- ⚠️ 该接口是 `DELETE`，不是 `POST`

---

## Block 示例

**文本**:
```json
{"block_type": 2, "text": {"elements": [{"text_run": {"content": "段落"}}]}}
```

**标题**:
```json
{"block_type": 3, "heading1": {"elements": [{"text_run": {"content": "标题"}}]}}
```

**代码块**:
```json
{
  "block_type": 14,
  "code": {
    "style": {"language": 1},
    "elements": [{"text_run": {"content": "console.log('hello')"}}]
  }
}
```

**Mermaid 绘图块（插件块）**:
```json
{
  "block_type": 40,
  "add_ons": {
    "component_type_id": "blk_631fefbbae02400430b8f9f4",
    "record": "{\"data\":\"flowchart TD\\nA-->B\",\"theme\":\"default\",\"view\":\"codeChart\"}"
  }
}
```

- `block_type = 40` 表示插件块
- `component_type_id = blk_631fefbbae02400430b8f9f4` 可用于 Mermaid 绘图
- `record` 是字符串化 JSON，目前验证过的字段：
  - `data`: Mermaid 源码
  - `theme`: 通常用 `default`
  - `view`: 通常用 `codeChart`
- 如果文档里已经有人手动插入过“本文绘图”格式的 Mermaid，优先先读取该块，再复用它的 `component_type_id/theme/view`

**高亮块（Callout）**:
```json
{
  "block_type": 19,
  "callout": {
    "background_color": 1,
    "border_color": 1,
    "emoji_id": "bulb"
  },
  "children": [
    {"block_type": 2, "text": {"elements": [{"text_run": {"content": "提示内容"}}]}}
  ]
}
```

**图片（两步）**:
1. 创建占位：`{"block_type": 27, "image": {}}`
2. 上传：`PUT /documents/{document_id}/blocks/{block_id}/image`

---

## 文本样式

```json
{
  "text_run": {
    "content": "样式文本",
    "text_element_style": {
      "bold": true,
      "italic": true,
      "strikethrough": true,
      "underline": true,
      "inline_code": true,
      "background_color": 1,
      "text_color": 1
    }
  }
}
```

---

## 并发处理

飞书文档支持多人协作，需处理并发：

1. **获取最新 revision**: `GET /documents/{document_id}`
2. **带 revision 写入**: `?document_revision_id={revision}`
3. **冲突时重试**（HTTP 409）

---

## Mermaid 推荐流程

当用户要求“按本文绘图格式统一 Mermaid”时，不要直接写普通文本块或代码块里的 ```mermaid。

推荐顺序：

1. 先读取目标文档所有块，确认是否已存在人工调整好的 Mermaid 绘图块
2. 如果存在，读取该块的：
   - `block_type`
   - `add_ons.component_type_id`
   - `add_ons.record`
3. 复用同样的绘图块结构创建新图，而不是继续写 `code` 块
4. 新图创建成功后，再删除旧的 Mermaid 代码块，避免文档里同时保留两套内容

适用场景：
- 用户已经把某一张 Mermaid 图手动改成了理想样式，要求“其他图也改成这种格式”
- 需要让多张流程图在同一篇 Docx 中保持一致视觉效果

---

## 实战建议

1. **普通结构优先用文本块/标题块**
2. **代码展示用 `block_type = 14`**
3. **流程图展示优先用 Mermaid 插件块，不要把 ```mermaid 当最终呈现形式**
4. **替换旧图时，先插入新块，再删除旧块，避免内容丢失**
5. **涉及批量替换时，先读取父块 children 顺序，再按 index 精确删除**

---

## 最佳实践

1. **优先用转换 API**（简化开发）
2. **批量创建 blocks**（减少 API 调用）
3. **处理并发冲突**（带 revision 参数）
4. **图片分两步**（占位 + 上传）
5. **Mermaid 图优先复用现有插件块格式**
