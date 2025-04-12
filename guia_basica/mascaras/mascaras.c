# include <stdio.h>
# include <stdint.h>
# include <stdbool.h>

bool comp(uint32_t a, uint32_t b);

int main() {
    uint32_t a = 0xA0000000;
    uint32_t b = 0x5;

    bool res = comp(a, b);
    res ? printf("Los bits son iguales\n") : printf("Los bits no son iguales\n");

    return 0;
}

bool comp(uint32_t a, uint32_t b) {
    a >>= 29;   // Muevo los 3 bits mas significativos de a los 3 menos significativos
    b &= 0x7;   // Me quedo solo con los 3 bits menos significativos de b
    return (a & b); // Compara bit a bit (solo los 3 menos significativos pueden ser != 0)
}
