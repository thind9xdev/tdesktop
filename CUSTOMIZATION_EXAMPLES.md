# Telegram Desktop Customization Examples

## Logo Replacement Examples

### 1. Replace Main App Icons
```bash
# Prepare your logo in multiple sizes
# Required sizes: 16x16, 32x32, 48x48, 64x64, 128x128, 256x256, 512x512

# Replace main icons
cp your_logo_16.png /Telegram/Resources/art/icon16.png
cp your_logo_32.png /Telegram/Resources/art/icon32.png
cp your_logo_48.png /Telegram/Resources/art/icon48.png
cp your_logo_64.png /Telegram/Resources/art/icon64.png
cp your_logo_128.png /Telegram/Resources/art/icon128.png
cp your_logo_256.png /Telegram/Resources/art/icon256.png
cp your_logo_512.png /Telegram/Resources/art/icon512.png

# Replace retina versions
cp your_logo_32.png /Telegram/Resources/art/icon16@2x.png
cp your_logo_64.png /Telegram/Resources/art/icon32@2x.png
cp your_logo_96.png /Telegram/Resources/art/icon48@2x.png
cp your_logo_128.png /Telegram/Resources/art/icon64@2x.png
cp your_logo_256.png /Telegram/Resources/art/icon128@2x.png
cp your_logo_512.png /Telegram/Resources/art/icon256@2x.png

# Replace main logo files
cp your_logo_256.png /Telegram/Resources/art/logo_256.png
cp your_logo_256.png /Telegram/Resources/art/logo_256_no_margin.png
```

### 2. Custom Business/Premium Logos  
```bash
# Replace business logo
cp your_business_logo.png /Telegram/Resources/art/business_logo.png

# Replace affiliate logo  
cp your_affiliate_logo.png /Telegram/Resources/art/affiliate_logo.png
```

## UI Color Customization

### 1. Basic Color Scheme
```cpp
// File: /Telegram/SourceFiles/ui/colors.palette
// Add custom colors
myCustomBg: #2E3440;
myCustomFg: #ECEFF4;
myCustomAccent: #5E81AC;
myCustomHover: #434C5E;
```

### 2. Chat Interface Colors
```style
// File: /Telegram/SourceFiles/dialogs/dialogs.style
// Customize dialog list colors
dialogsMenuToggle: IconButton {
    width: 40px;
    height: 40px;
    icon: icon {{ "menu_hamburger", myCustomFg }};
    iconOver: icon {{ "menu_hamburger", myCustomAccent }};
    iconPosition: point(6px, 6px);
    rippleAreaPosition: point(0px, 0px);
    rippleAreaSize: 40px;
    ripple: RippleAnimation(defaultRippleAnimation) {
        color: myCustomHover;
    }
}
```

## Database Configuration Examples

### 1. Custom Database Path
```cpp
// File: /Telegram/SourceFiles/storage/storage_account.cpp
// Modify ComputeDatabasePath function
QString ComputeDatabasePath(const QString &dataName) {
    // Original path
    // return BaseGlobalPath() + "user_" + dataName + '/';
    
    // Custom path - example: organize by date
    const auto currentDate = QDate::currentDate().toString("yyyy-MM");
    return BaseGlobalPath() 
        + "sessions/" 
        + currentDate + "/"
        + "user_" + dataName + '/';
}
```

### 2. Database Cleanup Configuration
```cpp
// File: /Telegram/SourceFiles/storage/storage_account.cpp
// Modify cache settings in constructor
Account::Account(not_null<Main::Account*> owner, const QString &dataName)
: _owner(owner)
, _dataName(dataName)
, _dataNameKey(ComputeDataNameKey(dataName))
, _basePath(BaseGlobalPath() + ToFilePart(_dataNameKey) + QChar('/'))
, _tempPath(BaseGlobalPath() + "temp_" + _dataName + QChar('/'))
, _databasePath(ComputeDatabasePath(dataName))
// Custom cache limits (default values shown)
, _cacheTotalSizeLimit(1024 * 1024 * 1024) // 1GB instead of default
, _cacheBigFileTotalSizeLimit(512 * 1024 * 1024) // 512MB
, _cacheTotalTimeLimit(3600 * 24 * 7) // 1 week instead of default
, _cacheBigFileTotalTimeLimit(3600 * 24 * 3) // 3 days
{
    // Additional initialization
}
```

## Main Window Customization

### 1. Window Title and Branding
```cpp
// File: /Telegram/SourceFiles/mainwindow.cpp
// Find window title setting
void MainWindow::updateTitle() {
    auto title = QString("My Custom Telegram");  // Custom title
    if (_account) {
        if (const auto session = _account->maybeSession()) {
            title += " - " + session->user()->name;
        }
    }
    setWindowTitle(title);
}
```

### 2. Startup Behavior
```cpp
// File: /Telegram/SourceFiles/core/application.cpp  
// Modify application startup
void Application::run() {
    // Custom startup logic
    LOG(("App Info: Starting Custom Telegram Client"));
    
    // Original code continues...
    QMimeDatabase().mimeTypeForName(u"text/plain"_q);
    // ... rest of function
}
```

## Build Configuration Examples

### 1. Custom Build Script
```bash
#!/bin/bash
# File: build_custom.sh

# Set custom API credentials
export TDESKTOP_API_ID="YOUR_CUSTOM_API_ID"  
export TDESKTOP_API_HASH="YOUR_CUSTOM_API_HASH"

# Custom build name
export CUSTOM_BUILD_NAME="MyTelegram"

# Build with custom configuration
docker run --rm -it \
    -u $(id -u) \
    -v "$PWD:/usr/src/tdesktop" \
    -e CONFIG=Release \
    -e CUSTOM_BUILD_NAME="$CUSTOM_BUILD_NAME" \
    tdesktop:centos_env \
    /usr/src/tdesktop/Telegram/build/docker/centos_env/build.sh \
    -D TDESKTOP_API_ID=$TDESKTOP_API_ID \
    -D TDESKTOP_API_HASH=$TDESKTOP_API_HASH \
    -D CMAKE_BUILD_TYPE=Release \
    -D TDESKTOP_DISABLE_CRASH_REPORTS=ON
```

### 2. Custom CMake Configuration
```cmake
# File: CustomConfig.cmake
# Add custom build options
set(CUSTOM_BRANDING "MyTelegram" CACHE STRING "Custom branding")
set(CUSTOM_VERSION "1.0.0" CACHE STRING "Custom version")

# Custom preprocessor definitions
add_definitions(-DCUSTOM_BUILD=1)
add_definitions(-DCUSTOM_BRANDING="${CUSTOM_BRANDING}")

# Custom resource paths
set(CUSTOM_RESOURCES_PATH "${CMAKE_SOURCE_DIR}/custom_resources")
if(EXISTS ${CUSTOM_RESOURCES_PATH})
    message(STATUS "Using custom resources from ${CUSTOM_RESOURCES_PATH}")
endif()
```

## Advanced Customization

### 1. Custom Menu Items
```cpp
// File: /Telegram/SourceFiles/mainwindow.cpp
// Add custom menu items
void MainWindow::createMenu() {
    // ... existing menu code ...
    
    // Add custom menu
    auto customMenu = new QMenu("Custom", this);
    customMenu->addAction("Custom Feature 1", [this] {
        // Custom action 1
        showCustomDialog1();
    });
    customMenu->addAction("Custom Feature 2", [this] {
        // Custom action 2  
        showCustomDialog2();
    });
    
    menuBar()->addMenu(customMenu);
}
```

### 2. Custom Notification Behavior
```cpp
// File: /Telegram/SourceFiles/core/application.cpp
// Customize notification handling
void Application::handleNotification(const Notification &notification) {
    // Custom notification logic
    if (customNotificationEnabled()) {
        sendCustomNotification(notification);
    }
    
    // Call original handler
    originalHandleNotification(notification);
}
```

## Testing and Validation

### 1. Custom Test Script
```bash
#!/bin/bash
# File: test_custom_build.sh

echo "Testing custom build..."

# Check if executable exists
if [ ! -f "./out/Telegram" ]; then
    echo "Build failed - executable not found"
    exit 1
fi

# Check custom branding
strings ./out/Telegram | grep -q "MyTelegram"
if [ $? -eq 0 ]; then
    echo "✓ Custom branding found"
else
    echo "✗ Custom branding not found"
fi

# Check custom icons
if [ -f "./out/resources/icon256.png" ]; then
    echo "✓ Custom icons present"
else
    echo "✗ Custom icons missing"
fi

# Test basic functionality
timeout 30s ./out/Telegram --test-mode &
PID=$!
sleep 5
if kill -0 $PID 2>/dev/null; then
    echo "✓ Application starts successfully"
    kill $PID
else
    echo "✗ Application failed to start"
fi

echo "Test completed"
```

### 2. Resource Validation
```bash
#!/bin/bash
# File: validate_resources.sh

echo "Validating custom resources..."

RESOURCES_DIR="/Telegram/Resources/art"
REQUIRED_ICONS=("icon16.png" "icon32.png" "icon48.png" "icon64.png" "icon128.png" "icon256.png" "icon512.png")

for icon in "${REQUIRED_ICONS[@]}"; do
    if [ -f "$RESOURCES_DIR/$icon" ]; then
        # Check image dimensions
        DIMENSIONS=$(identify -format "%wx%h" "$RESOURCES_DIR/$icon")
        EXPECTED="${icon%.*}" # Remove .png extension
        EXPECTED="${EXPECTED#icon}" # Remove icon prefix
        
        if [[ "$DIMENSIONS" == "${EXPECTED}x${EXPECTED}" ]]; then
            echo "✓ $icon ($DIMENSIONS)"
        else
            echo "✗ $icon wrong size ($DIMENSIONS, expected ${EXPECTED}x${EXPECTED})"
        fi
    else
        echo "✗ $icon missing"
    fi
done
```

This file provides concrete, actionable examples for customizing Telegram Desktop, covering logos, UI colors, database configuration, and build processes.