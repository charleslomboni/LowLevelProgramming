; Imprime rax em formato hexa
; 
; Para buildar:
; nasm -felf64 0003-print_rax.asm -o 0003-print_rax.o
; ld -o 0003-print_rax 0003-print_rax.o
; chmod u+x 0003-print_rax



section .data
codes:
	db		'0123456789ABCDEF'

section .text
global _start
_start:
	; número 1122... em formato hexadecimal
	mov rax, 0x1122334455667788

	mov rdi, 1
	mov rdx, 1
	mov rcx, 64

	; Cada 4 bytes deve ser exibido como um dígito hexadecimal
	; Use o deslocamento (shift) e a operação bit a bit AND para isolá-los
	; o resultado é o offset no array 'codes'
	.loop:
		push rax
		sub  rcx, 4
		; cl é um registrador, a parte menor de rcx
		; rax -- eax -- ax -- ah + al
		; rcx -- rcx -- cx -- ch + cl
		sar rax, cl
		and rax, 0xf

		lea rsi, [codes+rax]
		mov rax, 1

		; syscall delixa rcx e r11 alterados
		push rcx
		syscall
		pop rcx

		pop rax
		; test pode ser usado para uma verificação mais rápido do tipo 'é um zero?'
		; sobre comando test: https://www.aldeid.com/wiki/X86-assembly/Instructions/test
		test rcx, rcx
		jnz .loop

		mov rax, 60		; chamada de sistema 'exit'
		xor rdi, rdi
		syscall