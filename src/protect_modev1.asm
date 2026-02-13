bits 16
org 0x7c00

start:
	cli 
	
	xor ax, ax
	mov ds, ax
	mov ss, ax
	mov sp, 0x7C00

	lgdt [gdt_descriptor]

	mov eax, cr0
	or eax, 1
	mov cr0, eax

	jmp CODE_SEG:pm_start


gdt_start:
	dq 0x0000000000000000

gdt_code:
	dw 0xFFFF
	dw 0x0000
	db 0x00
	db 10011010b
	db 11001111b
	db 0x00

gdt_data:
	dw 0xFFFF
	dw 0x0000
	db 0x00
	db 10010010b
	db 11001111b
	db 0x00

gdt_end:
	

gdt_descriptor:
	dw gdt_end - gdt_start - 1
	dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SED equ gdt_data - gdt_start

32 bits
pm_start:
	mov ax, DATA_SEG
	mov ss, ax
	mov ds, ax
	mov es, ax
	mov gs, ax
	mov fs, ax
	
	mov esp, 0x90000

halt:
	jmp halt
times 510-($-$$) db 0
dw 0xAA55
