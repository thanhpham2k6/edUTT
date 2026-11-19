# Quy định Git Workflow & Đóng góp Mã nguồn (edUTT — Nhóm 1)

Tài liệu này quy định thống nhất cách quản lý nhánh, viết commit và tạo Pull Request cho cả 5 thành viên Nhóm 1 trong suốt 10 tuần triển khai đồ án **edUTT**.

---

## 1. Chiến lược phân nhánh (Branching Strategy)

Dự án áp dụng mô hình **Git Flow rút gọn** gồm 2 nhánh dài hạn và các nhánh chức năng ngắn hạn:

| Nhánh | Mục đích | Quy tắc bảo vệ |
| :--- | :--- | :--- |
| `main` | Phiên bản ổn định, sẵn sàng nộp bài / demo từng mốc lớn | **Không push trực tiếp.** Chỉ merge từ `dev` qua Pull Request sau khi kiểm thử đạt 100%. |
| `dev` | Nhánh tích hợp chính của toàn nhóm trong quá trình phát triển | **Không push trực tiếp.** Mọi tính năng mới phải tạo Pull Request vào `dev` và có ít nhất 1 thành viên review. |
| `feature/<tên-tính-năng>` | Phát triển tính năng mới theo phân công từng tuần | Tách từ `dev`, xóa sau khi merge vào `dev`. |
| `fix/<tên-lỗi>` | Sửa lỗi phát sinh trong quá trình test / tích hợp | Tách từ `dev`, merge về `dev`. |
| `docs/<tên-tài-liệu>` | Cập nhật báo cáo, sơ đồ thiết kế, README | Tách từ `dev`, merge về `dev`. |

### Ví dụ đặt tên nhánh theo từng phân hệ
- `feature/week1-usecase-docker-replica-set` (Phạm Văn Thanh)
- `feature/week2-erd-6-collections` (Bùi Văn Thắng)
- `feature/week3-collections-jsonschema` (Bùi Văn Thắng)
- `feature/week4-crud-and-db-rbac` (Vũ Quốc Doanh & Phạm Văn Thanh)
- `feature/week5-search-filter-sort` (Vũ Quốc Doanh)
- `feature/week6-transaction-and-automation` (Nguyễn Hữu Trọng)
- `feature/week7-aggregation-views` (Nguyễn Quang Lương)
- `feature/week8-seeding-index-benchmark` (Nguyễn Quang Lương)
- `feature/week9-backup-restore-and-ui` (Phạm Văn Thanh & Vũ Quốc Doanh)

---

## 2. Quy ước viết Commit (Conventional Commits)

Mọi commit message phải tuân thủ định dạng:

```text
<type>(<scope>): <mô tả ngắn gọn bằng tiếng Việt hoặc tiếng Anh>
```

### Danh sách `<type>` chuẩn:
- `feat`: Thêm tính năng mới (API, Model, UI, View, Hook...)
- `fix`: Sửa lỗi logic, bug API, lỗi truy vấn
- `docs`: Viết hoặc cập nhật tài liệu, đặc tả, README
- `chore`: Cấu hình hạ tầng, Docker, package.json, `.gitignore`
- `refactor`: Tái cấu trúc mã nguồn không làm thay đổi hành vi nghiệp vụ
- `perf`: Tối ưu hiệu năng (Index, Aggregation Pipeline, Batch Insert)
- `test`: Viết hoặc cập nhật bộ kiểm thử Jest / Supertest

### Ví dụ chuẩn:
```bash
chore(docker): cấu hình MongoDB Replica Set rs0 trong docker-compose.yml
docs(srs): hoàn thiện đặc tả yêu cầu hệ thống chương 1
feat(migration): thêm $jsonSchema validation cho collection users và questions
perf(index): thêm weighted text index và compound index ESR cho questions
test(concurrency): thêm stress test Promise.all cho luồng upvote
```

---

## 3. Quy trình làm việc hằng ngày cho thành viên

```bash
# 1. Luôn đồng bộ nhánh dev mới nhất trước khi bắt đầu công việc
git checkout dev
git pull origin dev

# 2. Tạo nhánh tính năng mới
git checkout -b feature/week2-schema-design

# 3. Lập trình, kiểm tra thay đổi và commit theo từng bước nhỏ rõ ràng
git status
git add <file_hoặc_thư_mục>
git commit -m "docs(schema): thiết kế sơ đồ 6 collection và ranh giới embedding"

# 4. Đẩy nhánh lên GitHub
git push -u origin feature/week2-schema-design

# 5. Mở Pull Request trên GitHub: feature/week2-schema-design -> dev
#    Điền đầy đủ mẫu PR và gắn người review (Nhóm trưởng hoặc thành viên phối hợp)
```

---

## 4. Các quy tắc bắt buộc để tránh xung đột (Conflict)

1. **Không bao giờ commit** các file nhạy cảm hoặc dung lượng lớn: `.env`, `node_modules/`, `backups/*.gz`, `dist/`.
2. **Pull `dev` thường xuyên** trước khi tạo PR để tự giải quyết conflict (nếu có) trên máy local.
3. **Thay đổi Schema / Index bắt buộc đi qua file Migration** (`migrate-mongo`) để toàn nhóm đồng bộ DB chỉ bằng 1 lệnh `npx migrate-mongo up`.
4. **Mỗi PR chỉ tập trung vào 1 nhiệm vụ cụ thể**, tránh gom quá nhiều thay đổi không liên quan vào cùng 1 PR.
