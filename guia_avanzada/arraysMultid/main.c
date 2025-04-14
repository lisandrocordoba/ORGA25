# include <stdio.h>

int main() {
    int matrix[3][4] = {
        {1, 2, 3, 4},
        {5, 6, 7, 8},
        {9, 10, 11, 12}
        };
    // p apunta al int en la fila 0, columna 0
    int *p = &matrix[0][0];

    // ¿que es reshape? 
    // Suposicion: reshape es un puntero a arrays de 2 elementos, por lo tanto es interpretar la matriz como reshape[6][2]
    //             es decir, tiene los mismos 12 elementos pero se interpretar como 6 filas de 2 elementos
    int (*reshape)[2] = (int (*)[2]) p;


    printf("%d\n", p[3]); // Qu´e imprime esta l´ınea?
    // Suposicion: p es puntero a int, por lo que p[3] = 4° elem en memoria = 4
    // Rta: BIEN

    printf("%d\n", reshape[1][1]); // Qu´e imprime esta l´ınea?
    // Suposicion: reshape los tiene agrupados como filas de 2 elementos,
    //              por lo que reshape[1][1] = 2° elem de la 2° fila = 4° elem en memoria = 4
    // Rta: BIEN

    return 0;
}