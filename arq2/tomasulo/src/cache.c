#include <stdio.h>
#include "memory.h"
#include "converters.h"
#include "cache.h"
#include <string.h>
#include "system_bus.h"

void read_cache(){
  cache *l;
  char addressBusC[33], linha[11], tag1[18], tag2[18], palavra[4], buffer1[129], buffer2[33], aux[33];
  int linhaC, i, palavraC, addressAux;
  long int tagC;

  to_convertDB(addressBusC, cpu_cache.addressBus, 32);
  addressBusC[32] = '\0';
  substring(addressBusC, tag1, 0, 16);
  substring(addressBusC, tag2, 0, 16);
  tag2[0] = '1';

  substring(addressBusC, linha, 17,27);
  substring(addressBusC, palavra, 28, 31);
  linhaC = to_convertBD(linha);
  tagC = to_convertBD(tag1);
  palavraC = to_convertBD(palavra);

  switch (cpu_cache.controlBus) {
    case CACHE_D:
      l = ld;
      break;
    case CACHE_I:
      l = li;
  }
  if(strcmp(l[linhaC].tag, tag1) && strcmp(l[linhaC].tag, tag2)){
    switch (cpu_cache.controlBus) {
      case CACHE_D:
        printf_data_instruction_miss(addressBusC);
        break;
      case CACHE_I:
        printf_cache_instruction_miss(addressBusC);
    }
    if(strcmp(l[linhaC].tag, "")){
      if(l[linhaC].tag[0] == '1'){
        memset(aux, '\0', 33);
        strcat(aux, l[linhaC].tag);
        strcat(aux, linha);
        strcat(aux, "0000");
        aux[0] = '0';
        addressAux = to_convertBD(aux);

        substring(l[linhaC].bloco, aux, 0, 31);
        set_bus_cache_mem(aux);
        cache_mem.controlBus = 1;
        cache_mem.addressBus = addressAux;
        store();

        substring(l[linhaC].bloco, aux, 32, 63);
        set_bus_cache_mem(aux);
        cache_mem.addressBus = addressAux;
        addressAux = addressAux + 4;
        cache_mem.addressBus = addressAux;
        store();

        substring(l[linhaC].bloco, aux, 64, 95);
        set_bus_cache_mem(aux);
        cache_mem.addressBus = addressAux;
        addressAux = addressAux + 4;
        cache_mem.addressBus = addressAux;
        store();

        substring(l[linhaC].bloco, aux, 96, 128);
        set_bus_cache_mem(aux);
        cache_mem.addressBus = addressAux;
        addressAux = addressAux + 4;
        cache_mem.addressBus = addressAux;
        store();
      }
    }

    addressBusC[28] = '0';
    addressBusC[29] = '0';
    addressBusC[30] = '0';
    addressBusC[31] = '0';
    buffer1[0] = '\0';
    cache_mem.controlBus = 1;
    cache_mem.addressBus = to_convertBD(addressBusC);
    load();
    memset(buffer2, '\0', 33);
    get_bus_cache_mem(buffer2);
    strcat(buffer1, buffer2);
    cache_mem.addressBus = cache_mem.addressBus + 4;
    load();
    memset(buffer2, '\0', 33);
    get_bus_cache_mem(buffer2);
    strcat(buffer1, buffer2);
    cache_mem.addressBus = cache_mem.addressBus + 4;
    load();
    memset(buffer2, '\0', 33);
    get_bus_cache_mem(buffer2);
    strcat(buffer1, buffer2);
    cache_mem.addressBus = cache_mem.addressBus + 4;
    load();
    memset(buffer2, '\0', 33);
    get_bus_cache_mem(buffer2);
    strcat(buffer1, buffer2);
    buffer1[129] = '\0';
    tag1[18] = '\0';
    for(i = 0; i < 129; i++){
      l[linhaC].bloco[i] = buffer1[i];
    }
    for(i = 0; i < 18; i++){
      l[linhaC].tag[i] = tag1[i];
    }
    cache_mem.controlBus = 0;
  }
  switch (palavraC) {
    case 0:
      substring(l[linhaC].bloco, buffer2, 0, 31);
      set_bus_cpu_cache(buffer2);
      break;
    case 4:
      substring(l[linhaC].bloco, buffer2, 32, 63);
      set_bus_cpu_cache(buffer2);
      break;
    case 8:
      substring(l[linhaC].bloco, buffer2, 64, 95);
      set_bus_cpu_cache(buffer2);
      break;
    case 12:
      substring(l[linhaC].bloco, buffer2, 96, 127);
      set_bus_cpu_cache(buffer2);
      break;
  }
}
void write_cache(){
  cache *l;
  char addressBusC[33], linha[11], tag1[18], tag2[18], palavra[4], buffer[33], aux[33];
  int linhaC, i, addressAux, palavraC;
  long int tagC;

  get_bus_cpu_cache(buffer);
  to_convertDB(addressBusC, cpu_cache.addressBus, 32);
  addressBusC[32] = '\0';
  substring(addressBusC, tag1, 0, 16);
  substring(addressBusC, tag2, 0, 16);
  tag2[0] = '1';

  substring(addressBusC, linha, 17,27);
  substring(addressBusC, palavra, 28, 31);
  linhaC = to_convertBD(linha);
  tagC = to_convertBD(tag1);
  palavraC = to_convertBD(palavra);
  switch (cpu_cache.controlBus) {
    case CACHE_D:
      l = ld;
      break;
    case CACHE_I:
      l = li;
  }
  if(strcmp(l[linhaC].tag, tag1) && strcmp(l[linhaC].tag, tag2)){
    read_cache();
  }
  switch (palavraC) {
    case 0:
      for(i = 0; i < 32; i++){
        l[linhaC].bloco[i] = buffer[i];
      }
      break;
    case 4:
      for(i = 32; i < 64; i++){
        l[linhaC].bloco[i] = buffer[i-32];
      }
      break;
    case 8:
      for(i = 64; i < 96; i++){
        l[linhaC].bloco[i] = buffer[i-64];
      }
      break;
    case 12:
      for(i = 96; i < 128; i++){
        l[linhaC].bloco[i] = buffer[i-96];
      }
      break;
  }
  l[linhaC].tag[0] = '1';
}

void printf_cache(){
  int i, j;
  for(i = 0; i < 10; i++){
    printf("linha %d\n", i);
    printf("  TAG %s\n", li[i].tag);
    printf("BLOCO %s\n\n", li[i].bloco);
  }
  for(i = 0; i < 10; i++){
    printf("linha %d\n", i);
    printf("  TAG %s\n", ld[i].tag);
    printf("BLOCO ");
    printf("%s\n\n", ld[i].bloco);
    printf("\n");
  }
}
