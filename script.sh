
# Nombre del archivo de salida
output_file="monitoreo_recursos.txt"

# Cabecera del archivo
echo "Tiempo %CPU Libre %Memoria Libre %Disco Libre" > $output_file

# Duración total de monitoreo en segundos (5 minutos = 300 segundos)
total_duration=300
# Intervalo entre capturas en segundos
interval=60
# Contador de tiempo
current_time=0

while [ $current_time -le $total_duration ]
do
    # Captura del tiempo transcurrido
    time_stamp="${current_time}s"
    
    # Captura de CPU libre (calculando el promedio de todos los núcleos)
    # Se obtiene la lista de porcentajes de uso de CPU por núcleo y se calcula el promedio de la CPU libre
    cpu_free=$(top -bn1 | grep "Cpu(s)" | awk -F',' '{idle=100 - $4; print idle}')
    
    # Captura de Memoria Libre en porcentaje
    mem_free=$(free | grep Mem | awk '{print ($4+$6+$7)/$2 * 100.0}')
    
    # Captura de Disco Libre en porcentaje (sistema raíz "/")
    disk_free=$(df / | grep / | awk '{print 100 - $5}' | tr -d '%')
    
    # Escribir en el archivo en formato de columnas
    echo "$time_stamp $cpu_free $mem_free $disk_free" >> $output_file
    
    # Espera el intervalo definido
    sleep $interval
    
    # Aumenta el contador de tiempo
    current_time=$((current_time + interval))
done

echo "Monitoreo completado. Los datos se han guardado en $output_file"

