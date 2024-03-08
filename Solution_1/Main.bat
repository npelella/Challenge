@echo off

rem Set variables
set /p OS_LANGUAGE=Enter the OS language (default is english [english/spanish]):
set /p PG_VERSION=Enter the PostgreSQL version (default is 15):
set /p PG_INSTALL_DIR=Enter PostgreSQL installation directory (default C:\Program Files\PostgreSQL): 
set /p PG_USER=Enter PostgreSQL username (default is postgres): 
set /p PG_PASSWORD=Enter PostgreSQL password (default is 1234): 
set /p PG_HOST=Enter PostgreSQL host (default is localhost): 
set /p PG_PORT=Enter PostgreSQL port (default is 5432): 
set /p DB_NAME=Enter PostgreSQL database name (default is postgres): 
set /p SQL_FILE=Enter path to SQL file (Example: if main.sql is in folder 'queries', then put up to C:\Users\NPelella\Challenge\Solution_1\Queries): 
set /p DATA_PATH=Enter path to data file (Example: if data.txt is in folder 'txt', then put up to C:\Users\NPelella\Challenge\Solution_1\txt): 
set /p POSTGREST_CONF=Enter path to PostgREST API configuration (Example: if challenge.conf is in folder 'API', then put up to C:\Users\NPelella\Challenge\Solution_1\API):
set /p CONF_FILE_NAME=Enter PostgREST configuration file name (default is challenge.conf.txt): 


rem Set default values if not provided by the user
if "%OS_LANGUAGE%"=="" set OS_LANGUAGE=Everyone
if "%OS_LANGUAGE%"=="english" set OS_LANGUAGE=Everyone
if "%OS_LANGUAGE%"=="spanish" set OS_LANGUAGE=Todos
if "%PG_VERSION%"=="" set PG_VERSION=15
if "%PG_INSTALL_DIR%"=="" set PG_INSTALL_DIR=C:\Program Files\PostgreSQL
if "%PG_USER%"=="" set PG_USER=postgres
if "%PG_PASSWORD%"=="" set PG_PASSWORD=1234
if "%PG_HOST%"=="" set PG_HOST=localhost
if "%PG_PORT%"=="" set PG_PORT=5432
if "%DB_NAME%"=="" set DB_NAME=postgres
if "%CONF_FILE_NAME%"=="" set CONF_FILE_NAME=challenge.conf.txt

rem Set psql to the system path
set "PATH=%PATH%;%PG_INSTALL_DIR%\%PG_VERSION%\bin"

rem Set file permissions for the TXT file
icacls %DATA_PATH%\Government_Employment.txt /grant %OS_LANGUAGE%:F
icacls %DATA_PATH%\TotalNonfarm.txt /grant %OS_LANGUAGE%:F
icacls %DATA_PATH%\TotalPrivate_Employment.txt /grant %OS_LANGUAGE%:F

rem Connect to PostgreSQL and run the SQL file
psql -h %PG_HOST% -p %PG_PORT% -U %PG_USER% -d %DB_NAME% -v data_path1='%DATA_PATH%\Government_Employment.txt' -v data_path2='%DATA_PATH%\TotalNonfarm.txt' -v data_path3='%DATA_PATH%\TotalPrivate_Employment.txt' -f %SQL_FILE%\Main.sql

rem go to directory where conf file is
cd %POSTGREST_CONF%

rem Start the PostgREST API
postgrest %CONF_FILE_NAME%

rem Wait for the API to start (adjust timeout as needed)
timeout /t 5
