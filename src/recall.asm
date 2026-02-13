org 0x7c00

mov si, message

.print_msg:
	loadsb
	or al, al
	je done
	mov ah, 0x0E
	int 0x10
	jmp .print_msg

done:
	jmp $

message 'Hello World', 0
times 510-($-$$) db 0
dw 0xAA55
