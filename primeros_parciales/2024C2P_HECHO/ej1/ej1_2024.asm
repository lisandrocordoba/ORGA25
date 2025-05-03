extern malloc

section .rodata
; Acá se pueden poner todas las máscaras y datos que necesiten para el ejercicio

section .text
; Marca un ejercicio como aún no completado (esto hace que no corran sus tests)
FALSE EQU 0
; Marca un ejercicio como hecho
TRUE  EQU 1

; Marca el ejercicio 1A como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - es_indice_ordenado
global EJERCICIO_1A_HECHO
EJERCICIO_1A_HECHO: db FALSE ; Cambiar por `TRUE` para correr los tests.

; Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - indice_a_inventario
global EJERCICIO_1B_HECHO
EJERCICIO_1B_HECHO: db FALSE ; Cambiar por `TRUE` para correr los tests.

;; La funcion debe verificar si una vista del inventario está correctamente 
;; ordenada de acuerdo a un criterio (comparador)

;; bool es_indice_ordenado(item_t** inventario, uint16_t* indice, uint16_t tamanio, comparador_t comparador);

;; Dónde:
;; - `inventario`: Un array de punteros a ítems que representa el inventario a
;;   procesar.
;; - `indice`: El arreglo de índices en el inventario que representa la vista.
;; - `tamanio`: El tamaño del inventario (y de la vista).
;; - `comparador`: La función de comparación que a utilizar para verificar el
;;   orden.
;; 
;; Tenga en consideración:
;; - `tamanio` es un valor de 16 bits. La parte alta del registro en dónde viene
;;   como parámetro podría tener basura.
;; - `comparador` es una dirección de memoria a la que se debe saltar (vía `jmp` o
;;   `call`) para comenzar la ejecución de la subrutina en cuestión.
;; - Los tamaños de los arrays `inventario` e `indice` son ambos `tamanio`.
;; - `false` es el valor `0` y `true` es todo valor distinto de `0`.
;; - Importa que los ítems estén ordenados según el comparador. No hay necesidad
;;   de verificar que el orden sea estable.

global es_indice_ordenado
es_indice_ordenado:
	; Te recomendamos llenar una tablita acá con cada parámetro y su
	; ubicación según la convención de llamada. Prestá atención a qué
	; valores son de 64 bits y qué valores son de 32 bits o 8 bits.
	;
	; rdi = item_t**     inventario
	; rsi = uint16_t*    indice
	; rdx = uint16_t     tamanio
	; rcx = comparador_t comparador

	; prologo
	push rbp
	mov rbp, rsp

	; preservo los no volatiles que voy a usar
	push r12
	push r13
	push r14
	push r15
	push rbx		
	sub rsp, 8			; PILA ALINEADA

	; preservo en no volatiles los argumentos
	mov r12, rdi		; r12 = inventario
	mov r13, rsi		; r13 = array indice
	xor r14, r14
	mov r14w, dx		; r14 = tamanio
	mov r15, rcx		; r15 = comparador

	xor rbx, rbx		; rbx = iterador = 0

	cmp r14, 0
	je fin 				; si el inventario es vacio, no entro al while

	;recorro todo el inventario
	sub r14, 1			; tamanio-- pues como recorro de a 2 items, en el caso i = tamanio - 1 no voy a entrar al while
	while:
		; dereferencio indice_vista_actual = [indice + iterador * 2]
		mov r10, rbx			; r10 copia de iterador
		sal r10, 1				; r10 = iterador * 2
		xor r8, r8
		mov r8w, [r13 + r10]	; r8w = indice_vista_actual
		sal r8, 3				; r8 = indice_vista_actual * 8 (tamaño puntero)
		; dereferencio item_actual = [inventario + indice_vista_actual * 8 (tamaño puntero)]
		mov rdi, [r12 + r8]	; rdi = item_actual


		; dereferencio indice_vista_siguiente = [indice + (iterador+1) * 2]
		mov r10, rbx					 ; r10 copia de iterador
		inc r10							 ; r10 = iterador+1
		sal r10, 1			   			 ; r10 = (iterador+1) * 2
		xor r8, r8
		mov r8w, [r13 + r10]			 ; r8w = indice_vista_siguiente
		sal r8, 3						 ; r8 = indice_vista_siguiente * 8 (tamaño puntero)
		; dereferencio itemsigueinte = [inventario + indice_vista_siguiente * 8 (tamaño puntero)]
		mov rsi, [r12 + r8]			; rsi = siguiente item


		; estanOrdenados = comparador(itemactual, itemsiguiente)
		call r15			; retorna en rax

		;si !estanOrdenados -> no_es_ordenado
		cmp rax, 0
		je	no_es_ordenado

		; siguiente iteracion (((IR HASTA TAMANIO - 2)))
		inc rbx				; iterador++
		cmp	rbx, r14
		jl while			; si (i < tamanio - 1) SIGO EL WHILE

		jmp es_ordenado		; si termine el while y no encontre ningun desordenado => es ordenado

	
	no_es_ordenado:
	xor rax, rax		; return false
	jmp fin

	es_ordenado:
	xor rax, rax
	inc rax				; return true
	jmp fin

	fin:
	;epilogo
	add rsp, 8
	pop rbx
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbp

	ret

;; Dado un inventario y una vista, crear un nuevo inventario que mantenga el
;; orden descrito por la misma.

;; La memoria a solicitar para el nuevo inventario debe poder ser liberada
;; utilizando `free(ptr)`.

;; item_t** indice_a_inventario(item_t** inventario, uint16_t* indice, uint16_t tamanio);

;; Donde:
;; - `inventario` un array de punteros a ítems que representa el inventario a
;;   procesar.
;; - `indice` es el arreglo de índices en el inventario que representa la vista
;;   que vamos a usar para reorganizar el inventario.
;; - `tamanio` es el tamaño del inventario.
;; 
;; Tenga en consideración:
;; - Tanto los elementos de `inventario` como los del resultado son punteros a
;;   `ítems`. Se pide *copiar* estos punteros, **no se deben crear ni clonar
;;   ítems**

global indice_a_inventario
indice_a_inventario:
	; Te recomendamos llenar una tablita acá con cada parámetro y su
	; ubicación según la convención de llamada. Prestá atención a qué
	; valores son de 64 bits y qué valores son de 32 bits o 8 bits.
	;
	; rdi = item_t**  inventario
	; rsi = uint16_t* indice
	; rdx = uint16_t  tamanio

	;prologo
	push rbp
	mov rbp, rsp

	; preservo los no volatiles que voy a usar
	push r12
	push r13
	push r14										
	sub rsp, 8		; PILA ALINEADA

	; antes de llamar a malloc, me guardo los argumentos en no volatiles
	mov r12, rdi		; r12 = inventario
	mov r13, rsi		; r13 = array indices
	mov r14, rdx		; r14 = tamanio

	; reservo memoria para nuevo_inventario
	mov rdi, r14		; rdi = tamanio
	sal rdi, 3			; rdi = tamanio * 8 (tamaño puntero)
	call malloc			; rax = nuevo_inventario

	; recorro todo el inventario
	xor r8, r8			; r8 = iterador = 0
	while2:
		; indiceNuevo = [indices + iterador * 2 (tamaño uint_16)]
		mov r10, r8		; r10 copia del iterador
		sal r10, 1		; r10 = iterador * 2
		xor r11, r11
		mov r11w, [r10 + r13]	;r11w = indice_nuevo

		; item_actual = [inventario + nuevo_indice * 8 (tamaño puntero)]
		sal r11, 3				; r11 = nuevo_indice * 8
		mov r9, [r12 + r11]		; r9 = inventario + nuevo_indice * 8
		;mov r9, [r9]			; r9 = item_actual

		; escribo resultado[i] = inventario[indice[i]]
		mov r10, r8 		; r10 copia del iterador
		sal r10, 3			; r10 = iterador*8
		mov [rax + r10], r9	; resultado[i] = item_actual
		
		; siguiente iteracion
		inc r8			; iterador++
		cmp r8, r14
		jl while2		; si (i < tamanio) SIGO EL WHILE

	;epilogo
	add rsp, 8
	pop rbp
	pop r14
	pop r13
	pop r12
	ret



