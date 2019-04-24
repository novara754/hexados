@echo off
pushd .\src\
nasm -f bin boot.asm -o ..\hexados.iso
popd
