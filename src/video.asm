print_string:
  lodsb
  or al, al ; Check if byte in AL is the nul byte
  jz .end ; If it is the nul byte end the function
  mov ah, 0x0E ; Use function 0x0E to print a character from AL
  int 0x10
  jmp print_string
.end:
  ret


print_string_ln:
  call print_string
  ; Next print carriage return and linefeed
  mov ah, 0x0E
  mov al, `\r`
  int 0x10
  mov ah, 0x0E
  mov al, `\n`
  int 0x10
  ret

clear_screen:
  mov ah, 0x06 ; Scroll window function
  mov al, 0 ; 0 = clear
  mov bh, 0x07
  mov cx, 0x0000 ; Top left corner
  mov dx, 0x184F ; Bottom right corner (24 rows, 79 cols)
  int 0x10
  xor bx, bx ; Page number
  mov ah, 0x02 ; Move cursor function
  mov dx, 0x0000 ; Position
  int 0x10
  ret
