#include "ej1.h"

uint32_t* acumuladoPorCliente(uint8_t cantidadDePagos, pago_t* arr_pagos){
    uint32_t* monto_total_clientes = calloc(10, sizeof(uint32_t));
    pago_t* pago_actual;
    uint8_t cliente, monto;

    // Lo hago lo mas "asm" posible para facilitar la traduccion
    for(int i = cantidadDePagos-1; i >= 0; i--){
        pago_actual = (pago_t*)((uint64_t)arr_pagos + i*24);      
        // Si el pago es aprobado, lo sumo al cliente q corresponda
        if(pago_actual->aprobado != 0){
            cliente = pago_actual->cliente;
            monto = pago_actual->monto;
            monto_total_clientes[cliente] += monto; 
        }
    }
    return monto_total_clientes;
}

uint8_t en_blacklist(char* comercio, char** lista_comercios, uint8_t n){
    char* comercio_actual = NULL;
    uint8_t son_iguales;
    for(int i = n-1; i >= 0; i--){
        comercio_actual = lista_comercios[i];
        son_iguales = strcmp(comercio_actual, comercio);
        if(son_iguales == 0) return 1;
    }
    return 0;
}

pago_t** blacklistComercios(uint8_t cantidad_pagos, pago_t* arr_pagos, char** arr_comercios, uint8_t size_comercios){
    uint8_t cant_pagos_blacklist = 0;
    pago_t* pago_actual;
    char* comercio_actual;
    pago_t** pagos_blacklist = NULL;

    // Primero tengo que saber cuanto va a medir el array
    // calculo la cantidad de pagos de los comercios q esten en la blacklist
    for(int i = cantidad_pagos-1; i >= 0; i--){
        pago_actual = (pago_t*)((uint64_t)arr_pagos + i*24);
        comercio_actual = pago_actual->comercio;
        if(en_blacklist(comercio_actual, arr_comercios, size_comercios)){
            cant_pagos_blacklist++;
        }
    }
    pagos_blacklist = malloc(cant_pagos_blacklist*sizeof(pago_t*));

    // Vuelvo a iterar para guardar los pagos de los comercios en blacklist
    cant_pagos_blacklist--;
    for(int i = cantidad_pagos-1; i >= 0; i--){
        pago_actual = (pago_t*)((uint64_t)arr_pagos + i*24);
        comercio_actual = pago_actual->comercio;
        if(en_blacklist(comercio_actual, arr_comercios, size_comercios)){
            pagos_blacklist[cant_pagos_blacklist] = pago_actual;
            cant_pagos_blacklist--;
        }
    }
    return pagos_blacklist;
}


