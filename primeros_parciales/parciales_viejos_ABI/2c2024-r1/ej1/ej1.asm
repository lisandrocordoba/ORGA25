extern malloc
extern free
extern strcpy

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
;   - optimizar
global EJERCICIO_1A_HECHO
EJERCICIO_1A_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

; Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - contarCombustibleAsignado
global EJERCICIO_1B_HECHO
EJERCICIO_1B_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

; Marca el ejercicio 1C como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - modificarUnidad
global EJERCICIO_1C_HECHO
EJERCICIO_1C_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
ATTACKUNIT_CLASE EQU 0
ATTACKUNIT_COMBUSTIBLE EQU 12
ATTACKUNIT_REFERENCES EQU 14
ATTACKUNIT_SIZE EQU 16

UNIDADES_EN_MAPA EQU 65025

global optimizar
optimizar:
	; Te recomendamos llenar una tablita acá con cada parámetro y su
	; ubicación según la convención de llamada. Prestá atención a qué
	; valores son de 64 bits y qué valores son de 32 bits o 8 bits.
	;
	; rdi = mapa_t           mapa
	; rsi = attackunit_t*    compartida
	; rdx = uint32_t*        fun_hash(attackunit_t*)

	; prologo
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15
	sub rsp, 8			; PILA ALINEADA

	; Preservo los argumentos y los datos que necesito
	xor rbx, rbx
	mov rbx, UNIDADES_EN_MAPA
	dec rbx				; rbx = i = 255*255 - 1
	mov r12, rdi		; r12 = *mapa
	mov r13, rsi		; r13 = *compartida
	mov r14, rdx		; r14 = *fun_hash()
	
	mov rdi, r13
	call r14
	mov r15, rax		; r15 = hash_compartida

	.loop:
		; Si la unidad_actual es NULL, sigo el for
		mov r8, qword [r12 + rbx*8]	; r8 = unidad_actual = mapa)[i];
		cmp r8, 0
		je .siguiente_iteracion

		; Busco el hash de la unidad
		mov rdi, r8
		mov qword [rbp-8], r8		; preservo unidad_actual	
		call r14					; rax = fun_hash(unidad_actual)
		mov r8, qword [rbp-8]

		; Si no comparten hash, sigo el for
		cmp rax, r15
		jne .siguiente_iteracion

		; Si comparten hash:
		; En el mapa cambio la actual x la compartida
		mov qword [r12 + rbx*8], r13	; mapa)[i] = compartida

		; Actualizo las referencias
		inc byte [r13 + ATTACKUNIT_REFERENCES]
		dec byte [r8 + ATTACKUNIT_REFERENCES]

		; Si la actual se quedó sin referencias, la liberó
		cmp byte [r8 + ATTACKUNIT_REFERENCES], 0
		jg .siguiente_iteracion
		mov rdi, r8
		call free

		.siguiente_iteracion:
		dec rbx
		cmp rbx, -1		; Quiero llegar hasta mapa[0]
		jg .loop
	
	; epilogo
	add rsp, 8
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp

	ret

global contarCombustibleAsignado
contarCombustibleAsignado:
	; rdi = mapa_t           mapa
	; rsi = uint16_t*        fun_combustible(char*)

	; prologo
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15
	sub rsp, 8			; PILA ALINEADA

	; Preservo los argumentos y las cosas q necesito
	xor rbx, rbx
	mov rbx, UNIDADES_EN_MAPA
	dec rbx				; rbx = i = 255*255 - 1
	mov r12, rdi		; r12 = *mapa
	mov r13, rsi		; r13 = *fun_combustible()
	xor r14, r14		; r14 = combustible_inicial_total = 0
	xor r15, r15		; r15 = combustible_actual_total = 0

	.loop:
		; Si la unidad es NULL, sigo el for
		mov r8, qword [r12 + rbx*8]	; r8 = unidad = mapa)[i];
		cmp r8, 0
		je .siguiente_iteracion2

		; Guardo con cuanto combustible se inicializa la unidad actual
		mov rdi, r8
		add rdi, ATTACKUNIT_CLASE	; rdi = puntero a clase
		mov qword [rbp-8], r8		; preservo unidad
		call r13
		mov r8, qword [rbp-8]
		add r14, rax				; combustible_inicial_total += fun_combustible(clase_unidad)

		; Guardo cuanto combustible tiene actualmente
		add r15w, word [r8 + ATTACKUNIT_COMBUSTIBLE]	; combustible_actual_total += unidad->combustible;

		.siguiente_iteracion2:
		dec rbx
		cmp rbx, -1		; Quiero llegar hasta mapa[0]
		jg .loop

	; rax = combustible_actual_total - combustible_inicial_total;
	mov rax, r15
	sub rax, r14

	; epilogo
	add rsp, 8
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp

	ret

global modificarUnidad
modificarUnidad:
	; rdi = mapa_t           mapa
	; sil = uint8_t          x
	; dl  = uint8_t          y
	; rcx = void*            fun_modificar(attackunit_t*)

	; prologo
	push rbp
	mov rbp, rsp
	push rbx
	push r12
	push r13
	push r14
	push r15
	sub rsp, 8			; PILA ALINEADA

	; Preservo los argumentos y las cosas q necesito
	mov r12, rdi		; r12 = *mapa
	xor r13, r13
	mov r13b, sil		; r13 = x
	xor r14, r14
	mov r14b, dl		; r14 = y
	mov r15, rcx		; r15 = *fun_modificar()

	; Si la unidad es NULL, salgo
	imul r13, r13, 255	; r13 = x*255
	add r13, r14		; r13 = x*255 + y
	mov rbx, qword [r12 + r13*8]	; rbx = unidad = mapa[x][y]
	cmp rbx, 0
	je .fin

	; Si tiene 1 sola referencia, la modifico
	cmp byte [rbx + ATTACKUNIT_REFERENCES], 1
	je .modificar

	; Si tiene 2 ó mas, hay q crear una copia
	mov rdi, ATTACKUNIT_SIZE
	call malloc		; rax = *unidad_modificada

	; Copio la clase
	mov rdi, [rax + ATTACKUNIT_CLASE]
	mov rsi, [rbx + ATTACKUNIT_CLASE]
	mov [rbp-8], rax	; preservo unidad_modificada
	call strcpy
	mov rax, [rbp-8]

	; Copio el combustible
	mov r8w, [rbx + ATTACKUNIT_COMBUSTIBLE]
	mov [rax + ATTACKUNIT_COMBUSTIBLE], r8w	; unidad_modificada->combustible = unidad->combustible;

	; Modifico las referencias
	dec byte [rbx + ATTACKUNIT_REFERENCES]		; unidad->references--;
	mov byte [rax + ATTACKUNIT_REFERENCES], 1	; unidad_modificada->references = 1;
	
	mov rbx, rax	; unidad = unidad_modificada;

	.modificar:
	mov rdi, rbx
	call r15		; fun_modificar(unidad);
	mov qword [r12 + r13*8], rbx	; (mapa[x][y] = unidad;

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