CREATE DATABASE SQLBENHVIEN2
USE SQLBENHVIEN2

-- Tạo SEQUENCE cho từng bảng
CREATE SEQUENCE seq_nguoi_dung AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_benh_nhan AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_bao_hiem AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_chuyen_khoa AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_bac_si AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_lich_hen AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_ho_so_y_te AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_don_thuoc AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_thuoc AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_thuoc_trong_don AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_don_hang AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_mat_hang_don_hang AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_thanh_toan AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_hoa_don AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_phan_hoi AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_lich_lam_viec AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_yeu_cau_ho_tro AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_thong_bao AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_phien_chat AS INT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_tin_nhan_chat AS INT START WITH 1 INCREMENT BY 1;

-- Bảng Nguoi_Dung
CREATE TABLE Nguoi_Dung (
    ma_nguoi_dung VARCHAR(20) PRIMARY KEY DEFAULT ('UserID' + CAST(NEXT VALUE FOR seq_nguoi_dung AS VARCHAR(10))),
    ten_dang_nhap VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    mat_khau_ma_hoa VARCHAR(255) NOT NULL,
    loai_nguoi_dung VARCHAR(20) CHECK (loai_nguoi_dung IN ('benh_nhan', 'bac_si', 'quan_tri', 'ho_tro', 'ke_toan', 'nha_thuoc')) NOT NULL,
    ho_ten VARCHAR(100) NOT NULL,
    so_dien_thoai VARCHAR(15) NOT NULL,
    thoi_gian_tao DATETIME NOT NULL DEFAULT GETDATE(),
    thoi_gian_cap_nhat DATETIME NOT NULL DEFAULT GETDATE(),
    dang_nhap_cuoi DATETIME,
    trang_thai_tai_khoan VARCHAR(10) DEFAULT 'hoat_dong' CHECK (trang_thai_tai_khoan IN ('hoat_dong', 'khong_hoat_dong', 'bi_khoa'))
);

-- Bảng Benh_Nhan
CREATE TABLE Benh_Nhan (
    ma_benh_nhan VARCHAR(20) PRIMARY KEY DEFAULT ('BN' + CAST(NEXT VALUE FOR seq_benh_nhan AS VARCHAR(10))),
    ma_nguoi_dung VARCHAR(20) NOT NULL UNIQUE,
    ngay_sinh DATE NOT NULL,
    gioi_tinh VARCHAR(1) CHECK (gioi_tinh IN ('Nam', 'Nu', 'Khac')) NOT NULL,
    dia_chi VARCHAR(255) NOT NULL,
    ma_bao_hiem VARCHAR(50) NULL,
    lien_he_khan_cap VARCHAR(100),
    tom_tat_lich_su_y_te TEXT,
    nhom_mau VARCHAR(5) DEFAULT 'Khong_biet' CHECK (nhom_mau IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-', 'Khong_biet')),
    thoi_gian_tao DATETIME NOT NULL DEFAULT GETDATE(),
    thoi_gian_cap_nhat DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_nguoi_dung FOREIGN KEY (ma_nguoi_dung) REFERENCES Nguoi_Dung(ma_nguoi_dung) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Bảng Bao_Hiem
CREATE TABLE Bao_Hiem (
    ma_bao_hiem VARCHAR(20) PRIMARY KEY DEFAULT ('INS' + CAST(NEXT VALUE FOR seq_bao_hiem AS VARCHAR(10))),
    ma_benh_nhan VARCHAR(20) NOT NULL UNIQUE,
    ten_nha_cung_cap VARCHAR(100) NOT NULL,
    so_hop_dong VARCHAR(50) NOT NULL,
    chi_tiet_bao_hiem TEXT,
    ngay_phat_hanh DATE NOT NULL,
    ngay_het_han DATE NOT NULL,
    trang_thai_bao_hiem VARCHAR(10) DEFAULT 'cho_xu_ly' CHECK (trang_thai_bao_hiem IN ('hoat_dong', 'het_han', 'cho_xu_ly')),
    thoi_gian_tao DATETIME NOT NULL DEFAULT GETDATE(),
    thoi_gian_cap_nhat DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_benh_nhan FOREIGN KEY (ma_benh_nhan) REFERENCES Benh_Nhan(ma_benh_nhan) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Bảng Chuyen_Khoa
CREATE TABLE Chuyen_Khoa (
    ma_chuyen_khoa VARCHAR(20) PRIMARY KEY DEFAULT ('SP' + CAST(NEXT VALUE FOR seq_chuyen_khoa AS VARCHAR(10))),
    ten_chuyen_khoa VARCHAR(100) NOT NULL UNIQUE,
    mo_ta TEXT,
    thoi_gian_tao DATETIME NOT NULL DEFAULT GETDATE(),
    thoi_gian_cap_nhat DATETIME NOT NULL DEFAULT GETDATE()
);

-- Bảng Bac_Si
CREATE TABLE Bac_Si (
    ma_bac_si VARCHAR(20) PRIMARY KEY DEFAULT ('DR' + CAST(NEXT VALUE FOR seq_bac_si AS VARCHAR(10))),
    ma_nguoi_dung VARCHAR(20) NOT NULL UNIQUE,
    ma_chuyen_khoa VARCHAR(20) NOT NULL,
    so_giay_phep VARCHAR(50) NOT NULL UNIQUE,
    so_nam_kinh_nghiem INT NOT NULL,
    dia_chi_phong_kham VARCHAR(255),
    tieu_su TEXT,
    thoi_gian_tao DATETIME NOT NULL DEFAULT GETDATE(),
    thoi_gian_cap_nhat DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_nguoi_dung_bac_si FOREIGN KEY (ma_nguoi_dung) REFERENCES Nguoi_Dung(ma_nguoi_dung) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_chuyen_khoa FOREIGN KEY (ma_chuyen_khoa) REFERENCES Chuyen_Khoa(ma_chuyen_khoa) ON DELETE NO ACTION ON UPDATE CASCADE
);

-- Bảng Lich_Hen
CREATE TABLE Lich_Hen (
    ma_lich_hen VARCHAR(20) PRIMARY KEY DEFAULT ('APPT' + CAST(NEXT VALUE FOR seq_lich_hen AS VARCHAR(10))),
    ma_benh_nhan VARCHAR(20) NOT NULL,
    ma_bac_si VARCHAR(20) NOT NULL,
    ngay_gio_hen DATETIME NOT NULL,
    loai_lich_hen VARCHAR(20) CHECK (loai_lich_hen IN ('truc_tiep', 'truc_tuyen')) DEFAULT 'truc_tiep',
    trang_thai VARCHAR(20) CHECK (trang_thai IN ('cho_xac_nhan', 'da_xac_nhan', 'hoan_thanh', 'da_huy')) DEFAULT 'cho_xac_nhan',
    ghi_chu TEXT,
    thoi_gian_tao DATETIME NOT NULL DEFAULT GETDATE(),
    thoi_gian_cap_nhat DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_benh_nhan_lich_hen FOREIGN KEY (ma_benh_nhan) REFERENCES Benh_Nhan(ma_benh_nhan) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_bac_si_lich_hen FOREIGN KEY (ma_bac_si) REFERENCES Bac_Si(ma_bac_si) ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Bảng Ho_So_Y_Te
CREATE TABLE Ho_So_Y_Te (
    ma_ho_so_y_te VARCHAR(20) PRIMARY KEY DEFAULT ('MR' + CAST(NEXT VALUE FOR seq_ho_so_y_te AS VARCHAR(10))),
    ma_benh_nhan VARCHAR(20) NOT NULL,
    ma_bac_si VARCHAR(20) NOT NULL,
    ngay_kham DATETIME NOT NULL,
    chan_doan TEXT NOT NULL,
    ma_chan_doan VARCHAR(10),
    phuong_phap_dieu_tri TEXT,
    ghi_chu TEXT,
    tap_tin_dinh_kem TEXT,
    thoi_gian_tao DATETIME NOT NULL DEFAULT GETDATE(),
    thoi_gian_cap_nhat DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_benh_nhan_ho_so FOREIGN KEY (ma_benh_nhan) REFERENCES Benh_Nhan(ma_benh_nhan) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_bac_si_ho_so FOREIGN KEY (ma_bac_si) REFERENCES Bac_Si(ma_bac_si) ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Bảng Don_Thuoc
CREATE TABLE Don_Thuoc (
    ma_don_thuoc VARCHAR(20) PRIMARY KEY DEFAULT ('PR' + CAST(NEXT VALUE FOR seq_don_thuoc AS VARCHAR(10))),
    ma_benh_nhan VARCHAR(20) NOT NULL,
    ma_bac_si VARCHAR(20) NOT NULL,
    ngay_ke_don DATETIME NOT NULL,
    ngay_het_han DATE NOT NULL,
    loai_don_thuoc VARCHAR(20) DEFAULT 'mot_lan' CHECK (loai_don_thuoc IN ('mot_lan', 'lap_lai')),
    trang_thai VARCHAR(20) DEFAULT 'con_hieu_luc' CHECK (trang_thai IN ('con_hieu_luc', 'het_han', 'da_su_dung')),
    huong_dan_su_dung TEXT,
    thoi_gian_tao DATETIME NOT NULL DEFAULT GETDATE(),
    thoi_gian_cap_nhat DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_benh_nhan_don_thuoc FOREIGN KEY (ma_benh_nhan) REFERENCES Benh_Nhan(ma_benh_nhan) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_bac_si_don_thuoc FOREIGN KEY (ma_bac_si) REFERENCES Bac_Si(ma_bac_si) ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Bảng Thuoc
CREATE TABLE Thuoc (
    ma_thuoc VARCHAR(20) PRIMARY KEY DEFAULT ('MED' + CAST(NEXT VALUE FOR seq_thuoc AS VARCHAR(10))),
    ten_thuoc VARCHAR(100) NOT NULL UNIQUE,
    ten_chung VARCHAR(100) NOT NULL,
    gia_don_vi DECIMAL(10,2) NOT NULL CHECK (gia_don_vi >= 0),
    don_vi VARCHAR(20) NOT NULL,
    mo_ta TEXT,
    tac_dung_phu TEXT,
    chong_chi_dinh TEXT,
    thoi_gian_tao DATETIME NOT NULL DEFAULT GETDATE(),
    thoi_gian_cap_nhat DATETIME NOT NULL DEFAULT GETDATE()
);

-- Bảng Thuoc_Trong_Don
CREATE TABLE Thuoc_Trong_Don (
    ma_thuoc_trong_don VARCHAR(20) PRIMARY KEY DEFAULT ('PM' + CAST(NEXT VALUE FOR seq_thuoc_trong_don AS VARCHAR(10))),
    ma_don_thuoc VARCHAR(20) NOT NULL,
    ma_thuoc VARCHAR(20) NOT NULL,
    so_luong INT NOT NULL CHECK (so_luong > 0),
    huong_dan_lieu_luong TEXT NOT NULL,
    thoi_gian_tao DATETIME NOT NULL DEFAULT GETDATE(),
    thoi_gian_cap_nhat DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_don_thuoc FOREIGN KEY (ma_don_thuoc) REFERENCES Don_Thuoc(ma_don_thuoc) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_thuoc FOREIGN KEY (ma_thuoc) REFERENCES Thuoc(ma_thuoc) ON DELETE NO ACTION ON UPDATE CASCADE
);

-- Bảng Don_Hang
CREATE TABLE Don_Hang (
    ma_don_hang VARCHAR(20) PRIMARY KEY DEFAULT ('ORD' + CAST(NEXT VALUE FOR seq_don_hang AS VARCHAR(10))),
    ma_benh_nhan VARCHAR(20) NOT NULL,
    ma_don_thuoc VARCHAR(20) NOT NULL,
    ngay_dat_hang DATETIME NOT NULL,
    tong_gia_tri DECIMAL(15,2) NOT NULL CHECK (tong_gia_tri >= 0),
    trang_thai VARCHAR(20) DEFAULT 'cho_xu_ly' CHECK (trang_thai IN ('cho_xu_ly', 'dang_xu_ly', 'da_giao', 'da_nhan', 'da_huy')),
    dia_chi_giao_hang VARCHAR(255) NOT NULL,
    thoi_gian_tao DATETIME NOT NULL DEFAULT GETDATE(),
    thoi_gian_cap_nhat DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_benh_nhan_don_hang FOREIGN KEY (ma_benh_nhan) REFERENCES Benh_Nhan(ma_benh_nhan) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT fk_don_thuoc_don_hang FOREIGN KEY (ma_don_thuoc) REFERENCES Don_Thuoc(ma_don_thuoc) ON DELETE NO ACTION ON UPDATE CASCADE
);

-- Bảng Mat_Hang_Don_Hang
CREATE TABLE Mat_Hang_Don_Hang (
    ma_mat_hang_don_hang VARCHAR(20) PRIMARY KEY DEFAULT ('OI' + CAST(NEXT VALUE FOR seq_mat_hang_don_hang AS VARCHAR(10))),
    ma_don_hang VARCHAR(20) NOT NULL,
    ma_thuoc_trong_don VARCHAR(20) NOT NULL,
    so_luong_dat INT NOT NULL CHECK (so_luong_dat > 0),
    gia_don_vi DECIMAL(10,2) NOT NULL CHECK (gia_don_vi >= 0),
    tong_phu DECIMAL(10,2) NOT NULL CHECK (tong_phu >= 0),
    thoi_gian_tao DATETIME NOT NULL DEFAULT GETDATE(),
    thoi_gian_cap_nhat DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_don_hang FOREIGN KEY (ma_don_hang) REFERENCES Don_Hang(ma_don_hang),
    CONSTRAINT fk_thuoc_trong_don FOREIGN KEY (ma_thuoc_trong_don) REFERENCES Thuoc_Trong_Don(ma_thuoc_trong_don)
);

-- Bảng Thanh_Toan
CREATE TABLE Thanh_Toan (
    ma_thanh_toan VARCHAR(20) PRIMARY KEY DEFAULT ('PAY' + CAST(NEXT VALUE FOR seq_thanh_toan AS VARCHAR(10))),
    ma_benh_nhan VARCHAR(20) NOT NULL,
    ma_don_hang VARCHAR(20),
    ma_lich_hen VARCHAR(20),
    so_tien DECIMAL(15,2) NOT NULL CHECK (so_tien > 0),
    phuong_thuc_thanh_toan VARCHAR(20) NOT NULL CHECK (phuong_thuc_thanh_toan IN ('tien_mat', 'the', 'chuyen_khoan', 'thanh_toan_di_dong')),
    trang_thai_thanh_toan VARCHAR(20) DEFAULT 'cho_xu_ly' CHECK (trang_thai_thanh_toan IN ('cho_xu_ly', 'hoan_thanh', 'that_bai')),
    ma_giao_dich VARCHAR(50),
    ngay_thanh_toan DATETIME NOT NULL,
    thoi_gian_tao DATETIME NOT NULL DEFAULT GETDATE(),
    thoi_gian_cap_nhat DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_benh_nhan_thanh_toan FOREIGN KEY (ma_benh_nhan) REFERENCES Benh_Nhan(ma_benh_nhan) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_don_hang_thanh_toan FOREIGN KEY (ma_don_hang) REFERENCES Don_Hang(ma_don_hang) ON DELETE SET NULL ON UPDATE NO ACTION,
    CONSTRAINT fk_lich_hen_thanh_toan FOREIGN KEY (ma_lich_hen) REFERENCES Lich_Hen(ma_lich_hen) ON DELETE SET NULL ON UPDATE NO ACTION,
    CONSTRAINT chk_don_hang_hoac_lich_hen CHECK (
        (ma_don_hang IS NOT NULL AND ma_lich_hen IS NULL) OR 
        (ma_don_hang IS NULL AND ma_lich_hen IS NOT NULL) OR 
        (ma_don_hang IS NULL AND ma_lich_hen IS NULL)
    )
);

-- Bảng Hoa_Don
CREATE TABLE Hoa_Don (
    ma_hoa_don VARCHAR(20) PRIMARY KEY DEFAULT ('INV' + CAST(NEXT VALUE FOR seq_hoa_don AS VARCHAR(10))),
    ma_benh_nhan VARCHAR(20) NOT NULL,
    ma_thanh_toan VARCHAR(20) NOT NULL,
    so_hoa_don VARCHAR(20) NOT NULL UNIQUE,
    tong_so_tien DECIMAL(15,2) NOT NULL CHECK (tong_so_tien > 0),
    ngay_phat_hanh DATETIME NOT NULL,
    trang_thai VARCHAR(20) DEFAULT 'da_phat_hanh' CHECK (trang_thai IN ('da_phat_hanh', 'da_thanh_toan', 'bi_huy')),
    thoi_gian_tao DATETIME NOT NULL DEFAULT GETDATE(),
    thoi_gian_cap_nhat DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_benh_nhan_hoa_don FOREIGN KEY (ma_benh_nhan) REFERENCES Benh_Nhan(ma_benh_nhan) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT fk_thanh_toan_hoa_don FOREIGN KEY (ma_thanh_toan) REFERENCES Thanh_Toan(ma_thanh_toan) ON DELETE NO ACTION ON UPDATE CASCADE
);

-- Bảng Phan_Hoi
CREATE TABLE Phan_Hoi (
    ma_phan_hoi VARCHAR(20) PRIMARY KEY DEFAULT ('FB' + CAST(NEXT VALUE FOR seq_phan_hoi AS VARCHAR(10))),
    ma_benh_nhan VARCHAR(20) NOT NULL,
    ma_bac_si VARCHAR(20) NOT NULL,
    diem_danh_gia TINYINT NOT NULL CHECK (diem_danh_gia BETWEEN 1 AND 5),
    binh_luan TEXT,
    ngay_phan_hoi DATETIME NOT NULL,
    thoi_gian_tao DATETIME NOT NULL DEFAULT GETDATE(),
    thoi_gian_cap_nhat DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_benh_nhan_phan_hoi FOREIGN KEY (ma_benh_nhan) REFERENCES Benh_Nhan(ma_benh_nhan) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_bac_si_phan_hoi FOREIGN KEY (ma_bac_si) REFERENCES Bac_Si(ma_bac_si) ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- Bảng Lich_Lam_Viec
CREATE TABLE Lich_Lam_Viec (
    ma_lich_lam_viec VARCHAR(20) PRIMARY KEY DEFAULT ('SCH' + CAST(NEXT VALUE FOR seq_lich_lam_viec AS VARCHAR(10))),
    ma_bac_si VARCHAR(20) NOT NULL,
    thoi_gian_bat_dau DATETIME NOT NULL,
    thoi_gian_ket_thuc DATETIME NOT NULL,
    trang_thai VARCHAR(20) DEFAULT 'con_trong' CHECK (trang_thai IN ('con_trong', 'da_dat', 'khong_kha_dung')),
    mo_hinh_lap_lai VARCHAR(50),
    thoi_gian_tao DATETIME NOT NULL DEFAULT GETDATE(),
    thoi_gian_cap_nhat DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_bac_si_lich_lam_viec FOREIGN KEY (ma_bac_si) REFERENCES Bac_Si(ma_bac_si) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_thoi_gian_hop_le CHECK (thoi_gian_bat_dau < thoi_gian_ket_thuc)
);

-- Bảng Yeu_Cau_Ho_Tro
CREATE TABLE Yeu_Cau_Ho_Tro (
    ma_yeu_cau VARCHAR(20) PRIMARY KEY DEFAULT ('SR' + CAST(NEXT VALUE FOR seq_yeu_cau_ho_tro AS VARCHAR(10))),
    ma_nguoi_dung VARCHAR(20) NOT NULL,
    duoc_phan_cong VARCHAR(20),
    tieu_de VARCHAR(100) NOT NULL,
    mo_ta TEXT NOT NULL,
    muc_do_uu_tien VARCHAR(20) DEFAULT 'trung_binh' CHECK (muc_do_uu_tien IN ('thap', 'trung_binh', 'cao')),
    trang_thai VARCHAR(20) DEFAULT 'moi' CHECK (trang_thai IN ('moi', 'dang_xu_ly', 'da_giai_quyet', 'da_dong')),
    ngay_yeu_cau DATETIME NOT NULL,
    ngay_giai_quyet DATETIME,
    thoi_gian_tao DATETIME NOT NULL DEFAULT GETDATE(),
    thoi_gian_cap_nhat DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_nguoi_dung_yeu_cau FOREIGN KEY (ma_nguoi_dung) REFERENCES Nguoi_Dung(ma_nguoi_dung) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_duoc_phan_cong FOREIGN KEY (duoc_phan_cong) REFERENCES Nguoi_Dung(ma_nguoi_dung) ON DELETE SET NULL ON UPDATE NO ACTION
);

-- Bảng Thong_Bao
CREATE TABLE Thong_Bao (
    ma_thong_bao VARCHAR(20) PRIMARY KEY DEFAULT ('NOTI' + CAST(NEXT VALUE FOR seq_thong_bao AS VARCHAR(10))),
    ma_nguoi_dung VARCHAR(20) NOT NULL,
    tieu_de VARCHAR(100) NOT NULL,
    noi_dung TEXT NOT NULL,
    trang_thai VARCHAR(20) DEFAULT 'chua_doc' CHECK (trang_thai IN ('chua_doc', 'da_doc')),
    loai_doi_tuong_lien_quan VARCHAR(50),
    ma_doi_tuong_lien_quan VARCHAR(20),
    ngay_gui DATETIME NOT NULL,
    thoi_gian_tao DATETIME NOT NULL DEFAULT GETDATE(),
    thoi_gian_cap_nhat DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_nguoi_dung_thong_bao FOREIGN KEY (ma_nguoi_dung) REFERENCES Nguoi_Dung(ma_nguoi_dung) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Bảng Phien_Chat
CREATE TABLE Phien_Chat (
    ma_phien_chat VARCHAR(20) PRIMARY KEY DEFAULT ('CS' + CAST(NEXT VALUE FOR seq_phien_chat AS VARCHAR(10))),
    ma_nguoi_dung_1 VARCHAR(20) NOT NULL,
    ma_nguoi_dung_2 VARCHAR(20) NOT NULL,
    thoi_gian_bat_dau DATETIME NOT NULL,
    thoi_gian_ket_thuc DATETIME,
    dang_hoat_dong BIT DEFAULT 1,
    loai_phien VARCHAR(20) NOT NULL CHECK (loai_phien IN ('tu_van_y_te', 'ho_tro_ky_thuat')),
    thoi_gian_tao DATETIME NOT NULL DEFAULT GETDATE(),
    thoi_gian_cap_nhat DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_nguoi_dung_1_phien FOREIGN KEY (ma_nguoi_dung_1) REFERENCES Nguoi_Dung(ma_nguoi_dung) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_nguoi_dung_2_phien FOREIGN KEY (ma_nguoi_dung_2) REFERENCES Nguoi_Dung(ma_nguoi_dung) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT chk_nguoi_dung_khac_nhau CHECK (ma_nguoi_dung_1 != ma_nguoi_dung_2),
    CONSTRAINT chk_thoi_gian_phien_hop_le CHECK (thoi_gian_ket_thuc IS NULL OR thoi_gian_bat_dau < thoi_gian_ket_thuc)
);

-- Bảng Tin_Nhan_Chat
CREATE TABLE Tin_Nhan_Chat (
    ma_tin_nhan VARCHAR(20) PRIMARY KEY DEFAULT ('MSG' + CAST(NEXT VALUE FOR seq_tin_nhan_chat AS VARCHAR(10))),
    ma_phien_chat VARCHAR(20) NOT NULL,
    ma_nguoi_gui VARCHAR(20) NOT NULL,
    noi_dung TEXT NOT NULL,
    thoi_gian_gui DATETIME NOT NULL,
    thoi_gian_tao DATETIME NOT NULL DEFAULT GETDATE(),
    thoi_gian_cap_nhat DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_phien_chat_tin_nhan FOREIGN KEY (ma_phien_chat) REFERENCES Phien_Chat(ma_phien_chat) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_nguoi_gui_tin_nhan FOREIGN KEY (ma_nguoi_gui) REFERENCES Nguoi_Dung(ma_nguoi_dung) ON DELETE NO ACTION ON UPDATE CASCADE
);

