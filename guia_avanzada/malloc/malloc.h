#ifndef MALLOC_H
#define MALLOC_H

#include <stdint.h>

typedef struct{
    char* name;
    uint16_t age;
} person_t;

person_t* createPerson(char* name, uint16_t age);
void deletePerson(person_t* person);


#endif