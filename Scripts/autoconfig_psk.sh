#!/bin/bash
PSK_Identity="PSK-$HOSTNAME"
PSK=""

# Переменные
zabbix_conf="/etc/zabbix/zabbix_agentd.conf"

zabbix_path_psk="/etc/zabbix/zabbix_agentd.conf.d"
zabbix_psk="zabbix_agentd.psk"



zabbix_fullpath_psk=""

# Check the script is being run by root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root"
   exit 1
fi

# Detect Debian users running the script with "sh" instead of bash
if readlink /proc/$$/exe | grep -q "dash"; then
        echo 'This installer needs to be run with "bash", not "sh".'
        exit 1
fi

if dpkg -s zabbix-agent >/dev/null 2>&1; then
    echo "The Zabbix agent is installed on the system."
else
    echo "The Zabbix agent is not installed on the system."
    exit 1
fi

CheckFile() {
if [ ! -f "$1" ]; then
    sudo touch "$1"
 fi
}
CheckFolder() {
if [ ! -d "$1" ]; then
    sudo mkdir -p "$1"
 fi
}
# Check path
CheckFolder "$zabbix_path_psk"
zabbix_fullpath_psk="$zabbix_path_psk/$zabbix_psk"
CheckFile "$zabbix_fullpath_psk"



# Генерация PSK
generate_psk() {
 CheckFile "$zabbix_fullpath_psk"
 openssl rand -hex 32 > $zabbix_fullpath_psk
}

if [ -z "$PSK" ]; then
generate_psk
else
echo "$PSK" > "$zabbix_fullpath_psk"
fi




#

# Установка PSK и идентификатора
echo "TLSConnect=psk" >> $zabbix_conf
echo "TLSAccept=psk" >> $zabbix_conf
echo "TLSPSKIdentity=$PSK_Identity" >> $zabbix_conf
echo "TLSPSKFile=$zabbix_fullpath_psk" >> $zabbix_conf

# Создание файла с PSK

# Изменение прав доступа к файлу с PSK
sudo chown zabbix:zabbix $zabbix_fullpath_psk
sudo chmod 640 $zabbix_fullpath_psk

# Перезапуск службы Zabbix Agent
service zabbix-agent restart
echo "PSK Identity: $PSK_Identity"
echo "Generated PSK: $(cat $zabbix_fullpath_psk)"
