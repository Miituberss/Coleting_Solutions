#!/bin/bash

# Ruta local
DESTINO="/backup/copias"

# Buscar .tar con más de 30 días
find "$DESTINO" -name "*.tar" -type f -mtime +30 | while read fichero; do
    echo "Eliminando $fichero"

    # Quitar inmutabilidad
    chattr -i "$fichero"

    # Borrar
    rm -f "$fichero"
done

