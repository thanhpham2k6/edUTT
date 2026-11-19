# Kế hoạch Triển khai, Phân công Nhiệm vụ & Tác nhân Hệ thống (edUTT — Nhóm 1)

- **Trường:** Đại học Công nghệ Giao thông Vận tải (UTT)
- **Học phần:** Đồ án Cơ sở dữ liệu
- **Đề tài 1:** Nền tảng hỏi đáp học thuật và lưu trữ tri thức (**edUTT**)
- **Hệ QTCSDL & Công nghệ:** MongoDB (Docker) • Node.js, Express, TypeScript • Giao diện Web React
- **Mô hình & Định hướng:** Cộng đồng sinh viên trao đổi học thuật lẫn nhau • Tập trung thiết kế & tối ưu CSDL MongoDB (10 tuần)

---

## 1. Bảng phân công nhiệm vụ theo thành viên (Trọng tâm CSDL)

| STT | Họ và tên | Vai trò phụ trách | Nội dung công việc chi tiết |
| :-: | :--- | :--- | :--- |
| 1 | **Phạm Văn Thanh** | **Nhóm trưởng** — Cài đặt CSDL, Phân quyền & Sao lưu | • Cài đặt cụm cơ sở dữ liệu MongoDB trên Docker (1 máy chủ chính và 2 máy chủ dự phòng).<br>• Tạo tài khoản truy cập CSDL và phân quyền rõ ràng (`edutt_app_rw` được ghi dữ liệu, `edutt_report_ro` chỉ được xem báo cáo).<br>• Viết lệnh sao lưu dữ liệu định kỳ và phục hồi lại dữ liệu khi xảy ra lỗi xóa nhầm.<br>• Tổng hợp báo cáo Word, làm slide thuyết trình và điều phối nhóm. |
| 2 | **Bùi Văn Thắng** | **Thiết kế cấu trúc CSDL & Xử lý giao dịch** | • Thiết kế sơ đồ 6 bảng (Collection) lưu trữ dữ liệu: người dùng, môn học, tài liệu, câu hỏi, câu trả lời và lượt bình chọn.<br>• Thiết lập quy tắc kiểm tra dữ liệu đầu vào (`$jsonSchema`: không cho để trống mục bắt buộc, không cho điểm uy tín bị âm).<br>• Cài đặt xử lý giao dịch đồng bộ (Transaction) khi sinh viên bình chọn hoặc chốt đáp án đúng, tránh sai lệch khi nhiều người bấm cùng lúc. |
| 3 | **Nguyễn Hữu Trọng** | **Truy vấn thống kê & Tự động hóa CSDL** | • Viết các truy vấn tổng hợp để tạo 2 bảng thống kê tự động: Top 10 sinh viên tích cực và tỷ lệ câu hỏi đã có đáp án theo từng môn.<br>• Cài đặt cơ chế tự động chuyển tiêu đề tiếng Việt sang không dấu để dễ tìm kiếm và tự động cộng điểm uy tín khi tài liệu được duyệt.<br>• Viết lệnh cập nhật đồng loạt tên môn học ở các câu hỏi liên quan khi quản trị viên sửa tên môn. |
| 4 | **Nguyễn Quang Lương** | **Tối ưu tốc độ tìm kiếm & Kiểm thử dữ liệu** | • Tạo sẵn 100.000 – 500.000 dữ liệu mẫu (câu hỏi, tài liệu, người dùng) để kiểm tra khả năng chịu tải của CSDL.<br>• Đánh chỉ mục (Index) cho các trường hay tìm kiếm (tiêu đề, mã môn) và chặn lỗi một sinh viên bình chọn nhiều lần cho cùng một bài.<br>• Đo và so sánh tốc độ truy vấn trước và sau khi đánh chỉ mục để chứng minh hệ thống tìm kiếm nhanh hơn. |
| 5 | **Vũ Quốc Doanh** | **Kết nối dữ liệu & Giao diện chạy thử** | • Viết các hàm kết nối để thêm, xem, sửa, xóa (CRUD) dữ liệu giữa ứng dụng và cơ sở dữ liệu MongoDB.<br>• Làm giao diện web đơn giản phục vụ chạy thử: tìm kiếm câu hỏi/tài liệu, lọc theo môn học, bình chọn, chốt đáp án và xem bảng xếp hạng.<br>• Chạy thử toàn bộ chức năng và kiểm tra các trường hợp nhập sai dữ liệu trước khi bảo vệ đồ án. |

---

## 2. Các tác nhân (Actors) trong hệ thống edUTT

### 2.1. Hai nhóm người dùng chính (mô hình cộng đồng sinh viên tự hỗ trợ)

| Tác nhân | Vai trò chính | Các thao tác được phép thực hiện trên CSDL | Quy định & Ràng buộc dữ liệu |
| :--- | :--- | :--- | :--- |
| **1. Sinh viên (`STUDENT`)** | Thành viên cộng đồng học tập — vừa đặt câu hỏi, chia sẻ tài liệu, vừa giải đáp và đánh giá chéo lẫn nhau. | • Đăng, xem và sửa câu hỏi của chính mình gắn kèm mã môn học.<br>• Viết bình luận ngắn và đăng câu trả lời hỗ trợ các bạn sinh viên khác.<br>• Bấm bình chọn (thích/không thích) cho câu trả lời hữu ích và tự chốt đáp án chuẩn cho câu hỏi mình đăng.<br>• Tải tài liệu học tập lên chia sẻ và tìm kiếm tài liệu theo từ khóa hoặc mã môn. | • Câu trả lời được bình chọn nhiều và được người hỏi chốt đáp án chuẩn sẽ giúp sinh viên giải đáp tăng điểm uy tín.<br>• Tài liệu mới tải lên ở trạng thái chờ duyệt; sau khi được duyệt, hệ thống tự động cộng điểm uy tín cho sinh viên đóng góp.<br>• Không được tự bình chọn cho bài của mình; mỗi sinh viên chỉ được bình chọn 1 lần cho 1 bài. |
| **2. Quản trị viên (`ADMIN`)** | Sinh viên đại diện ban điều hành hệ thống — quản lý danh mục môn học, kiểm duyệt tài liệu và theo dõi thống kê. | • Quản lý danh mục môn học: Thêm mới hoặc sửa mã môn, tên môn.<br>• Kiểm duyệt tài liệu sinh viên tải lên (chấp nhận công khai hoặc từ chối tài liệu sai quy định).<br>• Quản lý tài khoản người dùng: Khóa/mở tài khoản vi phạm và xem các bảng báo cáo thống kê tổng hợp. | • Khi Quản trị viên sửa tên môn học, hệ thống tự động cập nhật lại tên môn mới cho tất cả câu hỏi đang gắn môn đó.<br>• Điểm uy tín của mọi tài khoản luôn được giữ lớn hơn hoặc bằng 0 (`reputation >= 0`). |

### 2.2. Hai tài khoản kỹ thuật truy cập trực tiếp CSDL MongoDB

| Tài khoản CSDL | Phạm vi quyền hạn & Mục đích bảo mật |
| :--- | :--- |
| **Tài khoản ứng dụng (`edutt_app_rw` — Quyền Đọc & Ghi)** | Dùng cho phần mềm Backend kết nối vào MongoDB; chỉ được phép thêm, xem, sửa, xóa dữ liệu trong cơ sở dữ liệu `edutt`, không có quyền xóa toàn bộ hệ thống. |
| **Tài khoản báo cáo (`edutt_report_ro` — Quyền Chỉ đọc)** | Dùng để xuất báo cáo và xem thống kê; chỉ được phép đọc dữ liệu từ 2 bảng thống kê tổng hợp, tuyệt đối không thể sửa hay xóa dữ liệu gốc. |

---

## 3. Bảng theo dõi tiến độ theo lộ trình 10 tuần

| Tuần | Công việc trọng tâm | Người thực hiện chính | Người phối hợp | Sản phẩm bàn giao | Trạng thái |
| :-: | :--- | :--- | :--- | :--- | :-: |
| **Tuần 1** | Tạo nhóm làm việc trên GitHub, cài đặt CSDL MongoDB trên Docker và chốt yêu cầu đề tài | Phạm Văn Thanh | Cả nhóm | Tài liệu yêu cầu + Docker chạy sẵn + GitHub repo | ✅ Hoàn thành |
| **Tuần 2** | Vẽ sơ đồ 6 bảng dữ liệu (câu hỏi, câu trả lời, tài liệu, người dùng, môn học, bình chọn) | Bùi Văn Thắng | Nguyễn Hữu Trọng | Sơ đồ thiết kế CSDL | ⬜ Chưa bắt đầu |
| **Tuần 3** | Khởi tạo cấu trúc các bảng trong MongoDB và cài đặt quy tắc kiểm tra dữ liệu đầu vào | Bùi Văn Thắng | Phạm Văn Thanh | Mã nguồn cấu trúc bảng | ⬜ Chưa bắt đầu |
| **Tuần 4** | Viết các chức năng thêm, xem, sửa, xóa dữ liệu cơ bản và phân quyền người dùng | Vũ Quốc Doanh | Phạm Văn Thanh | Bộ chức năng CRUD & Phân quyền | ⬜ Chưa bắt đầu |
| **Tuần 5** | Viết truy vấn thống kê Top sinh viên, tỷ lệ giải đáp theo môn và tự động cộng điểm uy tín | Nguyễn Hữu Trọng | Bùi Văn Thắng | Các bảng thống kê tự động | ⬜ Chưa bắt đầu |
| **Tuần 6** | Tạo 500.000 dữ liệu mẫu, đánh chỉ mục tìm kiếm và đo tốc độ truy vấn trước/sau tối ưu | Nguyễn Quang Lương | Bùi Văn Thắng | Bảng so sánh tốc độ tìm kiếm | ⬜ Chưa bắt đầu |
| **Tuần 7** | Cài đặt xử lý đồng bộ khi nhiều sinh viên bấm bình chọn hoặc chốt đáp án cùng lúc | Bùi Văn Thắng | Nguyễn Quang Lương | Kịch bản kiểm thử chạy đồng thời | ⬜ Chưa bắt đầu |
| **Tuần 8** | Hoàn thiện giao diện web đơn giản để chạy thử các chức năng và kiểm tra lỗi nhập liệu | Vũ Quốc Doanh | Nguyễn Quang Lương | Bản chạy thử hoàn chỉnh | ⬜ Chưa bắt đầu |
| **Tuần 9** | Viết lệnh sao lưu toàn bộ dữ liệu và chạy thử khôi phục dữ liệu khi gặp sự cố | Phạm Văn Thanh | Nguyễn Quang Lương | File sao lưu + Biên bản khôi phục | ⬜ Chưa bắt đầu |
| **Tuần 10** | Rà soát lại toàn bộ hệ thống, hoàn thiện báo cáo Word, làm slide và tập thuyết trình | Phạm Văn Thanh | Vũ Quốc Doanh & Cả nhóm | Báo cáo hoàn chỉnh + Slide + Demo | ⬜ Chưa bắt đầu |
