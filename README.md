# edUTT — Nền tảng Hỏi đáp Học thuật & Lưu trữ Tri thức

> **Đồ án học phần Cơ sở dữ liệu — Nhóm 1**  
> **Trường Đại học Công nghệ Giao thông Vận tải (UTT)**  
> **Đề tài 1:** Xây dựng nền tảng hỏi đáp học thuật và lưu trữ tri thức (edUTT)

---

## 1. Tổng quan dự án

**edUTT** là nền tảng hỏi đáp học thuật tập trung theo từng học phần của trường đại học, giúp sinh viên và giảng viên đặt câu hỏi, thảo luận, bình chọn câu trả lời chất lượng, chốt đáp án chuẩn và lưu trữ tài liệu học tập có kiểm duyệt.

### Trọng tâm kỹ thuật Cơ sở dữ liệu (MongoDB)
1. **Mô hình hóa dữ liệu NoSQL:** Phân định ranh giới **Embedding** (`short_comments`, `subject_tags`) và **Referencing** (`answers`, `documents`, `votes`).
2. **Toàn vẹn dữ liệu ở nhân DB:** Áp đặt **`$jsonSchema` Validation** và **Unique / Compound Unique Index** thông qua `migrate-mongo`.
3. **Truy vấn tổng hợp & Tự động hóa:** **Aggregation Pipeline**, **MongoDB Read-only Views** (`v_top_contributors`, `v_subject_knowledge_stats`) và **Mongoose Hooks**.
4. **Tối ưu hiệu năng trên dữ liệu lớn:** Sinh **100.000 – 500.000 bản ghi** bằng `faker.js`, thiết kế **Weighted Text Index** & **Compound Index (ESR)**, đo benchmark `COLLSCAN` vs `IXSCAN` qua `explain("executionStats")`.
5. **Xử lý đồng thời:** **Multi-document ACID Transaction** (`ClientSession`) cho luồng bình chọn (vote) và chốt đáp án chuẩn (accept answer) chống Race Condition.
6. **Bảo mật & Vận hành:** Phân quyền **RBAC 2 lớp** (JWT API + MongoDB `readWrite`/`readOnly`) và sao lưu/phục hồi thảm họa bằng `mongodump` / `mongorestore`.

---

## 2. Công nghệ sử dụng (Tech Stack)

| Thành phần | Công nghệ / Công cụ |
| :--- | :--- |
| **Hệ QTCSDL** | MongoDB 7.0 (Replica Set trên Docker Compose) |
| **Backend & ODM** | Node.js, Express, TypeScript, Mongoose |
| **Frontend** | React (Vite), Axios |
| **Migration & Seeding** | `migrate-mongo`, `@faker-js/faker` |
| **Kiểm thử tự động** | Jest, Supertest |
| **Quản lý mã nguồn** | Git, GitHub |

---

## 3. Cấu trúc thư mục dự án

```text
edUTT/
├── .github/
│   └── PULL_REQUEST_TEMPLATE.md     # Mẫu Pull Request cho quy trình review
├── docs/
│   ├── 00-project-plan-and-team.md  # Phân công 5 thành viên & lộ trình 10 tuần
│   └── 01-system-requirements-specification.md  # Đặc tả yêu cầu hệ thống (Chương 1)
├── scripts/
│   └── verify-replica-set.ps1       # Script kiểm tra trạng thái MongoDB Replica Set
├── backups/                         # Lưu trữ file sao lưu mongodump (*.gz bị gitignore)
├── backend/                         # Mã nguồn Backend (Express + TypeScript + Mongoose)
│   ├── migrations/                  # Các file migrate-mongo ($jsonSchema, Index)
│   ├── scripts/                     # Script seed.ts (faker.js 500.000 bản ghi)
│   ├── src/
│   │   ├── config/                  # Kết nối DB, biến môi trường
│   │   ├── models/                  # Mongoose Schemas + Hooks
│   │   ├── middlewares/             # JWT Auth & RBAC (student, lecturer, admin)
│   │   ├── services/                # Nghiệp vụ chính + Multi-document ACID Transaction
│   │   ├── controllers/             # Xử lý HTTP Request/Response
│   │   └── routes/                  # Định tuyến REST API
│   └── tests/                       # Kiểm thử tự động Jest + Supertest
├── frontend/                        # Giao diện Web React (Vite)
├── docker-compose.yml               # MongoDB Replica Set 1 node (rs0 - tiết kiệm RAM)
├── docker-compose.cluster.yml       # MongoDB Replica Set 3 node (1 Primary, 2 Secondary)
├── .env.example                     # Mẫu biến môi trường
├── CONTRIBUTING.md                  # Quy định nhánh (Git Workflow) & quy ước Commit
└── README.md
```

---

## 4. Hướng dẫn thiết lập môi trường (Tuần 1)

### Yêu cầu cài đặt trước
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (bật WSL 2 trên Windows)
- [MongoDB Compass](https://www.mongodb.com/products/tools/compass)
- [Node.js LTS (v20 hoặc v22)](https://nodejs.org/)
- [Git](https://git-scm.com/)

### Bước 1: Clone dự án & tạo file `.env`
```bash
git clone <URL_REPO_GITHUB>
cd edUTT
cp .env.example .env
```

### Bước 2: Khởi chạy MongoDB Replica Set (`rs0`)
MongoDB bắt buộc chạy ở chế độ **Replica Set** (có Oplog) mới hỗ trợ **Multi-document ACID Transaction**.

- **Chế độ tiêu chuẩn (1 node Replica Set — khuyên dùng khi lập trình để tiết kiệm RAM):**
```bash
docker compose up -d
```

- **Chế độ cụm phân tán đầy đủ (3 node: 1 Primary, 2 Secondary — dùng khi demo hạ tầng):**
```bash
docker compose -f docker-compose.cluster.yml up -d
```

### Bước 3: Kiểm tra trạng thái Replica Set
Chạy script kiểm tra trên PowerShell:
```powershell
.\scripts\verify-replica-set.ps1
```
Hoặc kiểm tra thủ công bằng `mongosh` trong container:
```bash
docker exec -it edutt-mongo mongosh --eval "rs.status().members.map(m => ({ name: m.name, state: m.stateStr }))"
```
Kết quả hiển thị `state: 'PRIMARY'` là môi trường đã sẵn sàng.

- **Chuỗi kết nối cho Backend & MongoDB Compass:**
  ```text
  mongodb://localhost:27017/edutt_db?replicaSet=rs0
  ```

---

## 5. Nhóm thực hiện (Nhóm 1)

| STT | Họ và tên | Vai trò & Phân hệ phụ trách |
| :-: | :--- | :--- |
| 1 | **Phạm Văn Thanh** | Nhóm trưởng — Phân tích nghiệp vụ, Hạ tầng Docker & RBAC |
| 2 | **Bùi Văn Thắng** | Thiết kế CSDL (6 Collection), Migration (`$jsonSchema`) & ACID Transaction |
| 3 | **Nguyễn Hữu Trọng** | Backend REST API, Aggregation Pipeline, Views & Mongoose Hooks |
| 4 | **Nguyễn Quang Lương** | Seeding 500.000 bản ghi (`faker.js`), Index Benchmark, Jest & Backup/Restore |
| 5 | **Vũ Quốc Doanh** | Frontend React, Tích hợp API & Kịch bản Demo |

Xem chi tiết kế hoạch 10 tuần tại [docs/00-project-plan-and-team.md](docs/00-project-plan-and-team.md) và đặc tả yêu cầu hệ thống tại [docs/01-system-requirements-specification.md](docs/01-system-requirements-specification.md).

---

## 6. Quy định làm việc với Git

Vui lòng đọc kỹ quy định nhánh (`main`, `dev`, `feature/*`) và quy tắc Commit/PR tại [CONTRIBUTING.md](CONTRIBUTING.md) trước khi bắt đầu đóng góp mã nguồn.
