@echo off
REM Script de instalación de Jenkins con Docker para Windows
REM Ejecutar en PowerShell o CMD

echo ======================================
echo Instalando Jenkins con Docker
echo ======================================
echo.

REM Verificar Docker
echo Verificando Docker...
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Docker no esta corriendo
    echo Inicia Docker Desktop y vuelve a ejecutar este script
    pause
    exit /b 1
)

echo [OK] Docker esta instalado y corriendo
echo.

REM Detener Jenkins si ya existe
echo Deteniendo Jenkins existente (si existe)...
docker-compose -f docker-compose.jenkins.yml down 2>nul
echo.

REM Iniciar Jenkins
echo Iniciando Jenkins...
docker-compose -f docker-compose.jenkins.yml up -d

echo.
echo Esperando a que Jenkins inicie (esto puede tomar 1-2 minutos)...
timeout /t 30 /nobreak >nul

REM Obtener contraseña inicial
echo.
echo ======================================
echo Informacion de Jenkins
echo ======================================
echo.
echo URL: http://localhost:8080
echo.
echo Contrasena inicial de administrador:
echo --------------------------------------
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword 2>nul
if %errorlevel% neq 0 (
    echo Esperando a que Jenkins genere la contrasena...
    timeout /t 30 /nobreak >nul
    docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
)
echo.
echo ======================================
echo.
echo [OK] Jenkins instalado correctamente
echo.
echo Proximos pasos:
echo 1. Abre http://localhost:8080 en tu navegador
echo 2. Ingresa la contrasena inicial mostrada arriba
echo 3. Selecciona 'Install suggested plugins'
echo 4. Crea tu usuario administrador
echo.
echo Para ver los logs de Jenkins:
echo   docker logs -f jenkins
echo.
echo Para detener Jenkins:
echo   docker-compose -f docker-compose.jenkins.yml down
echo.
pause
