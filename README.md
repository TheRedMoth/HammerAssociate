## HammerPlusPlusAssociate

**HammerPlusPlusAssociate** is a branch of the **HammerAssociate** project that adds support for the **HammerPlusPlus** modification. It is designed to conveniently open files with the `.vmf` extension in either **HammerPlusPlus** or the regular **Hammer Editor**, depending on the availability of the corresponding executable file.

When **HammerPlusPlusAssociate** works with `.vmf` files, it will attempt to find the `HammerPlusPlus.exe` executable file instead of the standard `hammer.exe`. If the **HammerPlusPlus.exe** file is not found, the utility will launch the regular **Hammer Editor**.

It is worth noting that the **REGHACK** is now applied only to the regular **Hammer.exe**, as the **HammerPlusPlus** modification does not have any issues with object rendering distance limitations.

#### You still can opt out of the REGHACK feature during compilation in the corresponding choice!

## Extended support via shortcuts!

If you want to use **HammerPlusPlus** with other games besides those officially supported, you can create a shortcut to implement adaptation.

For example, to launch a map from **Portal 2** using **HammerPlusPlus**, you need to create a shortcut for `hammerplusplus.exe` from `...\common\Counter-Strike Global Offensive\bin\hammerplusplus.exe` and place it in the folder `...\common\Portal 2\bin`. Then the utility will pick up the path to HammerPlusPlus and open the map through it!

###### *So far, this feature has been tested only on Portal 2...

## Installation

1. **Run** `compile.bat` without administrator privileges to compile the utility into an `.exe` and choose whether you need **REGHACK**.

2. **Run** `install.bat` as an administrator to install the necessary associations in the system.

3. **Installation complete.** You may need to restart your computer for the changes to take effect.

## Known issues

1. **Hammer editor** for some reason **cannot properly open** `.vmx` through launch parameters, so when opening `.vmx`, the utility creates a copy of the map with the suffix `_x.vmf` and launches it. **If a file with the same name already exists during copying, the utility will ask if it can replace it.**

2. ~~**In the Hammer editor window title** after opening a map **and in the file replacement dialog**, **a broken path to the map may be displayed.** Don't worry, **this is strictly a graphical artifact and does not affect functionality!**~~ **[FIXED!]**

3. ~~**When creating** `_x.vmf`, in some cases, **the filename becomes corrupted.**~~ **[FIXED!]**

4. Sometimes, **when opening a map**, there is a chance that **Hammer may crash** for unknown reasons. But it is known that this issue is on Hammer's side. It is not critical, simply reopen the map! *Does HammerPlusPlus have such problems? I haven't encountered them yet...*

## License

The utility has no license ¯\\\_(ツ)\_/¯ You can do whatever you want with it!

###### *This text, like the utility itself, was written and translated using ChatGPT-3.5!
