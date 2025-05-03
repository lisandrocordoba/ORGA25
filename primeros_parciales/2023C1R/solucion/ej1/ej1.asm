global acumuladoPorCliente_asm
global en_blacklist_asm
global blacklistComercios_asm

extern malloc
extern calloc
extern strcmp

;########### SECCION DE TEXTO (PROGRAMA)
section .text

UINT32_SIZE EQU 4

PAGO_OFFSET_MONTO EQU 0
PAGO_OFFSET_COMERCIO EQU 8
PAGO_OFFSET_CLIENTE EQU 16
PAGO_OFFSET_APROB EQU 17
PAGO_SIZE EQU 24

; uint32_t* acumuladoPorCliente(uint8_t cantidadDePagos, pago_t* arr_pagos)
; dil = cantidadDePagos
; rsi = *arr_pagos

acumuladoPorCliente_asm:
	; prologo
	push rbp
	mov rbp, rsp
	push rbx
	push r13	; PILA ALINEADA

	; Preservo los argumentos
	xor rbx, rbx
	mov bl, dil			; rbx = cantidadDePagos
	mov r13, rsi		; r13 = *arr_pagos

	; Reservo memoria para el array
	mov rdi, qword 10
	mov rsi, qword 4
	call calloc			; rax = uint32_t* monto_total_clientes = calloc(10, sizeof(uint32_t));

	; Itero por el array de pagos
	dec rbx				; rbx = i = cantPagos-1
	.loop:
		; Agarro el iesimo pago
		mov r8, rbx
		imul r8, PAGO_SIZE
		add r8, r13			; r8 = pago_actual = (pago_t*)((uint64_t)arr_pagos + i*24);

		; Si el pago es rechazado no me interesa
		cmp	byte [r8 + PAGO_OFFSET_APROB], 0
		je .siguiente_iteracion
		
		mov r9b, byte [r8 + PAGO_OFFSET_CLIENTE]	; r9b = cliente = pago_actual->cliente;
		movzx r9, r9b								; r9 = cliente en dword
		mov r10b, byte [r8 + PAGO_OFFSET_MONTO]		; r10b = monto = pago_actual->monto;
		movzx r10d, r10b							; r10d = monto en uint_32
		add dword [rax + r9*UINT32_SIZE], r10d		; monto_total_clientes[cliente] += monto; 
        
		.siguiente_iteracion:
		dec rbx
		cmp rbx, 0
		jge .loop	; Quiero llegar hasta arr_pagos[0]

	; epilogo
	pop r13
	pop rbx
	pop rbp

	ret
; uint8_t en_blacklist(char* comercio, char** lista_comercios, uint8_t n)
; rdi = *comercio
; rsi = **lista_comercios
; dl = n
en_blacklist_asm:
	; prologo
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	sub rsp, 8	; PILA ALINEADA

	; Preservo argumentos
	mov r12, rdi	; r12 = *comercio
	mov r13, rsi	; r13 = **lista_comercios
	xor rbx, rbx
	mov bl, dl		; rbx = n = length_lista

	; Itero la lista y busco si está el comercio
	dec rbx			; rbx = i = length-1
	.loop2:
		; Desreferencio el comercio actual y lo comparo
		mov rdi, [r13 + rbx*8]	; rdi = comercio_actual = lista_comercios[i];
		mov rsi, r12			; rsi = comercio
		call strcmp

		; Si son iguales, ya está
		cmp rax, 0
		je .pertenece

		; Sino siguiente iteracion
		dec rbx
		cmp rbx, 0
		jge .loop2

		; Si termine de recorrer y no lo encontré, no pertenece	
		xor rax, rax
		jmp .fin2

		.pertenece:
			mov rax, 1

	.fin2:
	; epilogo
	add rsp, 8
	pop r13
	pop r12
	pop rbx
	pop rbp
	
	ret


; pago_t** blacklistComercios(uint8_t cantidad_pagos, pago_t* arr_pagos, char** arr_comercios, uint8_t size_comercios){
; dil = cantidad_pagos
; rsi = *arr_pagos
; rdx = ** arr_comercios
; cl = size_comercios

blacklistComercios_asm:
	; prologo
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15
	sub rsp, 24	; PILA ALINEADA

	; Presevo los argumentos
	xor rbx, rbx
	mov bl, dil		; rbx = cantidad_pagos
	xor r15, r15
	mov r15b, dil	; r15 = cantidad_pagos
	mov r12, rsi	; r12 = *arr_pagos
	mov r13, rdx	; r13 = **arr_comercios
	xor r14, r14
	mov r14b, cl	; r14 = size_comercios


	; Para saber cuanto debe medir el array tengo que contar los pagos de los comercios en la blacklist
	mov byte [rbp-8], 0 	; [rbp-8] = cant_pagos_blacklist = 0;

	; Itero por arr_pagos
	dec rbx					; rbx = i = cant_pagos-1
	.loop3:
		; Agarro el iesimo pago
		mov r8, rbx
		imul r8, PAGO_SIZE
		add r8, r12		; r8 = pago_actual = (pago_t*)((uint64_t)arr_pagos + i*24);

		; Me fijo si el comercio pertenece a la blacklist
		mov rdi, qword [r8 + PAGO_OFFSET_COMERCIO]	; rdi = comercio_actual = pago_actual->comercio;
		mov rsi, r13								; rsi = **arr_comercios
		mov dl, r14b								; dl = size_comercios
		call en_blacklist_asm

		; Si no pertenece, sigo el while
		cmp rax, 0
		je .siguiente_iteracion3

		; Si pertenece, aumento el contador
		inc byte [rbp-8]	; cant_pagos_blacklist++

		.siguiente_iteracion3:
		dec rbx
		cmp rbx, 0
		jge .loop3	; Quiero llegar hasta arr_pagos[0]

	; ----------------------------------------------------------------------
	; ACA TENGO EN [RBP-8] LA CANTIDAD DE PAGOS EN LA BLACKLIST
	; AHORA QUIERO INICIALIZAR EL ARRAY E IR GUARDANDO LOS PAGOS CORRESPONDIENTES
	xor rdi, rdi
	mov dil, byte [rbp-8]
	sal rdi, 3
	call malloc					; rax = pagos_blacklist = malloc(cant_pagos_blacklist*sizeof(pago_t*));

    ; Vuelvo a iterar para guardar los pagos de los comercios en blacklist
	xor rbx, rbx
	mov bl, byte [rbp-8]
	dec rbx						; rbx = cant_pagos_blacklist-1 (lo voy a usar como indice para agregar en el array)

	mov qword [rbp-8], rax		; preservo pagos_blacklist

	dec r15						; r15 = i = cant_pagos-1
	.loop4:
		; Agarro el iesimo pago
		mov r8, r15
		imul r8, PAGO_SIZE
		add r8, r12			; r8 = pago_actual = (pago_t*)((uint64_t)arr_pagos + i*24);

		; Me fijo si el comercio pertenece a la blacklist
		mov rdi, qword [r8 + PAGO_OFFSET_COMERCIO]	; rdi = comercio_actual = pago_actual->comercio;
		mov rsi, r13								; rsi = **arr_comercios
		mov dl, r14b								; dl = size_comercios
		mov qword [rbp-16], r8						; preservo pago_actual
		call en_blacklist_asm
		mov r8, qword [rbp-16]

		; Si no pertenece, sigo el while
		cmp rax, 0
		je .siguiente_iteracion4

		; Si pertenece, agrego el pago
		mov rax, qword [rbp-8]			; rax = pagos_blacklist
		mov qword [rax + rbx*8], r8		; pagos_blacklist[cant_pagos_blacklist] = pago_actual;
		dec rbx							; cant_pagos_blacklist--;

		.siguiente_iteracion4:
		dec r15
		cmp r15, 0
		jge .loop4	; Quiero llegar hasta arr_pagos[0]

	mov rax, [rbp-8]

	; epilogo
	add rsp, 24
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp

	ret
