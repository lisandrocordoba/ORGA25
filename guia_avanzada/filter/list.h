#ifndef LIST_H
#define LIST_H

#include <stdint.h>

typedef struct nodo_s {
    struct nodo_s* siguiente;
    int valor;
} nodo_t;

typedef struct lista_s {
    nodo_t* cabeza;
} lista_t;

lista_t* crear_lista_vacia();
nodo_t* crear_nuevo_nodo(int valor);
void insertar_al_final(lista_t* lista, int valor);
int eliminar_cabeza(lista_t* lista);
void eliminar_lista(lista_t* lista);
void map(lista_t* l, int (*operacion)(int));
void filter(lista_t* l, int (*criterio)(int));
void borrar_nodo(lista_t* l, uint16_t i);
void print_lista(lista_t* l);


#endif