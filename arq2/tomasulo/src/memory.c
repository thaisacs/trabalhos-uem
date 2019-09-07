#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include </usr/include/sys/types.h>
#include </usr/include/sys/mman.h>
#include </usr/include/sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include "converters.h"
#include "colors.h"
#include "memory.h"
#include "system_bus.h"
#include "utils.h"

void load(){
  int i, j;
  byte t;
  int address = cache_mem.addressBus;
  char dataBus[33];
  char b1[9], b2[9], b3[9], b4[9];
  memset(b1, '\0', 9);
  memset(b2, '\0', 9);
  memset(b3, '\0', 9);
  memset(b4, '\0', 9);
  for(i = 0; i < 4; i++){
    t = memory[address];
    for(j=0; j < strlen(t.bits); j++){
      if(i == 0){
        b1[j] = t.bits[j];
      }else if(i == 1){
        b2[j] = t.bits[j];
      }else if(i == 2){
        b3[j] = t.bits[j];
      }else{
        b4[j] = t.bits[j];
      }
    }
    address++;
  }
  b1[8] = '\0';
  b2[8] = '\0';
  b3[8] = '\0';
  b4[8] = '\0';
  memset(dataBus, '\0', 33);
  strcat(dataBus, b4);
  strcat(dataBus, b3);
  strcat(dataBus, b2);
  strcat(dataBus, b1);
  set_bus_cache_mem(dataBus);
}

void store(){
  byte t;
  memset(&t, '\0', sizeof(t));
  char b1[9], b2[9], b3[9], b4[9];
  int address = cache_mem.addressBus;
  substring(cache_mem.dataBus, b1, 0, 7);
  substring(cache_mem.dataBus, b2, 8, 15);
  substring(cache_mem.dataBus, b3, 16, 23);
  substring(cache_mem.dataBus, b4, 24, 31);
  strcpy(t.bits, b4);
  memory[address] = t;
  address++;
  strcpy(t.bits, b3);
  memory[address] = t;
  address++;
  strcpy(t.bits, b2);
  memory[address] = t;
  address++;
  strcpy(t.bits, b1);
  memory[address] = t;
}
