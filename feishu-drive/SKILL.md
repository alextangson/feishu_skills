---
name: feishu-drive
description: 飞书云空间文件管理。上传/下载/移动/搜索文件、创建文件夹。
required_permissions:
  - drive:file:upload
  - drive:file:download
  - drive:drive:readonly
---

# 飞书云空间文件管理

通过 Drive API 管理文件和文件夹。

**Base URL**: `https://open.feishu.cn/open-apis/drive/v1`

---

## 快速启动（必读）

为避免文件进入"私有黑盒"：

1. **创建锚点文件夹**（如 `AI-Workspace`）
2. **授权机器人**：文件夹【协作】设置中添加应用为【管理】权限
3. **获取 Token**：复制文件夹 URL 中的 Token
4. **测试**：调用 `batch_query` 查询该 Token

⚠️ API 创建的文件夹默认只对机器人可见，需手动添加协作者。

---

## 文件夹操作

| API | 端点 | 说明 |
|-----|------|------|
| 创建文件夹 | `POST /folders` | `{"name":"文件夹名","folder_token":"root"}` |
| 获取元数据 | `GET /metas/batch_query` | 批量查询文件/文件夹信息 |

---

## 文件上传

| API | 端点 | 说明 |
|-----|------|------|
| 小文件上传 | `POST /files/upload_all` | 一次性上传（<20MB） |
| 大文件上传 | `POST /files/upload_prepare` + `POST /files/upload_part` + `POST /files/upload_finish` | 分片上传 |

**小文件上传**:
```
POST /files/upload_all
Content-Type: multipart/form-data

file_name=test.txt
parent_type=explorer
parent_node=fldXXX
file=<binary>
```

---

## 文件下载

```
GET /files/{file_token}/download
```

返回文件二进制流。

---

## 文件操作

| API | 端点 | 说明 |
|-----|------|------|
| 移动文件 | `POST /files/{file_token}/move` | `{"type":"explorer","folder_token":"fldXXX"}` |
| 复制文件 | `POST /files/{file_token}/copy` | - |
| 删除文件 | `DELETE /files/{file_token}` | - |

---

## 搜索

```
POST /files/search
```

```json
{
  "search_key": "关键词",
  "owner_ids": ["ou_xxx"]
}
```

---

## 权限管理

| API | 端点 | 说明 |
|-----|------|------|
| 添加协作者 | `POST /permissions/{token}/members` | `{"member_type":"user","member_id":"ou_xxx","perm":"full_access"}` |
| 移除协作者 | `DELETE /permissions/{token}/members/{member_id}` | - |

**权限类型**: `view` / `edit` / `full_access`

---

## 最佳实践

1. **创建文件夹后立即添加协作者**（避免不可见）
2. **大文件用分片上传**（>20MB）
3. **权限继承**：父文件夹授权后，子文件夹自动继承
