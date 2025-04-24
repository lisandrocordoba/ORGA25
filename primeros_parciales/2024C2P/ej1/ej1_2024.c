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
 *   - indice_a_inventario
 */
bool EJERCICIO_1B_HECHO = true;

/**
 * OPCIONAL: implementar en C
 */
bool es_indice_ordenado(item_t** inventario, uint16_t* indice, uint16_t tamanio, comparador_t comparador) {
	for(uint16_t i = 0; i < tamanio - 1; i++){
		uint16_t indice_actual_vista = indice[i];
		uint16_t indice_siguiente_vista = indice[i + 1];
		item_t* item_actual = inventario[indice_actual_vista];
		item_t* item_siguiente = inventario[indice_siguiente_vista];
		bool estan_ordenados = comparador(item_actual, item_siguiente);
		if (!estan_ordenados) return false;
	}

	return true;
}

/**
 * OPCIONAL: implementar en C
 */
item_t** indice_a_inventario(item_t** inventario, uint16_t* indice, uint16_t tamanio) {

	item_t** resultado = malloc(tamanio * 8);

	for(uint16_t i = 0; i < tamanio; i++){

		uint16_t indice_nuevo = indice[i];

		item_t* item_actual = inventario[indice_nuevo];

		resultado[i] = item_actual;

	}	
	return resultado;
}
