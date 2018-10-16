; Programa utiliza apenas syscall write simples que aceita:
; Descritor de arquivos
; O endereço do buffer. Começamos a obter bytes consecutivos a partir dai
; A quantidades de bytes para escrever
; 
; Para buildar:
; nasm -felf64 0001-helloWorld.asm -o 0001-helloWorld.o
; ld -o 0001-helloWorld 0001-helloWorld.o
; chmod u+x 0001-helloWorld

global _start

section .data
message: db 'Hello, world!', 10

section .text
_start:
	mov rax, 1		; o número da chamada de sistema deve ser armazenado em rax
	mov rdi, 1		; argumento #1 em rdi: onde escrever o (descritor)?
	mov rsi, message	; argumento #2 em tsi: onde começa a string?
	mov rdx, 14		; argumento #3 em rdx: quantos bytes devem ser escritos?
	syscall			; essa instrução faz uma chamada de sistema
