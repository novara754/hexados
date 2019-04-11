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
