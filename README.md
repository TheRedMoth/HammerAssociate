## HammerAssociate

**HammerAssociate** is a utility designed for convenient opening of files with the `.vmf` extension. The utility is intended for opening **Valve Hammer Editor** maps, allowing users to quickly and easily launch the corresponding **Hammer** for the respective game.

When working with `.vmf` files, it is often inconvenient to use the standard file opening methods, and the option to *"Open with"* does not work as it requires additional parameters to be specified through the registry, which is quite problematic. **HammerAssociate** solves this problem by providing a simple and intuitive algorithm for determining which game the map belongs to and automatically launching the corresponding **Hammer Editor**.

###### * Please note that now the HammerPlusPlusAssociate branch is available for HammerPlusPlus!

## How does the algorithm work?

The utility searches for the executable file `bin\hammer.exe` by scanning the folder hierarchy above the location of the `.vmf` map.

For example, here is the launched map:

`"...\common\Portal 2\sdk_content\maps\map.vmf"`

The algorithm goes up the hierarchy each time until it finds `bin\hammer.exe`:

`"...\common\Portal 2\sdk_content\maps\bin\hammer.exe"` - Not found

`"...\common\Portal 2\sdk_content\bin\hammer.exe"` - Not found

`"...\common\Portal 2\bin\hammer.exe"` - Found

This algorithm allows launching the corresponding map in the corresponding game.

If `hammer.exe` is not found, the utility uses the information stored in the registry about the last opened *Hammer Editor* and launches the map through it:
`HKEY_CURRENT_USER\SOFTWARE\Valve\Hammer\General\Directory`

## REGHACK feature

**HammerAssociate** also includes an additional registry hack to automatically set ultra settings for rendering distance above **Hammer** limits:

```
HKEY_CURRENT_USER\SOFTWARE\Valve\Hammer\3D Views", "BackPlane", 131072
HKEY_CURRENT_USER\SOFTWARE\Valve\Hammer\3D Views", "DetailDistance", 131072
HKEY_CURRENT_USER\SOFTWARE\Valve\Hammer\3D Views", "ModelDistance", 131072
HKEY_CURRENT_USER\SOFTWARE\Valve\Hammer\General", "Undo Levels", 131072
```

*These parameters are set automatically when opening a map and allow increasing the limitations on the rendering distance of objects.*

#### You can opt out of the REGHACK feature during compilation in the corresponding choice!

## Installation

1. **Run** `compile.bat` without administrator privileges to compile the utility into an `.exe` and choose whether you need **REGHACK**.

2. **Run** `install.bat` as an administrator to install the necessary associations in the system.

3. **Installation complete.** You may need to restart your computer for the changes to take effect.

## Known issues

1. **Hammer editor** for some reason **cannot properly open** `.vmx` through launch parameters, so when opening `.vmx`, the utility creates a copy of the map with the suffix `_x.vmf` and launches it. **If a file with the same name already exists during copying, the utility will ask if it can replace it.**

2. ~~**In the Hammer editor window title** after opening a map **and in the file replacement dialog**, **a broken path to the map may be displayed.** Don't worry, **this is strictly a graphical artifact and does not affect functionality!**~~ **[FIXED!]**

3. ~~**When creating** `_x.vmf`, in some cases, **the filename becomes corrupted.**~~ **[FIXED!]**

4. Sometimes, **when opening a map**, there is a chance that **Hammer may crash** for unknown reasons. But it is known that this issue is on Hammer's side.

## License

The utility has no license ¯\\\_(ツ)_/¯ You can do whatever you want with it!

###### * This text, like the utility itself, was written and translated using ChatGPT-3.5!
