#include "type.h"
#include <stdio.h>
#include <stdlib.h>


size_t size_fat32 = sizeof(fat32_t);
size_t size_ext4 = sizeof(ext4_t);
size_t size_ntfs = sizeof(ntfs_t);

fat32_t* new_fat32(){
    fat32_t* file = malloc(size_fat32); // CUANTO DEBERIA MEDIR UN ARCHIVO????
    for (size_t i = 0; i < size_fat32; i++) file[i] = 0x80;     // LLENO EL ARCHIVO DE 80 PQ SI
    return file;
}

ext4_t* new_ext4(){
    ext4_t* file = malloc(size_ext4); // CUANTO DEBERIA MEDIR UN ARCHIVO????
    for (size_t i = 0; i < size_ext4; i++) file[i] = 0x80;     // LLENO EL ARCHIVO DE 80 PQ SI
    return file;
}

ntfs_t* new_ntfs(){
    ntfs_t* file = malloc(size_ntfs); // CUANTO DEBERIA MEDIR UN ARCHIVO????
    for (size_t i = 0; i < size_ntfs; i++) file[i] = 0x80;     // LLENO EL ARCHIVO DE 80 PQ SI
    return file;
}

fat32_t* copy_fat32(fat32_t* file){
    fat32_t* new_file = new_fat32();
    for (size_t i = 0; i < size_ntfs; i++) new_file[i] = file[i]; 
    return new_file;
}

ext4_t* copy_ext4(ext4_t* file){
    ext4_t* new_file = new_fat32();
    for (size_t i = 0; i < size_ext4; i++) new_file[i] = file[i];   
    return new_file;
}

ntfs_t* copy_ntfs(ntfs_t* file){
    ntfs_t* new_file = new_ntfs();
    for (size_t i = 0; i < size_ntfs; i++) new_file[i] = file[i];  
    return new_file;
}

void rm_fat32(fat32_t* file){
    free(file);
}

void rm_ext4(ext4_t* file){
    free(file);
}

void rm_ntfs(ntfs_t* file){
    free(file);
}
