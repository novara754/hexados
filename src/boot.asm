[bits 16]
[org 0x7C00]

start:
	xor ax, ax
	mov ds, ax
	mov es, ax

; Reset floppy controller
.reset_floppy:
	mov dl, 0x00 ; Floppy drive
	mov ah, 0x00 ; Function to reset
	int 0x13
	jnc .read_second_stage ; Carry bit set if error occured
	mov si, RESET_FLOPPY_ERROR_MSG
	call print_string_ln
	jmp .reset_floppy

.read_second_stage:
	; Second stage should be stored at 0x07E0:0x00 (ES:BX)
	mov bx, 0x7E00
	mov ah, 0x02 ; Function to read sector
	mov al, 0x01 ; Read 1 sector
	mov ch, 0x00 ; Read from cylinder 0
	mov cl, 0x02 ; Start reading from sector 2
	mov dh, 0x00 ; Head number
	mov dl, 0x00 ; Floppy drive
	int 0x13
	jc .read_second_stage_error ; Carry bit set if error occured
	cmp al, 0x01 ; Check if the amount of sectors read (AL) is really 1
	jnz .read_second_stage_error
	call main ; Jump to and execute second stage
.read_second_stage_error:
	mov si, READ_SECOND_STAGE_ERROR_MSG
	call print_string_ln
	jmp .read_second_stage

RESET_FLOPPY_ERROR_MSG: db `Failed to reset floppy controller. Trying again...`, 0
READ_SECOND_STAGE_ERROR_MSG: db `Failed to read second sector from disk. Trying again...`, 0

%include "video.asm"

times 510-($-$$) db 0x00
dw 0xAA55

main:
	call clear_screen

	mov si, WELCOME_MSG
	call print_string_ln

.command_loop:
	mov si, CMD_PROMPT
	call print_string

	mov si, CMD_BUFFER
	call get_input

	jmp .command_loop

	cli
	hlt

WELCOME_MSG: db `Welcome to Project Akuma`, 0
CMD_PROMPT: db "$ ", 0
CMD_BUFFER: times 50 db 0
