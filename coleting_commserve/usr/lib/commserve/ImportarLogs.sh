#!/bin/bash

# Destino de los logs para Grafana
LOG_DEST="/var/log/backup/"
# Origen de los logs en el MA
LOG_PATH="/backups/logsclientes/"
# Puerto SSH
SSH_PORT=8400
# Archivo con las IPs de los MAs
IP_FILE="ma_ips.txt"

# Verificar si el archivo de IPs existe
if [[ ! -f "$IP_FILE" ]]; then
    echo "ERROR: No se encuentra el archivo '$IP_FILE'"
    exit 1
fi

# Leer cada IP del archivo
while IFS= read -r IP_MA || [[ -n "$IP_MA" ]]; do
    # Saltar líneas vacías o que empiezan por #
    [[ -z "$IP_MA" || "$IP_MA" =~ ^# ]] && continue

    echo "Copiando logs desde $IP_MA..."
    scp -P "$SSH_PORT" "commadmin@$IP_MA:$LOG_PATH"*.log "$LOG_DEST"
done < "$IP_FILE"

