# Win Firewall Blocker

Script `.bat` que bloquea en el Firewall de Windows todos los ejecutables (`.exe`) de una carpeta, y permite revertir los cambios.

## Uso

1. Copia `ExeFirewallBlocker.bat` dentro de la carpeta que quieras analizar.
2. Ejecútalo (pide permisos de administrador automáticamente).
3. Elige una opción:
   - **1) Analizar y bloquear ejecutables**: busca todos los `.exe` en la carpeta del script y subcarpetas, y crea una regla de entrada y otra de salida por cada uno (prefijo `WFB_Block`). Las rutas bloqueadas se registran en `WinFirewallBlockerLog.txt`.
   - **2) Restablecer cambios**: lee `WinFirewallBlockerLog.txt`, elimina las reglas de cada ejecutable listado y borra el log.
   - **3) Salir**.

## Notas

- Mantén `ExeFirewallBlocker.bat` y `WinFirewallBlockerLog.txt` en la misma carpeta para poder revertir.
- Si ejecutas la opción 1 de nuevo, se omiten los ejecutables ya registrados en el log.
- Requiere Windows con `netsh advfirewall`.
