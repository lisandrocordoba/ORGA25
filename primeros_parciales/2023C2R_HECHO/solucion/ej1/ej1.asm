; /** defines bool y puntero **/
%define NULL 0
%define TRUE 1
%define FALSE 0


section .data

section .text
LIST_OFFSET_FIRST EQU 0
LIST_OFFSET_LAST EQU 8
LIST_SIZE EQU 16

NODE_OFFSET_NEXT EQU 0
NODE_OFFSET_PREVIOUS EQU 8
NODE_OFFSET_TYPE EQU 16
NODE_OFFSET_HASH EQU 24
NODE_SIZE EQU 32

global string_proc_list_create_asm
global string_proc_node_create_asm
global string_proc_list_add_node_asm
global string_proc_list_concat_asm

; FUNCIONES auxiliares que pueden llegar a necesitar:
extern malloc
extern free
extern str_concat

; string_proc_list* string_proc_list_create(void)
string_proc_list_create_asm:
    ; prologo
    push rbp
    mov rbp, rsp

    ; reservo memoria para la lista
    mov rdi, LIST_SIZE
    call malloc     ; rax = list = malloc(sizeof(string_proc_list));

    ; si falla el malloc return NULL
    cmp rax, 0
    je .fin         

    ; inicializo la lista en 0
    mov qword [rax + LIST_OFFSET_FIRST], 0
    mov qword [rax + LIST_OFFSET_LAST], 0

    .fin:
    ; epilogo
    pop rbp
    
    ret


; string_proc_node* string_proc_node_create(uint8_t type, char* hash)
; dil = type
; rsi = *hash
string_proc_node_create_asm:
    ; prologo
    push rbp
    mov rbp, rsp
    push r12
    push r13    ; PILA ALINEADA

    ; preservo argumentos
    mov r12b, dil       ; r12 = type
    mov r13, rsi        ; r13 = *hash

    ; reservo memoria para el nodo
    mov rdi, NODE_SIZE
    call malloc         ; rax = node = malloc(sizeof(string_proc_node));

    ; si falla el malloc return NULL
    cmp rax, 0
    je .fin2

    ; seteo los campos del nodo
    mov qword [rax + NODE_OFFSET_NEXT], 0
    mov qword [rax + NODE_OFFSET_PREVIOUS], 0
    mov byte [rax + NODE_OFFSET_TYPE], r12b
    mov qword [rax + NODE_OFFSET_HASH], r13

    .fin2:
    ; epilogo
    pop r13
    pop r12
    pop rbp
    
    ret

; void string_proc_list_add_node(string_proc_list* list, uint8_t type, char* hash)
; rdi = *list
; sil = type
; rdx = *hash
string_proc_list_add_node_asm:
    ; prologo
    push rbp
    mov rbp, rsp
    push r12
    push r13
    push r14
    push r15    ; PILA ALINEADA

    ; preservo argumentos
    mov r12, rdi        ; r12 = *list
    mov r13b, sil       ; r13b = type
    mov r14, rdx        ; r14 = *hash

    ; reservo memoria para el nodo
    mov dil, sil
    mov rsi, r14
    call string_proc_node_create_asm         ; rax = new_node = string_proc_node_create(type, hash);

    ; si falla el malloc return NULL
    cmp rax, 0
    je .fin3

    ; actualizo las referencias
    mov r8, qword [r12 + LIST_OFFSET_LAST]  ; r8 = last_node = list->last;
    
    ; Si la lista es vacia
    cmp r8, 0
    je .lista_vacia
    
    ; Si la lista no es vacia
    mov qword [r8 + NODE_OFFSET_NEXT], rax          ; last_node->next = new_node;
    jmp .actualizar_referencias
    
    .lista_vacia:
    mov qword [r12 + LIST_OFFSET_FIRST], rax        ; list->first = new_node;

    ; Esto hay q hacerlo en ambos casos
    .actualizar_referencias:
    mov qword [rax + NODE_OFFSET_PREVIOUS], r8      ; new_node->previous = last_node;
    mov qword [r12 + LIST_OFFSET_LAST], rax         ; list->last = new_node;

    .fin3:
    ; epilogo
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    
    ret


; char* string_proc_list_concat(string_proc_list* list, uint8_t type , char* hash)
; rdi = *list
; sil = type
; rdx = *hash
string_proc_list_concat_asm:
    ; prologo
    push rbp
    mov rbp, rsp
    push rbx;LIBRE
    push r12
    push r13
    push r14
    push r15 
    sub rsp, 8  ; PILA ALINEADA

    ; preservo argumentos y lo que necesito
    mov r12, [rdi + LIST_OFFSET_FIRST]  ; r12 = actual_node = list->first;
    mov r13b, sil                       ; r13b = type
    mov r14, rdx                        ; r14 = *hash

    ; Copio el hash en un nuevo puntero
    mov rdi, 1
    call malloc
    mov byte [rax], 0       ; rax = *hash_parcial = 0;
    mov rdi, rax            ; rdi = *hash_parcial = 0;
    mov rsi, r14            ; rsi = *hash
    mov r15, rdi            ; preservo *hash_parcial
    call str_concat         ; rax = hash_result = str_concat(hash_parcial, hash);
    mov rdi, r15            ; rdi = *hash_parcial
    mov r15, rax            ; r15 = hash_result
    call free               ; free(hash_parcial);

    .loop4:
        ; Si actual_node == NULL, terminé
        cmp r12, 0
        je .fin4

        ; Si (actual_type != type) sigo el while
        mov r8b, [r12 + NODE_OFFSET_TYPE]   ; r8b = actual_type = actual_node->type;
        cmp r8b, r13b
        jne .siguiente_iteracion4

        ; Si actual_type == type, concateno el hash
        mov rdi, r15                            ; rdi = hash_parcial = hash_result;
        mov rsi, qword [r12 + NODE_OFFSET_HASH] ; rsi = actual_hash = actual_node->hash;
        call str_concat                         ; rax = hash_result = str_concat(hash_parcial, actual_hash);
        ; Libero el hash que tenia hasta entonces y preservo el nuevo
        mov rdi, r15                            ; rdi = hash_parcial
        mov r15, rax                            ; r15 = hash_result
        call free

        .siguiente_iteracion4:
        mov r12, qword [r12 + NODE_OFFSET_NEXT] ; actual_node = actual_node->next;
        jmp .loop4

    .fin4:
    mov rax, r15
    ; epilogo
    add rsp, 8
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    
    ret
