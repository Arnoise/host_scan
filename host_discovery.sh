#!/bin/bash

trap 'echo -e "\nSaliendo del script"; exit 1' SIGINT

while true; do
    read -p "Ingrese el rango de IP a analizar (ej: 192.168.1.1-10): " ip_range

    # Verificar el formato del rango de IP
    if [[ $ip_range =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}-([0-9]{1,3})$ ]]; then
        IFS='-' read -r start_ip end_ip <<< "$ip_range"
        start=$(echo $start_ip | cut -d. -f4)
        end=$(echo $end_ip | cut -d. -f4)

        counter=0

        for ((ip=$start; ip<=$end; ip++)); do
            current_ip=$(echo $start_ip | cut -d. -f1-3).$ip
            ping -c 1 $current_ip > /dev/null 2>&1

            if [ $? -eq 0 ]; then
                counter=$((counter+1))
                echo "Equipo $current_ip activo"
            fi

            percentage=$((ip * 100 / (end - start + 1)))
            echo -ne "Analizando: $percentage%\r"
        done

        echo -e "\nAnálisis completado. $counter equipos activos encontrados."
        break
    else
        echo "Formato de IP inválido. Por favor, ingrese un rango de IP válido."
    fi
done

