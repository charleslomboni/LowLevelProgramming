; Diferença entre mov e lea
; 
; Para buildar:
; nasm -felf64 0004-lea_vs_mov.asm -o 0004-lea_vs_mov.o
; ld -o 0004-lea_vs_mov 0004-lea_vs_mov.o
; chmod u+x 0004-lea_vs_mov



section .data
codes:
	db		'0123456789ABCDEF'

section .text
global _start
_start:
	; rsi <- endereço do label 'codes', um número
	mov rsi, codes

	; rsi <- conteúdo da memória, começando no endereço 'codes'
	; 8 bytes consecutivos são obtidos porque o tamanho de rsi é de 8 bytes
	mov rsi, [codes]

	; rsi <- edereço de 'codes'
	; neste caso, é equivalente a mov rsi, codes
	; em geral, o endereço pode conter vários componentes
	lea rsi, [codes]

	; rsi <- conteúdo da memória, começando em (codes+rax)
	mov rsi, [codes+rax]

	; rsi <- codes + rax
	; equivalente à combinação:
	; -- mov rsi, codes
	; -- add rsi, rax
	; não é possível fazer isto com um único mov!
	lea rsi, [codes+rax]


	mov rax, 60		; chamada de sistema 'exit'
	xor rdi, rdi
	syscall