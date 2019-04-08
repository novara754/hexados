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
  call print_string
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
  call print_string
  jmp .read_second_stage

RESET_FLOPPY_ERROR_MSG: db "Failed to reset floppy controller. Trying again...", 0
READ_SECOND_STAGE_ERROR_MSG: db "Failed to read second sector from disk. Trying again...", 0

%include "print_string.asm"

times 510-($-$$) db 0x00
dw 0xAA55

main:
  mov si, SUCCESS_MSG
  call print_string

  cli
  hlt

SUCCESS_MSG: db "Successfully loaded the second stage.", 0
