#!/bin/bash

#Destino e los logs para grafana
LOG_DEST="/home/marcos"
#Origen de los logs en el MA
LOG_PATH="/backups/logsclientes/"
IP_MA="192.168.78.142"

scp -P 8400 "commadmin@$IP_MA:$LOG_PATH"*.log "$LOG_DEST"
