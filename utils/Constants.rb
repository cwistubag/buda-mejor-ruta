module Constants
    PARAM_RED_SUBWAY = "rojo"
    PARAM_GREEN_SUBWAY = "verde"
    PARAM_NORMAL_SUBWAY = "normal"
    DEFAULT_WEIGHT = 2
    EXPRESS_WEIGHT = 1
    MSG_INVALID_PARAMETERS = "Faltan parámetros de ejecución. Modo de uso: \nruby main.rb [Archivo Configuración Estaciones] [Estación inicial] [Estación final] [Color tren (Opcional)]"
    MSG_FILE_NOT_FOUND = "No se encuentra archivo especificado"
    MSG_NOT_VALID_JSON = "Archivo JSON con estructura inválida"
    MSG_STATION_NOT_FOUND = "La o las estaciones indicadas no se encuentran en el archivo de configuración"
    MSG_BAD_METHOD_CALL = "Metodo interno invocado incorrectamente"
    MSG_BAD_EXPRESS_SUBWAY_OPTION = "El tipo de tren solo puede ser 'rojo' o 'verde'"
    MSG_INITIAL_STATION_EQUALS_END_STATION = "La estación de origen y destino no pueden ser la misma"
    MSG_BAD_EXTENSION_FILE = "El archivo input debe ser un JSON (.json)"
    MSG_STATION_DISCONNECTED = "Estacion evaluada en recorrido no tiene asignada una conexion"
end
