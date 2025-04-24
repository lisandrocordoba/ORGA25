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
bool EJERCICIO_1B_HECHO = false;

/**
 * OPCIONAL: implementar en C
 */
bool es_indice_ordenado(item_t** inventario, uint16_t* indice, uint16_t tamanio, comparador_t comparador) {
	uint16_t indice_item_actual = 0;
	uint16_t indice_item_anterior = 0;
	item_t* item_actual = NULL;
	item_t* item_anterior = NULL;
	bool items_ordenados = 0;

	// Hago la iteracion de derecha a izquieda pq es mas facil en asm con dec
	for(int i = tamanio - 1; i > 0; i--){
		// Desreferencio los indices de los items de inventario a comparar
		indice_item_actual = indice[i];
		indice_item_anterior = indice[i-1];

		// Desreferencio los items de inventario a comparar
		item_actual = inventario[indice_item_actual];
		item_anterior = inventario[indice_item_anterior];

		// Comparo los items con el comparador
		items_ordenados = comparador(item_anterior, item_actual);	// si !(anterior > actual) => desordenado => false
		if (items_ordenados == false) return false;
	}
	return true;
}

/**
 * OPCIONAL: implementar en C
 */
item_t** indice_a_inventario(item_t** inventario, uint16_t* indice, uint16_t tamanio) {
	return ;
}
