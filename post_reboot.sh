#!/bin/bash

# Установка shadowsocks-libev
snap install shadowsocks-libev

# Настройка Shadowsocks
mkdir -p /var/snap/shadowsocks-libev/common/etc/shadowsocks-libev
touch /var/snap/shadowsocks-libev/common/etc/shadowsocks-libev/config.json

# Создание конфигурационного файла
cat <<EOF > /var/snap/shadowsocks-libev/common/etc/shadowsocks-libev/config.json
{
    "server":["::0", "0.0.0.0"],
    "mode":"tcp_and_udp",
    "server_port":8388,
    "local_port":1080,
    "password":"634759",
    "timeout":60,
    "fast_open":true,
    "reuse_port": true,
    "no_delay": true,
    "method":"aes-256-gcm"
}
EOF

# Создание сервиса systemd
touch /etc/systemd/system/shadowsocks-libev-server@.service
cat <<EOF > /etc/systemd/system/shadowsocks-libev-server@.service
[Unit]
Description=Shadowsocks-Libev Custom Server Service for %I
Documentation=man:ss-server(1)
After=network-online.target

[Service]
Type=simple
ExecStart=/usr/bin/snap run shadowsocks-libev.ss-server -c /var/snap/shadowsocks-libev/common/etc/shadowsocks-libev/%i.json

[Install]
WantedBy=multi-user.target
EOF

# Включение и запуск сервиса
systemctl enable --now shadowsocks-libev-server@config

# Проверка статуса сервиса
systemctl status shadowsocks-libev-server@config

# Настройка iptables
iptables -I INPUT -p tcp --dport 8388 -j ACCEPT
iptables -I INPUT -p udp --dport 8388 -j ACCEPT

# Настройка /etc/hosts
echo "99.84.58.138          fapi.binance.com" >> /etc/hosts
echo "99.84.58.138         api.binance.com" >> /etc/hosts

# Отключение фаервола
ufw disable

# Перезагрузка системы
reboot

