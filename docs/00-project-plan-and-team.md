# Kế hoạch Triển khai, Phân công Nhiệm vụ & Tác nhân Hệ thống (edUTT — Nhóm 1)

- **Trường:** Đại học Công nghệ Giao thông Vận tải (UTT)
- **Học phần:** Đồ án Cơ sở dữ liệu
- **Đề tài 1:** Nền tảng hỏi đáp học thuật và lưu trữ tri thức (**edUTT**)
- **Hệ QTCSDL & Công nghệ:** MongoDB (Docker) • Node.js, Express, TypeScript • Giao diện Web React
- **Mô hình & Định hướng:** Cộng đồng sinh viên trao đổi học thuật lẫn nhau • Tập trung thiết kế sơ đồ & nghiệp vụ CSDL MongoDB (10 tuần)

---

## 1. Bảng phân công nhiệm vụ theo thành viên (Trọng tâm CSDL)

| STT | Họ và tên | Vai trò phụ trách | Nội dung công việc chi tiết | Điểm GPA |
| :-: | :--- | :--- | :--- | :-: |
| 1 | **Phạm Văn Thanh** | **Nhóm trưởng** — Phân tích sơ đồ, Hạ tầng & Phân quyền CSDL | • Khảo sát yêu cầu thực tế, xác định tác nhân người dùng và vẽ sơ đồ Use Case, sơ đồ luồng nghiệp vụ chính của hệ thống.<br>• Cài đặt cụm cơ sở dữ liệu MongoDB trên Docker (1 máy chủ chính và 2 máy chủ dự phòng).<br>• Tạo tài khoản truy cập CSDL, phân quyền rõ ràng (`edutt_app_rw`, `edutt_report_ro`) và viết lệnh sao lưu/phục hồi dữ liệu.<br>• Tổng hợp báo cáo Word, làm slide thuyết trình và điều phối chung cả nhóm. | 3.43 |
| 2 | **Bùi Văn Thắng** | **Thiết kế sơ đồ CSDL & Ràng buộc dữ liệu** | • Vẽ sơ đồ quan hệ thực thể và thiết kế chi tiết cấu trúc 6 bảng (Collection): người dùng, môn học, tài liệu, câu hỏi, câu trả lời và lượt bình chọn.<br>• Phân định rõ dữ liệu nào nhúng chung (bình luận ngắn, thẻ môn học) và dữ liệu nào tách bảng tham chiếu để tối ưu lưu trữ.<br>• Thiết lập các quy tắc ràng buộc dữ liệu đầu vào (bắt buộc nhập các trường chính, kiểm tra trùng email/mã sinh viên, không cho điểm uy tín bị âm). | 3.32 |
| 3 | **Nguyễn Hữu Trọng** | **Nghiệp vụ giao dịch & Tự động hóa CSDL** | • Cài đặt nghiệp vụ xử lý giao dịch đồng bộ (Transaction) khi sinh viên bấm bình chọn hoặc chốt đáp án chuẩn, đảm bảo cập nhật chính xác đồng thời trên nhiều bảng.<br>• Cài đặt cơ chế tự động hóa trong CSDL: tự động cộng điểm uy tín khi tài liệu được duyệt và tự động chuyển tiêu đề tiếng Việt sang không dấu để dễ tìm kiếm.<br>• Cài đặt nghiệp vụ đồng bộ dữ liệu: tự động cập nhật lại tên môn học ở tất cả câu hỏi liên quan khi quản trị viên sửa tên môn. | 3.18 |
| 4 | **Nguyễn Quang Lương** | **Nghiệp vụ thống kê & Tối ưu tốc độ CSDL** | • Viết các truy vấn tổng hợp để tạo 2 bảng thống kê tự động: Top 10 sinh viên tích cực và tỷ lệ câu hỏi đã có đáp án theo từng môn.<br>• Tạo tập dữ liệu mẫu quy mô lớn (100.000 – 500.000 bản ghi) mô phỏng dữ liệu thực tế phục vụ phân tích hiệu năng truy vấn.<br>• Đánh chỉ mục (Index) cho các trường hay tìm kiếm (tiêu đề, mã môn), chặn lỗi một sinh viên bình chọn nhiều lần cho cùng một bài và so sánh tốc độ truy vấn. | 3.13 |
| 5 | **Vũ Quốc Doanh** | **Nghiệp vụ truy xuất dữ liệu & Giao diện minh họa** | • Xây dựng các nghiệp vụ thêm, xem, sửa, xóa dữ liệu (CRUD) cho từng phân hệ: quản lý tài khoản, danh mục môn học, hỏi đáp học thuật và kho tài liệu.<br>• Xây dựng nghiệp vụ tìm kiếm toàn văn tiếng Việt (có dấu/không dấu), lọc câu hỏi theo mã môn và sắp xếp câu trả lời theo lượt bình chọn.<br>• Làm giao diện web đơn giản kết nối trực tiếp với CSDL để minh họa trực quan các nghiệp vụ và bảng thống kê khi bảo vệ đồ án. | 2.82 |

---

## 2. Các tác nhân (Actors) trong hệ thống edUTT

### 2.1. Hai nhóm người dùng chính (mô hình cộng đồng sinh viên tự hỗ trợ)

| Tác nhân | Vai trò chính | Các thao tác được phép thực hiện trên CSDL | Quy định & Ràng buộc dữ liệu |
| :--- | :--- | :--- | :--- |
| **1. Sinh viên (`STUDENT`)** | Thành viên cộng đồng học tập — vừa đặt câu hỏi, chia sẻ tài liệu, vừa giải đáp và đánh giá chéo lẫn nhau. | • Đăng, xem và sửa câu hỏi của chính mình gắn kèm mã môn học.<br>• Viết bình luận ngắn và đăng câu trả lời hỗ trợ các bạn sinh viên khác.<br>• Bấm bình chọn (thích/không thích) cho câu trả lời hữu ích và tự chốt đáp án chuẩn cho câu hỏi mình đăng.<br>• Tải tài liệu học tập lên chia sẻ và tìm kiếm tài liệu theo từ khóa hoặc mã môn. | • Cơ chế cộng đồng tự đánh giá: câu trả lời được bình chọn nhiều và được người hỏi chốt đáp án chuẩn sẽ giúp sinh viên giải đáp tăng điểm uy tín.<br>• Tài liệu mới tải lên ở trạng thái chờ duyệt; sau khi được duyệt, hệ thống tự động cộng điểm uy tín cho sinh viên đóng góp.<br>• Không được tự bình chọn cho bài của mình; mỗi sinh viên chỉ được bình chọn 1 lần cho 1 bài. |
| **2. Quản trị viên (`ADMIN`)** | Sinh viên đại diện ban điều hành hệ thống — quản lý danh mục môn học, kiểm duyệt tài liệu và theo dõi thống kê. | • Quản lý danh mục môn học: Thêm mới hoặc sửa mã môn, tên môn.<br>• Kiểm duyệt tài liệu sinh viên tải lên (chấp nhận cho hiển thị công khai hoặc từ chối tài liệu sai quy định).<br>• Quản lý tài khoản người dùng: Khóa/mở tài khoản vi phạm và xem các bảng báo cáo thống kê tổng hợp. | • Khi Quản trị viên sửa tên môn học, hệ thống tự động cập nhật lại tên môn mới cho tất cả câu hỏi đang gắn môn đó.<br>• Điểm uy tín của mọi tài khoản luôn được giữ lớn hơn hoặc bằng 0 (`reputation >= 0`). |

### 2.2. Hai tài khoản kỹ thuật truy cập trực tiếp CSDL MongoDB

| Tài khoản CSDL | Phạm vi quyền hạn & Mục đích bảo mật |
| :--- | :--- |
| **Tài khoản ứng dụng (`edutt_app_rw` — Quyền Đọc & Ghi)** | Dùng cho phần mềm Backend kết nối vào MongoDB; chỉ được phép thêm, xem, sửa, xóa dữ liệu trong cơ sở dữ liệu `edutt`, không có quyền xóa toàn bộ hệ thống. |
| **Tài khoản báo cáo (`edutt_report_ro` — Quyền Chỉ đọc)** | Dùng để xuất báo cáo và xem thống kê; chỉ được phép đọc dữ liệu từ 2 bảng thống kê tổng hợp, tuyệt đối không thể sửa hay xóa dữ liệu gốc. |

---

## 3. Bảng theo dõi tiến độ theo lộ trình 10 tuần

| Tuần | Công việc trọng tâm | Người thực hiện chính | Người phối hợp | Sản phẩm bàn giao | Trạng thái |
| :-: | :--- | :--- | :--- | :--- | :-: |
| **Tuần 1** | Khảo sát yêu cầu, xác định tác nhân, vẽ sơ đồ Use Case và cài đặt CSDL MongoDB trên Docker | Phạm Văn Thanh | Cả nhóm | Sơ đồ Use Case + Docker chạy sẵn | ✅ Hoàn thành |
| **Tuần 2** | Vẽ sơ đồ quan hệ thực thể và thiết kế chi tiết cấu trúc 6 bảng dữ liệu (người dùng, môn học, tài liệu, câu hỏi, câu trả lời, bình chọn) | Bùi Văn Thắng | Nguyễn Hữu Trọng | Sơ đồ thiết kế 6 bảng CSDL | ⬜ Chưa bắt đầu |
| **Tuần 3** | Khởi tạo các bảng trong MongoDB và cài đặt quy tắc ràng buộc dữ liệu đầu vào (bắt buộc nhập, điểm uy tín >= 0) | Bùi Văn Thắng | Phạm Văn Thanh | Cấu trúc bảng & Ràng buộc dữ liệu | ⬜ Chưa bắt đầu |
| **Tuần 4** | Xây dựng nghiệp vụ thêm, xem, sửa, xóa dữ liệu (CRUD) cho hỏi đáp, tài liệu, môn học và phân quyền CSDL | Vũ Quốc Doanh | Phạm Văn Thanh | Bộ nghiệp vụ CRUD & Phân quyền DB | ⬜ Chưa bắt đầu |
| **Tuần 5** | Xây dựng nghiệp vụ tìm kiếm toàn văn tiếng Việt, lọc theo mã môn và sắp xếp câu trả lời theo lượt bình chọn | Vũ Quốc Doanh | Nguyễn Quang Lương | Nghiệp vụ tìm kiếm & Lọc dữ liệu | ⬜ Chưa bắt đầu |
| **Tuần 6** | Cài đặt nghiệp vụ giao dịch đồng bộ (Transaction) khi bình chọn/chốt đáp án và tự động cộng điểm uy tín, đồng bộ tên môn | Nguyễn Hữu Trọng | Bùi Văn Thắng | Xử lý giao dịch & Tự động hóa CSDL | ⬜ Chưa bắt đầu |
| **Tuần 7** | Viết truy vấn tổng hợp tạo 2 bảng thống kê tự động (Top 10 sinh viên tích cực, tỷ lệ giải đáp theo môn) | Nguyễn Quang Lương | Nguyễn Hữu Trọng | 2 bảng thống kê tổng hợp (Views) | ⬜ Chưa bắt đầu |
| **Tuần 8** | Tạo 500.000 dữ liệu mẫu, đánh chỉ mục tìm kiếm (Index) và đo đối chiếu tốc độ truy vấn trước/sau tối ưu | Nguyễn Quang Lương | Bùi Văn Thắng | Báo cáo tối ưu tốc độ truy vấn | ⬜ Chưa bắt đầu |
| **Tuần 9** | Viết lệnh sao lưu dữ liệu định kỳ, diễn tập phục hồi sự cố và hoàn thiện giao diện minh họa CSDL | Phạm Văn Thanh | Vũ Quốc Doanh | File sao lưu + Giao diện minh họa | ⬜ Chưa bắt đầu |
| **Tuần 10** | Rà soát toàn bộ CSDL, hoàn thiện báo cáo Word, thiết kế slide và chạy thử kịch bản trình bày | Phạm Văn Thanh | Cả nhóm | Báo cáo hoàn chỉnh + Slide + Demo | ⬜ Chưa bắt đầu |
