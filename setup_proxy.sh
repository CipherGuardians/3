#!/bin/bash

# Обновление системы и установка необходимых пакетов
apt update && apt upgrade -y
apt install -y snapd

# Открытие портов
sudo ufw allow 8388/udp
sudo ufw allow 8388/tcp

# Перезагрузка системы
reboot
