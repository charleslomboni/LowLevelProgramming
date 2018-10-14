; Tamanho de string - strlen.asm
; 
; Para buildar:
; nasm -felf64 0007-strlen.asm -o 0007-strlen.o
; ld -o 0007-strlen 0007-strlen.o
; chmod u+x 0007-strlen


global _start

section .data
text_string:	db	"abcdef", 0

section .text

strlen:						; de acordo com a nossa convenção, o primeiro e único argumento é obtido de rdi
	xor rax, rax			; rax armazenará o tamanho da string.
							; Se não for zerado antes, seu valor será totalmente aleatório


.loop:						; o laço principal começa arqui
	cmp byte[rdi+rax], 0	; verifica se o símbolo atual é o finalizador nulo.
							; precisamos do modificador 'byte', pois a parte a esquerda e a direita
							; de 'cmp' devem ter o mesmo tamanho. O operando à direita é imediato
							; e não contém nenhuma informação sobre o seu tamanho,
							; desse modo, não sabemos quantos bytes devem ser obtidos da memória
							; e comparados com zero.
	je .end					; Jump se o finalizador nulo foi encontrado, caso contrário,
	inc rax					; vai para o próximo símbolo e incrementa o contador
	jmp .loop

.end:
	ret 					; quando 'ret' for alcançado, rax deverá armazenar o valor de retorno


_start:
	
	xor rdi, rdi

	mov rdi, text_string
	call strlen
	mov rdi, rax

	mov rax, 60		; chamada de sistema 'exit'
	xor rdi, rdi
	syscall