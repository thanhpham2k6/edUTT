# Script kiểm tra nhanh trạng thái cụm MongoDB Replica Set (edUTT - Tuần 1)
# Cách chạy: .\scripts\verify-replica-set.ps1

Write-Host "=== Kiểm tra container MongoDB Replica Set (edutt-mongo) ===" -ForegroundColor Cyan

$container = docker ps --filter "name=edutt-mongo" --format "{{.Names}}\t{{.Status}}"
if (-not $container) {
    Write-Host "[LỖI] Container edutt-mongo chưa chạy. Hãy chạy lệnh: docker compose up -d" -ForegroundColor Red
    exit 1
}

Write-Host "[OK] Container đang chạy: $container" -ForegroundColor Green

Write-Host "`n=== Trạng thái Replica Set (rs.status()) ===" -ForegroundColor Cyan
docker exec edutt-mongo mongosh --port 27017 --quiet --eval "
const st = rs.status();
print('Replica Set:', st.set);
st.members.forEach(m => print(' -', m.name, '| State:', m.stateStr, '| Health:', m.health));
"

Write-Host "`n=== Chuỗi kết nối khuyến nghị ===" -ForegroundColor Cyan
Write-Host "MONGO_URI=mongodb://localhost:27017/edutt_db?replicaSet=rs0" -ForegroundColor Yellow
