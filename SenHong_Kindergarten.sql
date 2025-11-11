create database SenHong_Kindergarten;
use SenHong_Kindergarten;

--1. Bảng VAI TRÒ
create table VAITRO(
	MaVT varchar(10) constraint pk_vt primary key not null,
	TenVT nvarchar(30)
);

--2. Bảng NHÂN VIÊN
create table NHANVIEN(
	MaNV varchar(10) constraint pk_nv primary key not null,
	HoNV nvarchar(10),
	TenNV nvarchar(30),
	GioiTinh bit,
	NgaySinh DateTime default GetDate(),
	CCCD varchar(15),
	DiaChi nvarchar(100),
	Email varchar(100),
	MatKhau varchar(100),
	Sdt varchar(10),
	MaVT varchar(10) constraint fk_nv_vt foreign key(MaVT) references VAITRO(MaVT)
);

--3. Bảng CHẤM CÔNG
create table CHAMCONG(
	MaNV varchar(10) constraint fk_cc_nv foreign key(MaNV) references NHANVIEN(MaNV),
	NgayChamCong DateTime default GetDate(),
	TrangThai bit,
	GhiChu nvarchar(500),
	constraint pk_cc primary key(MaNV, NgayChamCong)
);

--4. Bảng BẢNG LƯƠNG
create table BANGLUONG (
	MaBangLuong varchar(10) constraint pk_bl primary key not null,
	HeSoLuong decimal(10,2),
	ThoiGianBD Date,
	ThoiGianKT Date,
	LuongCoBan int
);

--5. Bảng LƯƠNG NHÂN VIÊN
create table LUONGNHANVIEN (
	MaNV varchar(10),
	MaBangLuong varchar(10),
	ThoiGianTinhLuong DateTime,
	SoNgayCong int,
	constraint fk_lnv_nv foreign key (MaNV) references NHANVIEN(MaNV),
	constraint fk_lnv_bl foreign key (MaBangLuong) references BANGLUONG(MaBangLuong),
	constraint pk_lnv primary key(MaNV, MaBangLuong, ThoiGianTinhLuong)
);

--6. Bảng LỚP
create table LOP(
	MaLop varchar(10) constraint pk_lop primary key not null,
	TenLop nvarchar(20),
	SoLuong int,
	MaNV varchar(10) constraint fk_lop_nv foreign key (MaNV) references NHANVIEN(MaNV)
);

--7. Bảng HỌC SINH
create table HOCSINH (
	MaHS varchar(10) constraint pk_hs primary key not null,
	HoHS nvarchar(10),
	TenHS nvarchar(30),
	GioiTinh bit,
	DiaChi nvarchar(100),
	MaLop varchar(10) constraint fk_hs_lop foreign key (MaLop) references LOP(MaLop),
	NgayNhapHoc date
);

--8. Bảng PHỤ HUYNH
create table PHUHUYNH (
	MaPH varchar(10) constraint pk_ph primary key not null,
	HoPH nvarchar(10),
	TenPH nvarchar(30),
	Sdt varchar(10),
	Email varchar(100),
	MatKhau varchar(100),
	MaVT varchar(10) constraint fk_phhs_vt foreign key(MaVT) references VAITRO(MaVT)
);

--9. Bảng QUAN HỆ
create table QUANHE (
	MaHS varchar(10),
	MaPH varchar(10),
	MoiQuanHe nvarchar(30),
	constraint fk_qh_hs foreign key (MaHS) references HOCSINH(MaHS),
	constraint fk_qh_ph foreign key (MaPH) references PHUHUYNH(MaPH),
	constraint pk_qh primary key(MaHS, MaPH)
);

--10. Bảng MỨC HỌC PHÍ 
create table MUCHOCPHI (
	MaMucHocPhi varchar(10) constraint pk_mhp primary key not null,
	MaLop varchar(10) constraint fk_mhp_lop foreign key (MaLop) references LOP(MaLop),	
	HocPhiCoBan int,
	ThoiGianBatDau date,
	ThoiGianKetThuc date,
	GhiChu nvarchar(500),
	DaDong bit default 0
); 

--11. Bảng HỌC PHÍ //ghi chú: mức phụ thu gồm những tiền gì
create table HOCPHI (
	MaHS varchar(10),
	MaMucHocPhi varchar(10),
	MucPhuThu int,
	GhiChu nvarchar(500),
	ThoiGian Date,
	constraint fk_hp_hs foreign key (MaHS) references HOCSINH(MaHS),
	constraint fk_hp_mhp foreign key (MaMucHocPhi) references MUCHOCPHI(MaMucHocPhi),
	constraint pk_hp primary key(MaHS, MaMucHocPhi, ThoiGian)
);

--12. Bảng XẾP LOẠI
create table XEPLOAI(
	MaXL varchar(10) constraint pk_xl primary key not null,
	TenXL nvarchar(10)
);

--13. Bảng TÌNH HÌNH HỌC TẬP
create table TINHHINHHOCTAP(
	MaHS varchar(10),
	MaXL varchar(10),
	ThoiGianDG DateTime default GetDate(),
	DanhGia nvarchar(100),
	GhiChu nvarchar(500),
	constraint fk_thht_hs foreign key (MaHS) references HOCSINH(MaHS),
	constraint fk_thht_xl foreign key (MaXL) references XEPLOAI(MaXL),
	constraint pk_thht primary key(MaHS, ThoiGianDG)
);

--14. Bảng SỨC KHỎE
create table SUCKHOE (
	MaHS varchar(10) constraint fk_sk_hs foreign key (MaHS) references HOCSINH(MaHS),
	ThangKiemTra int,
	CanNang decimal(10,2),
	ChieuCao decimal(10,2),
	GhiChu nvarchar(500),
	constraint pk_sk primary key(MaHS, ThangKiemTra)
);

--15. Bảng ĐỊA ĐIỂM
create table DIADIEM(
	MaDiaDiem varchar(10) constraint pk_diadiem primary key not null,
	TenDiaDiem nvarchar(100)
);

--16. Bảng NGOẠI KHÓA
create table NGOAIKHOA(
	MaHD varchar(10) constraint pk_nk primary key not null,
	TenHD nvarchar(50),
	MoTa nvarchar(500),
	ThoiGianToChuc date,
	MaDiaDiem varchar(10) constraint fk_nk_diadiem foreign key (MaDiaDiem) references DIADIEM(MaDiaDiem),
	MaNV varchar(10) constraint fk_nk_nv foreign key (MaNV) references NHANVIEN(MaNV)
);

--17. Bảng ĐIỂM DANH
create table DIEMDANH(
	MaHS varchar(10),
	NgayDiemDanh date,
	TrangThai bit,
	GhiChu nvarchar(500),
	constraint fk_dd_hs foreign key (MaHS) references HOCSINH(MaHS),
	constraint pk_dd primary key(MaHS, NgayDiemDanh)
);

--18. Bảng PHÂN CÔNG
create table PHANCONG(
	MaNV varchar(10),
	MaLop varchar(10),
	BatDau date,
	KetThuc date,
	GhiChu nvarchar(500),
	constraint fk_pc_nv foreign key (MaNV) references NHANVIEN(MaNV),
	constraint fk_pc_lop foreign key (MaLop) references LOP(MaLop),
	constraint pk_pc primary key(MaLop, MaNV)
);

--19. Bảng CHƯƠNG TRÌNH HỌC
create table CHUONGTRINHHOC (
	MaCT varchar(10) constraint pk_cth primary key not null,
	TenChuDe nvarchar(100),
	NoiDung nvarchar(500),
	DoTuoiBD int,
	DoTuoiKT int
);

--20. Bảng KẾ HOẠCH GIẢNG DẠY
create table KEHOACHGIANGDAY(
	MaLop varchar(10),
	MaCT varchar(10),
	NgayBatDau date,
	NgayKetThuc date,
	TrangThaiPheDuyet bit,
	constraint fk_khgd_lop foreign key (MaLop) references LOP(MaLop),
	constraint fk_khgd_cth foreign key(MaCT) references CHUONGTRINHHOC(MaCT),
	constraint pk_khgd primary key (MaLop, MaCT, NgayBatDau)
);

--21. Bảng LOẠI PHÍ 
create table LOAIPHI (
	MaLoaiPhi varchar(10) constraint pk_lp primary key not null,
	TenLoaiPhi nvarchar(100)	
);

--22. Bảng PHÍ VẬN HÀNH
create table PHIVANHANH (
	MaPhiVanHanh varchar(10),
	MaLoaiPhi varchar(10) constraint fk_pvh_lp foreign key (MaLoaiPhi) references LOAIPHI(MaLoaiPhi),
	MucTien int,
	ThoiGianBatDau date,
	ThoiGianKetThuc date,	
	constraint pk_pvh primary key(MaPhiVanHanh, MaLoaiPhi)
);

--23. Bảng THỰC ĐƠN //cho tuần
create table THUCDON (
	MaThucDon varchar(10) constraint pk_td primary key not null,
	MaNV varchar(10) constraint fk_td_nv foreign key (MaNV) references NHANVIEN(MaNV),
	ThoiGianBatDau datetime,
	ThoiGianKetThuc datetime
);

--24. Bảng MÓN
create table MON (
	MaMon varchar(10) constraint pk_mon primary key not null,
	TenMon nvarchar(100)
);

--25. Bảng CHI TIẾT THỰC ĐƠN
create table CHITIETTHUCDON (
	MaMon varchar(10),
	MaThucDon varchar(10),
	Thu nvarchar(10),
	constraint fk_cttd_mon foreign key (MaMon) references MON(MaMon),
	constraint fk_cttd_td foreign key (MaThucDon) references THUCDON(MaThucDon),
	constraint pk_cttd primary key (MaMon, MaThucDon, Thu)
);

--26. Bảng NGUYÊN LIỆU
create table NGUYENLIEU (
	MaNguyenLieu varchar(10) constraint pk_nl primary key not null,
	TenNguyenLieu nvarchar(100),
	NgayNhap date,
	Gia int,
	SoLuong int,
	DonVi nvarchar(20),
	MaNV varchar(10) constraint fk_nl_nv foreign key (MaNV) references NHANVIEN(MaNV)
);

--27. Bảng CHI TIẾT MÓN
create table CHITIETMON (
	MaMon varchar(10),
	MaNguyenLieu varchar(10),
	constraint fk_ctm_mon foreign key (MaMon) references MON(MaMon),
	constraint fk_ctm_nl foreign key (MaNguyenLieu) references NGUYENLIEU(MaNguyenLieu),
	constraint pk_ctm primary key (MaMon, MaNguyenLieu)
);

--Chèn Dữ liệu

--1. Dữ liệu bảng VAI TRÒ
insert into VAITRO (MaVT, TenVT) values
('PHHS', N'Phụ Huynh'),
('HT', N'Hiệu trưởng'),
('HP', N'Hiệu phó'),
('GV', N'Giáo viên'),
('KT', N'Kế toán'),
('CD', N'Cấp dưỡng');

--2. Dữ liệu bảng NHÂN VIÊN
insert into NHANVIEN (MaNV, HoNV, TenNV, GioiTinh, NgaySinh, CCCD, DiaChi, Email, MatKhau, Sdt, MaVT) values
('NV001', N'Nguyễn', N'Thụy Thanh Phương', 0, '1970-10-20', '056123456789', N'Diên Sơn - Diên Khánh', 'phuong.ntt@senhong.edu.vn', '123', '0375123456', 'HT'),
('NV002', N'Lương', N'Ngọc Diễm Chi', 0, '1985-05-15', '056987654321', N'Nha Trang - Khánh Hòa', 'chi.lnd@senhong.edu.vn', '123', '0386543210', 'HP'),
('NV003', N'Trần', N'Minh Khang', 1, '1985-05-15', '056987654321', N'Nha Trang - Khánh Hòa', 'khang.tm@senhong.edu.vn', '123', '0386543210', 'KT'),
('NV004', N'Dương', N'Thị Hoài Thanh', 0, '1990-12-22', '056112233445', N'Cam Lâm - Khánh Hòa', 'thanh.dth@senhong.edu.vn', '123', '0399988776', 'KT'),
('NV005', N'Phạm', N'Phương Nam', 1, '1982-07-19', '056223344556', N'Ninh Hòa - Khánh Hòa', 'nam.pp@senhong.edu.vn', '123', '0377458965', 'GV'),
('NV006', N'Huỳnh', N'Xuân Hoài', 1, '1995-11-11', '056334455667', N'Vạn Ninh - Khánh Hòa', 'hoai.hx@senhong.edu.vn', '123', '0371122334', 'GV'),
('NV007', N'Nguyễn', N'Thị Thúy Hằng', 0, '2000-03-03', '056445566778', N'Phước Long - Nha Trang', 'hang.ntt@senhong.edu.vn', '123', '0392233445', 'GV'),
('NV008', N'Ngô', N'Kim Thanh', 0, '1997-09-09', '056556677889', N'Tân Lập - Nha Trang', 'thanh.kt@senhong.edu.vn', '123', '0385544662', 'GV'),
('NV009', N'Trần', N'Thị Liễu', 0, '1988-08-08', '056667788990', N'Vĩnh Hải - Nha Trang', 'lieu.tt@senhong.edu.vn', '123', '0399988777', 'GV'),
('NV010', N'Nguyễn', N'Thị Bảo Vân', 0, '1978-02-20', '056778899001', N'Phước Đồng - Nha Trang', 'van.ntb@senhong.edu.vn', '123', '0377744110', 'GV'),
('NV011', N'Trần', N'Mạnh Dũng', 1, '1995-03-03', '056445566778', N'Phước Long - Nha Trang', 'dung.tm@senhong.edu.vn', '123', '0392233445', 'GV'),
('NV012', N'Lê', N'Nhật Quân', 1, '1987-11-05', '056445566778', N'Phương Sài - Nha Trang', 'quan.ln@senhong.edu.vn', '123', '0392233445', 'GV'),
('NV013', N'Nguyễn', N'Thúy Phượng', 0, '1999-06-30', '056889900112', N'Diên Điền - Diên Khánh', 'phuong.nt@senhong.edu.vn', '123', '0378123456', 'CD'),
('NV014', N'Phan', N'Thị Kim Dung', 0, '2000-03-03', '056445566778', N'Diên Điền - Diên Khánh', 'dung.ptk@senhong.edu.vn', '123', '0392233445', 'CD'),
('NV015', N'Nguyễn', N'Vân Hoa', 0, '1993-12-10', '056445568143', N'Phước Long - Nha Trang', 'hoa.nv@senhong.edu.vn', '123', '0392233445', 'CD');

delete from NHANVIEN where TenNV = N'sava'

--3. Dữ liệu bảng CHẤM CÔNG
insert into CHAMCONG (MaNV, NgayChamCong, TrangThai, GhiChu) values
('NV001', '2025-05-09', 0, N'Có việc gia đình'),
('NV002', '2025-05-08', 1, N''),
('NV003', '2025-05-08', 1, N''),
('NV004', '2025-05-08', 1, N''),
('NV005', '2025-05-07', 1, N''),
('NV006', '2025-05-07', 0, N'Nghỉ ốm'),
('NV007', '2025-05-07', 1, N''),
('NV008', '2025-05-06', 1, N''),
('NV009', '2025-05-06', 1, N''),
('NV010', '2025-05-06', 0, N'Nghỉ phép'),
('NV001', '2025-05-05', 1, N''),
('NV002', '2025-05-05', 1, N''),
('NV003', '2025-05-05', 0, N'Nghỉ ốm'),
('NV004', '2025-05-05', 1, N''),
('NV005', '2025-05-05', 1, N'');

--4. Dữ liệu bảng BẢNG LƯƠNG
insert into BANGLUONG(MaBangLuong, HeSoLuong,ThoiGianBD, ThoiGianKT, LuongCoBan) values 
('BL001', 2.34, '2025-01-01', '2025-12-31', 1800000),
('BL002', 2.67, '2025-01-01', '2025-12-31', 2000000),
('BL003', 3.00, '2025-01-01', '2025-12-31', 2200000),
('BL004', 3.33, '2025-01-01', '2025-12-31', 2400000),
('BL005', 3.66, '2025-01-01', '2025-12-31', 2600000);

--5. Dữ liệu LƯƠNG NHÂN VIÊN
insert into LUONGNHANVIEN(MaNV, MaBangLuong,ThoiGianTinhLuong, SoNgayCong) values
('NV001', 'BL001', '2025-01-01',26),
('NV002', 'BL002', '2025-01-01',25),
('NV003', 'BL003', '2025-01-01',24),
('NV004', 'BL004', '2025-01-01',27),
('NV005', 'BL005', '2025-01-01',26),
('NV006', 'BL001', '2025-01-01',26),
('NV007', 'BL002', '2025-01-01',25),
('NV008', 'BL003', '2025-01-01',24),
('NV009', 'BL004', '2025-01-01',27),
('NV010', 'BL005', '2025-01-01',26);

--6. Dữ liệu bảng LỚP
insert into LOP (MaLop, TenLop, SoLuong, MaNV) values
('L01', N'Lớp 25-36 tháng', '22', 'NV001'),
('L02', N'Lớp 3-4 tuổi', '24', 'NV002'),
('L03', N'Lớp 4-5 tuổi', '22', 'NV003'),
('L04', N'Lớp 5-6 tuổi', '29', 'NV004');

--7. Dữ liệu bảng HỌC SINH
insert into HOCSINH (MaHS, HoHS, TenHS, GioiTinh, DiaChi, MaLop, NgayNhapHoc) values
('HS001', N'Bùi', N'Gia Bách', 1, N'45 Lý Thánh Tôn, Nha Trang, Khánh Hòa', 'L01', '2023-09-05'),
('HS002', N'Lê', N'Ngọc Linh Đan', 0, N'Thôn Diên Điền, Diên Khánh, Khánh Hòa', 'L01', '2023-09-05'),
('HS003', N'Nguyễn', N'Duy Khang', 1, N'Thôn Diên Sơn, Diên Khánh, Khánh Hòa', 'L01', '2023-09-05'),
('HS004', N'Tăng', N'Hoàng Bảo Nhi', 0, N'Thôn Diên Điền, Diên Khánh, Khánh Hòa', 'L01', '2023-09-05'),
('HS005', N'Trần', N'Hải Đăng', 1, N'Thôn Diên Phước, Diên Khánh, Khánh Hòa', 'L01', '2023-09-05'),
('HS006', N'Lê', N'Hoàng Gia Hân', 0, N'Thôn Diên Sơn, Diên Khánh, Khánh Hòa', 'L02', '2023-09-05'),
('HS007', N'Lê', N'Nhật Minh', 1, N'Xã Vĩnh Thạnh, Nha Trang, Khánh Hòa', 'L02', '2023-09-05'),
('HS008', N'Trần', N'Quốc Phúc', 1, N'Thôn Diên Lạc, Diên Khánh, Khánh Hòa', 'L02', '2023-09-05'),
('HS009', N'Đào', N'Gia Vỹ', 1, N'Thôn Diên Điền, Diên Khánh, Khánh Hòa', 'L02', '2023-09-05'),
('HS010', N'Phạm', N'Huỳnh Bảo Ngọc', 0, N'Thôn Diên Phước, Diên Khánh, Khánh Hòa', 'L02', '2023-09-05'),
('HS011', N'Lê', N'Võ Trà My', 0, N'Thôn Diên An, Diên Khánh, Khánh Hòa', 'L03', '2023-09-05'),
('HS012', N'Nguyễn', N'Phúc Chi', 0, N'Thôn Diên Sơn, Diên Khánh, Khánh Hòa', 'L03', '2023-09-05'),
('HS013', N'Nguyễn', N'Trí Nguyên', 1, N'Thôn Diên Phước, Diên Khánh, Khánh Hòa', 'L03', '2023-09-05'),
('HS014', N'Lê', N'Nguyễn Minh Khang', 1, N'Thôn Võ Cang, Nha Trang, Khánh Hòa', 'L03', '2023-09-05'),
('HS015', N'Phan', N'Hoàng Quân', 1, N'Thôn Diên Sơn, Diên Khánh, Khánh Hòa', 'L03', '2023-09-05'),
('HS016', N'Trần', N'Thiên Bảo', 1, N'Thôn Diên Sơn, Diên Khánh, Khánh Hòa', 'L04', '2023-09-05'),
('HS017', N'Trần', N'Nhật Hoàng Hạ', 0, N'Thôn Diên An, Diên Khánh, Khánh Hòa', 'L04', '2023-09-05'),
('HS018', N'Lê', N'Nguyễn Phương Quỳnh', 0, N'Thôn Diên Lạc, Diên Khánh, Khánh Hòa', 'L04', '2023-09-05'),
('HS019', N'Nguyễn', N'Ngọc Thiên Kim', 0, N'Thôn Diên Phước, Diên Khánh, Khánh Hòa', 'L04', '2023-09-05'),
('HS020', N'Phan', N'Thành Luân', 1, N'Thôn Diên Sơn, Diên Khánh, Khánh Hòa', 'L04', '2023-09-05');

--8. Dữ liệu bảng PHỤ HUYNH
insert into PHUHUYNH (MaPH, HoPH, TenPH, Sdt, Email, MatKhau, MaVT) values
('PH001', N'Nguyễn', N'Thanh Hằng', '0912345670', 'hang.nguyen@dienkhanh.edu.vn', 'thanhhang123', 'PHHS'),
('PH002', N'Trần', N'Quốc Huy', '0912345671', 'huy.tran@dienkhanh.edu.vn', '12345678', 'PHHS'),
('PH003', N'Lê', N'Thị Mai', '0912345672', 'mai.le@dienkhanh.edu.vn', 'lemai2023', 'PHHS'),
('PH004', N'Phạm', N'Văn Thắng', '0912345673', 'thang.pham@dienkhanh.edu.vn', 'thang@123', 'PHHS'),
('PH005', N'Hồ', N'Mỹ Duyên', '0912345674', 'duyen.ho@dienkhanh.edu.vn', 'duyen456', 'PHHS'),
('PH006', N'Đỗ', N'Minh Quân', '0912345675', 'quan.do@dienkhanh.edu.vn', 'abcd1234', 'PHHS'),
('PH007', N'Vũ', N'Thị Hạnh', '0912345676', 'hanh.vu@dienkhanh.edu.vn', 'passhanh', 'PHHS'),
('PH008', N'Bùi', N'Anh Tuấn', '0912345677', 'tuan.bui@dienkhanh.edu.vn', '1234abcd', 'PHHS'),
('PH009', N'Đặng', N'Kim Ngân', '0912345678', 'ngan.dang@dienkhanh.edu.vn', 'mkngan2024', 'PHHS'),
('PH010', N'Ngô', N'Hoàng Phúc', '0912345679', 'phuc.ngo@dienkhanh.edu.vn', 'phuc789', 'PHHS'),
('PH011', N'Dương', N'Thị Lan', '0912345680', 'lan.duong@dienkhanh.edu.vn', 'lan321', 'PHHS'),
('PH012', N'Tạ', N'Văn Hòa', '0912345681', 'hoa.ta@dienkhanh.edu.vn', 'hoa@dien123', 'PHHS'),
('PH013', N'Tống', N'Thảo Vy', '0912345682', 'vy.tong@dienkhanh.edu.vn', 'vy12345', 'PHHS'),
('PH014', N'Trịnh', N'Trung Hiếu', '0912345683', 'hieu.trinh@dienkhanh.edu.vn', 'hieu@ph', 'PHHS'),
('PH015', N'Cao', N'Thị Huệ', '0912345684', 'hue.cao@dienkhanh.edu.vn', 'huepass', 'PHHS'),
('PH016', N'Lý', N'Ngọc Hân', '0912345685', 'han.ly@dienkhanh.edu.vn', 'han321', 'PHHS'),
('PH017', N'Chu', N'Minh Đức', '0912345686', 'duc.chu@dienkhanh.edu.vn', 'mkduc123', 'PHHS'),
('PH018', N'Kiều', N'Phương Anh', '0912345687', 'anh.kieu@dienkhanh.edu.vn', 'phuong2023', 'PHHS'),
('PH019', N'Huỳnh', N'Hải Nam', '0912345688', 'nam.huynh@dienkhanh.edu.vn', 'hainan125', 'PHHS'),
('PH020', N'Mai', N'Trúc Linh', '0912345689', 'linh.mai@dienkhanh.edu.vn', 'mai@124', 'PHHS');


--9. Dữ liệu bảng QUAN HỆ
insert into QUANHE (MaHS, MaPH, MoiQuanHe) VALUES
('HS001', 'PH001', N'Mẹ'),
('HS002', 'PH002', N'Cha'),
('HS003', 'PH003', N'Mẹ'),
('HS004', 'PH004', N'Cha'),
('HS005', 'PH005', N'Mẹ'),
('HS006', 'PH006', N'Cha'),
('HS007', 'PH007', N'Cha'),
('HS008', 'PH008', N'Mẹ'),
('HS009', 'PH009', N'Cha'),
('HS010', 'PH010', N'Mẹ'),
('HS011', 'PH011', N'Mẹ'),
('HS012', 'PH012', N'Cha'),
('HS013', 'PH013', N'Mẹ'),
('HS014', 'PH014', N'Cha'),
('HS015', 'PH015', N'Mẹ'),
('HS016', 'PH016', N'Mẹ'),
('HS017', 'PH017', N'Mẹ'),
('HS018', 'PH018', N'Cha'),
('HS019', 'PH019', N'Mẹ'),
('HS020', 'PH020', N'Mẹ');

--10. Dữ liệu bảng MỨC HỌC PHÍ
insert into MUCHOCPHI(MaMucHocPhi, MaLop, HocPhiCoBan, ThoiGianBatDau, ThoiGianKetThuc, GhiChu) values
('HP01', 'L01', 1500000, '2025-02-03', '2025-05-31', N'Học kỳ 2'),
('HP02', 'L02', 1550000, '2025-02-03', '2025-05-31', N'Học kỳ 2'),
('HP03', 'L03', 1600000, '2025-02-03', '2025-05-31', N'Học kỳ 2'),
('HP04', 'L04', 1650000, '2025-02-03', '2025-05-31', N'Học kỳ 2'),
('HP05', 'L01', 1520000, '2025-02-03', '2025-05-30', N'Học kỳ 2');

--11. Dữ liệu bảng HỌC PHÍ
insert into HOCPHI(MaHS, MaMucHocPhi, MucPhuThu, GhiChu, ThoiGian) values
('HS001', 'HP01', 200000, N'Hoạt động ngoại khóa', '2025-04-01'),
('HS002', 'HP02', 250000, N'Phí vệ sinh','2025-06-25'),
('HS003', 'HP03',0 ,N'','2025-02-27'),
('HS004', 'HP04',300000 ,N'Chụp hình tốt nghiệp','2025-05-10'),
('HS005', 'HP05',0 ,N'','2025-03-15');

--12. Dữ liệu bảng XẾP LOẠI
insert into XEPLOAI (MaXL, TenXL) values
('XL01', N'A'),
('XL02', N'B'),
('XL03', N'C');

--13. Dữ liệu bảng TÌNH HÌNH HỌC TẬP
insert into TINHHINHHOCTAP (MaHS, MaXL, ThoiGianDG, DanhGia, GhiChu) values
('HS001', 'XL01', GETDATE(), N'Nổi bật toàn diện', N'Luôn hoàn thành tốt mọi nhiệm vụ'),
('HS002', 'XL02', GETDATE(), N'Học tốt, kỹ năng mạnh', N'Tham gia hoạt động tích cực'),
('HS003', 'XL03', GETDATE(), N'Nắm bài chắc', N'Biết áp dụng kiến thức tốt'),
('HS004', 'XL01', GETDATE(), N'Tốt, cần nâng cao thêm', N'Cần chủ động hơn khi học'),
('HS005', 'XL02', GETDATE(), N'Có tiến bộ', N'Cần phát huy thêm sự tập trung'),
('HS006', 'XL03', GETDATE(), N'Nắm bài cơ bản', N'Nên rèn luyện kỹ năng giao tiếp'),
('HS007', 'XL01', GETDATE(), N'Học giỏi', N'Nắm chắc kiến thức'),
('HS008', 'XL02', GETDATE(), N'Học tốt', N'Cố gắng phát huy'),
('HS009', 'XL03', GETDATE(), N'Thiếu chủ động', N'Cần sự kèm cặp thêm'),
('HS010', 'XL01', GETDATE(), N'Nổi bật toàn diện', N'Năn nổ, sôi động, tích cực'),
('HS011', 'XL01', GETDATE(), N'Nổi bật toàn diện', N'Luôn hoàn thành tốt mọi nhiệm vụ'),
('HS012', 'XL02', GETDATE(), N'Kỹ năng mạnh', N'Tham gia tích cực'),
('HS013', 'XL03', GETDATE(), N'Nắm bài chắc', N'Chăm học'),
('HS014', 'XL01', GETDATE(), N'Tốt, cần nâng cao thêm', N'Cần chủ động hơn khi học'),
('HS015', 'XL02', GETDATE(), N'Ngoan hiền', N'Cần phát huy thêm sự tập trung'),
('HS016', 'XL03', GETDATE(), N'Nắm bài cơ bản', N'Nên rèn luyện kỹ năng giao tiếp'),
('HS017', 'XL01', GETDATE(), N'Học giỏi', N'Nắm chắc kiến thức'),
('HS018', 'XL02', GETDATE(), N'Học tốt', N'Cố gắng phát huy'),
('HS019', 'XL03', GETDATE(), N'Thiếu chủ động', N'Cần sự kèm cặp thêm'),
('HS020', 'XL01', GETDATE(), N'Tích cực', N'Năn nổ, sôi động, tích cực');

--14. Dữ liệu bảng SỨC KHỎE
insert into SUCKHOE (MaHS, ThangKiemTra, CanNang, ChieuCao, GhiChu) values
('HS001', 9, 15.2, 98.5, N'Phát triển bình thường'),
('HS002', 9, 16.0, 100.2, N'Đạt chuẩn tuổi'),
('HS003', 9, 13.8, 95.0, N'Thấp cân nhẹ'),
('HS004', 9, 17.5, 105.0, N'Phát triển tốt'),
('HS005', 9, 14.6, 97.3, N'Bình thường'),
('HS006', 9, 15.9, 99.8, N'Đạt tiêu chuẩn'),
('HS007', 9, 14.2, 96.1, N'Thể trạng trung bình'),
('HS008', 9, 13.5, 94.2, N'Cần theo dõi cân nặng'),
('HS009', 9, 16.3, 101.0, N'Phát triển phù hợp'),
('HS010', 9, 15.0, 98.0, N'Bình thường'),
('HS011', 9, 14.8, 97.6, N'Phát triển ổn định'),
('HS012', 9, 17.0, 103.0, N'Tốt'),
('HS013', 9, 16.5, 101.8, N'Khỏe mạnh'),
('HS014', 9, 15.1, 98.9, N'Bình thường theo tuổi'),
('HS015', 9, 14.9, 97.0, N'Cần theo dõi chiều cao'),
('HS016', 9, 15.7, 99.5, N'Đạt yêu cầu'),
('HS017', 9, 13.9, 95.6, N'Gầy nhẹ, ăn uống kém'),
('HS018', 9, 16.2, 100.6, N'Phát triển tốt'),
('HS019', 9, 14.5, 96.8, N'Thấp cân nhẹ'),
('HS020', 9, 15.3, 98.7, N'Ổn định thể lực');

--15. Dữ liệu bảng ĐỊA ĐIỂM
insert into DIADIEM(MaDiaDiem, TenDiaDiem) values
('DD01', N'Sở thú thành phố Nha Trang'),
('DD02', N'Sân vận động thiếu nhi ở nhà văn hóa thôn'),
('DD03', N'Sân trường mầm non Sen Hồng'),
('DD04', N'Khu vườn học tập xanh'),
('DD05', N'Thư viện thiếu nhi Diên Khánh');

--16. Dữ liệu bảng NGOẠI KHÓA
insert into NGOAIKHOA(MaHD, TenHD, MoTa, ThoiGianToChuc, MaDiaDiem, MaNV) values
('HD01', N'Tham quan sở thú', N'Các bé được tham quan, học về các loài động vật', '2025-04-01 08:00:00', 'DD01', 'NV001'),
('HD02', N'Ngày hội thể thao', N'Tổ chức trò chơi vận động ngoài trời', '2025-03-15 07:30:00', 'DD02', 'NV002'),
('HD03', N'Lễ hội trung thu', N'Vui múa lân, rước đèn và phát quà trung thu', '2025-09-05 17:00:00', 'DD03', 'NV003'),
('HD04', N'Trồng cây xanh', N'Hướng dẫn các bé trồng và chăm sóc cây', '2025-02-20 08:30:00', 'DD04', 'NV004'),
('HD05', N'Tham quan thư viện', N'Các bé được nghe kể chuyện và xem sách tranh', '2025-05-25 09:00:00', 'DD05', 'NV005');

--17. Dữ liệu bảng ĐIỂM DANH
insert into DIEMDANH (MaHS, NgayDiemDanh, TrangThai, GhiChu) values
('HS001', '2025-05-05', 1, N'Có mặt, đúng giờ'),
('HS002', '2025-05-05', 0, N'Vắng có phép'),
('HS003', '2025-05-05', 1, N'Có mặt'),
('HS004', '2025-05-06', 1, N'Có mặt'),
('HS005', '2025-05-06', 1, N'Quay lại sau ngày nghỉ');

--18. Dữ liệu bảng PHÂN CÔNG
insert into PHANCONG(MaNV, MaLop, BatDau, KetThuc, GhiChu) values 
('NV001', 'L01', '2025-01-01', '2025-12-31', N'Phụ trách lớp 25-36 tháng'),
('NV002', 'L02', '2025-01-01', '2025-12-31', N'Giáo viên chủ nhiệm lớp 3-4 tuổi'),
('NV003', 'L03', '2025-01-01', '2025-12-31', N'Giáo viên lớp 4-5 tuổi'),
('NV004', 'L04', '2025-01-01', '2025-12-31', N'Giáo viên lớp 5-6 tuổi');

--19. Dữ liệu bảng CHƯƠNG TRÌNH HỌC TẬP
insert into CHUONGTRINHHOC (MaCT, TenChuDe, NoiDung, DoTuoiBD, DoTuoiKT) values 
('CT001', N'Làm quen trường lớp', N'Giúp trẻ làm quen với môi trường mầm non, cô giáo và bạn bè', 1, 2),
('CT002', N'Bản thân', N'Nhận biết các bộ phận cơ thể, chăm sóc bản thân và vệ sinh cá nhân', 2, 4),
('CT003', N'Gia đình', N'Trẻ hiểu về các thành viên trong gia đình và tình cảm gia đình', 2, 6),
('CT004', N'Thế giới động vật', N'Làm quen với các con vật nuôi, động vật hoang dã, tiếng kêu và nơi sống của chúng', 3, 6),
('CT005', N'Các phương tiện giao thông', N'Nhận biết các loại xe, luật lệ an toàn giao thông cơ bản', 3, 10),
('CT006', N'Thiên nhiên quanh bé', N'Tìm hiểu về cây cối, thời tiết, bốn mùa, hiện tượng tự nhiên', 3, 6),
('CT007', N'Bé vui học chữ cái', N'Làm quen chữ cái qua trò chơi, hình ảnh, âm thanh', 4, 6),
('CT008', N'Khám phá toán học', N'Nhận biết số lượng, hình dạng, màu sắc, kích thước, so sánh', 4, 6),
('CT009', N'Giáo dục kỹ năng sống', N'Học kỹ năng tự lập, làm việc nhóm, chia sẻ, ứng xử lễ phép', 3, 6),
('CT010', N'Ngày lễ và truyền thống', N'Tìm hiểu về Tết Nguyên Đán, Trung Thu, ngày Nhà giáo Việt Nam…', 3, 6);

--20. Dữ liệu bảng KẾ HOẠCH GIẢNG DẠY
insert into KEHOACHGIANGDAY(MaLop, MaCT, NgayBatDau, NgayKetThuc, TrangThaiPheDuyet) values
('L01', 'CT001', '2025-01-01', '2025-01-31', 1),
('L01', 'CT002', '2025-02-01', '2025-02-28', 1),
('L01', 'CT003', '2025-03-01', '2025-03-31', 1),
('L02', 'CT002', '2025-01-01', '2025-01-31', 1),
('L02', 'CT003', '2025-02-01', '2025-02-28', 1),
('L02', 'CT005', '2025-03-01', '2025-03-31', 1),
('L03', 'CT004', '2025-01-01', '2025-01-31', 1),
('L03', 'CT005', '2025-02-01', '2025-02-28', 1),
('L03', 'CT006', '2025-03-01', '2025-03-31', 1),
('L04', 'CT006', '2025-01-01', '2025-01-31', 1),
('L04', 'CT007', '2025-02-01', '2025-02-28', 1),
('L04', 'CT008', '2025-03-01', '2025-03-31', 1),
('L04', 'CT009', '2025-04-01', '2025-04-30', 1);

--21. Dữ liệu bảng LOẠI PHÍ
insert into LOAIPHI(MaLoaiPhi, TenLoaiPhi) values 
('LP001', N'Tiền điện'),
('LP002', N'Tiền nước'),
('LP003', N'Tiền nguyên liệu');

--22. Dữ liệu bảng PHÍ VẬN HÀNH
insert into PHIVANHANH (MaPhiVanHanh, MaLoaiPhi, MucTien, ThoiGianBatDau, ThoiGianKetThuc) values
('PVH001','LP001',4000000 ,'2025-01-01','2025-01-31'),
('PVH001','LP002',3000000 ,'2025-01-01','2025-01-31'),
('PVH001','LP003',10000000 ,'2025-01-01','2025-01-31'),
('PVH002','LP001',3500000 ,'2025-02-01','2025-02-28'),
('PVH002','LP002',2500000 ,'2025-02-01','2025-02-28'),
('PVH002','LP003',9500000 ,'2025-02-01','2025-02-28'),
('PVH003','LP001',4000000 ,'2025-03-01','2025-03-31'),
('PVH003','LP002',3000000 ,'2025-03-01','2025-03-31'),
('PVH003','LP003',10000000 ,'2025-03-01','2025-03-31'),
('PVH004','LP001',3800000 ,'2025-04-01','2025-04-30'),
('PVH004','LP002',2700000 ,'2025-04-01','2025-04-30'),
('PVH004','LP003',9700000 ,'2025-04-01','2025-04-30');

--23. Dữ liệu bảng THỰC ĐƠN
insert into THUCDON(MaThucDon, MaNV, ThoiGianBatDau, ThoiGianKetThuc) values
('TD01', 'NV013', '2025-02-03', '2025-02-08'),
('TD02', 'NV013', '2025-02-10', '2025-02-15'),
('TD03', 'NV014', '2025-02-17', '2025-02-22'),
('TD04', 'NV015', '2025-02-24', '2025-03-01'),
('TD05', 'NV014', '2025-03-03', '2025-03-08');

--24. Dữ liệu bảng MÓN
insert into MON (MaMon, TenMon) values
('M001', N'Bánh canh chả lụa'),
('M002', N'Canh rau nấm thịt'),
('M003', N'Thịt sườn ram me'),
('M004', N'Hủ tiếu tôm thịt'),
('M005', N'Canh bí xanh sườn'),
('M006', N'Thịt kho xúc xích'),
('M007', N'Gà chiên mắm'),
('M008', N'Cá diêu hồng chiên giòn'),
('M009', N'Miến trứng'),
('M010', N'Trứng gà cuộn thịt'),
('M011', N'Mì quảng thịt băm'),
('M012', N'Cháo hạt sen thịt bò'),
('M013', N'Bò kho bánh mì'),
('M014', N'Nui thịt băm'),
('M015', N'Súp hải sản');

--25. Dữ liệu bảng CHI TIẾT THỰC ĐƠN
insert into CHITIETTHUCDON (MaMon, MaThucDon, Thu) values
('M001', 'TD01', N'Thứ Hai'),
('M002', 'TD01', N'Thứ Hai'),
('M003', 'TD01', N'Thứ Hai'),
('M004', 'TD01', N'Thứ Hai'),
('M005', 'TD01', N'Thứ Ba'),
('M006', 'TD01', N'Thứ Ba'),
('M007', 'TD01', N'Thứ Ba'),
('M008', 'TD01', N'Thứ Ba'),
('M009', 'TD01', N'Thứ Tư'),
('M010', 'TD01', N'Thứ Tư'),
('M011', 'TD01', N'Thứ Tư'),
('M012', 'TD01', N'Thứ Tư'),
('M013', 'TD01', N'Thứ Năm'),
('M014', 'TD01', N'Thứ Năm'),
('M015', 'TD01', N'Thứ Năm'),
('M001', 'TD01', N'Thứ Năm'),
('M002', 'TD01', N'Thứ Sáu'),
('M003', 'TD01', N'Thứ Sáu'),
('M004', 'TD01', N'Thứ Sáu'),
('M005', 'TD01', N'Thứ Sáu'),
('M006', 'TD01', N'Thứ Bảy'),
('M007', 'TD01', N'Thứ Bảy'),
('M008', 'TD01', N'Thứ Bảy'),
('M009', 'TD01', N'Thứ Bảy');

--26. Dữ liệu bảng NGUYÊN LIỆU
insert into NGUYENLIEU (MaNguyenLieu, TenNguyenLieu, NgayNhap, Gia, SoLuong, DonVi, MaNV) values
('NL001', N'Gạo', '2025-05-01', 15000, 100, N'kg', 'NV013'),
('NL002', N'Thịt heo', '2025-05-02', 120000, 50, N'kg', 'NV014'),
('NL003', N'Rau cải', '2025-05-03', 30000, 30, N'kg', 'NV015'),
('NL004', N'Trứng gà', '2025-05-04', 3500, 200, N'quả', 'NV013'),
('NL005', N'Xúc xích', '2025-05-05', 10000, 100, N'cây', 'NV014'),
('NL006', N'Cá diêu hồng', '2025-05-06', 75000, 25, N'kg', 'NV015'),
('NL007', N'Hạt sen', '2025-05-07', 50000, 10, N'kg', 'NV013'),
('NL008', N'Nấm rơm', '2025-05-08', 80000, 20, N'kg', 'NV014'),
('NL009', N'Tôm tươi', '2025-05-09', 150000, 30, N'kg', 'NV015'),
('NL010', N'Sườn non', '2025-05-10', 130000, 40, N'kg', 'NV013');

--27. Dữ liệu bảng CHI TIẾT MÓN
insert into CHITIETMON (MaMon, MaNguyenLieu) values
('M001', 'NL001'),
('M001', 'NL002'),
('M001', 'NL003'),
('M002', 'NL001'),
('M002', 'NL007'),
('M002', 'NL008'),
('M003', 'NL002'),
('M003', 'NL010'),
('M004', 'NL001'),
('M004', 'NL009'),
('M005', 'NL002'),
('M005', 'NL010'),
('M006', 'NL005'),
('M006', 'NL002'),
('M007', 'NL002'),
('M007', 'NL004'),
('M008', 'NL006'),
('M008', 'NL002'),
('M009', 'NL001'),
('M009', 'NL004'),
('M010', 'NL004'),
('M010', 'NL002'),
('M011', 'NL001'),
('M011', 'NL002'),
('M012', 'NL001'),
('M012', 'NL007'),
('M013', 'NL002'),
('M013', 'NL010');


CREATE PROCEDURE NhanVien_TimKiem
    @HoTen NVARCHAR(50) = NULL,
    @GioiTinh NVARCHAR(3) = NULL,
    @VaiTro NVARCHAR(30) = NULL
AS
BEGIN
    DECLARE @SqlStr NVARCHAR(MAX)
    
    SELECT @SqlStr = '
        SELECT nv.MaNV, nv.HoNV, nv.TenNV, nv.GioiTinh, nv.NgaySinh,
               nv.CCCD, nv.DiaChi, nv.Email, nv.MatKhau, nv.Sdt, nv.MaVT,
               vt.TenVT, vt.MaVT as VT_MaVT  -- Thêm thông tin VAITRO
        FROM NHANVIEN nv
        JOIN VAITRO vt ON nv.MaVT = vt.MaVT
        WHERE (1=1)
    '
    
    IF @HoTen IS NOT NULL AND @HoTen <> ''
        SELECT @SqlStr = @SqlStr + '
            AND (nv.HoNV + '' '' + nv.TenNV LIKE N''%' + @HoTen + '%'')
        '
    
    IF @GioiTinh IS NOT NULL
        SELECT @SqlStr = @SqlStr + '
            AND (nv.GioiTinh = ' + CASE WHEN @GioiTinh = N'Nam' THEN '1' ELSE '0' END + ')
        '
    
    IF @VaiTro IS NOT NULL AND @VaiTro <> ''
        SELECT @SqlStr = @SqlStr + '
            AND (vt.TenVT LIKE N''%' + @VaiTro + '%'')
        '
    
    EXEC SP_EXECUTESQL @SqlStr
END
