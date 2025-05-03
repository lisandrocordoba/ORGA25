section .text

global contar_pagos_aprobados_asm
global contar_pagos_rechazados_asm

global split_pagos_usuario_asm

extern malloc
extern free
extern strcmp

PAGO_OFFSET_MONTO EQU 0
PAGO_OFFSET_APROBADO EQU 1
PAGO_OFFSET_PAGADOR EQU 8
PAGO_OFFSET_COBRADOR EQU 16
PAGO_SIZE EQU 24

SPLITTED_OFFSET_CANT_APRO EQU 0
SPLITTED_OFFSET_CANT_RECHA EQU 1
SPLITTED_OFFSET_APROBADOS EQU 8
SPLITTED_OFFSET_RECHAZADOS EQU 16
SPLITTED_SIZE EQU 24

LIST_OFFSET_FIRST EQU 0

LISTELEM_OFFSET_DATA EQU 0
LISTELEM_OFFSET_NEXT EQU 8

;########### SECCION DE TEXTO (PROGRAMA)

; uint8_t contar_pagos_aprobados_asm(list_t* pList, char* usuario);
; rdi = *pList
; rsi = *usuario
contar_pagos_aprobados_asm:
	; prologo
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15
	sub rsp, 8	; PILA ALINEADA

    ; Preservo argumentos
    xor rbx, rbx    ; rbx = total_aprobados = 0
    mov r12, rdi    ; r12 = *pList
    mov r13, rsi    ; r13 = *usuario

    mov r14, qword [r12 + LIST_OFFSET_FIRST]        ; r14 = nodo_actual = pList->first;

    .loop:
        ; Si nodo_actual es NULL terminé
        cmp r14, 0
        je .fin

        mov r8, qword [r14 + LISTELEM_OFFSET_DATA]  ; r8 = pago_actual = nodo_actual->data;
        ; Si pago_actual no es aprobado sigo el while
        cmp byte [r8 + PAGO_OFFSET_APROBADO], 0
        je .siguiente_iteracion

        ; Si el cobrador de pago_actual no es usuario, sigo el while
        mov rdi, qword [r8 + PAGO_OFFSET_COBRADOR]   
        mov rsi, r13
        call strcmp     ; rax = strcmp(nombre_cobrador, usuario);
        cmp rax, 0
        jne .siguiente_iteracion

        ; Si llego aca: es un pago aprobado cobrado por usuario
        inc rbx         ; total_aprobados++;

        .siguiente_iteracion:
        mov r14, qword [r14 + LISTELEM_OFFSET_NEXT]
        jmp .loop

    .fin:
    mov rax, rbx
	; epilogo
	add rsp, 8
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp

    ret



; uint8_t contar_pagos_rechazados_asm(list_t* pList, char* usuario);
contar_pagos_rechazados_asm:
	; prologo
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15
	sub rsp, 8	; PILA ALINEADA

    ; Preservo argumentos
    xor rbx, rbx    ; rbx = total_rechazados = 0
    mov r12, rdi    ; r12 = *pList
    mov r13, rsi    ; r13 = *usuario

    mov r14, qword [r12 + LIST_OFFSET_FIRST]        ; r14 = nodo_actual = pList->first;

    .loop2:
        ; Si nodo_actual es NULL terminé
        cmp r14, 0
        je .fin2

        mov r8, qword [r14 + LISTELEM_OFFSET_DATA]  ; r8 = pago_actual = nodo_actual->data;
        ; Si pago_actual no es rechazado sigo el while
        cmp byte [r8 + PAGO_OFFSET_APROBADO], 0
        jne .siguiente_iteracion2

        ; Si el cobrador de pago_actual no es usuario, sigo el while
        mov rdi, qword [r8 + PAGO_OFFSET_COBRADOR]   
        mov rsi, r13
        call strcmp     ; rax = strcmp(nombre_cobrador, usuario);
        cmp rax, 0
        jne .siguiente_iteracion2

        ; Si llego aca: es un pago rechazados cobrado por usuario
        inc rbx         ; total_rechazados++;

        .siguiente_iteracion2:
        mov r14, qword [r14 + LISTELEM_OFFSET_NEXT]
        jmp .loop2

    .fin2:
    mov rax, rbx
	; epilogo
	add rsp, 8
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp

    ret

; pagoSplitted_t* split_pagos_usuario_asm(list_t* pList, char* usuario);
; rdi = *pList
; rsi = *usuario
split_pagos_usuario_asm:
	; prologo
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15
	sub rsp, 8	    ; PILA ALINEADA

    ; Preservo los argumentos
    mov r12, rdi    ; r12 = *pList
    mov r13, rsi    ; r13 = *usuario

    ; ----- Inicializo el pagoSplitted ------
    mov rdi, SPLITTED_SIZE
    call malloc     
    mov r14, rax    ; r14 = pagos_usuario = malloc(sizeof(pagoSplitted_t));

    ; Seteo el campo cant_aprobados
    mov rdi, r12    
    mov rsi, r13
    call contar_pagos_aprobados_asm     ; al = contar_pagos_aprobados(pList, usuario);
    mov byte [r14 + SPLITTED_OFFSET_CANT_APRO], al

    ; Seteo el campo **aprobados
    mov rdi, rax    ; rdi = cant_aprobados
    sal rdi, 3      
    call malloc     ; rax = malloc(sizeof(pago_t*)*cant_aprobados);
    mov qword [r14 + SPLITTED_OFFSET_APROBADOS], rax

    ; Seteo el campo cant_rechazados
    mov rdi, r12    
    mov rsi, r13
    call contar_pagos_rechazados_asm     ; al = contar_pagos_rechazados(pList, usuario);
    mov byte [r14 + SPLITTED_OFFSET_CANT_RECHA], al
    
    ; Seteo el campo **rechazados
    mov rdi, rax    ; rdi = cant_rechazados
    sal rdi, 3      
    call malloc     ; rax = malloc(sizeof(pago_t*)*cant_rechazados);
    mov qword [r14 + SPLITTED_OFFSET_RECHAZADOS], rax

    ; -------------------------------------------------------------

    ; ------- Recorro los pagos para guardar los q correspondan -----
    mov rbx, qword [r12 + LIST_OFFSET_FIRST]          ; rbx = nodo_actual = pList->first
    mov r12, qword [r14 + SPLITTED_OFFSET_APROBADOS]  ; r12 = **aprobados
    mov r15, qword [r14 + SPLITTED_OFFSET_RECHAZADOS] ; r15 = **rechazados

    .loop3:
        ; Si nodo_actual es NULL, terminé
        cmp rbx, 0
        je .fin3

        ; Desreferencio el pago_actual
        mov r8, qword [rbx + LISTELEM_OFFSET_DATA]   ;r8 = pago_actual = nodo_actual->data;

        ; Si el cobrador no es usuario, sigo el while
        mov rdi, qword [r8 + PAGO_OFFSET_COBRADOR]
        mov rsi, r13
        mov qword [rbp-8], r8   ; Preservo pago_actual
        call strcmp             ; rax = strcmp(usuario, nombre_cobrador);
        mov r8, qword [rbp-8]
        cmp rax, 0
        jne .siguiente_iteracion3

        ; Agrego el pago en aprobados_usuario o rechazados_usuario segun corresponda
        cmp byte [r8 + PAGO_OFFSET_APROBADO], 0
        jne .agregar_pago_aprobado
        je .agregar_pago_rechazado

        .siguiente_iteracion3:
        mov rbx, qword [rbx + LISTELEM_OFFSET_NEXT] ; rbx = nodo_actual = nodo_actual->next;
        jmp .loop3

        .agregar_pago_aprobado:
        mov [r12], r8                ; pagos_usuario->aprobados[i] = pago_actual;
        add r12, 8                   ; en **aprobados avanzo al siguiente pago del array
        jmp .siguiente_iteracion3
        
        .agregar_pago_rechazado:
        mov [r15], r8                ; pagos_usuario->rechazados[j] = pago_actual;
        add r15, 8                   ; en **rechazados avanzo al siguiente pago del array
        jmp .siguiente_iteracion3
    ; -------------------------------------------------------------

    .fin3:
    mov rax, r14    ; rax = pagos_usuario
	; epilogo
	add rsp, 8
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp

    ret