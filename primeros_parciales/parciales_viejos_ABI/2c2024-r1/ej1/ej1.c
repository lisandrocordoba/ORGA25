#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ej1.h"

/**
 * Marca el ejercicio 1A como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - es_indice_ordenado
 */
bool EJERCICIO_1A_HECHO = true;

/**
 * Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - contarCombustibleAsignado
 */
bool EJERCICIO_1B_HECHO = true;

/**
 * Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - modificarUnidad
 */
bool EJERCICIO_1C_HECHO = true;

/**
 * OPCIONAL: implementar en C
 */
void optimizar(mapa_t mapa, attackunit_t* compartida, uint32_t (*fun_hash)(attackunit_t*)) {
    uint32_t hash_compartida = fun_hash(compartida);
    uint32_t hash_actual;
    attackunit_t* unidad_actual = NULL;

    // Recorro todo el mapa con 1 solo indice y de der a izq para que sea mas facil llevarlo a asm
    for(int i = 255*255 - 1; i >= 0; i--){
        unidad_actual = ((attackunit_t **)mapa)[i];
        if(unidad_actual != NULL){
            hash_actual = fun_hash(unidad_actual);
            // Si tengo que reemplazar la actual por la compartida hay que:
            if(hash_actual == hash_compartida){
                // Que el casillero del mapa apunte a la compartida
                ((attackunit_t **)mapa)[i] = compartida;
                // Actualizar las referencias
                compartida->references++;
                unidad_actual->references--;
                // Si la que estaba en el mapa no tiene mas referencias, hay que liberarla (notar que si tiene mas referencias, en algun momento del for va a llegar a 0)
                if(unidad_actual->references == 0) free(unidad_actual);
            } 
        }
    }
}


/**
 * OPCIONAL: implementar en C
 */
uint32_t contarCombustibleAsignado(mapa_t mapa, uint16_t (*fun_combustible)(char*)) {
    uint32_t combustible_inicial_total = 0, combustible_actual_total = 0;
    uint16_t combustible_inicial_unidad = 0;
    char* clase_unidad = NULL;
    attackunit_t* unidad = NULL;

    // Recorro todo el mapa con 1 solo indice y de der a izq para que sea mas facil llevarlo a asm
    for(int i = 255*255 - 1; i >= 0; i--){
        unidad = ((attackunit_t **)mapa)[i];
        if(unidad != NULL){
            clase_unidad = unidad->clase;
            combustible_inicial_unidad = fun_combustible(clase_unidad);
            combustible_inicial_total += combustible_inicial_unidad;

            combustible_actual_total += unidad->combustible;
        }        
    }
    uint32_t combustible_asignado = combustible_actual_total - combustible_inicial_total;
    return combustible_asignado;
}

/**
 * OPCIONAL: implementar en C
 */
void modificarUnidad(mapa_t mapa, uint8_t x, uint8_t y, void (*fun_modificar)(attackunit_t*)) {
    // Accedo asi a la unidad para que sea mas facil de llevar a asm
    attackunit_t* unidad = ((attackunit_t **)mapa)[x*255 + y];
    if(unidad != NULL){
        if(unidad->references > 1){
            // Creo otra unidad igual para no modificar la compartida
            attackunit_t* unidad_modificada = malloc(sizeof(attackunit_t));
            strcpy(unidad_modificada->clase, unidad->clase);
            unidad_modificada->combustible = unidad->combustible;

            // Modifico las referencias
            unidad->references--;
            unidad_modificada->references = 1;

            unidad = unidad_modificada;
        }
        // Modifico la unidad (aqui si o si tiene referencias = 1) y la guardo en el mapa
        fun_modificar(unidad);
        ((attackunit_t **)mapa)[x*255 + y] = unidad;
    }
}
