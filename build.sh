#!/bin/bash

set -e

DOWNLOAD_DIR="./downloads"

# Добавляем wine в AppImage
mv $DOWNLOAD_DIR/wine-staging.AppImage ./Wosb.AppDir/usr/bin/wine
chmod +x ./Wosb.AppDir/usr/bin/wine
ln -sf ./wine ./Wosb.AppDir/usr/bin/winetricks
# Добавляем overlayfs в AppImage
mv $DOWNLOAD_DIR/fuse-overlayfs ./Wosb.AppDir/usr/bin/overlayfs
chmod +x ./Wosb.AppDir/usr/bin/overlayfs

# Создаем префикс
export WINEARCH=win64
export WINEPREFIX=$PWD/Wosb.AppDir/app/wine 

WINE=$PWD/Wosb.AppDir/usr/bin/wine
WINETRICKS=$PWD/Wosb.AppDir/usr/bin/winetricks

rm -rf "$WINEPREFIX"

$WINETRICKS -q --force dxvk dotnetdesktop7

$WINE reg ADD "HKCU\\Software\\Xsolla\\3365\\204981\\default" /f /v "isInstalled" /t REG_SZ /d "true"
$WINE reg ADD "HKCU\\Software\\Xsolla\\3365\\204981\\default" /f /v "prefix" /t REG_SZ /d "C:/Games/World of Sea Battle"

# Добавляем лаунчер и сам возб в префикс
mkdir -p "$WINEPREFIX/drive_c/Games/World of Sea Battle/default"
7z x -y $DOWNLOAD_DIR/launcher.exe -o"$WINEPREFIX/drive_c/Games/Wosb Launcher"
# 7z x -y $DOWNLOAD_DIR/game_archive.zip -o"$WINEPREFIX/drive_c/Games/World of Sea Battle/default/game"

sleep 10
sync
chmod +x $DOWNLOAD_DIR/appimagetool.AppImage
ARCH=x86_64 $DOWNLOAD_DIR/appimagetool.AppImage Wosb.AppDir/
sync