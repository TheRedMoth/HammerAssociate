@echo off
title HammerAssociate

REM Проверка на запуск от имени администратора
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
  title HammerAssociate - Error
  echo.
  echo. Run this file as an administrator!
  pause>nul
  exit /b
)

REM Проверка наличия gcc
where gcc >nul 2>&1
if %errorlevel% neq 0 (
  echo.
  echo. GCC not found! Install and add in PATH
  pause>nul
  exit
)

REM Проверка наличия upx
where upx >nul 2>&1
if %errorlevel% neq 0 (
  echo.
  echo. UPX not found in PATH! Contining without compress...
) else (
  set compress=1
)

REM Задаем вопрос о методе reghack
title HammerAssociate - Waiting for input...
echo.
echo. Do you want to use the REGHACK feature? [Y/N]
choice /c yn /n
if %errorlevel% == 1 (
  REM Скомпилировать HammerAssociate_reghack.c
  title HammerAssociate - Compiling...
  gcc -o %~dp0src/HammerAssociate.exe %~dp0src/HammerAssociate_reghack.c -lshlwapi -mwindows -Os -s
  if %compress% == 1 (
    upx --best %~dp0src/HammerAssociate.exe
  )
) else (
  REM Скомпилировать HammerAssociate.c
  title HammerAssociate - Compiling...
  gcc -o %~dp0src/HammerAssociate.exe %~dp0src/HammerAssociate.c -lshlwapi -mwindows -Os -s
  if defined %compress% (
    upx --best %~dp0src/HammerAssociate.exe
  )
)

REM Задаем вопрос об установке для всех пользователей
title HammerAssociate - Waiting for input...
echo.
echo. Do you want to install for all users? [Y/N]
choice /c yn /n
if %errorlevel% == 1 (
  set allusers=1
)

REM Создание папки %ProgramFiles(x86)%\HammerAssociate, если она не существует
title HammerAssociate - Creating folder "%ProgramFiles(x86)%\HammerAssociate"...
if not exist "%ProgramFiles(x86)%\HammerAssociate" mkdir "%ProgramFiles(x86)%\HammerAssociate"

REM Перенос .exe файла в %ProgramFiles(x86)%\HammerAssociate
title HammerAssociate - Moving "bin\HammerAssociate.exe" to "%ProgramFiles(x86)%\HammerAssociate"...
move /Y src\HammerAssociate.exe "%ProgramFiles(x86)%\HammerAssociate"

REM Добавим в предлагаемый список
title HammerAssociate - Adding to the list of suggested files to open...
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v Applications\HammerAssociate.exe_.vmf /d "0" /f
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v Applications\HammerAssociate.exe_.vmx /d "0" /f
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v Applications\HammerAssociate.exe_.vmf_autosave /d "0" /f
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v Applications\HammerAssociate.exe_.vmf_autosavx /d "0" /f

if defined allusers (
  REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v Applications\HammerAssociate.exe_.vmf /d "0" /f
  REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v Applications\HammerAssociate.exe_.vmx /d "0" /f
  REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v Applications\HammerAssociate.exe_.vmf_autosave /d "0" /f
  REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v Applications\HammerAssociate.exe_.vmf_autosavx /d "0" /f
)

REM Теперь присваеваем открытие этого файла
title HammerAssociate - Assign formats...
REG ADD "HKEY_CLASSES_ROOT\vmf_auto_file\shell\open\command" /ve /d "%ProgramFiles(x86)%\HammerAssociate\HammerAssociate.exe %%1" /f
REG ADD "HKEY_CLASSES_ROOT\vmf_auto_file\shell\edit\command" /ve /d "%ProgramFiles(x86)%\HammerAssociate\HammerAssociate.exe %%1" /f
REG ADD "HKEY_CLASSES_ROOT\vmx_auto_file\shell\open\command" /ve /d "%ProgramFiles(x86)%\HammerAssociate\HammerAssociate.exe %%1" /f
REG ADD "HKEY_CLASSES_ROOT\vmx_auto_file\shell\edit\command" /ve /d "%ProgramFiles(x86)%\HammerAssociate\HammerAssociate.exe %%1" /f
REG ADD "HKEY_CLASSES_ROOT\vmf_autosave_auto_file\shell\open\command" /ve /d "%ProgramFiles(x86)%\HammerAssociate\HammerAssociate.exe %%1" /f
REG ADD "HKEY_CLASSES_ROOT\vmf_autosave_auto_file\shell\edit\command" /ve /d "%ProgramFiles(x86)%\HammerAssociate\HammerAssociate.exe %%1" /f
REG ADD "HKEY_CLASSES_ROOT\vmf_autosavx_auto_file\shell\open\command" /ve /d "%ProgramFiles(x86)%\HammerAssociate\HammerAssociate.exe %%1" /f
REG ADD "HKEY_CLASSES_ROOT\vmf_autosavx_auto_file\shell\edit\command" /ve /d "%ProgramFiles(x86)%\HammerAssociate\HammerAssociate.exe %%1" /f

REG ADD "HKEY_CURRENT_USER\SOFTWARE\Classes\vmf_auto_file\shell\open\command" /ve /d "%ProgramFiles(x86)%\HammerAssociate\HammerAssociate.exe %%1" /f
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Classes\vmf_auto_file\shell\edit\command" /ve /d "%ProgramFiles(x86)%\HammerAssociate\HammerAssociate.exe %%1" /f
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Classes\vmx_auto_file\shell\open\command" /ve /d "%ProgramFiles(x86)%\HammerAssociate\HammerAssociate.exe %%1" /f
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Classes\vmx_auto_file\shell\edit\command" /ve /d "%ProgramFiles(x86)%\HammerAssociate\HammerAssociate.exe %%1" /f
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Classes\vmf_autosave_auto_file\shell\open\command" /ve /d "%ProgramFiles(x86)%\HammerAssociate\HammerAssociate.exe %%1" /f
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Classes\vmf_autosave_auto_file\shell\edit\command" /ve /d "%ProgramFiles(x86)%\HammerAssociate\HammerAssociate.exe %%1" /f
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Classes\vmf_autosavx_auto_file\shell\open\command" /ve /d "%ProgramFiles(x86)%\HammerAssociate\HammerAssociate.exe %%1" /f
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Classes\vmf_autosavx_auto_file\shell\edit\command" /ve /d "%ProgramFiles(x86)%\HammerAssociate\HammerAssociate.exe %%1" /f

if defined allusers (
  REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\vmf_auto_file\shell\open\command" /ve /d "%ProgramFiles(x86)%\HammerAssociate\HammerAssociate.exe %%1" /f
  REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\vmf_auto_file\shell\edit\command" /ve /d "%ProgramFiles(x86)%\HammerAssociate\HammerAssociate.exe %%1" /f
  REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\vmx_auto_file\shell\open\command" /ve /d "%ProgramFiles(x86)%\HammerAssociate\HammerAssociate.exe %%1" /f
  REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\vmx_auto_file\shell\edit\command" /ve /d "%ProgramFiles(x86)%\HammerAssociate\HammerAssociate.exe %%1" /f
  REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\vmf_autosave_auto_file\shell\open\command" /ve /d "%ProgramFiles(x86)%\HammerAssociate\HammerAssociate.exe %%1" /f
  REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\vmf_autosave_auto_file\shell\edit\command" /ve /d "%ProgramFiles(x86)%\HammerAssociate\HammerAssociate.exe %%1" /f
  REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\vmf_autosavx_auto_file\shell\open\command" /ve /d "%ProgramFiles(x86)%\HammerAssociate\HammerAssociate.exe %%1" /f
  REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\vmf_autosavx_auto_file\shell\edit\command" /ve /d "%ProgramFiles(x86)%\HammerAssociate\HammerAssociate.exe %%1" /f
)

REM Задаем вопрос об установке иконок
title HammerAssociate - Waiting for input...
echo.
echo. Installing complete!
echo. Do you want to install icons? [Y/N]
choice /c yn /n
if %errorlevel% == 0 (
  goto m1
)

REM Копируем иконки
title HammerAssociate - Copying icons...
move /Y res\icon_vmf.ico "%ProgramFiles(x86)%\HammerAssociate"
move /Y res\icon_vmx.ico "%ProgramFiles(x86)%\HammerAssociate"
move /Y res\icon_vmf_autosave.ico "%ProgramFiles(x86)%\HammerAssociate"
move /Y res\icon_vmf_autosavx.ico "%ProgramFiles(x86)%\HammerAssociate"

REM Присваеваем иконки
title HammerAssociate - Assign icons...
REG ADD "HKEY_CLASSES_ROOT\.vmf" /ve /d "vmf_auto_file" /f
REG ADD "HKEY_CLASSES_ROOT\.vmx" /ve /d "vmx_auto_file" /f
REG ADD "HKEY_CLASSES_ROOT\.vmf_autosave" /ve /d "vmf_autosave_auto_file" /f
REG ADD "HKEY_CLASSES_ROOT\.vmf_autosavx" /ve /d "vmf_autosavx_auto_file" /f
REG ADD "HKEY_CLASSES_ROOT\vmf_auto_file\DefaultIcon" /ve /d "%ProgramFiles(x86)%\HammerAssociate\icon_vmf.ico" /f
REG ADD "HKEY_CLASSES_ROOT\vmx_auto_file\DefaultIcon" /ve /d "%ProgramFiles(x86)%\HammerAssociate\icon_vmx.ico" /f
REG ADD "HKEY_CLASSES_ROOT\vmf_autosave_auto_file\DefaultIcon" /ve /d "%ProgramFiles(x86)%\HammerAssociate\icon_vmf_autosave.ico" /f
REG ADD "HKEY_CLASSES_ROOT\vmf_autosavx_auto_file\DefaultIcon" /ve /d "%ProgramFiles(x86)%\HammerAssociate\icon_vmf_autosavx.ico" /f

REG ADD "HKEY_CURRENT_USER\SOFTWARE\Classes\.vmf" /ve /d "vmf_auto_file" /f
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Classes\.vmx" /ve /d "vmx_auto_file" /f
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Classes\.vmf_autosave" /ve /d "vmf_autosave_auto_file" /f
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Classes\.vmf_autosavx" /ve /d "vmf_autosavx_auto_file" /f
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Classes\vmf_auto_file\DefaultIcon" /ve /d "%ProgramFiles(x86)%\HammerAssociate\icon_vmf.ico" /f
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Classes\vmx_auto_file\DefaultIcon" /ve /d "%ProgramFiles(x86)%\HammerAssociate\icon_vmx.ico" /f
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Classes\vmf_autosave_auto_file\DefaultIcon" /ve /d "%ProgramFiles(x86)%\HammerAssociate\icon_vmf_autosave.ico" /f
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Classes\vmf_autosavx_auto_file\DefaultIcon" /ve /d "%ProgramFiles(x86)%\HammerAssociate\icon_vmf_autosavx.ico" /f

if defined allusers (
  REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\.vmf" /ve /d "vmf_auto_file" /f
  REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\.vmx" /ve /d "vmx_auto_file" /f
  REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\.vmf_autosave" /ve /d "vmf_autosave_auto_file" /f
  REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\.vmf_autosavx" /ve /d "vmf_autosavx_auto_file" /f
  REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\vmf_auto_file\DefaultIcon" /ve /d "%ProgramFiles(x86)%\HammerAssociate\icon_vmf.ico" /f
  REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\vmx_auto_file\DefaultIcon" /ve /d "%ProgramFiles(x86)%\HammerAssociate\icon_vmx.ico" /f
  REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\vmf_autosave_auto_file\DefaultIcon" /ve /d "%ProgramFiles(x86)%\HammerAssociate\icon_vmf_autosave.ico" /f
  REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\vmf_autosavx_auto_file\DefaultIcon" /ve /d "%ProgramFiles(x86)%\HammerAssociate\icon_vmf_autosavx.ico" /f
)

REM Удаление папки bin
title HammerAssociate - Deleting temporary files...
del src\HammerAssociate.exe

:m1

REM Всё готово!
title HammerAssociate - Installing complete!
echo.
echo. Complete!
echo. For the changes to take effect, you may need to restart your computer!
echo.
echo. Press any key to exit...

pause>nul
