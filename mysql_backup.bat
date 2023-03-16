@echo off
setlocal enableextensions enabledelayedexpansion

:: Configuración de variables de entorno
set MYSQL_PATH=C:\Program Files\MySQL\MySQL Server 5.6
set TARGET_DIR=%USERPROFILE%\Documents\dumps
set USER=tocsa
set PASSWORD=T0cs4$2015
set HOST=10.0.0.72
set PORT=3306

:: Comprobación de la existencia de la ruta de destino
if not exist "%TARGET_DIR%" (
  echo El directorio de destino no existe. Creando directorio...
  mkdir "%TARGET_DIR%"
)

:: Opciones de línea de comandos
set DBNAME=%1
set /p DBNAME=Nombre de la base de datos: %DBNAME%
if not defined DBNAME (
  echo Debe especificar el nombre de la base de datos.
  goto :EOF
)

set /p TARGET_FILE=Nombre del archivo de respaldo: %DBNAME%-
if not defined TARGET_FILE (
  echo Debe especificar el nombre del archivo de respaldo.
  goto :EOF
)

:: Obtener fecha y hora actual
set TIMESTAMP=%DATE:/=-%_%TIME::=.%
set TIMESTAMP=%TIMESTAMP:,=-%
set TIMESTAMP=%TIMESTAMP: =%
set TIMESTAMP=%TIMESTAMP::=_%
set TIMESTAMP=%TIMESTAMP:.=%
set TIMESTAMP=%TIMESTAMP:~0,-2%

:: Realizar copia de seguridad
echo Realizando copia de seguridad de la base de datos %DBNAME%...
"%MYSQL_PATH%\bin\mysqldump.exe" -u%USER% -p%PASSWORD% -h%HOST% --port %PORT% -Q --hex-blob --ignore-table="%DBNAME%.Attach" --ignore-table="%DBNAME%.EventLog" --verbose --complete-insert --allow-keywords --create-options -r"%TARGET_DIR%\%TARGET_FILE%%TIMESTAMP%.sql" %DBNAME%

:: Comprimir automáticamente el archivo de respaldo
echo Comprimiendo archivo de respaldo...
"%ProgramFiles%\WinRAR\rar.exe" a -r -m5 -ep1 "%TARGET_DIR%\%TARGET_FILE%%TIMESTAMP%.rar" "%TARGET_DIR%\%TARGET_FILE%%TIMESTAMP%.sql"
del "%TARGET_DIR%\%TARGET_FILE%%TIMESTAMP%.sql"

echo Copia de seguridad completada exitosamente.
