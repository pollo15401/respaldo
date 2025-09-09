# respaldo
# codigo en linux 
DESTINO="$HOME/Respaldo"

respaldo() {
    read -p "Ingresa la ruta de la carpeta a respaldar: " carpeta_origen
    
    if [ ! -d "$carpeta_origen" ]; then
        echo "La carpeta no existe."
        exit 1
    fi

    fecha=$(date +%Y-%m-%d)
    dia_semana=$(date +%A)  # Lunes, Martes, etc.

    carpeta_diaria="$DESTINO/$fecha-$dia_semana"
    mkdir -p "$carpeta_diaria"

    cp -r "$carpeta_origen"/* "$carpeta_diaria/"

    echo "Respaldo diario creado en: $carpeta_diaria"

    if [ $(ls -1 "$DESTINO" | wc -l) -ge 7 ]; then
        semana=$(date +%Y-%U)  # Año-Semana
        zip_file="$DESTINO/respaldo_semana_$semana.zip"
        zip -r "$zip_file" "$DESTINO"/*  # Comprime todo
        echo "Respaldo semanal creado en: $zip_file"

        rm -rf "$DESTINO"/-[Ll]unes "$DESTINO"/-[Mm]artes "$DESTINO"/-[Mm]iercoles "$DESTINO"/-[Jj]ueves "$DESTINO"/-[Vv]iernes "$DESTINO"/-[Ss]abado "$DESTINO"/*-[Dd]omingo
    fi
}

restaurar() {
    echo "Opciones de restauración:"
    echo "1) Restaurar un día específico"
    echo "2) Restaurar toda la semana"
    read -p "Elige opción (1 o 2): " opcion

    read -p "Ingresa la ruta donde deseas restaurar: " carpeta_destino
    mkdir -p "$carpeta_destino"

    if [ "$opcion" == "1" ]; then
        read -p "Ingresa la fecha a restaurar (YYYY-MM-DD): " fecha
        # Buscar la carpeta que coincida
        carpeta="$DESTINO/$fecha-"*
        if [ -d "$carpeta" ]; then
            cp -r "$carpeta"/* "$carpeta_destino/"
            echo "Respaldo de $fecha restaurado en $carpeta_destino"
        else
            echo "No se encontró respaldo para esa fecha."
        fi
    elif [ "$opcion" == "2" ]; then
        read -p "Ingresa el nombre del archivo zip semanal: " zip_file
        if [ -f "$DESTINO/$zip_file" ]; then
            unzip "$DESTINO/$zip_file" -d "$carpeta_destino"
            echo "Respaldo semanal restaurado en $carpeta_destino"
        else
            echo "No se encontró el archivo $zip_file"
        fi
    else
        echo "Opción inválida."
    fi
}

echo "===== Script de Respaldos ====="
echo "1) Hacer respaldo"
echo "2) Restaurar respaldo"
read -p "Elige opción (1 o 2): " eleccion

case $eleccion in
    1) respaldo ;;
    2) restaurar ;;
    *) echo "Opción inválida" ;;
esac
