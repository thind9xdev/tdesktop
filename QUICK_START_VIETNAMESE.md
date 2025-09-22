# Hướng dẫn Nhanh - Telegram Desktop

## Câu trả lời cho các câu hỏi chính

### 1. Dự án này là gì?
**Telegram Desktop** là mã nguồn mở của ứng dụng Telegram cho máy tính desktop. Nó được viết bằng C++ và sử dụng Qt framework.

**Cấu trúc chính:**
- **C++ Core**: Logic chính của ứng dụng
- **Qt UI**: Giao diện người dùng
- **MTProto**: Giao thức bảo mật của Telegram  
- **Database**: Lưu trữ tin nhắn và cache

### 2. Sửa code ở thư mục nào để thay đổi giao diện?

#### 🎨 **Giao diện chính:**
```
/Telegram/SourceFiles/ui/           # Components UI cơ bản
/Telegram/SourceFiles/mainwindow.*  # Cửa sổ chính
/Telegram/SourceFiles/dialogs/      # Danh sách chat
/Telegram/SourceFiles/boxes/        # Hộp thoại popup
```

#### 🎨 **Màu sắc và themes:**
```
/Telegram/SourceFiles/ui/colors.palette  # Định nghĩa màu
/Telegram/SourceFiles/ui/*.style         # Style sheets
/Telegram/Resources/*.tdesktop-theme     # File theme
```

#### 📱 **Màn hình đăng nhập:**
```
/Telegram/SourceFiles/intro/        # Màn hình intro/login
/Telegram/SourceFiles/intro/intro_qr.cpp  # QR code login
```

### 3. Thay đổi logo ở đâu?

#### 🖼️ **Tất cả logo và icon:**
```
/Telegram/Resources/art/            # Thư mục chính chứa logo
```

**Các file cần thay thế:**
```bash
icon16.png, icon32.png, icon48.png, icon64.png    # Icon kích thước nhỏ
icon128.png, icon256.png, icon512.png             # Icon kích thước lớn
icon*@2x.png                                       # Icon cho màn hình Retina
logo_256.png                                       # Logo chính
logo_256_no_margin.png                             # Logo không viền
business_logo.png                                  # Logo business
affiliate_logo.png                                 # Logo affiliate
```

**Cách thay thế nhanh:**
```bash
# Chuẩn bị logo các kích thước khác nhau
cp logo_moi_256.png /Telegram/Resources/art/logo_256.png
cp logo_moi_256.png /Telegram/Resources/art/icon256.png
# ... thay thế tất cả kích thước tương ứng
```

### 4. Cách tạo database cho nó?

#### 💾 **Database tự tạo:**
Database được **TỰ ĐỘNG** tạo khi:
- Người dùng đăng nhập lần đầu
- Ứng dụng khởi động và không tìm thấy database

#### 📍 **Vị trí database:**
```bash
# Windows
%APPDATA%/Telegram Desktop/tdata/

# Linux  
~/.local/share/TelegramDesktop/tdata/

# macOS
~/Library/Application Support/Telegram Desktop/tdata/
```

#### ⚙️ **Cấu hình database:**
```cpp
// File: /Telegram/SourceFiles/storage/storage_account.cpp
QString ComputeDatabasePath(const QString &dataName) {
    return BaseGlobalPath() + "user_" + dataName + '/';
}

// Có thể tùy chỉnh đường dẫn ở đây
```

### 5. Cách chạy dự án?

#### 🛠️ **Bước 1: Chuẩn bị**
```bash
# 1. Lấy API credentials từ https://my.telegram.org
# 2. Clone repository
git clone --recursive https://github.com/thind9xdev/tdesktop.git
cd tdesktop
```

#### 🐳 **Bước 2: Build với Docker (Khuyến nghị)**
```bash
# Chuẩn bị môi trường
./Telegram/build/prepare/linux.sh

# Build
docker run --rm -it \
    -u $(id -u) \
    -v "$PWD:/usr/src/tdesktop" \
    tdesktop:centos_env \
    /usr/src/tdesktop/Telegram/build/docker/centos_env/build.sh \
    -D TDESKTOP_API_ID=YOUR_API_ID \
    -D TDESKTOP_API_HASH=YOUR_API_HASH
```

#### ▶️ **Bước 3: Chạy**
```bash
# Sau khi build xong
./out/Telegram
```

## Workflow Nhanh cho Customization

### 1. Thay đổi Logo (5 phút)
```bash
# Chuẩn bị logo PNG với nền trong suốt
cp logo_moi.png /Telegram/Resources/art/logo_256.png
cp logo_moi.png /Telegram/Resources/art/icon256.png

# Build lại
docker run --rm -it -v "$PWD:/usr/src/tdesktop" tdesktop:centos_env \
    /usr/src/tdesktop/Telegram/build/docker/centos_env/build.sh \
    -D TDESKTOP_API_ID=YOUR_API_ID -D TDESKTOP_API_HASH=YOUR_API_HASH
```

### 2. Thay đổi Màu sắc (10 phút)  
```cpp
// File: /Telegram/SourceFiles/ui/colors.palette
// Thêm màu tùy chỉnh
myBrandColor: #FF6B35;        // Màu chính
myBrandColorHover: #E55A2B;   // Màu hover
myBrandBg: #2C3E50;           // Màu nền
myBrandText: #FFFFFF;         // Màu text
```

### 3. Test nhanh
```bash
# Chạy debug mode
./out/Telegram --debug

# Hoặc với log  
QT_LOGGING_RULES="*.debug=true" ./out/Telegram
```

## Troubleshooting Phổ biến

### ❌ **Build Error**
```bash
# Kiểm tra dependencies
./Telegram/build/prepare/linux.sh

# Clean build
rm -rf out/
```

### ❌ **Runtime Error**
```bash
# Kiểm tra library dependencies
ldd ./out/Telegram

# Chạy với debug
gdb ./out/Telegram
```

### ❌ **Database Issues**
```bash
# Xóa database cũ để tạo mới
rm -rf ~/.local/share/TelegramDesktop/tdata/
```

## Resources Hữu ích

- **📖 Build docs**: `docs/building-linux.md`
- **🔧 API Setup**: `docs/api_credentials.md`  
- **💬 Community**: [Telegram Developers Chat](https://t.me/tgbetachat)
- **🐛 Issues**: [GitHub Issues](https://github.com/telegramdesktop/tdesktop/issues)

---

**💡 Tip:** Bắt đầu với việc thay đổi logo và màu sắc trước, sau đó mới chỉnh sửa logic phức tạp!