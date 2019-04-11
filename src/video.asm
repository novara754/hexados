print_string:
	lodsb
	or al, al ; Check if byte in AL is the nul byte
	jz .end ; If it is the nul byte end the function
	mov ah, 0x0E ; Use function 0x0E to print a character from AL
	int 0x10
	jmp print_string
.end:
	ret

end_line:
	mov ah, 0x0E
	mov al, `\r`
	int 0x10
	mov ah, 0x0E
	mov al, `\n`
	int 0x10
	ret

print_string_ln:
	call print_string
	call end_line
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

move_cursor_back:
	mov ah, 0x03 ; Get cursor position
	int 0x10
	cmp dl, 0 ; Check if column is 0 to wrap back to previous line
	jz .decrease_row
	sub dl, 1 ; Decrease column by 1
	jmp .end
.decrease_row:
	sub dh, 1
.end:
	mov ah, 0x02 ; Set cursor position
	int 0x10
	ret

get_input:
	xor bx, bx
	xor ax, ax
	int 0x16
	cmp ah, 0x0E ; Check if scancode is backspace
	jz .backspace
	cmp ah, 0x1C ; Check if scancode is enter
	jz .enter_key
	mov ah, 0x0E
	int 0x10
	jmp get_input
.backspace:
	call move_cursor_back
	mov ah, 0x0E
	mov al, ' '
	int 0x10
	call move_cursor_back
	jmp get_input
.enter_key:
	call end_line
	ret
