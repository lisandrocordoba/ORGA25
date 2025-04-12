# include <stdio.h>
# include <stdint.h>


int main() {
    uint16_t a = 5, b = 3, c = 2, d = 1;
    printf("a + b * c / d = %d\n", a + b * c / d);
    printf("a %% b = %d\n", a % b);
    printf("a & b = %d\n", a & b);
    printf("a | b = %d\n", a | b);
    printf("~a = %x\n", ~a);
    printf("a && b = %d\n", a && b);
    printf("a || b = %d\n", a || b);
    printf("a >> 1 = %d\n", a >> 1);
    printf("a << 1 = %d\n", a << 1);
    return 0;
}