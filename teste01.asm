section .data
minhaStr db "minha string",0
newLine db 10

section .text
global _start

exit:
    mov rax, 60             ; chamada de sistema 'exit'
    xor rdi, rdi
    syscall

string_length:
                            ; de acordo com a nossa convenção, o primeiro e único argumento é obtido de rdi
    xor rax, rax            ; rax armazenará o tamanho da string.
                            ; Se não for zerado antes, seu valor será totalmente aleatório


.loop:                      ; o laço principal começa arqui
    cmp byte[rdi+rax], 0    ; verifica se o símbolo atual é o finalizador nulo.
                            ; precisamos do modificador 'byte', pois a parte a esquerda e a direita
                            ; de 'cmp' devem ter o mesmo tamanho. O operando à direita é imediato
                            ; e não contém nenhuma informação sobre o seu tamanho,
                            ; desse modo, não sabemos quantos bytes devem ser obtidos da memória
                            ; e comparados com zero.
    je .end                 ; Jump se o finalizador nulo foi encontrado, caso contrário,
    inc rax                 ; vai para o próximo símbolo e incrementa o contador
    jmp .loop

.end:
    ret                     ; quando 'ret' for alcançado, rax deverá armazenar o valor de retorno

; ================================================================================================================================

print_string:
    push rdi                ; salva o conteúdo atual de 'rdi' que é a string a ser impressa
    call string_length      ; recupera o tamanho atual da string

    pop rsi                 ; coloca o valor de 'rdi' em 'rsi'
    mov rdx, rax            ; tamanho da string, 'rdx' recebe a quantidade de bytes a ser escrito
    mov rax, 1              ; identificador da syscall 'write'
    mov rdi, 1              ; descritor do arquivo 'stdout'
    syscall

    ret

; ================================================================================================================================

print_char:
    push rdi                ; salva 'rdi' que contém o char
    mov rdi, rsp            ; 'rdi' agora contém a stack
    call print_string       ; imiprime o caracter
    pop rdi                 ; recupera o caracter passado para 'rdi'
    ret

; ================================================================================================================================

print_newline:
    mov rax, 1              ; identificador da syscall 'write'
    mov rdi, 1              ; descritor do arquivo 'stdout'
    mov rsi, newLine        ; local de onde os dados são obtidos
    mov rdx, 1              ; a quantidade de bytes a ser escrita
    syscall
    ret

; ================================================================================================================================

_start:
    mov rdi, minhaStr
    call print_string
    call print_newline

    mov rdi, 65
    call print_char
    call print_newline
    call exit