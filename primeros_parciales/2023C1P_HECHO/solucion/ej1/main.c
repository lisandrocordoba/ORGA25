#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>

#include "ej1.h"

int main (void){
	/* Acá pueden realizar sus propias pruebas */
	templo* arrayTemplos = malloc(5*sizeof(templo));
	for(int i = 0; i < 5; i++){
		if(i%2 == 0){
			arrayTemplos[i].colum_largo = 5;
			arrayTemplos[i].colum_corto = 2;
		}
		else{
			arrayTemplos[i].colum_largo = 6;
			arrayTemplos[i].colum_corto = 3;
		}
	}
	uint32_t cant_clasicos = cuantosTemplosClasicos(arrayTemplos, 5);
	//templo* arrayTemplosClasicos = templosClasicos(arrayTemplos, 5)
	//printf("%d\n", cant_clasicos);
	return 0;    
}


