@echo off
title HammerAssociate

REM Проверка на запуск от имени администратора
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
  title HammerAssociate - Error
  echo Run this file as an administrator!
  pause>nul
  exit /b
)

REM Был ли запущен компилятор?
if not exist %~dp0\dist (
  title HammerAssociate - Error
  echo First run compile.bat!
  pause>nul
  exit /b
)

REM Создание папки %ProgramFiles(x86)%\HammerAssociate, если она не существует
title HammerAssociate - Creating folder "%ProgramFiles(x86)%\HammerAssociate"...
if not exist "%ProgramFiles(x86)%\HammerAssociate" mkdir "%ProgramFiles(x86)%\HammerAssociate"

REM Перенос .exe файла в %ProgramFiles(x86)%\HammerAssociate
title HammerAssociate - Moving "dist\HammerAssociate.exe" to "%ProgramFiles(x86)%\HammerAssociate"...
move /Y %~dp0\dist\HammerAssociate.exe "%ProgramFiles(x86)%\HammerAssociate"

REM Добавим в предлагаемый список
title HammerAssociate - Adding to the list of suggested files to open...
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v Applications\HammerAssociate.exe_.vmf /d "0" /f
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v Applications\HammerAssociate.exe_.vmx /d "0" /f
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v Applications\HammerAssociate.exe_.vmf_autosave /d "0" /f
REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" /v Applications\HammerAssociate.exe_.vmf_autosavx /d "0" /f

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

REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\vmf_auto_file\shell\open\command" /ve /d "%ProgramFiles(x86)%\HammerAssociate\HammerAssociate.exe %%1" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\vmf_auto_file\shell\edit\command" /ve /d "%ProgramFiles(x86)%\HammerAssociate\HammerAssociate.exe %%1" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\vmx_auto_file\shell\open\command" /ve /d "%ProgramFiles(x86)%\HammerAssociate\HammerAssociate.exe %%1" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\vmx_auto_file\shell\edit\command" /ve /d "%ProgramFiles(x86)%\HammerAssociate\HammerAssociate.exe %%1" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\vmf_autosave_auto_file\shell\open\command" /ve /d "%ProgramFiles(x86)%\HammerAssociate\HammerAssociate.exe %%1" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\vmf_autosave_auto_file\shell\edit\command" /ve /d "%ProgramFiles(x86)%\HammerAssociate\HammerAssociate.exe %%1" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\vmf_autosavx_auto_file\shell\open\command" /ve /d "%ProgramFiles(x86)%\HammerAssociate\HammerAssociate.exe %%1" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\vmf_autosavx_auto_file\shell\edit\command" /ve /d "%ProgramFiles(x86)%\HammerAssociate\HammerAssociate.exe %%1" /f

REM Присваеваем иконку
title HammerAssociate - Assign icons...
REG ADD "HKEY_CLASSES_ROOT\.vmf" /ve /d "vmf_auto_file" /f
REG ADD "HKEY_CLASSES_ROOT\vmf_auto_file\DefaultIcon" /ve /d "%ProgramFiles(x86)%\HammerAssociate\HammerAssociate.exe,0" /f
REG ADD "HKEY_CLASSES_ROOT\.vmx" /ve /d "vmx_auto_file" /f
REG ADD "HKEY_CLASSES_ROOT\vmx_auto_file\DefaultIcon" /ve /d "%ProgramFiles(x86)%\HammerAssociate\HammerAssociate.exe,1" /f
REG ADD "HKEY_CLASSES_ROOT\.vmf_autosave" /ve /d "vmf_autosave_auto_file" /f
REG ADD "HKEY_CLASSES_ROOT\vmf_autosave_auto_file\DefaultIcon" /ve /d "%ProgramFiles(x86)%\HammerAssociate\HammerAssociate.exe,2" /f
REG ADD "HKEY_CLASSES_ROOT\.vmf_autosavx" /ve /d "vmf_autosavx_auto_file" /f
REG ADD "HKEY_CLASSES_ROOT\vmf_autosavx_auto_file\DefaultIcon" /ve /d "%ProgramFiles(x86)%\HammerAssociate\HammerAssociate.exe,3" /f

REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\.vmf" /ve /d "vmf_auto_file" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\vmf_auto_file\DefaultIcon" /ve /d "%ProgramFiles(x86)%\HammerAssociate\HammerAssociate.exe,0" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\.vmx" /ve /d "vmx_auto_file" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\vmx_auto_file\DefaultIcon" /ve /d "%ProgramFiles(x86)%\HammerAssociate\HammerAssociate.exe,1" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\.vmf_autosave" /ve /d "vmf_autosave_auto_file" /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\vmf_autosave_auto_file\DefaultIcon" /ve /d "%ProgramFiles(x86)%\HammerAssociate\HammerAssociate.exe,2" /f

REM Удаление папки dist
title HammerAssociate - Deleting temporary folders...
rmdir /s /q %~dp0\dist
rmdir /s /q %~dp0\build

REM Всё готово!
title HammerAssociate - Installing complete!
echo The association of icons and executable file was added successfully.
echo For the changes to take effect, you may need to restart your computer!

pause>nul
