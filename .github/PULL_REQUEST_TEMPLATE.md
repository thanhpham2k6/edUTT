## Mô tả thay đổi
<!-- Mô tả ngắn gọn tính năng / bản sửa lỗi của PR này -->

## Phân hệ / Tuần thực hiện
- [ ] Tuần 1: Khảo sát yêu cầu, chốt mô hình, bảng phân công & Đề cương chi tiết
- [ ] Tuần 2: Sơ đồ Use Case, luồng nghiệp vụ chính & Thiết kế cấu trúc 6 bảng (Collection)
- [ ] Tuần 3: Cài đặt Docker MongoDB Replica Set, khởi tạo 6 bảng & Ràng buộc `$jsonSchema`, Unique Index
- [ ] Tuần 4: Nghiệp vụ CRUD các phân hệ & Phân quyền 2 lớp (RBAC & DB User `edutt_app_rw`, `edutt_report_ro`)
- [ ] Tuần 5: Nghiệp vụ tìm kiếm toàn văn tiếng Việt, lọc theo mã môn & sắp xếp câu trả lời
- [ ] Tuần 6: Giao dịch đồng bộ (Transaction) bình chọn/chốt đáp án & Tự động hóa CSDL (Hook, đồng bộ tên môn)
- [ ] Tuần 7: Truy vấn tổng hợp (Aggregation Pipeline) & 2 bảng thống kê tự động (Views)
- [ ] Tuần 8: Tạo 500.000 dữ liệu mẫu (`faker.js`), đánh Index & Đo đối chiếu hiệu năng `explain()`
- [ ] Tuần 9: Sao lưu/phục hồi dữ liệu (`mongodump`/`mongorestore`) & Hoàn thiện giao diện Web minh họa CSDL
- [ ] Tuần 10: Rà soát CSDL trên GitHub, Báo cáo Word/PDF, Slide & Kịch bản trình bày

## Checklist trước khi merge vào `dev`
- [ ] Code đã chạy thử không lỗi trên máy local
- [ ] Không commit file `.env`, `node_modules` hoặc file dump dữ liệu lớn
- [ ] Đã cập nhật tài liệu / migration (nếu có thay đổi Schema hoặc API)
- [ ] Ít nhất 1 thành viên khác đã review PR
