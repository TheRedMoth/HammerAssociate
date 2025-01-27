#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <shlwapi.h>

#pragma comment(lib, "shlwapi.lib")

// Функция для поиска hammer.exe
char* FindHammer(const char* filePath) {
    char mapDir[MAX_PATH];
    strncpy(mapDir, filePath, MAX_PATH);
    PathRemoveFileSpec(mapDir);

    char currentPath[MAX_PATH];
    strncpy(currentPath, mapDir, MAX_PATH);

    while (1) {
        char binPath[MAX_PATH];
        PathCombine(binPath, currentPath, "bin");

        char hammerPath[MAX_PATH];
        PathCombine(hammerPath, binPath, "hammer.exe");

        if (PathFileExists(hammerPath)) {
            return strdup(hammerPath);
        }

        char parentDir[MAX_PATH];
        strncpy(parentDir, currentPath, MAX_PATH);
        PathRemoveFileSpec(parentDir);

        if (strcmp(currentPath, parentDir) == 0) {
            break;
        }

        strncpy(currentPath, parentDir, MAX_PATH);
    }

    // Поиск в реестре
    HKEY hKey;
    if (RegOpenKeyEx(HKEY_CURRENT_USER, "SOFTWARE\\Valve\\Hammer\\General", 0, KEY_READ, &hKey) == ERROR_SUCCESS) {
        char hammerDir[MAX_PATH];
        DWORD bufferSize = MAX_PATH;
        if (RegQueryValueEx(hKey, "Directory", NULL, NULL, (LPBYTE)hammerDir, &bufferSize) == ERROR_SUCCESS) {
            char hammerExePath[MAX_PATH];
            PathCombine(hammerExePath, hammerDir, "hammer.exe");

            if (PathFileExists(hammerExePath)) {
                RegCloseKey(hKey);
                return strdup(hammerExePath);
            }
        }
        RegCloseKey(hKey);
    }

    return NULL;
}

// Функция для открытия Hammer
void OpenHammer(const char* filePath) {
    // Проверка расширения файла
    const char* ext = PathFindExtension(filePath);
    if (_stricmp(ext, ".vmf") != 0 && _stricmp(ext, ".vmx") != 0 &&
        _stricmp(ext, ".vmf_autosave") != 0 && _stricmp(ext, ".vmf_autosavx") != 0) {
        MessageBox(NULL, "Invalid file type. Only .vmf, .vmx, .vmf_autosave or .vmf_autosavx files are supported.", "HammerAssociate", MB_ICONERROR);
        return;
    }

    char newFilePath[MAX_PATH];
    if (_stricmp(ext, ".vmx") == 0) {
        strncpy(newFilePath, filePath, MAX_PATH);
        PathRemoveExtension(newFilePath);
        strcat(newFilePath, "_x.vmf");

        if (PathFileExists(newFilePath)) {
            int response = MessageBox(NULL, "The file already exists. Do you want to replace it?", "HammerAssociate", MB_YESNO | MB_ICONQUESTION);
            if (response != IDYES) {
                return;
            }
        }

        if (!CopyFile(filePath, newFilePath, FALSE)) {
            MessageBox(NULL, "Failed to copy the file.", "HammerAssociate", MB_ICONERROR);
            return;
        }

        filePath = newFilePath;
    }

    // Поиск пути к Hammer
    char* hammerPath = FindHammer(filePath);
    if (hammerPath) {
        // Запуск Hammer
        char command[MAX_PATH + 20];
        snprintf(command, sizeof(command), "\"%s\" -nop4 \"%s\"", hammerPath, filePath);
        STARTUPINFO si = { sizeof(si) };
        PROCESS_INFORMATION pi;
        if (CreateProcess(NULL, command, NULL, NULL, FALSE, 0, NULL, NULL, &si, &pi)) {
            CloseHandle(pi.hProcess);
            CloseHandle(pi.hThread);
        } else {
            MessageBox(NULL, "Failed to start Hammer.", "HammerAssociate", MB_ICONERROR);
        }

        free(hammerPath);
    } else {
        MessageBox(NULL, "\"bin\\hammer.exe\" was not found.", "HammerAssociate", MB_ICONERROR);
    }
}

int main(int argc, char* argv[]) {
    if (argc > 1) {
        for (int i = 1; i < argc; i++) {
            OpenHammer(argv[i]);
        }
    } else {
        MessageBox(NULL, "Open .vmf, .vmx, .vmf_autosave, .vmf_autosavx file via HammerAssociate.exe in the \"Open with\" context menu.", "HammerAssociate", MB_ICONINFORMATION);
    }

    return 0;
}
