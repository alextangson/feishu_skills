---
name: feishu-doc-writer
description: 飞书文档写入。Markdown 转 Block、创建文档块、处理并发。
---

# 飞书文档写入

通过 Docx API 写入内容到飞书云文档。飞书文档使用 **Block 树模型**，不接受原始 Markdown。

**Base URL**: `https://open.feishu.cn/open-apis/docx/v1`

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

## 最佳实践

1. **优先用转换 API**（简化开发）
2. **批量创建 blocks**（减少 API 调用）
3. **处理并发冲突**（带 revision 参数）
4. **图片分两步**（占位 + 上传）
