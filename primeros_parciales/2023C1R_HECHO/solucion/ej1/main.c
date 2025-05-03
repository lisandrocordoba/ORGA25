#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>

#include "ej1.h"

int main (void){

    // LISTA PAGOS
    pago_t* arrayPagos = malloc(5*sizeof(pago_t));
    for(int i = 0; i < 5; i++){
        if(i%2 == 0){
            arrayPagos[i].monto = 2;
            arrayPagos[i].comercio = "par";
            arrayPagos[i].cliente = 0;
            arrayPagos[i].aprobado = 1;
        }
        else{
            arrayPagos[i].monto = 3;
            arrayPagos[i].comercio = "impar";
            arrayPagos[i].cliente = 1;
            arrayPagos[i].aprobado = 1;
        }
    }
    // EJ A)
    uint32_t* array_clientes = acumuladoPorCliente(5, arrayPagos);

    // LISTA COMERCIOS
    char **lista_comercios = malloc(3 * sizeof(char*));
    lista_comercios[0] = "coto";
    lista_comercios[1] = "dia";
    lista_comercios[2] = "vea";
    
    // LISTA COMERCIOS BLACKLIST
    char **comercios_blacklist = malloc(2 * sizeof(char*));
    comercios_blacklist[0] = "coto";
    comercios_blacklist[1] = "dia"; 
      
    // EJ B)
    pago_t** pagos_blacklist = blacklistComercios_asm(5, arrayPagos, comercios_blacklist, 2);

    
    //printf("%d debe ser 0\n", en_blacklist_asm("vea", comercios_blacklist, 2));
    free(arrayPagos);
    free(array_clientes);
    free(lista_comercios);
    free(comercios_blacklist);
    free(pagos_blacklist);
}


