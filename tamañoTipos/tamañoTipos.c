# include <stdio.h>
# include <stdint.h>


int main() {

    int8_t ocho = -50;
    uint8_t Uocho = 50;
    int64_t sesentaycuatro = -600000;
    uint64_t Usesentaycuatro = 600000;
    printf("int8(%lu): %d \n", sizeof(ocho),ocho);
    printf("uint8(%lu): %d \n", sizeof(Uocho),Uocho);
    printf("int64(%lu): %ld \n", sizeof(sesentaycuatro),sesentaycuatro);
    printf("uint64(%lu): %ld \n", sizeof(Usesentaycuatro),Usesentaycuatro);

    return 0;
}