import os
import sys
import winreg
import win32api
import subprocess
import win32com.client

# Определяем функцию для установки значения в реестре
def set_registry_value(key_path, value_name, value_data, value_type):
    print(f"Setting registry value: {value_name} = {value_data} ({value_type})")
    try:
        key = winreg.OpenKey(winreg.HKEY_CURRENT_USER, key_path, 0, winreg.KEY_ALL_ACCESS)
        winreg.SetValueEx(key, value_name, 0, value_type, value_data)
        winreg.CloseKey(key)
        return True
    except:
        return False

def find_hammer(file_path) -> str:
    map_dir = os.path.dirname(file_path)

    # Поиск hammerplusplus.exe или ярлыка в иерархии папок
    current_path = map_dir
    while True:
        bin_path = os.path.join(current_path, 'bin')
        
        # Поиск ярлыка hammerplusplus.exe
        lnk_path = os.path.join(bin_path, 'hammerplusplus.exe.lnk')
        if os.path.exists(lnk_path):
            return win32com.client.Dispatch("WScript.Shell").CreateShortCut(lnk_path).TargetPath
        
        # Поиск hammerplusplus.exe
        hammer_path = os.path.join(bin_path, 'hammerplusplus.exe')
        if os.path.exists(hammer_path):
            return hammer_path

        # Поиск hammer.exe
        hammer_path = os.path.join(bin_path, 'hammer.exe')
        if os.path.exists(hammer_path):
            return hammer_path

        # Идём в родительскую папку
        parent_dir = os.path.dirname(current_path)
        if current_path == parent_dir:
            break
        current_path = parent_dir

    # Если hammer.exe не найден, получаем путь о последнем запущенном Hammer из реестра
    try:
        with winreg.OpenKey(winreg.HKEY_CURRENT_USER, r'SOFTWARE\Valve\Hammer\General') as key:
            hammer_dir = winreg.QueryValueEx(key, 'Directory')[0]

        hammer_path = os.path.join(hammer_dir, 'hammer.exe')
        if os.path.exists(hammer_path):
            return hammer_path
    except FileNotFoundError:
        pass

    return None

def open_hammer(file_path):
    # Проверка расширения файла
    if not file_path.lower().endswith(('.vmf', '.vmx', '.vmf_autosave', '.vmf_autosavx')):
        # Вызываем функцию MessageBox для отображения диалогового окна ошибки
        win32api.MessageBox(None, 'Invalid file type. Only .vmf, .vmx, .vmf_autosave or .vmf_autosavx files are supported.', "HammerAssociate", 0x10)
        return
    
    # Если расширение файла .vmx, создаем копию файла с новым именем
    if file_path.lower().endswith('.vmx'):
        new_file_path = os.path.splitext(win32api.GetLongPathName(file_path))[0] + "_x.vmf"
        
        # Проверяем, существует ли уже файл с таким именем
        if os.path.exists(new_file_path):
            response = win32api.MessageBox(None, f'The file "{win32api.GetLongPathName(new_file_path)}" already exists. Do you want to replace it?', "HammerAssociate", 0x4 | 0x20)
            
            if response != 6:  # 6 corresponds to "Yes" button in MessageBox
                return
        
        # Копируем файл с новым именем
        try:
            with open(file_path, 'rb') as src_file, open(new_file_path, 'wb') as dst_file:
                dst_file.write(src_file.read())
            
            file_path = new_file_path
        except OSError:
            win32api.MessageBox(None, 'Failed to copy the file.', "HammerAssociate", 0x10)
            return
    
    # Поиск пути к Hammer
    hammer_path = find_hammer(file_path)
    if hammer_path:
        # Установка значений в реестре
        set_registry_value(r"SOFTWARE\Valve\Hammer\3D Views", "BackPlane", 131072, winreg.REG_DWORD)
        set_registry_value(r"SOFTWARE\Valve\Hammer\3D Views", "DetailDistance", 131072, winreg.REG_DWORD)
        set_registry_value(r"SOFTWARE\Valve\Hammer\3D Views", "ModelDistance", 131072, winreg.REG_DWORD)
        set_registry_value(r"SOFTWARE\Valve\Hammer\General", "Undo Levels", 131072, winreg.REG_SZ)
        
        # Запуск Hammer с указанным файлом карты
        subprocess.Popen([hammer_path, '-nop4', win32api.GetLongPathName(file_path)])
    else:
        win32api.MessageBox(None, '"bin\hammer.exe" was not found.', "HammerAssociate", 0x10)

if __name__ == "__main__":
    # Проверяем, есть ли переданные аргументы командной строки
    if len(sys.argv) > 1:
        # Получаем массив с путями к файлам из аргументов
        for file_path in sys.argv[1:]:
            open_hammer(file_path) # Запускаем Hammer с каждым путем к файлу
    else:
        win32api.MessageBox(None, 'Open .vmf, .vmx, .vmf_autosave, .vmf_autosavx file via HammerAssociate.exe in the "Open with" context menu.', "HammerAssociate", 0x40)
