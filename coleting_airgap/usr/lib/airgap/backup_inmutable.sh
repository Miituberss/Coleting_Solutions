#!/bin/bash

DESTINO="/backup/copias"
ORIGEN="/backups"
IP_LISTA="/usr/share/airgap/lista_mediaagents.txt"
USUARIO="commadmin"

# ========================
# PREPARACIÓN
# ========================
mkdir -p "$DESTINO"
cd "$DESTINO" || exit 1

# Copia evitando duplicados
while read -r IP; do
    [ -z "$IP" ] && continue  # Saltar líneas vacías

    echo "---- Conectando a $IP ----"

    # Listar archivos .tar remotos
    ssh "$USUARIO@$IP" "ls -1 $ORIGEN/*.tar 2>/dev/null" | while read -r archivo_remoto; do
        nombre_fichero=$(basename "$archivo_remoto")

        # Verificar si el fichero ya existe
        if [ ! -f "$DESTINO/$nombre_fichero" ]; then
            echo "Copiando $nombre_fichero desde $IP..."

            # Copiar con preservación de fechas
            scp -p "$USUARIO@$IP:$archivo_remoto" "$DESTINO/"

            if [ $? -eq 0 ]; then
                echo "Aplicando inmutabilidad a $nombre_fichero"
                chattr +i "$DESTINO/$nombre_fichero"
            else
                echo "❌ Error al copiar $nombre_fichero desde $IP" >> /var/log/backup_error.log
            fi
        else
            echo "Saltando $nombre_fichero (ya existe)"
        fi
    done

done < "$IP_LISTA"



