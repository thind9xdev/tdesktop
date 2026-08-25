# Hướng dẫn Chi tiết Dự án Telegram Desktop

## Giới thiệu về Dự án

Đây là mã nguồn hoàn chỉnh của **Telegram Desktop** - ứng dụng nhắn tin chính thức của Telegram cho máy tính. Dự án được viết bằng C++ sử dụng framework Qt và được xây dựng trên Telegram API và giao thức MTProto.

## Cấu trúc Thư mục Chính

### 1. Thư mục Giao diện (UI) - Nơi sửa đổi giao diện

```
/Telegram/SourceFiles/ui/          # Các thành phần giao diện chính
/Telegram/SourceFiles/intro/       # Màn hình đăng nhập/giới thiệu
/Telegram/SourceFiles/mainwindow.cpp # Cửa sổ chính
/Telegram/SourceFiles/mainwidget.cpp # Widget chính
/Telegram/SourceFiles/window/      # Quản lý cửa sổ
/Telegram/SourceFiles/dialogs/     # Danh sách cuộc trò chuyện
/Telegram/SourceFiles/boxes/       # Các hộp thoại
```

**Các file quan trọng để sửa giao diện:**
- `mainwindow.cpp/h` - Cửa sổ chính của ứng dụng
- `ui/` - Chứa tất cả components UI như button, input, layout
- `intro/intro_qr.cpp` - Màn hình QR code đăng nhập
- `dialogs/` - Giao diện danh sách chat

### 2. Thư mục Logo và Biểu tượng - Nơi thay đổi logo

```
/Telegram/Resources/art/           # Chứa tất cả logo và icon
/Telegram/Resources/icons/         # Icon giao diện
/Telegram/Resources/qrc/           # File tài nguyên Qt
```

**Các file logo chính cần thay đổi:**
- `icon256.png` - Icon chính 256x256px
- `logo_256.png` - Logo chính 256x256px
- `logo_256_no_margin.png` - Logo không có viền
- `business_logo.png` - Logo business
- `affiliate_logo.png` - Logo affiliate
- `icon*.png` - Các icon với kích thước khác nhau (16, 32, 48, 64, 128, 512px)

### 3. Thư mục Database/Storage - Nơi quản lý cơ sở dữ liệu

```
/Telegram/SourceFiles/storage/     # Hệ thống lưu trữ
/Telegram/SourceFiles/main/        # Quản lý tài khoản và session
```

**Các file database quan trọng:**
- `storage_account.cpp` - Quản lý tài khoản và đường dẫn database
- `storage_domain.cpp` - Quản lý domain và khởi tạo
- `main_domain.cpp` - Logic chính của domain

## Cách Thay đổi Giao diện

### 1. Sửa đổi màu sắc và theme
- File style: `/Telegram/SourceFiles/ui/*.style`
- Theme files: `/Telegram/Resources/*.tdesktop-theme`

### 2. Sửa đổi layout và components
- Main window: `/Telegram/SourceFiles/mainwindow.cpp`
- Widgets: `/Telegram/SourceFiles/ui/`

### 3. Thay đổi text và ngôn ngữ
- Language files: `/Telegram/Resources/langs/`
- String resources: Trong các file `.cpp` có thể tìm kiếm chuỗi để thay đổi

## Cách Thay đổi Logo

### 1. Chuẩn bị logo mới
Tạo logo với các kích thước:
- 16x16, 32x32, 48x48, 64x64, 128x128, 256x256, 512x512 pixels
- Format: PNG với nền trong suốt
- Có thể tạo cả file ICO cho Windows

### 2. Thay thế files trong `/Telegram/Resources/art/`
```bash
# Thay thế các file logo chính
cp logo_moi_256.png /Telegram/Resources/art/logo_256.png
cp logo_moi_256.png /Telegram/Resources/art/logo_256_no_margin.png
cp icon_moi_256.png /Telegram/Resources/art/icon256.png

# Thay thế tất cả kích thước icon
cp icon_moi_16.png /Telegram/Resources/art/icon16.png
cp icon_moi_32.png /Telegram/Resources/art/icon32.png
# ... và tiếp tục với các kích thước khác
```

### 3. Cập nhật trong code (nếu cần)
Tìm kiếm trong code các tham chiếu đến logo:
```cpp
// Trong intro_qr.cpp
QImage TelegramLogoImage() {
    // Có thể cần sửa đổi hàm này
}
```

## Cách Tạo và Quản lý Database

### 1. Hiểu về Database Structure
Telegram Desktop sử dụng:
- **Local Storage**: Lưu trữ cache, settings, và dữ liệu tạm
- **SQLite**: Cho một số dữ liệu có cấu trúc
- **Custom Binary Format**: Cho dữ liệu tin nhắn

### 2. Database Paths
```cpp
// Trong storage_account.cpp
QString ComputeDatabasePath(const QString &dataName) {
    return BaseGlobalPath()
        + "user_" + dataName + '/';
}
```

Đường dẫn database mặc định:
- **Windows**: `%APPDATA%/Telegram Desktop/tdata/`
- **Linux**: `~/.local/share/TelegramDesktop/tdata/`
- **macOS**: `~/Library/Application Support/Telegram Desktop/tdata/`

### 3. Khởi tạo Database
Database được tự động tạo khi:
- Người dùng đăng nhập lần đầu
- Ứng dụng khởi động và không tìm thấy database

## Cách Build và Chạy Dự án

### 1. Yêu cầu hệ thống

**Dependencies chính:**
- Qt 6.x hoặc Qt 5.15
- CMake 3.16+
- C++20 compiler (GCC 10+, Clang 12+, MSVC 2019+)
- Python 3.x
- Git

### 2. Lấy API Credentials
Trước khi build, bạn cần có `api_id` và `api_hash` từ:
1. Đăng ký tại https://my.telegram.org
2. Tạo app mới để lấy API credentials

### 3. Build trên Linux (Khuyến nghị dùng Docker)

```bash
# 1. Clone repository
git clone --recursive https://github.com/thind9xdev/tdesktop.git
cd tdesktop

# 2. Chuẩn bị môi trường
./Telegram/build/prepare/linux.sh

# 3. Build bằng Docker
docker run --rm -it \
    -u $(id -u) \
    -v "$PWD:/usr/src/tdesktop" \
    tdesktop:centos_env \
    /usr/src/tdesktop/Telegram/build/docker/centos_env/build.sh \
    -D TDESKTOP_API_ID=YOUR_API_ID \
    -D TDESKTOP_API_HASH=YOUR_API_HASH

# 4. Build debug version
docker run --rm -it \
    -u $(id -u) \
    -v "$PWD:/usr/src/tdesktop" \
    -e CONFIG=Debug \
    tdesktop:centos_env \
    /usr/src/tdesktop/Telegram/build/docker/centos_env/build.sh \
    -D TDESKTOP_API_ID=YOUR_API_ID \
    -D TDESKTOP_API_HASH=YOUR_API_HASH
```

### 4. Build trên Windows

```cmd
# 1. Clone repository
git clone --recursive https://github.com/thind9xdev/tdesktop.git
cd tdesktop

# 2. Chạy configure script
cd Telegram
configure.bat -D TDESKTOP_API_ID=YOUR_API_ID -D TDESKTOP_API_HASH=YOUR_API_HASH

# 3. Build
cmake --build ../out --config Release
```

### 5. Build trên macOS

```bash
# 1. Clone repository
git clone --recursive https://github.com/thind9xdev/tdesktop.git
cd tdesktop

# 2. Chuẩn bị
./Telegram/build/prepare/mac.sh

# 3. Configure và build
cd Telegram
./configure.sh -D TDESKTOP_API_ID=YOUR_API_ID -D TDESKTOP_API_HASH=YOUR_API_HASH
cd ..
cmake --build out --config Release
```

## Cách Chạy Ứng dụng

### 1. Sau khi build thành công
File executable sẽ có trong thư mục `out/`:
- **Linux**: `out/Telegram`
- **Windows**: `out/Release/Telegram.exe`
- **macOS**: `out/Telegram.app`

### 2. Chạy ứng dụng
```bash
# Linux
./out/Telegram

# Windows
./out/Release/Telegram.exe

# macOS
open ./out/Telegram.app
```

## Tips và Lưu ý

### 1. Development Workflow
- Sử dụng debug build khi develop: `-e CONFIG=Debug`
- Enable logging để debug: thêm `-DTDESKTOP_DISABLE_CRASH_REPORTS=ON`

### 2. Customization Tips
- Backup code gốc trước khi sửa đổi
- Test trên debug build trước khi build release
- Sử dụng Qt Creator IDE để development dễ dàng hơn

### 3. Common Issues
- **Build errors**: Kiểm tra dependencies và API credentials
- **Runtime errors**: Kiểm tra permissions và database paths
- **UI issues**: Kiểm tra Qt version compatibility

### 4. Useful Commands
```bash
# Clean build
rm -rf out/

# Rebuild completely
./configure.sh && cmake --build out --config Release

# Check dependencies
ldd ./out/Telegram  # Linux
otool -L ./out/Telegram.app/Contents/MacOS/Telegram  # macOS
```

## Ví dụ Cụ thể về Sửa đổi Code

### 1. Thay đổi Logo trong QR Login
```cpp
// File: /Telegram/SourceFiles/intro/intro_qr.cpp
// Tìm hàm TelegramLogoImage() để thay đổi logo QR
QImage TelegramLogoImage() {
    const auto size = QSize(st::introQrCenterSize, st::introQrCenterSize);
    auto result = QImage(
        size * style::DevicePixelRatio(),
        QImage::Format_ARGB32_Premultiplied);
    result.fill(Qt::transparent);
    result.setDevicePixelRatio(style::DevicePixelRatio());
    {
        auto p = QPainter(&result);
        auto hq = PainterHighQualityEnabler(p);
        p.setBrush(QrActiveColor());
        p.setPen(Qt::NoPen);
        p.drawEllipse(QRect(QPoint(), size));
        // Thay đổi icon ở đây
        st::introQrPlane.paintInCenter(p, QRect(QPoint(), size));
    }
    return result;
}
```

### 2. Thay đổi Logo Business/Affiliate
```cpp
// File: /Telegram/SourceFiles/ui/effects/premium_top_bar.cpp
// Tìm đoạn code load logo business
if (_logo == u"business"_q) {
    _dollar = ScaleTo(QImage(u":/gui/art/business_logo.png"_q));
} else if (_logo == u"affiliate"_q) {
    _dollar = ScaleTo(QImage(u":/gui/art/affiliate_logo.png"_q));
}
// Thay thế các file PNG này bằng logo mới
```

### 3. Database Path Configuration
```cpp
// File: /Telegram/SourceFiles/storage/storage_account.cpp
QString ComputeDatabasePath(const QString &dataName) {
    return BaseGlobalPath()
        + "user_" + dataName
        + '/';
}

// Có thể tùy chỉnh đường dẫn database ở đây
// Ví dụ: thêm prefix hoặc thay đổi structure
```

### 4. Thay đổi Màu sắc UI
```style
// File: /Telegram/SourceFiles/ui/td_common.style
// Sửa đổi các biến màu
windowBg: #ffffff;
windowFg: #000000;
windowBgOver: #f5f5f5;
windowBgRipple: #e7e7e7;
```

## Workflow Development Khuyến nghị

### 1. Setup Development Environment
```bash
# Clone repo
git clone --recursive https://github.com/thind9xdev/tdesktop.git
cd tdesktop

# Tạo branch mới cho customization
git checkout -b custom-ui-changes

# Setup build environment
./Telegram/build/prepare/linux.sh  # hoặc platform tương ứng
```

### 2. Iterative Development Process
```bash
# 1. Thay đổi logo/resources
cp logo_moi.png /Telegram/Resources/art/logo_256.png

# 2. Sửa đổi code UI
# Edit các file trong /Telegram/SourceFiles/ui/

# 3. Test build
docker run --rm -it \
    -v "$PWD:/usr/src/tdesktop" \
    -e CONFIG=Debug \
    tdesktop:centos_env \
    /usr/src/tdesktop/Telegram/build/docker/centos_env/build.sh \
    -D TDESKTOP_API_ID=YOUR_API_ID \
    -D TDESKTOP_API_HASH=YOUR_API_HASH

# 4. Run và test
./out/Telegram

# 5. Commit changes
git add .
git commit -m "Custom UI changes"
```

### 3. Debug và Troubleshooting
```bash
# Enable debug output
export QT_LOGGING_RULES="*.debug=true"
./out/Telegram

# Check dependencies
ldd ./out/Telegram

# Memory/crash debugging
gdb ./out/Telegram
```

## Tài liệu Tham khảo

- [Official Build Instructions](docs/)
- [Telegram API Documentation](https://core.telegram.org)
- [Qt Documentation](https://doc.qt.io)
- [CMake Documentation](https://cmake.org/documentation/)
- [C++ Reference](https://en.cppreference.com/)

## Liên hệ và Hỗ trợ

Nếu gặp vấn đề trong quá trình development:
1. Kiểm tra [GitHub Issues](https://github.com/telegramdesktop/tdesktop/issues)
2. Tham khảo [Telegram Developers Chat](https://t.me/tgbetachat)
3. Đọc documentation chi tiết trong thư mục `docs/`