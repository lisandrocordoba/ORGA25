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
bool EJERCICIO_1A_HECHO = false;

/**
 * Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - indice_a_inventario
 */
bool EJERCICIO_1B_HECHO = false;

/**
 * OPCIONAL: implementar en C
 */
bool es_indice_ordenado(item_t** inventario, uint16_t* indice, uint16_t tamanio, comparador_t comparador) {
	uint16_t indice_item_actual, indice_item_anterior;
	item_t *item_actual,*item_anterior = NULL;
	bool ordenado = false;

	for(int i = (tamanio-1); i > 0; i--){
		indice_item_actual = indice[i];
		item_actual = inventario[indice_item_actual];

		indice_item_anterior = indice[i-1];
		item_anterior = inventario[indice_item_anterior];

		ordenado = comparador(item_anterior, item_actual);
		if (ordenado == false) return false;		
	}
	return true;
}

/**
 * OPCIONAL: implementar en C
 */
item_t** indice_a_inventario(item_t** inventario, uint16_t* indice, uint16_t tamanio) {
	// ¿Cuánta memoria hay que pedir para el resultado?
	item_t** resultado = malloc(tamanio*8);	// sizeof(item_t* = 8)
	for(int i = tamanio-1; i >= 0; i--){
		resultado[i] = inventario[indice[i]];
	}
	return resultado;
}
