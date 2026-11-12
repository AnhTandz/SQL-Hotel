CREATE DATABASE QLDatPhongKhachSan
GO
USE QLDatPhongKhachSan
GO

-- Bảng Loại Phòng
CREATE TABLE LoaiPhong (
    MaLoai INT IDENTITY(1,1) PRIMARY KEY,
    TenLoai NVARCHAR(50) NOT NULL UNIQUE,
    DonGia DECIMAL(18,2) NOT NULL,
    MoTa NVARCHAR(500) NULL,
    CONSTRAINT CK_LoaiPhong_DonGia CHECK (DonGia >= 0)
)
GO

-- Them du lieu mau vao bang LoaiPhong
INSERT INTO LoaiPhong (TenLoai, DonGia, MoTa)
VALUES
(N'Phòng đơn', 300000, N'Phòng dành cho 1-2 người'),
(N'Phòng đôi', 500000, N'Phòng có sức chứa 2-3 người'),
(N'Phòng VIP', 1000000, N'Phòng cao cấp');

GO

-- Bảng Phòng
CREATE TABLE Phong (
    MaPhong INT IDENTITY(1,1) PRIMARY KEY,
    TenPhong NVARCHAR(50) NOT NULL UNIQUE,
    MaLoai INT NOT NULL,
    SucChua INT NOT NULL DEFAULT 2,
    TrangThai NVARCHAR(50) NOT NULL DEFAULT N'Trống',
    CONSTRAINT FK_Phong_LoaiPhong FOREIGN KEY (MaLoai) REFERENCES LoaiPhong(MaLoai),
    CONSTRAINT CK_Phong_SucChua CHECK (SucChua > 0),
    CONSTRAINT CK_Phong_TrangThai
        CHECK (TrangThai IN (N'Trống', N'Bảo trì', N'Ngừng kinh doanh'))
)
GO

-- Bảng Khách Hàng
CREATE TABLE KhachHang (
    MaKH INT IDENTITY(1,1) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    SoDienThoai VARCHAR(15) NULL,
    Email NVARCHAR(100) NULL,
    CONSTRAINT UQ_KhachHang_SoDienThoai UNIQUE (SoDienThoai)
)
GO

-- Bảng Booking (Đặt phòng)
CREATE TABLE Booking (
    MaBooking INT IDENTITY(1,1) PRIMARY KEY,
    MaKH INT NOT NULL,
    NgayDat DATETIME2(0) NOT NULL DEFAULT SYSDATETIME(),
    NgayNhan DATE NOT NULL,
    NgayTra DATE NOT NULL,
    TongTien DECIMAL(18,2) NOT NULL DEFAULT 0,
    TrangThai NVARCHAR(50) NOT NULL DEFAULT N'Chờ duyệt',
    CONSTRAINT FK_Booking_KhachHang FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH),
    CONSTRAINT CK_Booking_Ngay CHECK (NgayTra > NgayNhan),
    CONSTRAINT CK_Booking_TongTien CHECK (TongTien >= 0),
    CONSTRAINT CK_Booking_TrangThai
        CHECK (TrangThai IN (N'Chờ duyệt', N'Đã xác nhận', N'Đã hủy',
                             N'Đã nhận phòng', N'Đã trả phòng'))
)
GO

-- Bảng Chi tiết Booking (Liên kết giữa Booking và Phòng)
CREATE TABLE ChiTietBooking (
    MaBooking INT NOT NULL,
    MaPhong INT NOT NULL,
    DonGiaDat DECIMAL(18,2) NOT NULL,
    CONSTRAINT PK_ChiTietBooking PRIMARY KEY (MaBooking, MaPhong),
    CONSTRAINT FK_ChiTietBooking_Booking FOREIGN KEY (MaBooking) REFERENCES Booking(MaBooking),
    CONSTRAINT FK_ChiTietBooking_Phong FOREIGN KEY (MaPhong) REFERENCES Phong(MaPhong),
    CONSTRAINT CK_ChiTietBooking_DonGiaDat CHECK (DonGiaDat >= 0)
)
GO

/* 6. Bang DonGia: lich su gia theo loai phong va thoi gian */
CREATE TABLE DonGia (
    MaDonGia INT IDENTITY(1,1) PRIMARY KEY,
    MaLoai INT NOT NULL,
    DonGia DECIMAL(18,2) NOT NULL,
    NgayApDung DATE NOT NULL,
    NgayKetThuc DATE NULL,
    CONSTRAINT FK_DonGia_LoaiPhong FOREIGN KEY (MaLoai) REFERENCES LoaiPhong(MaLoai),
    CONSTRAINT CK_DonGia_DonGia CHECK (DonGia >= 0),
    CONSTRAINT CK_DonGia_Ngay CHECK (NgayKetThuc IS NULL OR NgayKetThuc >= NgayApDung)
)
GO

INSERT INTO Phong (TenPhong, MaLoai, SucChua, TrangThai)
VALUES
(N'P101', 1, 2, N'Trống'),
(N'P102', 1, 2, N'Trống'),
(N'P201', 2, 2, N'Trống'),
(N'P202', 2, 3, N'Trống'),
(N'P301', 3, 4, N'Trống')
GO

INSERT INTO KhachHang (HoTen, SoDienThoai, Email)
VALUES
(N'Nguyễn Văn An', '0900000001', N'an@example.com'),
(N'Trần Thị Bình', '0900000002', N'binh@example.com'),
(N'Lê Minh Châu', '0900000003', N'chau@example.com')
GO

INSERT INTO DonGia (MaLoai, DonGia, NgayApDung, NgayKetThuc)
VALUES
(1, 300000, '2026-01-01', NULL),
(2, 500000, '2026-01-01', NULL),
(3, 1000000, '2026-01-01', NULL)
GO

/* Tao booking mau cho phong P101 trong khoang 10-12/11/2026 */
INSERT INTO Booking (MaKH, NgayNhan, NgayTra, TongTien, TrangThai)
VALUES (1, '2026-11-10', '2026-11-12', 600000, N'Đã xác nhận')
GO

INSERT INTO ChiTietBooking (MaBooking, MaPhong, DonGiaDat)
VALUES (1, 3, 300000)
GO


/* 1. Danh sach phong va loai phong */
SELECT p.MaPhong, p.TenPhong, lp.TenLoai, lp.DonGia, p.TrangThai
FROM Phong p
JOIN LoaiPhong lp ON p.MaLoai = lp.MaLoai
WHERE p.TrangThai = N'Trống' AND p.MaLoai = 1
GO

/* 2. Xem chi tiet mot phong */
SELECT p.MaPhong, p.TenPhong, lp.TenLoai, lp.DonGia, p.TrangThai
FROM Phong p
JOIN LoaiPhong lp ON p.MaLoai = lp.MaLoai
WHERE p.MaPhong = 1
GO

/* 3. Tao booking moi (mau).
   Trong ung dung thuc te, can kiem tra trung lich truoc khi INSERT. */
INSERT INTO Booking (MaKH, NgayNhan, NgayTra, TongTien, TrangThai)
VALUES (2, '2026-11-15', '2026-11-17', 600000, N'Chờ duyệt')
GO

/* 4. Tim phong khong bi trung lich trong khoang ngay.
   Sua hai bien ngay neu muon thu khoang ngay khac. */
DECLARE @NgayNhan DATE = '2026-11-10';
DECLARE @NgayTra DATE = '2026-11-12';

SELECT p.MaPhong, p.TenPhong, lp.TenLoai, lp.DonGia, p.TrangThai
FROM Phong p
JOIN LoaiPhong lp ON p.MaLoai = lp.MaLoai
WHERE p.TrangThai = N'Trống'
  AND NOT EXISTS (
      SELECT 1
      FROM ChiTietBooking ct
      JOIN Booking b ON ct.MaBooking = b.MaBooking
      WHERE ct.MaPhong = p.MaPhong
        AND b.TrangThai IN (N'Chờ duyệt', N'Đã xác nhận', N'Đã nhận phòng')
        AND @NgayNhan < b.NgayTra
        AND @NgayTra > b.NgayNhan
  )
  AND @NgayTra > @NgayNhan
GO

/* 5. Kiem tra mot phong co bi trung lich hay khong */
DECLARE @MaPhong INT = 1;
DECLARE @NgayNhanKiemTra DATE = '2026-11-11';
DECLARE @NgayTraKiemTra DATE = '2026-11-13';

SELECT COUNT(*) AS SoLuongTrung,
       CASE WHEN COUNT(*) > 0 THEN N'Bị trùng lịch'
            ELSE N'Không bị trùng lịch' END AS KetQua
FROM ChiTietBooking ct
JOIN Booking b ON ct.MaBooking = b.MaBooking
WHERE ct.MaPhong = @MaPhong
  AND b.TrangThai IN (N'Chờ duyệt', N'Đã xác nhận', N'Đã nhận phòng')
  AND @NgayNhanKiemTra < b.NgayTra
  AND @NgayTraKiemTra > b.NgayNhan
  AND @NgayTraKiemTra > @NgayNhanKiemTra
GO

/* 6. Tinh lai TongTien tu gia da chot trong ChiTietBooking */
UPDATE b
SET TrangThai = N'Đã xác nhận',
    TongTien = DATEDIFF(DAY, b.NgayNhan, b.NgayTra) *
        ISNULL((
            SELECT SUM(ct.DonGiaDat)
            FROM ChiTietBooking ct
            WHERE ct.MaBooking = b.MaBooking
        ), 0)
FROM Booking b
WHERE b.MaBooking = 1
GO

/* 7. Xem booking kem thong tin khach va phong */
SELECT b.MaBooking, kh.HoTen, kh.SoDienThoai,
       b.NgayNhan, b.NgayTra, b.TongTien, b.TrangThai,
       p.MaPhong, p.TenPhong, ct.DonGiaDat
FROM Booking b
JOIN KhachHang kh ON b.MaKH = kh.MaKH
JOIN ChiTietBooking ct ON b.MaBooking = ct.MaBooking
JOIN Phong p ON ct.MaPhong = p.MaPhong
ORDER BY b.MaBooking
GO