; ===============================
; Intent IR v0.1 — Law-Clean Bootloader
; ===============================

bits 16
org 0x7C00

; -------------------------------
; INTENT DEFINITIONS (FINITE LAW)
; -------------------------------
INTENT_NONE   equ 0
INTENT_MODE_A equ 1
INTENT_MODE_B equ 2

; -------------------------------
; BOOT ENTRY
; -------------------------------
start:
    cli                     ; no interrupts during setup
    xor ax, ax
    mov ss, ax              ; stack segment = 0
    mov sp, 0x7C00          ; stack grows down from bootloader
    sti

    mov byte [intent], INTENT_NONE

    mov si, menu_msg
    call print_string

main_loop:
    call interpret_input
    call validate_intent
    call dispatch
    jmp main_loop           ; system never "ends"

; ============================================================
; INTERPRETER — MAY BE SMART, NEVER POWERFUL
; ============================================================
; Reads raw input
; Translates it to *data only*
; NEVER changes control flow
; NEVER executes actions
interpret_input:
    mov ah, 0x00
    int 0x16                ; wait for keypress (AL = ASCII)

    cmp al, '1'
    jne .check2
    mov byte [intent], INTENT_MODE_A
    ret

.check2:
    cmp al, '2'
    jne .invalid
    mov byte [intent], INTENT_MODE_B
    ret

.invalid:
    mov byte [intent], INTENT_NONE
    ret

; ============================================================
; VALIDATION — DUMB, SIDE-EFFECT FREE
; ============================================================
; Collapses intent into a safe subset
; NEVER prints
; NEVER jumps to actions
; NEVER loops
validate_intent:
    cmp byte [intent], INTENT_MODE_A
    je .ok
    cmp byte [intent], INTENT_MODE_B
    je .ok

    mov byte [intent], INTENT_NONE
.ok:
    ret

; ============================================================
; DISPATCHER — THE ONLY AUTHORITY
; ============================================================
; Enforces law
; Executes only whitelisted behavior
; Rejects everything else
dispatch:
    cmp byte [intent], INTENT_MODE_A
    je do_mode_a
    cmp byte [intent], INTENT_MODE_B
    je do_mode_b
    ret                     ; rejection = no execution

; ============================================================
; ACTIONS — BORING BY DESIGN
; ============================================================
do_mode_a:
    mov si, msg_a
    call print_string
    ret

do_mode_b:
    mov si, msg_b
    call print_string
    ret

; ============================================================
; UTILITIES
; ============================================================
print_string:
    lodsb
    cmp al, 0
    je .done
    mov ah, 0x0E
    int 0x10
    jmp print_string
.done:
    ret

; ============================================================
; DATA (NO MEANING UNLESS USED)
; ============================================================
menu_msg:
    db 13,10,'Select mode:',13,10
    db '1) Mode A',13,10
    db '2) Mode B',13,10
    db '> ',0

msg_a:
    db 13,10,'Mode A executed',13,10,0

msg_b:
    db 13,10,'Mode B executed',13,10,0

intent db INTENT_NONE

; -------------------------------
; BOOT SIGNATURE
; -------------------------------
times 510-($-$$) db 0
dw 0xAA55
