# include <stdio.h>
# include <stdlib.h>
# include <string.h>
# include "malloc.h"


int main(){
    char* name = "Lisandro";
    person_t* lisandro = createPerson(name, 21);

    printf("%s, %d\n", lisandro->name, lisandro->age);

    deletePerson(lisandro);
}

person_t* createPerson(char* name, uint16_t age){
    person_t* person_new = malloc(sizeof(person_t));
    if (person_new == NULL) return NULL;

    person_new->name = malloc(strlen(name));
    if (person_new->name == NULL) {
        free(person_new);
        return NULL;
    }

    strcpy(person_new->name, name);
    person_new->age = age;

    return person_new;
}

void deletePerson(person_t* person){
    free(person->name);
    free(person);
}
