; ===============================
; Minimal Protected Mode Entry
; ===============================

bits 16
org 0x7C00

start:
    cli                     ; stop interrupts

    xor ax, ax
    mov ss, ax              ; stack segment = 0
    mov sp, 0x7C00          ; stack top
    mov ds, ax              ; data segment = 0

    ; ---------------------------
    ; Load GDT
    ; ---------------------------
    lgdt [gdt_descriptor]

    ; ---------------------------
    ; Enter protected mode
    ; ---------------------------
    mov eax, cr0
    or eax, 1               ; set PE bit
    mov cr0, eax

    ; FAR jump (flush pipeline)
    jmp CODE_SEG:pm_start

; ===============================
; GDT
; ===============================

gdt_start:
    dq 0x0000000000000000   ; null descriptor

gdt_code:
    dw 0xFFFF               ; limit low
    dw 0x0000               ; base low
    db 0x00                 ; base middle
    db 10011010b            ; access (code, ring 0)
    db 11001111b            ; flags + limit high
    db 0x00                 ; base high

gdt_data:
    dw 0xFFFF               ; limit low
    dw 0x0000               ; base low
    db 0x00                 ; base middle
    db 10010010b            ; access (data, ring 0)
    db 11001111b            ; flags + limit high
    db 0x00                 ; base high

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

; ===============================
; 32-bit Protected Mode
; ===============================

bits 32

pm_start:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov esp, 0x90000        ; new 32-bit stack

halt:
    jmp halt                ; safe infinite loop

; ===============================
; Boot signature
; ===============================
times 510-($-$$) db 0
dw 0xAA55
