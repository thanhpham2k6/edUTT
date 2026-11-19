# edUTT — Nền tảng Hỏi đáp Học thuật & Lưu trữ Tri thức

> **Đồ án học phần Cơ sở dữ liệu — Nhóm 1**  
> **Trường Đại học Công nghệ Giao thông Vận tải (UTT)**  
> **Đề tài 1:** Xây dựng nền tảng hỏi đáp học thuật và lưu trữ tri thức (edUTT)  
> **Mô hình:** Cộng đồng sinh viên trao đổi học thuật lẫn nhau — Tập trung thiết kế & tối ưu CSDL MongoDB (10 tuần)

---

## 1. Tổng quan dự án

**edUTT** là nền tảng hỏi đáp học thuật theo mô hình **cộng đồng sinh viên tự hỗ trợ**, tập trung theo từng học phần của nhà trường. Sinh viên có thể đặt câu hỏi, bình luận ngắn, giải đáp lẫn nhau, bình chọn câu trả lời hữu ích, tự chốt đáp án chuẩn và chia sẻ tài liệu học tập có kiểm duyệt.

### Trọng tâm kỹ thuật Cơ sở dữ liệu (MongoDB)
1. **Mô hình hóa dữ liệu NoSQL (6 Collection):** Phân định ranh giới **Embedding** (`short_comments`, `subject_tags`) và **Referencing** (`answers`, `documents`, `votes`).
2. **Toàn vẹn dữ liệu ở nhân DB:** Áp đặt **`$jsonSchema` Validation** (không để trống mục bắt buộc, `reputation >= 0`) và **Unique / Compound Unique Index** (chặn 1 sinh viên bình chọn nhiều lần cho 1 bài).
3. **Truy vấn tổng hợp & Tự động hóa:** **Aggregation Pipeline**, 2 bảng thống kê tự động (**MongoDB Read-only Views**: `v_top_contributors`, `v_subject_knowledge_stats`), tự động chuẩn hóa tiếng Việt không dấu (`search_normalized`), tự động cộng điểm uy tín khi duyệt tài liệu và đồng bộ tên môn học bằng `updateMany()`.
4. **Tối ưu hiệu năng trên dữ liệu lớn:** Sinh **100.000 – 500.000 bản ghi** giả lập, đánh **Weighted Text Index** & **Compound Index (ESR)**, đo đối chiếu `COLLSCAN` vs `IXSCAN` qua `explain("executionStats")`.
5. **Xử lý đồng thời:** **Multi-document ACID Transaction** (`ClientSession`) khi nhiều sinh viên bấm bình chọn hoặc chốt đáp án cùng lúc.
6. **Bảo mật & Vận hành:** Phân quyền **2 vai trò người dùng** (`STUDENT`, `ADMIN`) + **2 tài khoản CSDL MongoDB** (`edutt_app_rw`, `edutt_report_ro`) và sao lưu/phục hồi sự cố bằng `mongodump` / `mongorestore`.

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
│   ├── 00-project-plan-and-team.md  # Phân công 5 thành viên, tác nhân & lộ trình 10 tuần
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
│   │   ├── middlewares/             # JWT Auth & RBAC (STUDENT, ADMIN)
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

- **Chế độ cụm đầy đủ (1 máy chủ chính Primary & 2 máy chủ dự phòng Secondary):**
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
  mongodb://localhost:27017/edutt?replicaSet=rs0
  ```

---

## 5. Nhóm thực hiện (Nhóm 1)

| STT | Họ và tên | Vai trò phụ trách (Trọng tâm CSDL) |
| :-: | :--- | :--- |
| 1 | **Phạm Văn Thanh** | **Nhóm trưởng** — Phân tích sơ đồ (Use Case, nghiệp vụ), Hạ tầng Docker, Phân quyền CSDL & Sao lưu/Phục hồi |
| 2 | **Bùi Văn Thắng** | **Thiết kế sơ đồ CSDL & Ràng buộc dữ liệu** — Sơ đồ 6 Collection, Embedding/Referencing & `$jsonSchema` |
| 3 | **Nguyễn Hữu Trọng** | **Nghiệp vụ giao dịch & Tự động hóa CSDL** — ACID Transaction, chuẩn hóa tiếng Việt không dấu, Hook uy tín & đồng bộ tên môn |
| 4 | **Nguyễn Quang Lương** | **Nghiệp vụ thống kê & Tối ưu tốc độ CSDL** — 2 bảng Views, 500.000 dữ liệu mẫu, Index & đo benchmark |
| 5 | **Vũ Quốc Doanh** | **Nghiệp vụ truy xuất dữ liệu & Giao diện minh họa** — CRUD các phân hệ, tìm kiếm/lọc & giao diện Web React |

Xem chi tiết phân công, tác nhân hệ thống & kế hoạch 10 tuần tại [docs/00-project-plan-and-team.md](docs/00-project-plan-and-team.md) và đặc tả yêu cầu hệ thống tại [docs/01-system-requirements-specification.md](docs/01-system-requirements-specification.md).

---

## 6. Quy định làm việc với Git

Vui lòng đọc kỹ quy định nhánh (`main`, `dev`, `feature/*`) và quy tắc Commit/PR tại [CONTRIBUTING.md](CONTRIBUTING.md) trước khi bắt đầu đóng góp mã nguồn.
