; Print_newline e print_hex
; Imprime uma nova linha e pegar um número e imprimir
; 
; Para buildar:
; nasm -felf64 0005-print_call.asm -o 0005-print_call.o
; ld -o 0005-print_call 0005-print_call.o
; chmod u+x 0005-print_call



section .data
codes:			db	'0123456789abcdef'
newLine_char:	db	10

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
		sub rcx, 4
		sar rax, cl				; desloca para 60, 56, 52,  ... 4, 0
								; o registrador cl é a menor parte de rcx
		
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
	mov rdi, 0x1122334455667788

	call print_hex
	call print_newline

	mov rax, 60		; chamada de sistema 'exit'
	xor rdi, rdi
	syscall