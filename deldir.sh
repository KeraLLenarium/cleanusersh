#!/bin/bash

read -p "Юзер: " USER

# Директория, которую нужно очистить
TARGET_DIR="/home/$USER"

# Проверяем, существует ли директория
if [ ! -d "$TARGET_DIR" ]; then
  echo "Ошибка: Юзера $USER не существует."
  exit 1
fi

# Снимаем атрибут immutable со всех файлов и поддиректорий
find "$TARGET_DIR" -exec chattr -i {} \;

# Удаляем всё содержимое директории, кроме самой директории
find "$TARGET_DIR" -mindepth 1 -delete

echo "Содержимое юзер $USER успешно удалено."

# Копирование всех файлов и каталогов из /etc/skel в целевую директорию
cp -a /etc/skel/. "$TARGET_DIR"

echo "Содержимое юзер $USER успешно добавлено."

# Изменение прав на юзерские
chown -R $USER.$USER $TARGET_DIR

# Меняем ремину
sed -i "s|datadir_path=/mainTK/user_name|datadir_path=/mainTK/user_name/$USER|g" "$TARGET_DIR/.config/remmina/remmina.pref"
echo "Имя пользователя успешно обновлено в конфигурационном файле."
