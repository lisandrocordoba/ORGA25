#include "list.h"
#include <stdio.h>

int es_par(int x);
int duplicar(int x);

int main() {
    lista_t* mi_lista = crear_lista_vacia();
    insertar_al_final(mi_lista, 1);
    insertar_al_final(mi_lista, 2);
    insertar_al_final(mi_lista, 3);
    insertar_al_final(mi_lista, 4);
    // En este momento mi_lista = [1,2,3,4]
    print_lista(mi_lista);

    filter(mi_lista, &es_par);
    // En este momento mi_lista = [2,4]
    print_lista(mi_lista);
    
    map(mi_lista, &duplicar);
    // En este momento mi_lista = [4,8]
    print_lista(mi_lista);
    
    eliminar_lista(mi_lista);
    return 0;
}

int es_par(int x) {
    if (x % 2 == 0)
    return 1;
    else
    return 0;
}

int duplicar(int x) {
return x*2;
}

