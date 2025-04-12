# include <stdio.h>

int main() {
    int mensaje_secreto[] = {116, 104, 101, 32, 103, 105, 102, 116, 32, 111,
    102, 32, 119, 111, 114, 100, 115, 32, 105, 115, 32, 116, 104, 101, 32,
    103, 105, 102, 116, 32, 111, 102, 32, 100, 101, 99, 101, 112, 116, 105,
    111, 110, 32, 97, 110, 100, 32, 105, 108, 108, 117, 115, 105, 111, 110};

    float f = 0.1;
    double d = 0.1;

    size_t length = sizeof(mensaje_secreto) / sizeof(int);
    
    char decoded[length];
    for (int i = 0; i < length; i++) {
        decoded[i] = (char) (mensaje_secreto[i]); // casting de int a char
    }
    
    for (int i = 0; i < length; i++) {
        printf("%c", decoded[i]);
    }
    printf("\n");


    printf("f: %f\n", f);
    printf("d: %lf\n", d);

    printf("f casteado: %d\n", (int) f);
    printf("d casteado: %d\n", (int) d);
}
