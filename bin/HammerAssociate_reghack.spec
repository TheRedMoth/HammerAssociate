# HammerAssociate.spec

block_cipher = None

a = Analysis(['main_reghack.py'],
             pathex=['E:/Python/HammerAssociate/compile'],
             binaries=[],
             hiddenimports=[],
             hookspath=[],
             runtime_hooks=[],
             excludes=[],
             win_no_prefer_redirects=False,
             win_private_assemblies=False,
             cipher=block_cipher,
             noarchive=False)

pyz = PYZ(a.pure, a.zipped_data,
          cipher=block_cipher)

a.datas += [('main_reghack.py', 'main_reghack.py', 'DATA')]  # Исправленная строка для добавления файла в список данных

exe = EXE(pyz,
          a.scripts,
          a.binaries,
          a.zipfiles,
          a.datas,
          [],
          name='HammerAssociate',
          description='Use me to open up .vmf, .vmx, .vmf_autosave or .vmf_autosavx files.',
          icon=['res/icon_vmf.ico', 'res/icon_vmx.ico', 'res/icon_vmf_autosave.ico', 'res/icon_vmf_autosavx.ico'],  # Путь к иконке .ico (если нужно)
          debug=False,
          bootloader_ignore_signals=False,
          strip=False,
          upx=True,
          upx_exclude=[],
          runtime_tmpdir=None,
          console=False)  # Установите значение console на False, чтобы избежать консольного окна