# Kế hoạch Triển khai, Phân công Nhiệm vụ & Tác nhân Hệ thống (edUTT — Nhóm 1)

- **Trường:** Đại học Công nghệ Giao thông Vận tải (UTT)
- **Học phần:** Đồ án Cơ sở dữ liệu
- **Đề tài 1:** Xây dựng nền tảng hỏi đáp học thuật và lưu trữ tri thức (**edUTT**)
- **Hệ QTCSDL & Công nghệ:** MongoDB Replica Set (1 Primary, 2 Secondary qua Docker Compose) • Node.js, Express, TypeScript, Mongoose • React (giao diện minh họa CSDL) • `migrate-mongo`, `faker.js` • GitHub
- **Công cụ AI hỗ trợ:** Gemini, GPT, Claude, DeepSeek
- **Chuẩn đầu ra & Tiến độ:** Đáp ứng đầy đủ CLO1 – CLO7 | Lộ trình 10 tuần (**Tiến độ hiện tại: Tuần 2** — Thiết kế sơ đồ Use Case & cấu trúc 6 Collection)

---

## 1. Bảng phân công nhiệm vụ 5 thành viên Nhóm 1

| STT | Họ và tên | GPA | Vai trò phụ trách | Trọng tâm công việc chuyên sâu về CSDL |
| :-: | :--- | :-: | :--- | :--- |
| 1 | **Phạm Văn Thanh** (Nhóm trưởng) | 3.43 | **Phân tích sơ đồ, Hạ tầng & Phân quyền CSDL** | Vẽ sơ đồ Use Case, luồng nghiệp vụ chính; cài đặt MongoDB trên Docker (1 Primary, 2 Secondary); tạo tài khoản & phân quyền CSDL (`edutt_app_rw`, `edutt_report_ro`); sao lưu/phục hồi dữ liệu; tổng hợp báo cáo Word/PDF, slide. |
| 2 | **Bùi Văn Thắng** | 3.32 | **Thiết kế sơ đồ CSDL & Ràng buộc dữ liệu** | Vẽ sơ đồ quan hệ thực thể và thiết kế chi tiết cấu trúc 6 bảng (Collection); phân định dữ liệu nhúng (`short_comments`, `subject_tags`) vs. tham chiếu (`answers`, `documents`, `votes`); cài đặt quy tắc ràng buộc đầu vào (`$jsonSchema`, điểm uy tín ≥ 0). |
| 3 | **Nguyễn Hữu Trọng** | 3.18 | **Nghiệp vụ giao dịch & Tự động hóa CSDL** | Cài đặt giao dịch đồng bộ (Transaction) khi bình chọn/chốt đáp án chuẩn; tự động cộng điểm uy tín khi duyệt tài liệu, chuyển tiêu đề không dấu (`search_normalized`) và đồng bộ tên môn học (`updateMany`). |
| 4 | **Nguyễn Quang Lương** | 3.13 | **Nghiệp vụ thống kê & Tối ưu tốc độ CSDL** | Viết truy vấn tổng hợp (Aggregation Pipeline) tạo 2 bảng thống kê tự động (Top 10 sinh viên tích cực, tỷ lệ giải đáp theo môn); tạo 100.000 – 500.000 dữ liệu mẫu (`faker.js`); đánh chỉ mục (Index) và đo đối chiếu tốc độ (`explain()`). |
| 5 | **Vũ Quốc Doanh** | 2.82 | **Nghiệp vụ truy xuất dữ liệu & Giao diện minh họa** | Xây dựng nghiệp vụ thêm, xem, sửa, xóa dữ liệu (CRUD) cho các phân hệ; tìm kiếm toàn văn tiếng Việt, lọc theo mã môn, sắp xếp câu trả lời và làm giao diện web React minh họa CSDL. |

---

## 2. Các tác nhân (Actors) trong hệ thống edUTT

### 2.1. Hai nhóm người dùng chính (mô hình cộng đồng sinh viên tự hỗ trợ)

| Tác nhân | Vai trò chính | Các thao tác được phép thực hiện trên CSDL | Quy định & Ràng buộc dữ liệu |
| :--- | :--- | :--- | :--- |
| **1. Sinh viên (`STUDENT`)** | Thành viên cộng đồng học tập — vừa đặt câu hỏi, chia sẻ tài liệu, vừa giải đáp và đánh giá chéo lẫn nhau. | • Đăng, xem và sửa câu hỏi của chính mình gắn kèm mã môn học.<br>• Viết bình luận ngắn (`$push`/`$pull`) và đăng câu trả lời hỗ trợ các bạn sinh viên khác.<br>• Bấm bình chọn (thích/không thích) cho câu trả lời hữu ích và tự chốt đáp án chuẩn cho câu hỏi mình đăng.<br>• Tải tài liệu học tập lên chia sẻ và tìm kiếm tài liệu theo từ khóa hoặc mã môn. | • Cơ chế cộng đồng tự đánh giá: câu trả lời được bình chọn nhiều và được người hỏi chốt đáp án chuẩn sẽ giúp sinh viên giải đáp tăng điểm uy tín.<br>• Tài liệu mới tải lên ở trạng thái chờ duyệt (`pending`); sau khi được duyệt (`approved`), hệ thống tự động cộng điểm uy tín cho sinh viên đóng góp.<br>• Không được tự bình chọn cho bài của mình; mỗi sinh viên chỉ được bình chọn 1 lần cho 1 bài. |
| **2. Quản trị viên (`ADMIN`)** | Sinh viên đại diện ban điều hành hệ thống — quản lý danh mục môn học, kiểm duyệt tài liệu và theo dõi thống kê. | • Quản lý danh mục môn học: Thêm mới hoặc sửa mã môn, tên môn.<br>• Kiểm duyệt tài liệu sinh viên tải lên (chấp nhận công khai hoặc từ chối tài liệu sai quy định).<br>• Quản lý tài khoản người dùng: Khóa/mở tài khoản vi phạm và xem các bảng báo cáo thống kê tổng hợp. | • Khi Quản trị viên sửa tên môn học, hệ thống tự động cập nhật lại tên môn mới cho tất cả câu hỏi đang gắn môn đó (`updateMany()`).<br>• Điểm uy tín của mọi tài khoản luôn được giữ lớn hơn hoặc bằng 0 (`reputation >= 0`). |

### 2.2. Hai tài khoản kỹ thuật truy cập trực tiếp CSDL MongoDB

| Tài khoản CSDL | Phạm vi quyền hạn & Mục đích bảo mật |
| :--- | :--- |
| **Tài khoản ứng dụng (`edutt_app_rw` — Quyền Đọc & Ghi)** | Dùng cho phần mềm Backend kết nối vào MongoDB; chỉ được phép thêm, xem, sửa, xóa dữ liệu trong cơ sở dữ liệu `edutt`, không có quyền xóa toàn bộ hệ thống. |
| **Tài khoản báo cáo (`edutt_report_ro` — Quyền Chỉ đọc)** | Dùng để xuất báo cáo và xem thống kê; chỉ được phép đọc dữ liệu từ 2 bảng thống kê tổng hợp (`v_top_contributors`, `v_subject_knowledge_stats`), tuyệt đối không thể sửa hay xóa dữ liệu gốc. |

---

## 3. Kế hoạch triển khai và bàn giao sản phẩm (10 tuần)

| Tuần | CLO | Người phụ trách | Công việc trọng tâm | Sản phẩm bàn giao | Trạng thái |
| :-: | :--- | :--- | :--- | :--- | :-: |
| **Tuần 1** | CLO1, CLO7 | Phạm Văn Thanh & Cả nhóm | Khảo sát yêu cầu đề tài edUTT, chốt mô hình cộng đồng sinh viên tự hỗ trợ, phân công nhiệm vụ 5 thành viên và hoàn thiện Đề cương chi tiết. | Đề cương chi tiết & Bảng phân công | ✅ Đã hoàn thành |
| **Tuần 2** | CLO1, CLO2 | Phạm Văn Thanh, Bùi Văn Thắng | Vẽ sơ đồ Use Case, luồng nghiệp vụ chính; vẽ sơ đồ quan hệ thực thể và thiết kế chi tiết cấu trúc 6 bảng dữ liệu (Collection). | Sơ đồ Use Case & Sơ đồ thiết kế 6 bảng | 🔄 Đang thực hiện |
| **Tuần 3** | CLO2, CLO6 | Bùi Văn Thắng, Phạm Văn Thanh | Cài đặt cụm MongoDB Replica Set trên Docker; khởi tạo 6 bảng và cài đặt quy tắc ràng buộc dữ liệu đầu vào (`$jsonSchema`, Unique Index). | Môi trường Docker & Cấu trúc bảng CSDL | ⬜ Kế hoạch |
| **Tuần 4** | CLO5, CLO6 | Vũ Quốc Doanh, Phạm Văn Thanh | Xây dựng nghiệp vụ thêm, xem, sửa, xóa dữ liệu (CRUD) cho hỏi đáp, tài liệu, môn học và cấu hình phân quyền 2 lớp (RBAC & DB User). | Bộ nghiệp vụ CRUD & Phân quyền DB | ⬜ Kế hoạch |
| **Tuần 5** | CLO3 | Vũ Quốc Doanh, Nguyễn Quang Lương | Xây dựng nghiệp vụ tìm kiếm toàn văn tiếng Việt (có dấu/không dấu), lọc theo mã môn và sắp xếp câu trả lời theo lượt bình chọn. | Nghiệp vụ tìm kiếm & Lọc dữ liệu | ⬜ Kế hoạch |
| **Tuần 6** | CLO5 | Nguyễn Hữu Trọng, Bùi Văn Thắng | Cài đặt giao dịch đồng bộ (Transaction) khi bình chọn/chốt đáp án; tự động cộng điểm uy tín khi duyệt bài và đồng bộ tên môn học. | Xử lý giao dịch & Tự động hóa CSDL | ⬜ Kế hoạch |
| **Tuần 7** | CLO3 | Nguyễn Quang Lương, Nguyễn Hữu Trọng | Viết truy vấn tổng hợp (Aggregation Pipeline) tạo 2 bảng thống kê tự động: Top 10 sinh viên tích cực và tỷ lệ giải đáp theo môn. | 2 bảng thống kê tổng hợp (Views) | ⬜ Kế hoạch |
| **Tuần 8** | CLO4 | Nguyễn Quang Lương, Bùi Văn Thắng | Tạo 500.000 dữ liệu mẫu giả lập (`faker.js`), đánh chỉ mục tìm kiếm (Index) và đo đối chiếu tốc độ truy vấn trước/sau bằng `explain()`. | Báo cáo tối ưu tốc độ truy vấn | ⬜ Kế hoạch |
| **Tuần 9** | CLO5 | Phạm Văn Thanh, Vũ Quốc Doanh | Viết lệnh sao lưu dữ liệu định kỳ (`mongodump`), diễn tập phục hồi sự cố (`mongorestore`) và hoàn thiện giao diện Web minh họa CSDL. | File sao lưu & Giao diện minh họa | ⬜ Kế hoạch |
| **Tuần 10** | CLO7 | Phạm Văn Thanh & Cả nhóm | Rà soát toàn bộ CSDL trên GitHub, hoàn thiện báo cáo Word/PDF, thiết kế slide và chạy thử kịch bản trình bày bảo vệ đồ án. | Báo cáo hoàn chỉnh + Slide + Demo | ⬜ Kế hoạch |
