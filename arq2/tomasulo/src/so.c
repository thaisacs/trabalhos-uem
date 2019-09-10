#include <stdio.h>
#include <stdlib.h>
#include "registers.h"
#include "so.h"
#include "tomasulo.h"
#include "fila.h"

int system_call(int op){
  int l;
  switch (op) {
    case 1:
      printf("%d\n", register_bank[$a0].value);
      break;
    case 5:
      scanf("%d", &l);
      register_bank[$v0].value = l;
      break;
    case 10:
      program_finaly = 1;
      break;
  }
  return 0;
}

int tomasulo_empty(){
  int i, control = 0;
  for(i = 1; i <= QTD_RS; i++){
    if(reservation_stations[i][BUSY] != 0){
      control = 1;
    }
  }
  return !control;
}

int exit_program(){
  if(program_finaly && tomasulo_empty()){
    return 1;
  }
  return 0;
}

void start(){
  fi = criaFila();
  PC = 0;
  bussCDB.controlBus = 0;
  program_finaly = 0;
  control_ls = 0;
  control_rs = 1;
  pause = 0;
  reservation_stations[0][BUSY] = 0;
  start_reservation_stations(reservation_stations);
  start_register_bank(register_bank);
  register_bank[$gp].value = 268468224;
  //register_bank[$gp].value = 536870912;
  register_bank[$sp].value = 2147483644;
  IR[0] = '\0';
  _clock();
}
