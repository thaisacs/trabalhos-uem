#ifndef SYSTEM_BUS_H
#define SYSTEM_BUS_H

#define CACHE_D 1
#define CACHE_I 2

struct busSystem {
  int controlBus;
  int addressBus;
  char dataBus[33];
} typedef busSystem;

busSystem cpu_cache;
busSystem cache_mem;

void set_bus_cpu_cache(char data[]);
void set_bus_cache_mem(char data[]);
void get_bus_cpu_cache(char data[]);
void get_bus_cache_mem(char data[]);
#endif
