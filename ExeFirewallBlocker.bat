@echo off
setlocal
title ExeFirewallBlocker

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Se requieren permisos de administrador. Solicitando elevacion...
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

set "CARPETA=%~dp0"
set "LOG=%~dp0WinFirewallBlockerLog.txt"
set "PREFIJO=WFB_Block"

:menu
cls
echo ==========================================
echo        Exe Firewall Blocker
echo ==========================================
echo  Carpeta: %CARPETA%
echo  Log:     %LOG%
echo.
echo  1) Analizar y bloquear ejecutables
echo  2) Restablecer cambios (usa WinFirewallBlockerLog.txt)
echo  3) Salir
echo.
set "OP="
set /p "OP=Elija una opcion: "
if "%OP%"=="1" goto bloquear
if "%OP%"=="2" goto restaurar
if "%OP%"=="3" exit /b
goto menu

:bloquear
echo.
echo Analizando: %CARPETA%
echo.
if not exist "%LOG%" (
    echo # WinFirewallBlockerLog - un ejecutable bloqueado por linea. No editar las rutas.>"%LOG%"
)
set /a TOTAL=0
for /r "%CARPETA%" %%F in (*.exe) do (
    findstr /x /c:"%%F" "%LOG%" >nul 2>&1
    if errorlevel 1 (
        echo Bloqueando: %%F
        netsh advfirewall firewall add rule name="%PREFIJO% OUT - %%F" dir=out action=block program="%%F" enable=yes profile=any >nul
        netsh advfirewall firewall add rule name="%PREFIJO% IN - %%F" dir=in action=block program="%%F" enable=yes profile=any >nul
        echo %%F>>"%LOG%"
        set /a TOTAL+=1
    ) else (
        echo Ya bloqueado, se omite: %%F
    )
)
echo.
echo Listo. Nuevos ejecutables bloqueados: %TOTAL%
echo Reporte guardado en: %LOG%
pause
goto menu

:restaurar
echo.
if not exist "%LOG%" (
    echo No se encontro %LOG%
    echo No hay cambios que restablecer.
    pause
    goto menu
)
set /a TOTAL=0
for /f "usebackq eol=# tokens=* delims=" %%L in ("%LOG%") do (
    echo Desbloqueando: %%L
    netsh advfirewall firewall delete rule name="%PREFIJO% OUT - %%L" >nul 2>&1
    netsh advfirewall firewall delete rule name="%PREFIJO% IN - %%L" >nul 2>&1
    set /a TOTAL+=1
)
del "%LOG%"
echo.
echo Listo. Ejecutables desbloqueados: %TOTAL%. Log eliminado.
pause
goto menu
