USE QLDatPhongKhachSan;
GO

ALTER TABLE KhachHang
ADD MatKhauHash NVARCHAR(255) NULL;
GO

CREATE TABLE AdminUser
(
    MaAdmin INT IDENTITY(1,1) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    MatKhauHash NVARCHAR(255) NOT NULL
);
GO

INSERT INTO AdminUser (HoTen, Email, MatKhauHash)
VALUES (
    N'Quản trị viên',
    'admin@gmail.com',
    'TEMP_HASH'
);

SELECT 
    MaAdmin,
    HoTen,
    Email,
    LEFT(MatKhauHash, 20) AS KiemTraMatKhau
FROM AdminUser;

DELETE FROM AdminUser
WHERE Email = 'admin@gmail.com';

SELECT MaAdmin, HoTen, Email,
       LEFT(MatKhauHash, 20) AS KiemTraMatKhau
FROM AdminUser;

