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
EJERCICIO_1A_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

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



;; bool es_indice_ordenado(item_t** inventario, uint16_t* indice, uint16_t tamanio, comparador_t comparador) {
global es_indice_ordenado
es_indice_ordenado:
	; rdi = **inventario
	; rsi = *indice
	; dx = tamanio
	; rcx = *comparador

	; prologo
	push rbp
	mov rbp, rsp 
	push rbx
	push r12
	push r13
	push r14 
	push r15 
	sub rsp, 8		; PILA ALINEADA
	
	xor rbx, rbx
	mov bx, dx		; bx = tamanio
	mov r12, rdi	; r12 = **inventario
	mov r13, rsi	; r13 = *indice
	mov r14, rcx	; r14 = *comparador

	; si (tamanio < 2) return true
	mov rax, 1
	cmp rbx, 2			
	jl .fin

	dec rbx			; rbx = i = (tamanio-1)
	.loop:
		; desreferencio los indices_actuales
		mov r8, rbx
		sal r8, 1							; r8 = i*2 (tamaño int16)
		mov r8w, word [r13 + r8]			; r8w = indice_item_actual = indice[i]

		mov r9, rbx
		dec r9
		sal r9, 1							; r9 = (i-1)*2 (tamaño int16)
		mov r9w, word [r13 + r9]			; r9w = indice_item_anterior = indice[i-1]

		; desreferencio los items_actuales
		sal r8, 3							; r8 = indice_item_actual*8 (tamaño *item_t)
		mov r10, qword [r12 + r8]			; r10 = item_actual = inventario[indice_item_actual]

		sal r9, 3							; r9 = indice_item_anterior*8 (tamaño *item_t)
		mov r11, qword [r12 + r9]			; r11 = item_anterior = inventario[indice_item_anterior]

		; comparo
		mov rdi, r11
		mov rsi, r10
		call r14					; rax = comparador(item_anterior, item_actual)

		cmp rax, 0
		je .fin						; si (rax==0) {return 0 pues no estan ordenados)				

		.siguiente_iteracion:		; si estan ordenados, sigo
		dec rbx		; tamanio--
		jnz .loop

	.fin:
	;epilogo
	add rsp, 8
	pop r15
	pop r14 
	pop r13
	pop r12
	pop rbx
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

