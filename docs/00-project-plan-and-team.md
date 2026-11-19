# Kế hoạch Triển khai & Phân công Nhiệm vụ Nhóm 1 (edUTT)

- **Trường:** Đại học Công nghệ Giao thông Vận tải (UTT)
- **Học phần:** Đồ án Cơ sở dữ liệu
- **Đề tài 1:** Nền tảng hỏi đáp học thuật và lưu trữ tri thức (**edUTT**)
- **Chuẩn đầu ra:** CLO1 – CLO7 | **Thời gian triển khai:** 10 tuần

---

## 1. Bảng phân công nhiệm vụ theo thành viên

| STT | Họ và tên | Vai trò & Phân hệ phụ trách | Nội dung công việc chi tiết | Chuẩn đầu ra |
| :-: | :--- | :--- | :--- | :--- |
| 1 | **Phạm Văn Thanh** | **Nhóm trưởng** — Phân tích nghiệp vụ, Hạ tầng & RBAC | • Khởi tạo GitHub repo, quy định nhánh (Git workflow) và viết đặc tả yêu cầu hệ thống (Chương 1).<br>• Cấu hình `docker-compose.yml` chạy cụm MongoDB Replica Set và khởi tạo `rs.initiate()`.<br>• Xây dựng API xác thực JWT, quản lý `users`, `subjects` và phân quyền RBAC 2 lớp (API + tài khoản DB `readWrite`/`readOnly`).<br>• Tổng hợp báo cáo Word/PDF, thiết kế Slide và điều phối bảo vệ. | CLO1, CLO5, CLO6, CLO7 |
| 2 | **Bùi Văn Thắng** | **Thiết kế CSDL & Xử lý đồng thời** — Schema, Migration & ACID | • Thiết kế sơ đồ Document Schema 6 Collection (`users`, `subjects`, `documents`, `questions`, `answers`, `votes`), phân định ranh giới Embedding vs. Referencing.<br>• Dựng khung dự án Express + TypeScript + Mongoose + `migrate-mongo`; viết migration tạo `$jsonSchema` và các Unique/Compound Index.<br>• Cài đặt Multi-document ACID Transaction (`ClientSession`) xử lý vote, chốt đáp án chuẩn và cộng điểm reputation chống Race Condition. | CLO1, CLO2, CLO5, CLO6 |
| 3 | **Nguyễn Hữu Trọng** | **Backend API & Lập trình CSDL** — Aggregation, Views & Hooks | • Xây dựng RESTful API CRUD cho phân hệ Hỏi đáp (`questions`, `answers`, `short_comments`) và Tài liệu (`documents`).<br>• Xử lý đồng bộ `subject_tags` bằng `updateMany()` khi cập nhật danh mục môn học.<br>• Viết Aggregation Pipeline tạo 2 Read-only Views (`v_top_contributors`, `v_subject_stats`) và cài đặt Mongoose Hooks chuẩn hóa `search_normalized` tiếng Việt, cộng uy tín duyệt bài. | CLO3, CLO5, CLO6 |
| 4 | **Nguyễn Quang Lương** | **Tối ưu hiệu năng & Kiểm thử** — Dữ liệu lớn, Index & Vận hành | • Viết script `faker.js` + `bulkWrite()` / `insertMany()` sinh 100.000 – 500.000 bản ghi giả lập.<br>• Thiết kế Weighted Text Index & Compound Index; đo benchmark `COLLSCAN` vs. `IXSCAN` qua `explain("executionStats")`.<br>• Viết bộ test tự động Jest + Supertest (CRUD, `$jsonSchema`, RBAC, Stress Test đa luồng `Promise.all()`) và script sao lưu/khôi phục `mongodump` / `mongorestore`. | CLO4, CLO5, CLO6 |
| 5 | **Vũ Quốc Doanh** | **Frontend & Tích hợp** — Giao diện React & Kịch bản Demo | • Xây dựng giao diện Web React kết nối REST API: trang chủ hỏi đáp, tìm kiếm toàn văn tiếng Việt (có dấu/không dấu), lọc theo mã môn.<br>• Xây dựng màn hình chi tiết câu hỏi, bình luận nhanh, upvote/downvote, chốt đáp án chuẩn và kho tài liệu học tập.<br>• Xây dựng giao diện biểu đồ thống kê từ Views, kiểm thử end-to-end và chuẩn bị kịch bản demo trực tiếp. | CLO6, CLO7 |

---

## 2. Lộ trình triển khai 10 tuần

| Tuần | CLO | Công việc trọng tâm | Người thực hiện chính | Người phối hợp | Sản phẩm bàn giao | Trạng thái |
| :-: | :--- | :--- | :--- | :--- | :--- | :-: |
| **Tuần 1** | CLO1, CLO7 | Khởi tạo GitHub, dựng Docker Replica Set, phân tích nghiệp vụ edUTT | Phạm Văn Thanh | Cả nhóm | Đặc tả yêu cầu + Docker chạy sẵn + GitHub repo | ✅ Hoàn thành |
| **Tuần 2** | CLO1, CLO2 | Vẽ sơ đồ 6 Collection; chốt ranh giới nhúng (`short_comments`, `subject_tags`) và tham chiếu | Bùi Văn Thắng | Nguyễn Hữu Trọng | Sơ đồ Schema + Giải trình thiết kế | ⬜ Chưa bắt đầu |
| **Tuần 3** | CLO2, CLO6 | Dựng Express/TS/Mongoose + `migrate-mongo`, cài `$jsonSchema` và Unique Index | Bùi Văn Thắng | Phạm Văn Thanh | Mã nguồn Model + File Migration v1 | ⬜ Chưa bắt đầu |
| **Tuần 4** | CLO5, CLO6 | Xây dựng REST API CRUD hỏi đáp/tài liệu và phân quyền RBAC 2 lớp | Nguyễn Hữu Trọng | Phạm Văn Thanh | Bộ API cốt lõi + Phân quyền DB | ⬜ Chưa bắt đầu |
| **Tuần 5** | CLO3 | Viết Aggregation Pipeline, tạo 2 Read-only Views và Mongoose Hooks | Nguyễn Hữu Trọng | Bùi Văn Thắng | Bộ truy vấn tổng hợp, Views & Hooks | ⬜ Chưa bắt đầu |
| **Tuần 6** | CLO4 | Sinh 500.000 bản ghi bằng `faker.js`, đánh Index và đo `explain("executionStats")` | Nguyễn Quang Lương | Bùi Văn Thắng | Báo cáo benchmark `COLLSCAN` vs `IXSCAN` | ⬜ Chưa bắt đầu |
| **Tuần 7** | CLO5 | Cài đặt Multi-document ACID Transaction cho luồng vote/chốt đáp án & stress test | Bùi Văn Thắng | Nguyễn Quang Lương | Test case chứng minh không lỗi đồng thời | ⬜ Chưa bắt đầu |
| **Tuần 8** | CLO6 | Xây dựng giao diện React kết nối API và hoàn thiện bộ test Jest + Supertest | Vũ Quốc Doanh | Nguyễn Quang Lương | Ứng dụng chạy end-to-end + Test pass 100% | ⬜ Chưa bắt đầu |
| **Tuần 9** | CLO5 | Viết script sao lưu `mongodump` và diễn tập khôi phục dữ liệu bằng `mongorestore` | Nguyễn Quang Lương | Phạm Văn Thanh | Script backup + Biên bản phục hồi sự cố | ⬜ Chưa bắt đầu |
| **Tuần 10** | CLO7 | Rà soát mã nguồn, hoàn thiện báo cáo Word/PDF, làm Slide và chạy thử demo bảo vệ | Phạm Văn Thanh | Vũ Quốc Doanh & Cả nhóm | Báo cáo hoàn chỉnh + Slide + Bản demo | ⬜ Chưa bắt đầu |
