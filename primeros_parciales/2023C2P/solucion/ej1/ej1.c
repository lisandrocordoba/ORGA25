#include "ej1.h"

list_t* listNew(){
  list_t* l = (list_t*) malloc(sizeof(list_t));
  l->first=NULL;
  l->last=NULL;
  return l;
}

void listAddLast(list_t* pList, pago_t* data){
    listElem_t* new_elem= (listElem_t*) malloc(sizeof(listElem_t));
    new_elem->data=data;
    new_elem->next=NULL;
    new_elem->prev=NULL;
    if(pList->first==NULL){
        pList->first=new_elem;
        pList->last=new_elem;
    } else {
        pList->last->next=new_elem;
        new_elem->prev=pList->last;
        pList->last=new_elem;
    }
}


void listDelete(list_t* pList){
    listElem_t* actual= (pList->first);
    listElem_t* next;
    while(actual != NULL){
        next=actual->next;
        free(actual);
        actual=next;
    }
    free(pList);
}

uint8_t contar_pagos_aprobados(list_t* pList, char* usuario){
    uint8_t total_aprobados = 0;
    char* nombre_cobrador = NULL;
    uint8_t son_iguales = 0;
    listElem_t* nodo_actual = pList->first;
    pago_t* pago_actual = NULL;

    while(nodo_actual != NULL){
        pago_actual = nodo_actual->data;
        if(pago_actual->aprobado != 0){
            nombre_cobrador = pago_actual->cobrador;
            son_iguales = strcmp(usuario, nombre_cobrador);
            if(son_iguales == 0){
                total_aprobados++;
            }
        }
        nodo_actual = nodo_actual->next;
    }
    return total_aprobados;
}

uint8_t contar_pagos_rechazados(list_t* pList, char* usuario){
    uint8_t total_rechazados = 0;
    listElem_t* nodo_actual = pList->first;
    pago_t* pago_actual = NULL;
    char* nombre_cobrador = NULL;
    uint8_t son_iguales = 0;

    while(nodo_actual != NULL){
        pago_actual = nodo_actual->data;
        if(pago_actual->aprobado == 0){
            nombre_cobrador = pago_actual->cobrador;
            son_iguales = strcmp(usuario, nombre_cobrador);
            if(son_iguales == 0){
                total_rechazados++;
            }
        }
        nodo_actual = nodo_actual->next;
    }
    return total_rechazados;    
}

pagoSplitted_t* split_pagos_usuario(list_t* pList, char* usuario){
    // Inicializo el pagoSplitted
    pagoSplitted_t* pagos_usuario = malloc(sizeof(pagoSplitted_t));

    // Seteo los campos de aprobados (cantidad y array)
    uint8_t cant_aprobados = contar_pagos_aprobados(pList, usuario);
    pagos_usuario->cant_aprobados = cant_aprobados;
    pago_t** aprobados_usuario = malloc(sizeof(pago_t*)*cant_aprobados);
    pagos_usuario->aprobados = aprobados_usuario;

    // Seteo los campos de rechazados (cantidad y array)
    uint8_t cant_rechazados = contar_pagos_rechazados(pList, usuario);
    pagos_usuario->cant_rechazados = cant_rechazados;
    pago_t** rechazados_usuario = malloc(sizeof(pago_t*)*cant_rechazados);
    pagos_usuario->rechazados = rechazados_usuario;

    // Recorro los pagos para guardar los q correspondan
    listElem_t* nodo_actual = pList->first;
    pago_t* pago_actual = NULL;
    char* nombre_cobrador = NULL;
    uint8_t son_iguales = 0;

    uint8_t aprobados_guardados = 0;
    uint8_t rechazados_guardados = 0;

    while(nodo_actual != NULL){
        pago_actual = nodo_actual->data;

        nombre_cobrador = pago_actual->cobrador;
        son_iguales = strcmp(usuario, nombre_cobrador);
        // Si el pago lo cobró usuario, me interesa
        if(son_iguales == 0){
            // Si es aprobado, lo guardo en aprobados_usuario
            if(pago_actual->aprobado != 0){
                pagos_usuario->aprobados[aprobados_guardados] = pago_actual;
                aprobados_guardados++;
            }
            // Si es rechazado, lo guardo en rechazados_usuario
            else{
                pagos_usuario->rechazados[rechazados_guardados] = pago_actual;
                rechazados_guardados++;
            }
        }
        nodo_actual = nodo_actual->next;
    }
    return pagos_usuario;
}