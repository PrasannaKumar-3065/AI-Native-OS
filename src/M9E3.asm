org 0x7C00

; Reset disk
mov ah, 0x00
mov dl, 0x00
int 0x13

; Read sector
mov ah, 0x02
mov al, 1          ; read 1 sector
mov ch, 0x00       ; cylinder
mov cl, 2          ; sector
mov dh, 0          ; head
mov dl, 0x00       ; drive
mov bx, buffer     ; buffer offset
mov ax, 0x0000
mov es, ax         ; segment
int 0x13

; Print from buffer
mov si, buffer
mov ah, 0x0E

.print_loop:
    lodsb
    or al, al
    jz .done
    int 0x10
    jmp .print_loop

.done:
    jmp $

; Buffer (small, not 510 bytes)
buffer: times 128 db 0   ; enough space for 1 sector (512 bytes in total file)

; Pad rest of boot sector
times 510-($-$$) db 0
dw 0xAA55
