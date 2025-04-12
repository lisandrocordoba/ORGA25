#include <stdio.h>
#include <stdint.h>

# define N 3

typedef struct {
    char* name;
    uint32_t life;
    uint64_t attack;
    uint64_t defense;
} monster_t;
 
monster_t evolution(monster_t monster);

int main() {
    monster_t monsters[N] = {
        {"Abril", 10, 20, 300000},
        {"Lichu", 15, 15, 15},
        {"Chula", 40, 35, 28}
    };

    // Printear nombres, vida
    for(int i = 0; i < N; i++){
        printf("%s, %d\n", monsters[i].name, monsters[i].life);
    }

    // Aumentarle 10 a la vida y el ataque de abril, dps printear
    printf("Original:%s, %ld, %ld\n", monsters[1].name, monsters[1].attack, monsters[1].defense);
    monsters[1] = evolution(monsters[1]);
    printf("Evolutioned:%s, %ld, %ld\n", monsters[1].name, monsters[1].attack, monsters[1].defense);

    
    return 0;
}

monster_t evolution(monster_t monster){
    monster_t evolutioned_monster = monster;
    evolutioned_monster.attack += 10;
    evolutioned_monster.defense += 10;
    return evolutioned_monster;
}
