#!/bin/bash

# Create DEB package directory structure
APPNAME="statesvill-bank"
VERSION="1.0.0"
ARCH="amd64"
DEB_NAME="${APPNAME}_${VERSION}_${ARCH}.deb"
BUILD_DIR="deb-build"
INSTALL_PREFIX="opt/statesvill-bank"

# Clean and setup
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR/DEBIAN"
mkdir -p "$BUILD_DIR/$INSTALL_PREFIX"
mkdir -p "$BUILD_DIR/usr/bin"
mkdir -p "$BUILD_DIR/usr/share/applications"
mkdir -p "$BUILD_DIR/usr/share/icons/hicolor/256x256/apps"

# Copy application files
cp -r "dist/linux-unpacked/"* "$BUILD_DIR/$INSTALL_PREFIX/"

# Create control file
cat > "$BUILD_DIR/DEBIAN/control" << 'CONTROL'
Package: statesvill-bank
Version: 1.0.0
Architecture: amd64
Maintainer: Statesvill <statesvill@bank.local>
Depends: libgtk-3-0, libnotify4, libnss3, libxss1, libxtst6, libsecret-1-0
Homepage: https://statesvillbank.local
Description: Statesvill Bank - Professional Banking Application
 A comprehensive banking application with teller workstation mode,
 50+ banking features, loan calculator, account management, and more.
CONTROL

# Create launcher script
cat > "$BUILD_DIR/usr/bin/$APPNAME" << 'LAUNCHER'
#!/bin/bash
exec /$INSTALL_PREFIX/statesvill-bank "$@"
LAUNCHER
chmod +x "$BUILD_DIR/usr/bin/$APPNAME"

# Create desktop file
cat > "$BUILD_DIR/usr/share/applications/$APPNAME.desktop" << 'DESKTOP'
[Desktop Entry]
Type=Application
Name=Statesvill Bank
Exec=statesvill-bank %U
Icon=statesvill-bank
Categories=Finance;Office;
Terminal=false
DESKTOP

# Build the .deb
cd "$BUILD_DIR"
tar czf ../control.tar.gz DEBIAN/
tar czf ../data.tar.gz --exclude=DEBIAN *
cd ..

# Create the .deb file (ar archive)
ar r "$DEB_NAME" control.tar.gz data.tar.gz

# Cleanup
rm -rf "$BUILD_DIR" control.tar.gz data.tar.gz

echo "✅ Created: $DEB_NAME"
ls -lh "$DEB_NAME"

