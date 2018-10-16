; Programa utiliza apenas syscall write simples que aceita:
; Descritor de arquivos
; O endereço do buffer. Começamos a obter bytes consecutivos a partir dai
; A quantidades de bytes para escrever
; 
; Para buildar:
; nasm -felf64 0002-helloWorld_exit.asm -o 0002-helloWorld_exit.o
; ld -o 0002-helloWorld_exit 0002-helloWorld_exit.o
; chmod u+x 0002-helloWorld_exit

global _start

section .data
message: db 'Hello, world!', 10

section .text
_start:
	mov rax, 1		; número da syscall 'write'
	mov rdi, 1		; descritor de stdout 
	mov rsi, message	; endereço da string
	mov rdx, 14		; tamanho da string em bytes
	syscall

	mov rax, 60		; número da syscall 'exit'
	xor rdi, rdi
	syscall
