#!/bin/bash

set -e

# URL страницы с загрузками игры
PAGE_URL="https://www.worldofseabattle.com/download2"

# API URL для релизов Wine-staging и fuse-overlayfs
WINE_API_URL="https://api.github.com/repos/mmtrt/WINE_AppImage/releases"
FUSE_OVERLAYFS_API_URL="https://api.github.com/repos/containers/fuse-overlayfs/releases"

#Appimagetool URL
APPIMAGETOOL_URL="https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage"

# Путь для сохранения файлов
DOWNLOAD_DIR="./downloads"
mkdir -p "$DOWNLOAD_DIR"

# Скачиваем страницу с игры
echo "Загрузка страницы..."
PAGE_CONTENT=$(curl -s "$PAGE_URL")

# Извлечение ссылок на лаунчер и архив
LAUNCHER_URL=$(echo "$PAGE_CONTENT" | grep -oP '(?<=href=")[^"]*installer\.launcher\.xsolla\.com[^"]*')
# ARCHIVE_URL=$(echo "$PAGE_CONTENT" | grep -oP '(?<=href=")[^"]*drive\.usercontent\.google\.com[^"]*')

# Проверка на наличие ссылок
if [ -z "$LAUNCHER_URL" ]; then #if [ -z "$LAUNCHER_URL" ] || [ -z "$ARCHIVE_URL" ]; then
  echo "Не удалось найти ссылки для загрузки. Проверьте URL страницы."
  exit 1
fi

# Скачивание лаунчера
echo "Скачивание лаунчера..."
curl -L -o "$DOWNLOAD_DIR/launcher.exe" "$LAUNCHER_URL"

# Скачивание архива
# echo "Скачивание архива..."
# curl -L -o "$DOWNLOAD_DIR/game_archive.zip" "$ARCHIVE_URL&confirm=t"

# Получаем информацию о последнем релизе Wine-staging
echo "Получение информации о последнем релизе Wine-staging..."
WINE_DOWNLOAD_URL=$(curl -s "$WINE_API_URL" | grep -oP '(?<="browser_download_url": ")[^"]*' | grep -vE 'ge_proton' | grep 'continuous-staging' | head -n 1)

# Проверка, была ли найдена ссылка на Wine-staging
if [ -z "$WINE_DOWNLOAD_URL" ]; then
  echo "Не удалось найти ссылку на последний релиз Wine-staging."
  exit 1
fi

# Скачивание последней версии Wine-staging
echo "Скачивание последней версии Wine-staging..."
curl -L -o "$DOWNLOAD_DIR/wine-staging.AppImage" "$WINE_DOWNLOAD_URL"

# Получаем информацию о последнем релизе fuse-overlayfs
echo "Получение информации о последнем релизе fuse-overlayfs..."
FUSE_OVERLAYFS_DOWNLOAD_URL=$(curl -s "$FUSE_OVERLAYFS_API_URL" | grep -oP '(?<="browser_download_url": ")[^"]*' | grep x86_64 | head -n 1)

# Проверка, была ли найдена ссылка на fuse-overlayfs
if [ -z "$FUSE_OVERLAYFS_DOWNLOAD_URL" ]; then
  echo "Не удалось найти ссылку на последний релиз fuse-overlayfs."
  exit 1
fi

# Скачивание последней версии fuse-overlayfs
echo "Скачивание последней версии fuse-overlayfs..."
curl -L -o "$DOWNLOAD_DIR/fuse-overlayfs" "$FUSE_OVERLAYFS_DOWNLOAD_URL"

# Скачивание последней версии Appimagetool
echo "Скачивание последней версии Appimagetool"
curl -L -o "$DOWNLOAD_DIR/appimagetool.AppImage" "$APPIMAGETOOL_URL"

sync

echo "Все файлы успешно скачаны в $DOWNLOAD_DIR."