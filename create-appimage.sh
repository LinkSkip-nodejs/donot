#!/bin/bash
mkdir -p AppDir/usr/lib/statesvill-bank
mkdir -p AppDir/usr/bin
mkdir -p AppDir/usr/share/applications

# Copy app
cp -r src AppDir/usr/lib/statesvill-bank/
cp -r node_modules AppDir/usr/lib/statesvill-bank/
cp package.json AppDir/usr/lib/statesvill-bank/

# Create launcher
cat > AppDir/AppRun << 'LAUNCHER'
#!/bin/bash
SELF=$(readlink -f "$0")
HERE="${SELF%/*}"
exec "$HERE/usr/lib/statesvill-bank/node_modules/.bin/electron" "$HERE/usr/lib/statesvill-bank" "$@"
LAUNCHER
chmod +x AppDir/AppRun

# Create desktop file
cat > AppDir/statesvill-bank.desktop << 'DESKTOP'
[Desktop Entry]
Type=Application
Name=Statesvill Bank
Exec=statesvill-bank
Icon=system-file-manager
Categories=Finance;
DESKTOP

# Create AppImage
cd AppDir
tar czf ../statesvill-bank.AppImage.tar.gz .
cd ..

echo "✅ AppImage ready: statesvill-bank.AppImage.tar.gz"
ls -lh statesvill-bank.AppImage.tar.gz
