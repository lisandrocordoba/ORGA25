#ifndef LIST_H 
#define LIST_H 

# include "type.h"

typedef struct node {
    void* data;
    struct node* prev;
    struct node* next;
} node_t;

typedef struct list {
    type_t type;
    uint8_t size;
    node_t* first;
    node_t* last;
} list_t;

list_t* listNew(type_t t);
void listAddFirst(list_t* l, void* data); //copia el dato
void listAddLast(list_t* l, void* data); //copia el dato
void* listGet(list_t* l, uint8_t i); //se asume: i < l->size
void* listRemove(list_t* l, uint8_t i); //se asume: i < l->size
void listDelete(list_t* l);
void exchangeOrder(list_t* l, uint8_t i, uint8_t j);

#endif