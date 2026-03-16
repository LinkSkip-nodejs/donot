const tar = require('tar');
const fs = require('fs');
const path = require('path');

const debDir = 'dist';
if (!fs.existsSync(debDir)) fs.mkdirSync(debDir);

const appName = 'statesvill-bank';
const version = '1.0.0';
const arch = 'amd64';
const debFile = path.join(debDir, `${appName}_${version}_${arch}.deb`);

console.log('Building .deb package...');

// Create DEBIAN directory
const debianDir = path.join(debDir, 'DEBIAN');
if (fs.existsSync(debianDir)) fs.rmSync(debianDir, { recursive: true });
fs.mkdirSync(debianDir, { recursive: true });

// Write control file
const controlContent = `Package: statesvill-bank
Version: ${version}
Architecture: ${arch}
Maintainer: Statesvill <statesvill@bank.local>
Homepage: https://statesvillbank.local
Description: Statesvill Bank - Professional Banking Application
Depends: libnotify-bin
`;
fs.writeFileSync(path.join(debianDir, 'control'), controlContent);

// Create package directory
const pkgDir = path.join(debDir, 'package');
if (fs.existsSync(pkgDir)) fs.rmSync(pkgDir, { recursive: true });
fs.mkdirSync(pkgDir, { recursive: true });

// Copy app files
const appDir = path.join(pkgDir, 'usr/local/lib/statesvill-bank');
fs.mkdirSync(appDir, { recursive: true });

console.log('Copying application files...');
copyDirSync('src', path.join(appDir, 'src'));
copyDirSync('node_modules', path.join(appDir, 'node_modules'));
copyFileSync('package.json', path.join(appDir, 'package.json'));
copyFileSync('package-lock.json', path.join(appDir, 'package-lock.json'));

// Create desktop file
const desktopDir = path.join(pkgDir, 'usr/share/applications');
fs.mkdirSync(desktopDir, { recursive: true });
const desktopFile = `[Desktop Entry]
Type=Application
Name=Statesvill Bank
Exec=/usr/local/lib/statesvill-bank/node_modules/.bin/electron /usr/local/lib/statesvill-bank
Icon=application-x-executable
Categories=Finance;
`;
fs.writeFileSync(path.join(desktopDir, 'statesvill-bank.desktop'), desktopFile);

// Create executable launcher
const binDir = path.join(pkgDir, 'usr/local/bin');
fs.mkdirSync(binDir, { recursive: true });
const launcherScript = `#!/bin/bash
/usr/local/lib/statesvill-bank/node_modules/.bin/electron /usr/local/lib/statesvill-bank
`;
fs.writeFileSync(path.join(binDir, 'statesvill-bank'), launcherScript);
fs.chmodSync(path.join(binDir, 'statesvill-bank'), '755');

// Package into tar
console.log('Creating tar archives...');
tar.c({ gzip: true, file: path.join(debDir, 'control.tar.gz'), cwd: debianDir }, ['.']);
tar.c({ gzip: true, file: path.join(debDir, 'data.tar.gz'), cwd: pkgDir }, ['.']);

// Create debian-binary
fs.writeFileSync(path.join(debDir, 'debian-binary'), '2.0\n');

// Combine into .deb
console.log('Combining into .deb package...');
const deb = fs.createWriteStream(debFile);
deb.write(fs.readFileSync(path.join(debDir, 'debian-binary')));
deb.write(fs.readFileSync(path.join(debDir, 'control.tar.gz')));
deb.write(fs.readFileSync(path.join(debDir, 'data.tar.gz')));
deb.end();

console.log(`✅ .deb created: ${debFile}`);

function copyDirSync(src, dest) {
  if (!fs.existsSync(dest)) fs.mkdirSync(dest, { recursive: true });
  const entries = fs.readdirSync(src, { withFileTypes: true });
  for (const entry of entries) {
    if (entry.name === 'node_modules' && src === '.') continue;
    const srcPath = path.join(src, entry.name);
    const destPath = path.join(dest, entry.name);
    if (entry.isDirectory()) copyDirSync(srcPath, destPath);
    else fs.copyFileSync(srcPath, destPath);
  }
}

function copyFileSync(src, dest) {
  if (fs.existsSync(src)) fs.copyFileSync(src, dest);
}
