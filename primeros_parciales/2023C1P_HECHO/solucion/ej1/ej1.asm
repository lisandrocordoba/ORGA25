global templosClasicos
global cuantosTemplosClasicos

extern malloc

section .data
OFFSET_LARGO_TEMPLO EQU 0
OFFSET_NOMBRE_TEMPLO EQU 8
OFFSET_CORTO_TEMPLO EQU 16
TEMPLO_SIZE EQU 24

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;templo* templosClasicos(templo *temploArr, size_t temploArr_len)
; *temploArr -> rdi
; temploArr_len -> rsi
; NOTAR: size_t son 8 bytes
templosClasicos:
    ;prologo
    push rbp
    mov rbp, rsp
    push r12
    push r13        
    push r14
    push r15        ; ALINEADA
    mov r12, rdi    ; r12 = *temploArr
    mov r13, rsi    ; r13 = temploArr_len

    ; NOTAR: ya tengo los argumentos en rdi y rsi
    call cuantosTemplosClasicos     ; rax = #templosClasicos
    mov r14, rax    ; r14 = #templosClasicos // lo preservo por el call a malloc

    ; llamar a malloc
    mov r8, TEMPLO_SIZE
    mul r8          ; rax = #templosClasicos*sizeof(templo)
    mov rdi, rax
    call malloc             ; rax = *nuevoTemploArray
    mov r15, rax            ; r15 = *nuevoTemploArray    // rax lo dejo quieto para retornarlo

    ; iterar len veces
    .loop:
        xor r8, r8
        xor r9, r9
        mov r8b, byte [r12 + OFFSET_LARGO_TEMPLO]    ; r8b = templo_actual->largo
        mov r9b, byte [r12 + OFFSET_CORTO_TEMPLO]    ; r9b = templo_actual->corto
        mov r10b, r8b

        ; si templo_actual esClasico
        sub r8, 1      
        sub r8, r9
        sub r8, r9  
        cmp r8, 0    ; si M-2N-1 = 0, es clasico 
        jne .noEsClasico
        ; copio largo
        mov byte [r15+OFFSET_LARGO_TEMPLO], r10b
        ; copio corto
        mov byte [r15+OFFSET_CORTO_TEMPLO], r9b
        ; copio nombre
        mov r8, qword [r15+OFFSET_NOMBRE_TEMPLO]
        mov qword [r15+OFFSET_NOMBRE_TEMPLO], r8

        add r15, TEMPLO_SIZE

        ; Si ya agregue todos los clasicos que habia, salgo
        dec r14
        jz .fin         

        .noEsClasico:
        ; no hay que hacer nada, solo no aumentar el contador

        ; siguiente iteracion
        add r12, TEMPLO_SIZE
        dec r13
        jnz .loop

    .fin
    ;epilogo
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    ret



; uint32_t cuantosTemplosClasicos(templo *temploArr, size_t temploArr_len)
; *temploArr -> rdi
; temploArr_len -> rsi
; NOTAR: size_t son 8 bytes
cuantosTemplosClasicos:
    ; prologo
    push rbp
    mov rbp, rsp

    ; rax = contador = 0
    xor eax, eax

    ; iterar len veces
    .loop:
        xor r8, r8
        xor r9, r9
        mov r8b, [rdi + OFFSET_LARGO_TEMPLO]    ; r8b = templo_actual->largo
        mov r9b, [rdi + OFFSET_CORTO_TEMPLO]    ; r9b = templo_actual->corto

        ; si templo_actual esClasico
        sub r8, 1      
        sub r8, r9
        sub r8, r9 
        cmp r8, 0    ; si M-2N-1 = 0, es clasico 
        jne .noEsClasico  
        inc eax         ; contador++

        .noEsClasico:
        ; no hay que hacer nada, solo no aumentar el contador

        ; siguiente iteracion
        add rdi, TEMPLO_SIZE
        dec rsi
        jnz .loop
    
    ; epilogo
    pop rbp
    ret



