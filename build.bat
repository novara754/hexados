@echo off
pushd .\src\
nasm -f bin boot.asm -o ..\akuma.iso
popd
