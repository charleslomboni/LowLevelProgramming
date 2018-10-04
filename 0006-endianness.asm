; Print_newline e print_hex
; Imprime uma nova linha e pegar um número e imprimir
; Duas formas diferentes de imprimir números na tela
; 
; Para buildar:
; nasm -felf64 0006-endianness.asm -o 0006-endianness.o
; ld -o 0006-endianness 0006-endianness.o
; chmod u+x 0006-endianness



section .data
codes:			db	'0123456789abcdef'
newLine_char:	db	10
demo1:			dq	0x1122334455667788	; quadword
demo2:			db	0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88

section .text
global _start

print_newline:
	mov rax, 1				; identificador da syscall 'write'
	mov rdi, 1				; descritor do arquivo 'stdout'
	mov rsi, newLine_char 	; local de onde os dados são obtidos
	mov rdx, 1				; a quantidade de bytes a ser escrita
	syscall
ret

print_hex:
	mov rax, rdi

	mov rdi, 1
	mov rdx, 1
	mov rcx, 64				; até que ponto estamos deslocando rax?

	iterate:
		push rax				; salva o valor inicial de rax
		sub rcx, 4				; desloca para 60, 56, 52,  ... 4, 0
		sar rax, cl				; o registrador cl é a menor parte de rcx						
		and rax, 0xf			; limpa todos os bits, exceto os quatro menos significativos
		lea rsi, [codes+rax]	; obtém o código de caracter de um digito hexadecimal

		mov rax, 1

		push rcx				; syscall altera rcx
		syscall					; rax = 1 (31) - o identificador de 'write',
								; rdi = 1 para 'stdout'
								; rsi = o endereço de um caractere	

		pop rcx

		pop rax
		test rcx, rcx			; rcx = 0 quando todos os dígitos forem mostrados
		jnz iterate

	ret


_start:
	
	xor rdi, rdi

	mov rdi, [demo1]
	call print_hex
	call print_newline

	mov rdi, [demo2]
	call print_hex
	call print_newline

	mov rax, 60		; chamada de sistema 'exit'
	xor rdi, rdi
	syscall