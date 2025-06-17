#!/bin/bash

# Archivo que contiene las IPs (una por línea)
IP_LIST="/usr/share/mediaagnt/lista_clientes.txt"

# Fecha
DATE=$(date +'%Y-%m-%d')

# Ruta de los backups
SOURCE_FILE="/CopiasSegTAR"

# Ruta de destino para los backups
DEST_PATH="/backups"

#Ruta logs de Importacion
LOG_PATH="/backups/logsImport"
mkdir -p "$LOG_PATH"

# Usuario ssh
REMOTE_USER="commadmin"

#Destino de los logs de los clientes:
DEST_LOGS="/backups/logsclientes"
mkdir -p "$DEST_LOGS"

# Verifica si el archivo de IPs existe
if [ ! -f "$IP_LIST" ]; then
  echo "Archivo de IPs no encontrado: $IP_LIST"
  exit 1
fi

# Importar copias y los logs de los clientes
# El usuario que utilicemos tiene que tener importadas las claves de SSH de tal manera que no nos pida password (tienen que estar en el mismo usuario del cron)
while IFS= read -r ncli; do
  if [[ -n "$ncli" ]]; then
    echo "Importando copia de $ncli..."
	DEST_COPY="$DEST_PATH/$ncli/"
	mkdir -p "$DEST_COPY"
	scp "commadmin@$ncli:$SOURCE_FILE/"*.tar.gz "$DEST_COPY"
    if [ $? -eq 0 ]; then
      echo "Exito en la transferencia desde: $ncli - $DATE" >> "$LOG_PATH/imports.txt"
	    ssh -x "commadmin@$ncli" "rm -rf $SOURCE_FILE/"*.tar.gz
    else
      echo "Error al importar de $ncli el $SOURCE_FILE - $DATE" >> "$LOG_PATH/imports.txt"
    fi
#Importar logs de los clientes para mostrarlos en grafana
	scp -r "commadmin@$ncli:$SOURCE_FILE/logs/"* "$DEST_LOGS"
  fi
done < "$IP_LIST"



chown -R commadmin:commadmin /backups
