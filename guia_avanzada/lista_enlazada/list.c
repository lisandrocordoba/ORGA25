#include "list.h"
#include <stdio.h>
#include <stdlib.h>

list_t* listNew(type_t t) {
    list_t* l = malloc(sizeof(list_t));
    l->type = t; // l->type es equivalente a (*l).type
    l->size = 0;
    l->first = NULL;
    l->last = NULL;
    return l;
}

void listAddFirst(list_t* l, void* data) {
    node_t* n = malloc(sizeof(node_t));
    switch(l->type) {
        case TypeFAT32:
            n->data = (void*) copy_fat32((fat32_t*) data);
            break;
        case TypeEXT4:
            n->data = (void*) copy_ext4((ext4_t*) data);
            break;
        case TypeNTFS:
            n->data = (void*) copy_ntfs((ntfs_t*) data);
            break;
    }
    n->prev = NULL;
    n->next = l->first;
    l->first = n;
    if(l->size == 0) l->last = n;   // Si la l era vacia, n es first y last
    l->size++;
}

//se asume: i < l->size
void* listGet(list_t* l, uint8_t i){
    node_t* n = l->first;
    for(uint8_t j = 0; j < i; j++)
        n = n->next;
    return n->data;
}

//se asume: i < l->size
void* listRemove(list_t* l, uint8_t i){
    node_t* tmp = NULL;
    void* data = NULL;
    if(i == 0){
        node_t* new_first = l->first->next;
        data = l->first->data;
        tmp = l->first;
        l->first = new_first;
        new_first->prev = NULL;
    }else if (i == l->size - 1){ 
        node_t* new_last = l->last->prev;
        data = l->last->data;
        tmp = l->last;
        l->last = new_last;
        new_last->next = NULL;
    }else{
        node_t* n = l->first;
        for(uint8_t j = 0; j < i - 1; j++)
            n = n->next;
        data = n->next->data;
        tmp = n->next;
        n->next = n->next->next;
        if(l->size > 2) n->next->prev = n;  // El if es para evitar NULL->prev
    }
    free(tmp);
    l->size--;
    return data;
}

void listDelete(list_t* l){
    node_t* n = l->first;
    while(n){
        node_t* tmp = n;
        n = n->next;
        switch(l->type) {
            case TypeFAT32:
                rm_fat32((fat32_t*) tmp->data);
                break;
            case TypeEXT4:
                rm_ext4((ext4_t*) tmp->data);
                break;
            case TypeNTFS:
                rm_ntfs((ntfs_t*) tmp->data);
                break;
        }
        free(tmp);
    }
    free(l);
}

// Asumo i,j < l.size
void exchangeOrder(list_t* l, uint8_t i, uint8_t j){
    if(l->size <= 1) return;

    node_t* n_i = NULL;
    node_t* n_j = NULL;
    node_t* n = l->first;

    for (uint16_t k = 0; k < l->size; k++){
        if(k == i) n_i = n;
        if(k == j) n_j = n;
        if(k > i && k > j) break;    // Salgo del for pues ya agarre tanto el i-esimo nodo como el j-esimo

        n = n->next;
        k++;
    }

    // Ya tengo ambos nodos, intercambio los archivos apuntados x cada uno
    void* tmp = n_i->data;
    n_i->data = n_j->data;
    n_j->data = tmp;
}

void listAddLast(list_t* l, void* data){
    node_t* n = malloc(sizeof(node_t));
    switch(l->type) {
        case TypeFAT32:
            n->data = (void*) copy_fat32((fat32_t*) data);
            break;
        case TypeEXT4:
            n->data = (void*) copy_ext4((ext4_t*) data);
            break;
        case TypeNTFS:
            n->data = (void*) copy_ntfs((ntfs_t*) data);
            break;
    }
    n->next = NULL;
    n->prev = l->last;
    l->last = n;
    if(l->size == 0) l->first = n;   // Si la l era vacia, n es first y last
    l->size++;
}