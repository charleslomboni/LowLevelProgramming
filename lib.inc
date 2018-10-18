section .data
newLine db 10

section .text

; ================================================================================================================================

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
    xor rax, rax
    mov rax, 1              ; identificador da syscall 'write'
    mov rdi, 1              ; descritor do arquivo 'stdout'
    mov rsi, newLine        ; local de onde os dados são obtidos
    mov rdx, 1              ; a quantidade de bytes a ser escrita
    syscall
    ret

; ================================================================================================================================


print_uint:
    mov rax, rdi
    mov rdi, rsp
    push 0
    sub rsp, 16

    dec rdi
    mov r8, 10
.loop:
    xor rdx, rdx
    div r8
    or dl, 0x30
    dec rdi
    mov [rdi], dl
    test rax, rax
    jnz .loop

    call print_string

    add rsp, 24
    ret

; ================================================================================================================================

print_int:
    test rdi, rdi
    
    jns print_uint
    push rdi
    mov rdi, '-'
    
    call print_char
    
    pop rdi
    neg rdi
    
    jmp print_uint

; ================================================================================================================================    

string_equals:
    mov al, byte [rdi]
    cmp al, byte [rsi]
    jne .no
    inc rdi
    inc rsi
    test al, al
    jnz string_equals
    mov rax, 1
    ret
    .no:
    xor rax, rax
    ret 

; ================================================================================================================================

read_char:
    push 0
    xor rax, rax
    xor rdi, rdi
    mov rsi, rsp 
    mov rdx, 1
    syscall
    pop rax
    ret 

; ================================================================================================================================

read_word:
    push r14
    push r15
    xor r14, r14 
    mov r15, rsi
    dec r15

    .A:
    push rdi
    call read_char
    pop rdi
    cmp al, ' '
    je .A
    cmp al, 10
    je .A
    cmp al, 13
    je .A 
    cmp al, 9 
    je .A
    test al, al
    jz .C

    .B:
    mov byte [rdi + r14], al
    inc r14

    push rdi
    call read_char
    pop rdi
    cmp al, ' '
    je .C
    cmp al, 10
    je .C
    cmp al, 13
    je .C 
    cmp al, 9
    je .C
    test al, al
    jz .C
    cmp r14, r15
    je .D

    jmp .B

    .C:
    mov byte [rdi + r14], 0
    mov rax, rdi 
   
    mov rdx, r14 
    pop r15
    pop r14
    ret

    .D:
    xor rax, rax
    pop r15
    pop r14
    ret

; ================================================================================================================================

; rdi points to a string
; returns rax: number, rdx : length
parse_uint:
    mov r8, 10
    xor rax, rax
    xor rcx, rcx
.loop:
    movzx r9, byte [rdi + rcx] 
    cmp r9b, '0'
    jb .end
    cmp r9b, '9'
    ja .end
    xor rdx, rdx 
    mul r8
    and r9b, 0x0f
    add rax, r9
    inc rcx 
    jmp .loop 
    .end:
    mov rdx, rcx
    ret

; ================================================================================================================================

; rdi points to a string
; returns rax: number, rdx : length
parse_int:
    mov al, byte [rdi]
    cmp al, '-'
    je .signed
    jmp parse_uint
.signed:
    inc rdi
    call parse_uint
    neg rax
    test rdx, rdx
    jz .error

    inc rdx
    ret

    .error:
    xor rax, rax
    ret 

; ================================================================================================================================

; rdi = source
    ; rsi = dest
    ; rdx = dest length 
string_copy:

    push rdi
    push rsi
    push rdx
    call string_length
    pop rdx
    pop rsi
    pop rdi

    cmp rax, rdx
    jae .too_long  ; we also need to store null-terminator
    
    push rsi 

        .loop: 
        mov dl, byte[rdi]
        mov byte[rsi], dl
        inc rdi
        inc rsi
        test dl, dl
        jnz .loop 

    pop rax 
    ret

    .too_long:
    xor rax, rax
    ret

; ================================================================================================================================