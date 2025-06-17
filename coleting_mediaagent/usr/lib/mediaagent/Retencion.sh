#!/bin/bash

#Variables Directorios (Deben ser las mismas que las del script de backups)
DEST_DIR="/backups/"

#AQUI SE VARIA LA RETENCION EN DIAS (Se recomienda que sean multiplos de 7 Ya que al borrar la full se inutilizan las incrementales)

diasretencion=21

#Le sumo 1 a la retencion para que de tiempo a user la incremental del dia despues
retencionfull=$(echo $(($diasretencion+1)))

find "$DEST_DIR" -type f -name "backup_full*.tar.gz" -mtime +$retencionfull -exec rm -f {} \;
find "$DEST_DIR" -type f -name "backup_inc*.tar.gz" -mtime +$diasretencion -exec rm -f {} \;
