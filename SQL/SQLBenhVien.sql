CREATE DATABASE SQLBENHVIEN1
USE SQLBENHVIEN1
CREATE TABLE Users (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    UserID AS ('UserID' + CAST(ID AS VARCHAR(10))) PERSISTED,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    user_type VARCHAR(20) CHECK (user_type IN ('patient', 'doctor', 'admin', 'support', 'accountant', 'pharmacy')) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(15) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    last_login DATETIME,
    account_status VARCHAR(10) DEFAULT 'active' CHECK (account_status IN ('active', 'inactive', 'locked'))
);
INSERT INTO Users (username, email, password_hash, user_type, full_name, phone_number)
VALUES 
('han01', 'han@example.com', '123456hashed', 'patient', 'Han Nguyễn', '0901234567'),
('minhphuc', 'phuc@example.com', 'abc123hashed', 'doctor', 'Minh Phúc', '0987654321'),
('linhtruong', 'linh@example.com', 'linhpass123', 'support', 'Linh Trương', '0911222333'),
('admin01', 'admin@example.com', 'adminsecure', 'admin', 'Admin Super', '0999888777'),
('hoa.tran', 'hoa@example.com', 'hoapass456', 'accountant', 'Trần Thị Hoa', '0933444555'),
('khangpham', 'khang@example.com', 'khangsecure', 'pharmacy', 'Phạm Khang', '0977333444');


CREATE TABLE Patients (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    
    -- Tạo patient_id dạng BN1, BN2, BN3...
    patient_id AS ('BN' + CAST(ID AS VARCHAR(10))) PERSISTED,
    
    UserID INT NOT NULL UNIQUE,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(1) CHECK (gender IN ('M', 'F', 'O')) NOT NULL,
    address VARCHAR(255) NOT NULL,
    insurance_id VARCHAR(50) NULL,
    emergency_contact VARCHAR(100),
    medical_history_summary TEXT,
    blood_type VARCHAR(5) DEFAULT 'Unknown' CHECK (blood_type IN (
        'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-', 'Unknown'
    )),
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),

    -- Foreign Key với Users
    CONSTRAINT fk_user FOREIGN KEY (UserID) REFERENCES Users(ID) ON DELETE CASCADE ON UPDATE CASCADE
);
-- Dữ liệu cho bảng Patients
INSERT INTO Patients (UserID, date_of_birth, gender, address, insurance_id, emergency_contact, medical_history_summary, blood_type)
VALUES
(1, '1995-01-20', 'M', N'123 Nguyễn Trãi, Hà Nội', 'INS1', N'Nguyễn Văn B – 0909123456', N'Tiền sử dị ứng nhẹ với hải sản.', 'O+'),
(2, '1988-05-10', 'M', N'456 Lê Lợi, TP.HCM', 'INS2', N'Trần Văn C – 0987987654', N'Không có bệnh nền.', 'A-'),
(3, '1994-09-15', 'F', N'789 Hai Bà Trưng, Đà Nẵng', 'INS3', N'Phạm Thị D – 0977123456', N'Tiểu đường tuýp 2.', 'B+'),
(4, '1985-03-01', 'M', N'321 Đoàn Văn Bảo, Hà Nội', 'INS4', N'Lê Minh A – 0934567890', N'Mắc bệnh viêm khớp mãn tính.', 'O-'),
(5, '1992-11-22', 'F', N'654 Nguyễn Hữu Thọ, TP.HCM', 'INS5', N'Phạm Quốc H – 0912123232', N'Không có tiền sử bệnh tật.', 'A+'),
(6, '1990-07-30', 'M', N'234 Trần Hưng Đạo, Đà Nẵng', 'INS6', N'Trần Minh T – 0981234567', N'Tiền sử đau dạ dày.', 'B-');



CREATE TABLE Insurance (
    ID INT IDENTITY(1,1) PRIMARY KEY,

    -- Mã định danh dạng INS1, INS2...
    insurance_id AS ('INS' + CAST(ID AS VARCHAR)) PERSISTED,

    patient_id INT NOT NULL UNIQUE,
    provider_name VARCHAR(100) NOT NULL,
    policy_number VARCHAR(50) NOT NULL,
    coverage_details TEXT,
    issue_date DATE NOT NULL,
    expiry_date DATE NOT NULL,
    insurance_status VARCHAR(10) DEFAULT 'pending' CHECK (insurance_status IN ('active', 'expired', 'pending')),
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),

    -- Foreign key đến bảng Patients.ID (là khóa chính thực sự)
    CONSTRAINT fk_patient FOREIGN KEY (patient_id) REFERENCES Patients(ID) ON DELETE CASCADE ON UPDATE CASCADE
);
-- Dữ liệu cho bảng Insurance
INSERT INTO Insurance (patient_id, provider_name, policy_number, coverage_details, issue_date, expiry_date, insurance_status)
VALUES
(1, N'VietinBank Insurance', 'P1234567', N'Chăm sóc sức khỏe tổng quát', '2023-01-01', '2024-01-01', 'active'),
(2, N'Bảo Việt Insurance', 'P2345678', N'Bảo hiểm tai nạn, ung thư', '2022-06-15', '2023-06-15', 'expired'),
(3, N'Fubon Insurance', 'P3456789', N'Bảo hiểm điều trị dài hạn', '2021-10-10', '2025-10-10', 'pending'),
(4, N'Prudential Insurance', 'P4567890', N'Bảo hiểm sức khỏe và tai nạn', '2020-11-01', '2023-11-01', 'expired'),
(5, N'Manulife Insurance', 'P5678901', N'Bảo hiểm bệnh hiểm nghèo', '2021-05-25', '2024-05-25', 'active'),
(6, N'Bảo Minh Insurance', 'P6789012', N'Bảo hiểm chi trả viện phí', '2022-12-15', '2024-12-15', 'pending');

CREATE TABLE Specialty (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    specialty_id AS ('SP' + CAST(ID AS VARCHAR)) PERSISTED,
    specialty_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
);


CREATE TABLE Doctor (
    ID INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-increment ID (sử dụng làm ID duy nhất trong bảng)
    doctor_id AS ('DR' + CAST(ID AS VARCHAR(10))) PERSISTED,  -- Tạo doctor_id theo dạng DR1, DR2,...
    UserID INT NOT NULL UNIQUE,  -- User ID liên kết với bảng User
    specialty_id INT NOT NULL,  -- Specialty ID liên kết với bảng Specialty
    license_number VARCHAR(50) NOT NULL UNIQUE,  -- Số giấy phép hành nghề
    years_of_experience INT NOT NULL,  -- Số năm kinh nghiệm
    clinic_address VARCHAR(255),  -- Địa chỉ phòng khám
    bio TEXT,  -- Tiểu sử bác sĩ
    created_at DATETIME NOT NULL DEFAULT GETDATE(),  -- Thời gian tạo
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),  -- Thời gian cập nhật
    CONSTRAINT fk_user_doctor FOREIGN KEY (UserID) REFERENCES Users(ID) ON DELETE CASCADE ON UPDATE CASCADE,  -- Khóa ngoại liên kết với User
    CONSTRAINT fk_specialty FOREIGN KEY (specialty_id) REFERENCES Specialty(ID) ON DELETE NO ACTION ON UPDATE CASCADE  -- Khóa ngoại liên kết với Specialty
);

CREATE TABLE Appointment (
    ID INT IDENTITY(1,1) PRIMARY KEY,  -- Số ID tự động tăng
    appointment_id AS ('APPT' + CAST(ID AS VARCHAR)) PERSISTED,  -- Mã định danh dạng APPT1, APPT2...
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATETIME NOT NULL,
    appointment_type VARCHAR(20) CHECK (appointment_type IN ('in_person', 'online')) DEFAULT 'in_person',
    status VARCHAR(20) CHECK (status IN ('pending', 'confirmed', 'completed', 'cancelled')) DEFAULT 'pending',
    notes TEXT,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),  -- Thời gian tạo
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),  -- Thời gian cập nhật
    
    -- Foreign Keys
    CONSTRAINT fk_patient_appt FOREIGN KEY (patient_id) REFERENCES Patients(ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_doctor_appt FOREIGN KEY (doctor_id) REFERENCES Doctor(ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);






