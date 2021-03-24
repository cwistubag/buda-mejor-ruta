# Buda.com - Selección mejor ruta Metro

Proyecto desarrollado en Ruby que, dado un archivo de configuración de nodos (estaciones de metro), evalúa las posibles rutas entre una estación de origen y otra de destino.

### Descripción 📜

El programa se basa en una adaptación realizada del algoritmo de Dijkstra [(Wiki)](https://es.wikipedia.org/wiki/Anexo:Ejemplo_de_Algoritmo_de_Dijkstra) en el cual se configuran una serie de nodos (estaciones) 
y a la relación entre ellas se mide a través de un "peso". Mediante un archivo en formato JSON se realiza la configuración y conexión entre ellos. 
El programa asigna los pesos en función de uno de los argumentos de ejecución (tipo de ruta) y evalúa las distintas rutas posibles encontradas, retornando como resultado, la que tenga menos peso, por lo tanto, la más óptima.

### Prerrequisitos 📑

El código fue desarrollado con Ruby 2.7 el cual se puede descargar [(aquí)](https://www.ruby-lang.org/es/downloads/)

### Preparación (Windows) 🔧

Una vez instalado Ruby, abrir una consola cmd de Windows , ubicarse en espacio de trabajo definido y realizar los siguientes pasos:

- Instalar "bundle", ejecutar comando:

```
gem install bundle
```

- Clonar repositorio:

```
git clone https://github.com/cwistubag/buda-mejor-ruta.git
```

- Ingresar a carpeta del proyecto:

```
cd buda-mejor-ruta
```

- Instalar gemas necesarias

```
bundle install
```

### Preparación (Linux) 🔧

Una vez instalado Ruby, abrir terminal de Linux , ubicarse en espacio de trabajo definido y realizar los siguientes pasos:

- Instalar "bundle", ejecutar comando:

```
sudo gem install bundle
```

- Clonar repositorio:

```
git clone https://github.com/cwistubag/buda-mejor-ruta.git
```

- Ingresar a carpeta del proyecto:

```
cd buda-mejor-ruta
```

- Instalar gemas necesarias

```
sudo bundle install
```

- Asignar permisos ejecución para Shell de pruebas

```
chmod 755 runTestsLinux.sh
```

## Ejecución del programa

La ejecución del programa requiere de 4 argumentos, siendo el último opcional:

```
ruby main.rb [ARCHIVO_JSON_CONFIGURACION] [ESTACION_INICIAL] [ESTACION_FINAL] [TIPO_DE_TREN(verde|rojo)]
```

En donde:

- [ARCHIVO_JSON_CONFIGURACION] : Ruta y nombre de archivo que contiene la configuración de estaciones. Un ejemplo se puede encontrar en la carpeta './subwayConfig'
- [ESTACION_INICIAL] : Nombre de estación inicial 
- [ESTACION_FINAL] : Nombre de estación de destino
- [TIPO_DE_TREN] : Puede ser 'verde' o 'rojo'. Puede ser omitido.

## Ejecución de pruebas

- Windows

Ejecutar desde consola cmd de Windows o abrir directamente el archivo bat correspondiente:

```
runTestsWindows.bat
```

- Linux

Ejecutar script:

```
./runTestsLinux.sh
```

Tiempo promedio de ejecuión de pruebas : 10 Segundos (Referencia: Raspberry PI 4)

## Versionamiento 📌

- v1.0 : Versión inicial liberada

## Autor ✒️

* **Carlos Wistuba** - [email](carlos@wistuba.cl) - 2021
