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
EJERCICIO_1B_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
ITEM_NOMBRE EQU 0
ITEM_FUERZA EQU 20
ITEM_DURABILIDAD EQU 24
ITEM_SIZE EQU 28

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
	; dx = uint16_t     tamanio
	; rcx = comparador_t comparador

	; prologo
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15
	sub rsp, 8	; PILA ALINEADA

	; preservo en no volatiles
	xor rbx, rbx
	mov bx, dx		; rbx = tamanio
	mov r12, rdi	; r12 = *inventario
	mov r13, rsi	; r13 = *indice
	mov r14, rcx	; r14 = comparador

	dec rbx 		; rbx = i = (tamanio-1)
	.loop:
		; busco el item actual
		xor r8, r8
		mov r8w, word [r13 + rbx*2]			; r8 = indice_item_actual = indice[i];
		mov r9, qword [r12 + r8*8]			; r9 = item_actual = inventario[indice_item_actual];

		; busco el item anterior
		xor r10, r10
		mov r10w, word [r13 + (rbx-1)*2]	; r10 = indice_item_anterior = indice[i-1];
		mov r11, qword [r12 + r10*8]		; r11 = item_anterior = inventario[indice_item_anterior];

		; los comparo
		mov rdi, r11
		mov rsi, r9
		call r14
		; si estan desordenados return false
		cmp rax, 0
		je .estan_desordenados
		; sino sigo
		.siguiente_iteracion:
		dec rbx
		jnz .loop 
	
	; si termine y es indice ordenado
	mov rax, 1
	jmp .fin

	.estan_desordenados:
	; rax ya es 0, no tengo q hacer nada

	.fin:
	; epilogo
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
	; rdi = item_t**  inventario
	; rsi = uint16_t* indice
	; dx = uint16_t  tamanio

	; prologo
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14	; PILA ALINEADA	

	; preservo en no volatiles
	xor rbx, rbx
	mov bx, dx		; rbx = tamanio
	mov r12, rdi	; r12 = *inventario
	mov r13, rsi	; r13 = *indice

	; reservo memoria para inventario_reordenado
	mov rdi, rbx	
	sal rdi, 3		; rdi = tamaño*sizeof(*item_t)
	call malloc
	mov r14, rax	; r14 = *inventario_reordenado

	dec rbx 		; rbx = i = (tamanio-1)
	.loop:
		; busco el item actual
		xor r8, r8
		mov r8w, word [r13 + rbx*2]			; r8 = indice_item_actual = indice[i];
		mov r9, qword [r12 + r8*8]			; r9 = item_actual = inventario[indice_item_actual];

		mov qword [r14 + rbx*8], r9			; inventario_reordenado[i] = item_actual

		;siguiente_iteracion:
		dec rbx
		cmp rbx, -1		; Pues quiero entrar al while cuando i = 0
		jg .loop 

	mov rax, r14
	; epilogo
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp

	ret
