@echo off
title HammerAssociate

REM Проверка на запуск от имени администратора
net session >nul 2>&1
if %errorlevel% EQU 0 (
  title HammerAssociate - Error
  echo This file cannot be run as an administrator!
  pause>nul
  exit /b
)

REM Задаем вопрос о методе reghack
title HammerAssociate - Waiting for input...
echo Do you want to use the REGHACK feature? [Y/N]
choice /c yn /n
if %errorlevel% == 1 (
  REM Скомпилировать main_reghack.py
  title HammerAssociate - Compiling...
  pyinstaller %~dp0\bin\HammerAssociate_reghack.spec
) else (
  REM Скомпилировать main.py
  title HammerAssociate - Compiling...
  pyinstaller %~dp0\bin\HammerAssociate.spec
)

REM Успешно ли скомпилировался проект?
if not exist %~dp0\dist\HammerAssociate.exe (
  title HammerAssociate - Error
  echo An unknown error occurred while compiling the project!
  pause>nul
  exit /b
)

REM А вот теперь направляем пользователя дозавершить установку
title HammerAssociate - Compile complete!
echo Now run install.bat!

pause>nul