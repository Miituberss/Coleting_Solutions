#!/bin/bash

SOURCE_DIR="/home"
DEST_DIR="/CopiasSegTAR"
SNAPSHOT_DIR="$DEST_DIR/snapshots"
LOG_FILE="$DEST_DIR/logs/backups_tar_$HOSTNAME.log"

DATE=$(date +'%Y-%m-%d')
DAY_OF_WEEK=$(date +'%u')  # 1=lunes, 7=domingo
INICIO=$(date +%s)

mkdir -p "$DEST_DIR" "$SNAPSHOT_DIR"
mkdir -p "$DEST_DIR/logs"

if [ "$DAY_OF_WEEK" -eq 7 ] || [ ! -f "$SNAPSHOT_DIR/latest.snar" ]; then
    TYPE="full"
else
    TYPE="inc"
fi

# Definir archivo actual
SNAPSHOT_FILE="$SNAPSHOT_DIR/backup_$DATE.snar"
ARCHIVE_NAME="backup_$TYPE-$DATE.tar.gz"

# Copiar el snapshot anterior si es incremental para que use ese como referancia para las incrementales
if [ "$TYPE" = "inc" ]; then
    cp "$SNAPSHOT_DIR/latest.snar" "$SNAPSHOT_FILE" 2> /dev/null
fi

# Ejecutar backup
tar --listed-incremental="$SNAPSHOT_DIR/latest.snar" -czf "$DEST_DIR/$ARCHIVE_NAME" -C "$SOURCE_DIR" .

# Log
FIN=$(date +%s)
DURACION=$(($FIN - $INICIO))
echo "timestamp=[$(date +'%Y-%m-%d %H:%M:%S')] level=info job=backup status=success file=$ARCHIVE_NAME duration=$DURACION host=$HOSTNAME" >> "$LOG_FILE"

# Actualizar snapshot actual
ln -sf "$SNAPSHOT_FILE" "$SNAPSHOT_DIR/latest.snar"

# Le damos la propiedad del backup a commadmin para que se pueda manejar el archivo correctamente
chown -R commadmin:commadmin "$DEST_DIR"

# Limpiar archivos viejos(snapshots)
 find "$SNAPSHOT_DIR" -type f -name "backup_*.snar" -mtime +30 -exec rm -f {} \;
