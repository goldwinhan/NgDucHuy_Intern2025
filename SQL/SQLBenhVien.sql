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
CREATE TABLE Medical_Record (
    ID INT IDENTITY(1,1) PRIMARY KEY,  -- Sử dụng IDENTITY thay vì AUTO_INCREMENT
    record_id AS ('MR' + CAST(ID AS VARCHAR(10))) PERSISTED,  -- Tạo mã định danh dạng MR1, MR2,...
    patient_id INT NOT NULL,  -- Liên kết với Patients.ID
    doctor_id INT NOT NULL,  -- Liên kết với Doctor.ID
    visit_date DATETIME NOT NULL,  -- Ngày khám
    diagnosis TEXT NOT NULL,  -- Chẩn đoán
    diagnosis_code VARCHAR(10),  -- Mã chẩn đoán (ICD-10, ví dụ)
    treatment TEXT,  -- Phương pháp điều trị
    notes TEXT,  -- Ghi chú
    attachments TEXT,  -- Đính kèm (liên kết file, nếu có)
    created_at DATETIME NOT NULL DEFAULT GETDATE(),  -- Thời gian tạo
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),  -- Thời gian cập nhật
    -- Khóa ngoại liên kết với Patients và Doctor
    CONSTRAINT fk_patient_medical FOREIGN KEY (patient_id) REFERENCES Patients(ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_doctor_medical FOREIGN KEY (doctor_id) REFERENCES Doctor(ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE TABLE Prescription (
    ID INT IDENTITY(1,1) PRIMARY KEY,  -- Sử dụng IDENTITY thay vì AUTO_INCREMENT
    prescription_id AS ('PR' + CAST(ID AS VARCHAR(10))) PERSISTED,  -- Tạo mã định danh dạng PR1, PR2,...
    patient_id INT NOT NULL,  -- Liên kết với Patients.ID
    doctor_id INT NOT NULL,  -- Liên kết với Doctor.ID
    issue_date DATETIME NOT NULL,  -- Ngày phát hành đơn thuốc
    validity_period DATE NOT NULL,  -- Thời hạn hiệu lực
    prescription_type VARCHAR(20) DEFAULT 'one_time' CHECK (prescription_type IN ('one_time', 'recurring')),  -- Thay ENUM bằng CHECK
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'expired', 'used')),  -- Thay ENUM bằng CHECK
    instructions TEXT,  -- Hướng dẫn sử dụng
    created_at DATETIME NOT NULL DEFAULT GETDATE(),  -- Thời gian tạo
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),  -- Thời gian cập nhật
    -- Khóa ngoại liên kết với Patients và Doctor
    CONSTRAINT fk_patient_prescription FOREIGN KEY (patient_id) REFERENCES Patients(ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_doctor_prescription FOREIGN KEY (doctor_id) REFERENCES Doctor(ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);
CREATE TABLE Medication (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    medication_id AS ('MED' + CAST(ID AS VARCHAR(10))) PERSISTED,
    medication_name VARCHAR(100) NOT NULL UNIQUE,
    generic_name VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
    unit VARCHAR(20) NOT NULL,
    description TEXT,
    side_effects TEXT,
    contraindications TEXT,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE()
);
INSERT INTO Medication (medication_name, generic_name, unit_price, unit, description, side_effects, contraindications)
VALUES
('Paracetamol', 'Acetaminophen', 500.00, 'viên', N'Thuốc giảm đau, hạ sốt', N'Buồn nôn, phát ban', N'Dị ứng paracetamol'),
('Amoxicillin', 'Amoxicillin', 2000.00, 'viên', N'Kháng sinh phổ rộng', N'Tiêu chảy, dị ứng', N'Dị ứng penicillin'),
('Insulin', 'Insulin', 150000.00, 'lọ', N'Điều trị tiểu đường', N'Hạ đường huyết', N'Hạ đường huyết');

CREATE TABLE Prescription_Medication (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    prescription_medication_id AS ('PM' + CAST(ID AS VARCHAR(10))) PERSISTED,
    prescription_id INT NOT NULL,
    medication_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    dosage_instructions TEXT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_prescription FOREIGN KEY (prescription_id) REFERENCES Prescription(ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_medication FOREIGN KEY (medication_id) REFERENCES Medication(ID) ON DELETE NO ACTION ON UPDATE CASCADE
);



CREATE TABLE [Order] (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    order_id AS ('ORD' + CAST(ID AS VARCHAR(10))) PERSISTED,
    patient_id INT NOT NULL,
    prescription_id INT NOT NULL,
    order_date DATETIME NOT NULL,
    total_amount DECIMAL(15,2) NOT NULL CHECK (total_amount >= 0),
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled')),
    shipping_address VARCHAR(255) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_patient_order FOREIGN KEY (patient_id) REFERENCES Patients(ID) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT fk_prescription_order FOREIGN KEY (prescription_id) REFERENCES Prescription(ID) ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE Order_Item (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    order_item_id AS ('OI' + CAST(ID AS VARCHAR(10))) PERSISTED,
    order_id INT NOT NULL,
    prescription_medication_id INT NOT NULL,
    quantity_ordered INT NOT NULL CHECK (quantity_ordered > 0),
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
    subtotal DECIMAL(10,2) NOT NULL CHECK (subtotal >= 0),
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_order FOREIGN KEY (order_id) REFERENCES [Order](ID) ,
    CONSTRAINT fk_prescription_medication FOREIGN KEY (prescription_medication_id) REFERENCES Prescription_Medication(ID) 
);


CREATE TABLE Payment (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    payment_id AS ('PAY' + CAST(ID AS VARCHAR(10))) PERSISTED,
    patient_id INT NOT NULL,
    order_id INT,
    appointment_id INT,
    amount DECIMAL(15,2) NOT NULL CHECK (amount > 0),
    payment_method VARCHAR(20) NOT NULL CHECK (payment_method IN ('cash', 'card', 'bank_transfer', 'mobile_payment')),
    payment_status VARCHAR(20) DEFAULT 'pending' CHECK (payment_status IN ('pending', 'completed', 'failed')),
    transaction_id VARCHAR(50),
    payment_date DATETIME NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_patient_payment FOREIGN KEY (patient_id) REFERENCES Patients(ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_order_payment FOREIGN KEY (order_id) REFERENCES [Order](ID) ON DELETE SET NULL ON UPDATE NO ACTION,
    CONSTRAINT fk_appointment_payment FOREIGN KEY (appointment_id) REFERENCES Appointment(ID) ON DELETE SET NULL ON UPDATE NO ACTION,
    CONSTRAINT chk_order_or_appointment CHECK (
        (order_id IS NOT NULL AND appointment_id IS NULL) OR 
        (order_id IS NULL AND appointment_id IS NOT NULL) OR 
        (order_id IS NULL AND appointment_id IS NULL)
    )
);

CREATE TABLE Invoices (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    invoice_id AS ('INV' + CAST(ID AS VARCHAR(10))) PERSISTED,
    patient_id INT NOT NULL,
    payment_id INT NOT NULL,
    invoice_number VARCHAR(20) NOT NULL UNIQUE,
    total_amount DECIMAL(15,2) NOT NULL CHECK (total_amount > 0),
    issue_date DATETIME NOT NULL,
    status VARCHAR(20) DEFAULT 'issued' CHECK (status IN ('issued', 'paid', 'void')),
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_patient_invoice FOREIGN KEY (patient_id) REFERENCES Patients(ID) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT fk_payment_invoice FOREIGN KEY (payment_id) REFERENCES Payment(ID) ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE Feedback (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    feedback_id AS ('FB' + CAST(ID AS VARCHAR(10))) PERSISTED,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    rating TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    feedback_date DATETIME NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_patient_feedback FOREIGN KEY (patient_id) REFERENCES Patients(ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_doctor_feedback FOREIGN KEY (doctor_id) REFERENCES Doctor(ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE Schedule (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    schedule_id AS ('SCH' + CAST(ID AS VARCHAR(10))) PERSISTED,
    doctor_id INT NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    status VARCHAR(20) DEFAULT 'available' CHECK (status IN ('available', 'booked', 'unavailable')),
    recurrence_pattern VARCHAR(50),
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_doctor_schedule FOREIGN KEY (doctor_id) REFERENCES Doctor(ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_time_validity CHECK (start_time < end_time)
);

CREATE TABLE Support_Request (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    request_id AS ('SR' + CAST(ID AS VARCHAR(10))) PERSISTED,
    user_id INT NOT NULL,
    assigned_to INT,
    subject VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    priority VARCHAR(20) DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high')),
    status VARCHAR(20) DEFAULT 'open' CHECK (status IN ('open', 'in_progress', 'resolved', 'closed')),
    request_date DATETIME NOT NULL,
    resolved_date DATETIME,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_user_request FOREIGN KEY (user_id) REFERENCES Users(ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_assigned_to FOREIGN KEY (assigned_to) REFERENCES Users(ID) ON DELETE SET NULL ON UPDATE NO ACTION
);

CREATE TABLE Notification (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    notification_id AS ('NOTI' + CAST(ID AS VARCHAR(10))) PERSISTED,
    user_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    message TEXT NOT NULL,
    status VARCHAR(20) DEFAULT 'unread' CHECK (status IN ('unread', 'read')),
    related_entity_type VARCHAR(50),
    related_entity_id INT,
    sent_date DATETIME NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_user_notification FOREIGN KEY (user_id) REFERENCES Users(ID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Chat_Session (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    session_id AS ('CS' + CAST(ID AS VARCHAR(10))) PERSISTED,
    user1_id INT NOT NULL,
    user2_id INT NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME,
    is_active BIT DEFAULT 1,
    session_type VARCHAR(20) NOT NULL CHECK (session_type IN ('consultation', 'support')),
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_user1_session FOREIGN KEY (user1_id) REFERENCES Users(ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT fk_user2_session FOREIGN KEY (user2_id) REFERENCES Users(ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT chk_users_different CHECK (user1_id != user2_id),
    CONSTRAINT chk_chat_session_time_validity CHECK (end_time IS NULL OR start_time < end_time)
);

CREATE TABLE Chat_Message (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    message_id AS ('MSG' + CAST(ID AS VARCHAR(10))) PERSISTED,
    session_id INT NOT NULL,
    user_id INT NOT NULL,
    message_content TEXT NOT NULL,
    sent_at DATETIME NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_session_message FOREIGN KEY (session_id) REFERENCES Chat_Session(ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_user_message FOREIGN KEY (user_id) REFERENCES Users(ID) ON DELETE NO ACTION ON UPDATE CASCADE
);



