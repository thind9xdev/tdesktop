# Hướng Dẫn Xây Dựng Telegram Desktop Từ Mã Nguồn

Tài liệu này hướng dẫn bạn cách xây dựng ứng dụng Telegram Desktop riêng dựa trên mã nguồn mở chính thức.

## Mục Lục
1. [Tổng Quan](#tổng-quan)
2. [Yêu Cầu Hệ Thống](#yêu-cầu-hệ-thống)
3. [Bước 1: Lấy API Credentials](#bước-1-lấy-api-credentials)
4. [Bước 2: Clone Mã Nguồn](#bước-2-clone-mã-nguồn)
5. [Bước 3: Xây Dựng Trên Từng Hệ Điều Hành](#bước-3-xây-dựng-trên-từng-hệ-điều-hành)
   - [Windows (64-bit)](#windows-64-bit)
   - [Windows (32-bit)](#windows-32-bit)
   - [macOS](#macos)
   - [Linux (Docker)](#linux-docker)
6. [Tùy Chỉnh Ứng Dụng](#tùy-chỉnh-ứng-dụng)
7. [Xử Lý Sự Cố](#xử-lý-sự-cố)
8. [Tài Nguyên Bổ Sung](#tài-nguyên-bổ-sung)

---

## Tổng Quan

Telegram Desktop là ứng dụng nhắn tin mã nguồn mở được phát hành theo giấy phép GPLv3. Bạn có thể:
- Xây dựng phiên bản Telegram Desktop riêng của mình
- Tùy chỉnh giao diện và tính năng
- Học hỏi từ mã nguồn chuyên nghiệp

**Lưu ý quan trọng:** Để sử dụng API của Telegram, bạn cần tuân thủ [Điều khoản dịch vụ của Telegram](https://core.telegram.org/api/terms).

---

## Yêu Cầu Hệ Thống

### Windows
- **Hệ điều hành:** Windows 7 trở lên
- **Phần mềm cần thiết:**
  - Visual Studio 2022 với Windows SDK 10.0.26100.0
  - Python 3.10
  - Git
- **Dung lượng ổ đĩa:** Khoảng 50 GB

### macOS
- **Hệ điều hành:** macOS 10.13 trở lên
- **Phần mềm cần thiết:**
  - Xcode (phiên bản mới nhất)
  - Homebrew
  - Git, CMake, Ninja, và các công cụ khác
- **Dung lượng ổ đĩa:** Khoảng 55 GB

### Linux
- **Hệ điều hành:** Bất kỳ bản phân phối Linux nào hỗ trợ Docker
- **Phần mềm cần thiết:**
  - Docker
  - Git
  - Poetry (Python)
- **Dung lượng ổ đĩa:** Khoảng 40 GB

---

## Bước 1: Lấy API Credentials

Để xây dựng Telegram Desktop, bạn cần có `api_id` và `api_hash` từ Telegram.

### Cách lấy API Credentials:

1. Truy cập [https://my.telegram.org](https://my.telegram.org)
2. Đăng nhập bằng số điện thoại Telegram của bạn
3. Chọn **API development tools**
4. Điền thông tin ứng dụng:
   - **App title:** Tên ứng dụng của bạn
   - **Short name:** Tên viết tắt
   - **Platform:** Chọn Desktop
   - **Description:** Mô tả ứng dụng
5. Nhấn **Create application**
6. Ghi lại `api_id` và `api_hash` của bạn

### Credentials Thử Nghiệm (CHỈ DÙNG ĐỂ TEST):

Nếu bạn chỉ muốn thử nghiệm, có thể sử dụng credentials sau (không dùng để triển khai thực tế):

```
api_id: 17349
api_hash: 344583e45741c457fe1862106095a5eb
```

**Cảnh báo:** Nếu triển khai ứng dụng với credentials này, người dùng sẽ gặp lỗi server khi đăng nhập.

---

## Bước 2: Clone Mã Nguồn

Mở Terminal (hoặc Command Prompt trên Windows) và chạy:

```bash
# Chọn thư mục làm việc (ví dụ: TBuild)
mkdir TBuild
cd TBuild

# Clone mã nguồn kèm submodules
git clone --recursive https://github.com/telegramdesktop/tdesktop.git
```

---

## Bước 3: Xây Dựng Trên Từng Hệ Điều Hành

### Windows (64-bit)

#### Chuẩn bị:

1. **Cài đặt Visual Studio 2022:**
   - Tải từ [https://visualstudio.microsoft.com](https://visualstudio.microsoft.com)
   - Chọn workload "Desktop development with C++"
   - Đảm bảo cài Windows SDK 10.0.26100.0

2. **Cài đặt Python 3.10:**
   - Tải từ [https://www.python.org/downloads/](https://www.python.org/downloads/)
   - **Quan trọng:** Chọn "Add to PATH" khi cài đặt

3. **Cài đặt Git:**
   - Tải từ [https://git-scm.com/download/win](https://git-scm.com/download/win)

#### Xây dựng:

1. Mở **x64 Native Tools Command Prompt for VS 2022** (tìm trong Start Menu > Visual Studio 2022)

2. Di chuyển đến thư mục làm việc:
   ```batch
   cd D:\TBuild
   ```

3. Clone và chuẩn bị thư viện:
   ```batch
   git clone --recursive https://github.com/telegramdesktop/tdesktop.git
   tdesktop\Telegram\build\prepare\win.bat
   ```

4. Cấu hình dự án (thay YOUR_API_ID và YOUR_API_HASH):
   ```batch
   cd tdesktop\Telegram
   configure.bat x64 -D TDESKTOP_API_ID=YOUR_API_ID -D TDESKTOP_API_HASH=YOUR_API_HASH
   ```

5. Mở file solution trong Visual Studio:
   - Mở `D:\TBuild\tdesktop\out\Telegram.sln`
   - Chọn project Telegram
   - Nhấn **Build > Build Telegram**

6. Tìm file thực thi tại:
   - Debug: `D:\TBuild\tdesktop\out\Debug\Telegram.exe`
   - Release: `D:\TBuild\tdesktop\out\Release\Telegram.exe`

### Windows (32-bit)

Quy trình tương tự Windows 64-bit, chỉ thay đổi:

1. Mở **x86 Native Tools Command Prompt for VS 2022**
2. Cấu hình với x86:
   ```batch
   configure.bat x86 -D TDESKTOP_API_ID=YOUR_API_ID -D TDESKTOP_API_HASH=YOUR_API_HASH
   ```

---

### macOS

#### Chuẩn bị:

1. **Cài đặt Xcode:**
   ```bash
   # Cài đặt từ App Store, sau đó:
   sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
   ```

2. **Cài đặt Homebrew và các công cụ:**
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   brew install git automake cmake wget pkg-config gnu-tar ninja nasm meson
   ```

#### Xây dựng:

1. Di chuyển đến thư mục làm việc:
   ```bash
   cd ~/TBuild
   ```

2. Clone và chuẩn bị thư viện:
   ```bash
   git clone --recursive https://github.com/telegramdesktop/tdesktop.git
   ./tdesktop/Telegram/build/prepare/mac.sh
   ```

3. Cấu hình dự án (thay YOUR_API_ID và YOUR_API_HASH):
   ```bash
   cd tdesktop/Telegram
   ./configure.sh -D TDESKTOP_API_ID=YOUR_API_ID -D TDESKTOP_API_HASH=YOUR_API_HASH
   ```

4. Mở Xcode và xây dựng:
   - Mở `~/TBuild/tdesktop/out/Telegram.xcodeproj`
   - Chọn cấu hình Debug hoặc Release
   - Nhấn **Product > Build**

---

### Linux (Docker)

#### Chuẩn bị:

1. **Cài đặt Docker:**
   ```bash
   # Ubuntu/Debian
   sudo apt update
   sudo apt install docker.io
   sudo usermod -aG docker $USER
   # Đăng xuất và đăng nhập lại

   # Fedora
   sudo dnf install docker
   sudo systemctl start docker
   sudo usermod -aG docker $USER
   ```

2. **Cài đặt Poetry:**
   ```bash
   curl -sSL https://install.python-poetry.org | python3 -
   ```

#### Xây dựng:

1. Di chuyển đến thư mục làm việc:
   ```bash
   cd ~/TBuild
   ```

2. Clone và chuẩn bị:
   ```bash
   git clone --recursive https://github.com/telegramdesktop/tdesktop.git
   ./tdesktop/Telegram/build/prepare/linux.sh
   ```

3. Xây dựng phiên bản Release:
   ```bash
   cd tdesktop
   docker run --rm -it \
       -u $(id -u) \
       -v "$PWD:/usr/src/tdesktop" \
       tdesktop:centos_env \
       /usr/src/tdesktop/Telegram/build/docker/centos_env/build.sh \
       -D TDESKTOP_API_ID=YOUR_API_ID \
       -D TDESKTOP_API_HASH=YOUR_API_HASH
   ```

4. Xây dựng phiên bản Debug:
   ```bash
   docker run --rm -it \
       -u $(id -u) \
       -v "$PWD:/usr/src/tdesktop" \
       -e CONFIG=Debug \
       tdesktop:centos_env \
       /usr/src/tdesktop/Telegram/build/docker/centos_env/build.sh \
       -D TDESKTOP_API_ID=YOUR_API_ID \
       -D TDESKTOP_API_HASH=YOUR_API_HASH
   ```

5. Tìm file thực thi trong thư mục `out`

#### Visual Studio Code (Tùy chọn):

Nếu muốn phát triển với VS Code:

1. Cài đặt extension [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

2. Tạo file `.vscode/settings.json`:
   ```json
   {
       "cmake.configureSettings": {
           "TDESKTOP_API_ID": "YOUR_API_ID",
           "TDESKTOP_API_HASH": "YOUR_API_HASH"
       }
   }
   ```

3. Mở repository và chọn **Reopen in Container**

---

## Tùy Chỉnh Ứng Dụng

Sau khi xây dựng thành công, bạn có thể tùy chỉnh ứng dụng:

### Thay đổi tên ứng dụng:
- Tìm các file cấu hình trong `Telegram/Resources/`
- Chỉnh sửa tên hiển thị trong các file `.rc` và `.plist`

### Thay đổi biểu tượng:
- Thay thế các file icon trong `Telegram/Resources/art/`

### Thay đổi màu sắc và giao diện:
- Xem các file style trong `Telegram/SourceFiles/ui/`

### Thêm tính năng mới:
- Mã nguồn chính nằm trong `Telegram/SourceFiles/`
- Tuân theo cấu trúc và coding style hiện có

---

## Xử Lý Sự Cố

### Lỗi phổ biến:

1. **Thiếu submodules:**
   ```bash
   git submodule update --init --recursive
   ```

2. **Lỗi thư viện thiếu:**
   - Chạy lại script prepare tương ứng với hệ điều hành

3. **Lỗi API credentials:**
   - Đảm bảo `api_id` là số nguyên (không có dấu ngoặc kép)
   - Đảm bảo `api_hash` là chuỗi hợp lệ

4. **Lỗi dung lượng ổ đĩa:**
   - Đảm bảo có đủ dung lượng (50-55 GB)

5. **Lỗi phiên bản SDK trên Windows:**
   - Kiểm tra đã cài Windows SDK 10.0.26100.0

---

## Tài Nguyên Bổ Sung

- [Telegram API Documentation](https://core.telegram.org)
- [MTProto Protocol](https://core.telegram.org/mtproto)
- [Telegram Open Source Projects](https://telegram.org/apps#source-code)
- [Issues và Thảo luận](https://github.com/telegramdesktop/tdesktop/issues)

---

## Giấy Phép

Mã nguồn Telegram Desktop được phát hành theo giấy phép [GPLv3 với ngoại lệ OpenSSL](LICENSE).

---

**Chúc bạn xây dựng thành công ứng dụng Telegram của riêng mình!** 🎉
