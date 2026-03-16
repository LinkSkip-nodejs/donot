#!/bin/bash
set -e

echo "Building Statesvill Bank .deb..."

VERSION="1.0.0"
ARCH="amd64"
DEB_NAME="statesvill-bank_${VERSION}_${ARCH}.deb"
BUILD_DIR="$(pwd)/dist/build"
PACKAGE_DIR="${BUILD_DIR}/package"
DEBIAN_DIR="${BUILD_DIR}/DEBIAN"

# Clean and create directories
rm -rf "$BUILD_DIR" 2>/dev/null || true
mkdir -p "$DEBIAN_DIR"
mkdir -p "$PACKAGE_DIR/usr/local/lib/statesvill-bank"
mkdir -p "$PACKAGE_DIR/usr/local/bin"
mkdir -p "$PACKAGE_DIR/usr/share/applications"

# Create control file
cat > "$DEBIAN_DIR/control" << 'CONTROL'
Package: statesvill-bank
Version: 1.0.0
Architecture: amd64
Maintainer: Statesvill <statesvill@bank.local>
Homepage: https://statesvillbank.local
Description: Statesvill Bank - Professional Banking Application
 A desktop banking application with cashier workstation features
CONTROL

# Create postinst script
cat > "$DEBIAN_DIR/postinst" << 'POSTINST'
#!/bin/bash
chmod +x /usr/local/bin/statesvill-bank
chmod +x /usr/local/lib/statesvill-bank/node_modules/.bin/electron
POSTINST

chmod 755 "$DEBIAN_DIR/postinst"

# Copy application files
echo "Copying application files..."
cp -r src "$PACKAGE_DIR/usr/local/lib/statesvill-bank/"
cp -r node_modules "$PACKAGE_DIR/usr/local/lib/statesvill-bank/"
cp package.json "$PACKAGE_DIR/usr/local/lib/statesvill-bank/"

# Create desktop entry
cat > "$PACKAGE_DIR/usr/share/applications/statesvill-bank.desktop" << 'DESKTOP'
[Desktop Entry]
Type=Application
Name=Statesvill Bank
Exec=/usr/local/lib/statesvill-bank/node_modules/.bin/electron /usr/local/lib/statesvill-bank
Icon=system-file-manager
Categories=Finance;
Terminal=false
DESKTOP

# Create launcher script
cat > "$PACKAGE_DIR/usr/local/bin/statesvill-bank" << 'LAUNCHER'
#!/bin/bash
exec /usr/local/lib/statesvill-bank/node_modules/.bin/electron /usr/local/lib/statesvill-bank "$@"
LAUNCHER

chmod 755 "$PACKAGE_DIR/usr/local/bin/statesvill-bank"

# Create tar archives
echo "Creating archive files..."
(cd "$DEBIAN_DIR" && tar czf "$BUILD_DIR/control.tar.gz" .)
(cd "$PACKAGE_DIR" && tar czf "$BUILD_DIR/data.tar.gz" .)
echo "2.0" > "$BUILD_DIR/debian-binary"

# Create .deb
echo "Building .deb package..."
cd "$BUILD_DIR"
ar r "$(pwd)/../${DEB_NAME}" debian-binary control.tar.gz data.tar.gz

# Verify
DEB_PATH="$(pwd)/../${DEB_NAME}"
if [ -f "$DEB_PATH" ]; then
  SIZE=$(ls -lh "$DEB_PATH" | awk '{print $5}')
  echo "✅ .deb created successfully: $DEB_PATH ($SIZE)"
  ls -lh "$DEB_PATH"
else
  echo "❌ Failed to create .deb"
  exit 1
fi

# Cleanup
rm -rf "$BUILD_DIR"
