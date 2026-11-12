USE QLDatPhongKhachSan;
GO

-- Thêm cột ảnh đại diện vào LoaiPhong nếu chưa có
IF COL_LENGTH('dbo.LoaiPhong', 'AnhDaiDien') IS NULL
BEGIN
    ALTER TABLE dbo.LoaiPhong
    ADD AnhDaiDien NVARCHAR(255) NULL;
END
GO

-- Tạo bảng lưu nhiều ảnh chi tiết
IF OBJECT_ID('dbo.HinhAnhLoaiPhong', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.HinhAnhLoaiPhong
    (
        MaHinhAnh INT IDENTITY(1,1) PRIMARY KEY,
        MaLoai INT NOT NULL,
        TenHinhAnh NVARCHAR(255) NOT NULL,

        CONSTRAINT FK_HinhAnhLoaiPhong_LoaiPhong
        FOREIGN KEY (MaLoai)
        REFERENCES dbo.LoaiPhong(MaLoai)
    );
END
GO

-- Xóa bảng lưu ảnh của loại phòng
IF OBJECT_ID('dbo.HinhAnhLoaiPhong', 'U') IS NOT NULL
BEGIN
    DROP TABLE dbo.HinhAnhLoaiPhong;
END
GO

-- Xóa cột ảnh đại diện khỏi LoaiPhong
IF COL_LENGTH('dbo.LoaiPhong', 'AnhDaiDien') IS NOT NULL
BEGIN
    ALTER TABLE dbo.LoaiPhong
    DROP COLUMN AnhDaiDien;
END
GO

-- Thêm ảnh đại diện vào bảng Phong
IF COL_LENGTH('dbo.Phong', 'AnhDaiDien') IS NULL
BEGIN
    ALTER TABLE dbo.Phong
    ADD AnhDaiDien NVARCHAR(255) NULL;
END
GO

-- Tạo bảng lưu nhiều ảnh của từng phòng
IF OBJECT_ID('dbo.HinhAnhPhong', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.HinhAnhPhong
    (
        MaHinhAnh INT IDENTITY(1,1) PRIMARY KEY,
        MaPhong INT NOT NULL,
        TenHinhAnh NVARCHAR(255) NOT NULL,

        CONSTRAINT FK_HinhAnhPhong_Phong
        FOREIGN KEY (MaPhong)
        REFERENCES dbo.Phong(MaPhong)
    );
END
GO

-- Kiểm tra cột ảnh đại diện trong LoaiPhong
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'LoaiPhong';

-- Kiểm tra bảng ảnh của LoaiPhong
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME = 'HinhAnhLoaiPhong';

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN (
    'Booking',
    'ChiTietBooking',
    'KhachHang',
    'DonGia'
)
ORDER BY TABLE_NAME, ORDINAL_POSITION;


SELECT * FROM AdminUser;

SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Phong'
ORDER BY ORDINAL_POSITION;

ALTER TABLE Phong
ADD DiaDiem NVARCHAR(100) NULL,
    TenKhachSan NVARCHAR(150) NULL;
GO

SELECT * FROM Phong;

-- Kiểm tra cấu trúc bảng Booking
SELECT
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Booking'
ORDER BY ORDINAL_POSITION;


-- Kiểm tra cấu trúc bảng ChiTietBooking
SELECT
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ChiTietBooking'
ORDER BY ORDINAL_POSITION;

SELECT * FROM Booking;

SELECT * FROM ChiTietBooking;

-- Tạo bảng KhachSan
IF OBJECT_ID('dbo.KhachSan', 'U') IS NULL
BEGIN
    CREATE TABLE KhachSan
    (
        MaKhachSan INT IDENTITY(1,1) PRIMARY KEY,
        TenKhachSan NVARCHAR(150) NOT NULL,
        TinhThanh NVARCHAR(100) NOT NULL,
        DiaChi NVARCHAR(255) NULL,
        MoTa NVARCHAR(MAX) NULL,
        AnhDaiDien NVARCHAR(255) NULL
    );
END
GO

-- Thêm MaKhachSan vào bảng Phong
IF COL_LENGTH('dbo.Phong', 'MaKhachSan') IS NULL
BEGIN
    ALTER TABLE Phong
    ADD MaKhachSan INT NULL;
END
GO

-- Tạo khóa ngoại liên kết Phong với KhachSan
IF NOT EXISTS
(
    SELECT 1
    FROM sys.foreign_keys
    WHERE name = 'FK_Phong_KhachSan'
)
BEGIN
    ALTER TABLE Phong
    ADD CONSTRAINT FK_Phong_KhachSan
    FOREIGN KEY (MaKhachSan)
    REFERENCES KhachSan(MaKhachSan);
END
GO

SELECT * FROM KhachSan;

SELECT * FROM Phong;


INSERT INTO KhachSan
(
    TenKhachSan,
    TinhThanh,
    DiaChi,
    MoTa,
    AnhDaiDien
)
VALUES
(
    N'Dalat Palace Hotel',
    N'Đà Lạt',
    N'02 Trần Phú, Đà Lạt, Lâm Đồng',
    N'Khách sạn nghỉ dưỡng tại trung tâm Đà Lạt.',
    NULL
),
(
    N'Saigon Central Hotel',
    N'TP. Hồ Chí Minh',
    N'Quận 1, TP. Hồ Chí Minh',
    N'Khách sạn nằm tại trung tâm thành phố.',
    NULL
),
(
    N'Vung Tau Beach Hotel',
    N'Vũng Tàu',
    N'Đường Thùy Vân, Vũng Tàu',
    N'Khách sạn gần biển, thuận tiện nghỉ dưỡng.',
    NULL
),
(
    N'Nha Trang Ocean Hotel',
    N'Nha Trang',
    N'TP. Nha Trang, Khánh Hòa',
    N'Khách sạn nghỉ dưỡng gần bãi biển.',
    NULL
),
(
    N'Da Nang Riverside Hotel',
    N'Đà Nẵng',
    N'Quận Hải Châu, Đà Nẵng',
    N'Khách sạn gần khu vực sông Hàn.',
    NULL
);
GO

-- Kiểm tra danh sách khách sạn
SELECT * FROM KhachSan;

-- Kiểm tra danh sách phòng
SELECT * FROM Phong;

UPDATE Phong
SET MaKhachSan = 1
WHERE MaPhong IN (2, 3);

UPDATE Phong
SET MaKhachSan = 2
WHERE MaPhong IN (4, 5);

UPDATE Phong
SET MaKhachSan = 3
WHERE MaPhong IN (6, 7);
GO

SELECT
    p.MaPhong,
    p.TenPhong,
    p.MaKhachSan,
    ks.TenKhachSan,
    ks.TinhThanh
FROM Phong p
LEFT JOIN KhachSan ks
    ON p.MaKhachSan = ks.MaKhachSan;

SELECT
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Phong';

SELECT TOP 5 * FROM Booking;

SELECT TOP 5 * FROM ChiTietBooking;

SELECT * FROM LoaiPhong;

-- Kiểm tra bảng DonGia có tồn tại không
IF OBJECT_ID('dbo.DonGia', 'U') IS NOT NULL
BEGIN
    SELECT * FROM DonGia;
END
ELSE
BEGIN
    PRINT N'Chưa có bảng DonGia';
END

SELECT
    p.MaPhong,
    p.TenPhong,
    p.MaLoai,
    lp.TenLoai,
    lp.DonGia AS GiaMacDinh,
    p.SucChua,
    p.TrangThai,
    ks.TenKhachSan,
    ks.TinhThanh
FROM Phong p
LEFT JOIN LoaiPhong lp
    ON p.MaLoai = lp.MaLoai
LEFT JOIN KhachSan ks
    ON p.MaKhachSan = ks.MaKhachSan;

-- Kiểm tra cấu trúc bảng Booking
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Booking';

-- Kiểm tra cấu trúc bảng ChiTietBooking
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ChiTietBooking';

-- Kiểm tra cấu trúc bảng DonGia
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'DonGia';

-- Kiểm tra các trạng thái Booking đang có
SELECT DISTINCT TrangThai
FROM Booking;

SELECT
    COLUMN_NAME,
    COLUMNPROPERTY(
        OBJECT_ID('dbo.Booking'),
        COLUMN_NAME,
        'IsIdentity'
    ) AS IsIdentity
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Booking'
  AND COLUMN_NAME = 'MaBooking';