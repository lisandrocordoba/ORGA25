#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include "list.h"

lista_t* crear_lista_vacia() {
    lista_t* lista_vacia = malloc(sizeof(lista_t));
    lista_vacia->cabeza = NULL; // El operador x->y es equivalente a (*x).y
    return lista_vacia;
}

nodo_t* crear_nuevo_nodo(int valor) {
    nodo_t* nuevo_nodo = malloc(sizeof(nodo_t));
    nuevo_nodo->siguiente = NULL;
    nuevo_nodo->valor = valor;
    return nuevo_nodo;
}

void insertar_al_final(lista_t* lista, int valor) {
    nodo_t* actual = lista->cabeza;
    nodo_t* a_insertar = crear_nuevo_nodo(valor);

    // Caso lista vacia.
    if (actual == NULL) {
        lista->cabeza = a_insertar;
        return;
    }

    while (actual->siguiente != NULL)
        actual = actual->siguiente;

    actual->siguiente = a_insertar;
}

int eliminar_cabeza(lista_t* lista) {
    nodo_t* actual = lista->cabeza;
    if (actual == NULL)
        return -1;
    lista->cabeza = actual->siguiente;
    free(actual);
    return 0;
}

void eliminar_lista(lista_t* lista) {
    nodo_t* actual = lista->cabeza;
    while (actual != NULL) {
        nodo_t* siguiente = actual->siguiente;
        free(actual);
        actual = siguiente;
    }
    free(lista);
}

void borrar_nodo(lista_t* l, uint16_t i){
    nodo_t* tmp = NULL;
    if(i == 0){
        nodo_t* new_first = l->cabeza->siguiente;
        tmp = l->cabeza;
        l->cabeza = new_first;
    }else{
        nodo_t* n = l->cabeza;
        for(uint8_t j = 0; j < i - 1; j++)
            n = n->siguiente;
        tmp = n->siguiente;
        n->siguiente = n->siguiente->siguiente;
    }
    free(tmp);
}

void map(lista_t* l, int (*operacion)(int)) {
    nodo_t* actual = l->cabeza;
    while (actual != NULL) {
        actual->valor = operacion(actual->valor);
        actual = actual->siguiente;
    }
}

void filter(lista_t* l, int (*criterio)(int)){
    uint16_t indice_actual = 0;
    nodo_t* actual = l->cabeza;
    while (actual != NULL) {
        if(criterio(actual->valor)){
            borrar_nodo(l, indice_actual);
        }
        actual = actual->siguiente;
        indice_actual++;
    }
}

void print_lista(lista_t* l){
    nodo_t* actual = l->cabeza;
    if (actual != NULL) printf("[%d, ", actual->valor);

    while(actual->siguiente != NULL){
        printf("%d, ", actual->valor);
        actual = actual->siguiente;
    }

    if (actual != NULL) printf("%d]", actual->valor);
}