org 0x7C00

jmp start

; ----------------------
; BIOS print string
; ----------------------
print_str:
    mov ah, 0x0E
.next_char:
    lodsb               ; Load byte from SI into AL
    cmp al, 0
    je .done
    int 0x10
    jmp .next_char
.done:
    ret

; ----------------------
; Print AX in decimal
; ----------------------
print_num:
    pusha
    mov bx, 10
    mov cx, 0
.divide_loop:
    xor dx, dx
    div bx              ; AX / 10 → quotient in AX, remainder in DX
    push dx             ; save remainder
    inc cx
    test ax, ax
    jnz .divide_loop
.print_loop:
    pop dx
    add dl, '0'
    mov ah, 0x0E
    mov al, dl
    int 0x10
    loop .print_loop
    popa
    ret

; ----------------------
; Main
; ----------------------
start:
    mov si, msg_heads
    call print_str

    mov ah, 0x08        ; get disk parameters
    mov dl, 0x00        ; floppy drive 0
    int 0x13

    mov al, dh          ; max head number (0-based)
    inc ax              ; heads = DH + 1
    call print_num

    mov si, msg_sectors
    call print_str

    mov al, cl
    and al, 0x3F        ; mask to get sectors per track
    mov ah, 0
    call print_num

hang:
    jmp hang

; ----------------------
; Data
; ----------------------
msg_heads db 0x0D,0x0A,"Heads: ",0
msg_sectors db 0x0D,0x0A,"Sectors/Track: ",0

times 510-($-$$) db 0
dw 0xAA55
