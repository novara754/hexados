# Project Akuma

Simple 16-bit bootloader/operating system written in x86 assembly language.

## Building

**NOTES:** Requires nasm to be installed. 

Bash:
```
$ ./build.sh
```

CMD/Powershell:
```
...> .\build.bat
```

## Running

**DISCLAIMER:**  
- This code has only been tested in Bochs and QEMU.  
- I claim no responsibility for what might or might not happen when running this code.

The build script produces a file called `akuma.iso`.
Use this image as the first floppy disk and boot from it.

For example:
```
$ qemu-system-i386 -fda ./akuma.iso
```

## Images

![https://i.imgur.com/EB8wy0v.png](preview image)
