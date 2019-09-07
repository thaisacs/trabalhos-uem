#ifndef CACHE_H
#define CACHE_H

struct cacheLine{
  char tag[18];
  char bloco[129];
};
typedef struct cacheLine cache;

cache *li; //cache de instrução
cache *ld; //cache de dados

void read_cache();
void write_cache();

#endif
