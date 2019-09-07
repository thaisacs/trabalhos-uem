#include "system_bus.h"
#include "stdio.h"

void set_bus_cpu_cache(char data[]){
  int i;
  for(i = 0; i < 33; i++){
    cpu_cache.dataBus[i] = data[i];
  }
  cpu_cache.dataBus[33] = '\0';
}

void set_bus_cache_mem(char data[]){
  int i;
  for(i = 0; i < 33; i++){
    cache_mem.dataBus[i] = data[i];
  }
  cache_mem.dataBus[33] = '\0';
}

void get_bus_cpu_cache(char data[]){
  int i;
  for(i = 0; i < 33; i++){
    data[i] = cpu_cache.dataBus[i];
  }
  data[33] = '\0';
}

void get_bus_cache_mem(char data[]){
  int i;
  for(i = 0; i < 33; i++){
    data[i] = cache_mem.dataBus[i];
  }
  data[33] = '\0';
}
