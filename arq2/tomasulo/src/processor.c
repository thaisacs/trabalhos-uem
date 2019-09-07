#include <stdio.h>
#include <stdlib.h>
#include "converters.h"
#include "so.h"
#include <string.h>
#include "cache.h"
#include "fila.h"
#include "tomasulo.h"
#include "colors.h"
#include "registers.h"
#include "system_bus.h"
#include "options.h"
#include "processor.h"

unsigned int clock;

extern int functional_unit_1(int, int, int);
extern int functional_unit_2(int, int, int);
extern int functional_unit_3(int, int, int);
extern int functional_unit_4(int, int, int);
extern int functional_unit_5(int, int, int);

void somadorPC(int label, int op){
  switch (op) {
    case 0:
      PC = PC + 4;
      break;
    case 1:
      PC = label;
      break;
  }
}

void IF(){
  if(pause && tomasulo_empty()){
    switch (pause) {
      case PAUSE_SYSCALL:
        system_call(register_bank[$v0].value);
        pause = 0;
        break;
      case PAUSE_MOV:
        pause = 0;
        break;
    }
  }
  if(!program_finaly && !pause){
    cpu_cache.addressBus = PC;
    cpu_cache.controlBus = CACHE_I;
    read_cache();
    get_bus_cpu_cache(IR);
    if(option == OP_DETAILED){
      printf_if(IR, PC);
    }
    somadorPC(0,0);
  }
}

void ID(){
  unsigned int op, funct, i, rt, rs, rd;
  int imm, a, aux;
  type comp;
  char buffer[30];
  if(strlen(IR) > 0){
    if(option == OP_DETAILED){
      printf_id(IR);
    }
    memset(buffer, '\0', 30);
    substring(IR, buffer, 0, 5);
    op = to_convertBD(buffer);
    memset(buffer, '\0', 30);
    substring(IR, buffer, 26, 31);
    funct = to_convertBD(buffer);
    memset(buffer, '\0', 30);
    substring(IR, buffer, 6, 10);
    rs = to_convertBD(buffer);
    memset(buffer, '\0', 30);
    substring(IR, buffer, 11, 15);
    rt = to_convertBD(buffer);
    memset(buffer, '\0', 30);
    substring(IR, buffer, 16, 20);
    rd = to_convertBD(buffer);
    memset(buffer, '\0', 30);
    substring(IR, buffer, 16, 31);
    a = twos_complementsBD(buffer, 16);
    memset(buffer, '\0', 30);
    substring(IR, buffer, 6, 31);
    imm = to_convertBD(buffer);
    switch (op) {
      case 0:
        if(funct == 12){//syscall
          pause = PAUSE_SYSCALL;
        }else{
          comp.rd = rd;
          comp.rs = rs;
          comp.rt = rt;
          comp.address = 0;
          comp.imm = 0;
          switch (funct) {
            case 0:
              if(rd == 0){
                comp.op = NOP;
              }else{
                memset(buffer, '\0', 30);
                substring(IR, buffer, 21, 25);
                comp.rs = rt;
                comp.imm = to_convertBD(buffer);
                comp.op = SLL;
                comp.rt = 0;
              }
              break;
            case 2:
              memset(buffer, '\0', 30);
              substring(IR, buffer, 21, 25);
              comp.rs = rt;
              comp.imm = to_convertBD(buffer);
              comp.op = SRL;
              comp.rt = 0;
              break;
            case 3:
              memset(buffer, '\0', 30);
              substring(IR, buffer, 21, 25);
              comp.rs = rt;
              comp.imm = to_convertBD(buffer);
              comp.op = SRA;
              comp.rt = 0;
              break;
            case 4:
              comp.op = SLLV;
              break;
            case 6:
              comp.op = SRLV;
              break;
            case 7:
              comp.op = SRAV;
              break;
            case 8:
              pause = PAUSE_JUMP;
              comp.op = JR;
              break;
            case 9:
              pause = PAUSE_JUMP;
              comp.op = JALR;
              break;
            case 10:
              comp.op = MOVZ;
              pause = PAUSE_MOV;
              break;
            case 11:
              comp.op = MOVN;
              pause = PAUSE_MOV;
              break;
            case 16:
              comp.op = MFHI;
              comp.rs = HI;
              break;
            case 17:
              comp.op = MTHI;
              comp.rd = HI;
              break;
            case 18:
              comp.op = MFLO;
              comp.rs = LO;
              break;
            case 19:
              comp.op = MTLO;
              comp.rd = LO;
              break;
            case 24:
              comp.op = MULT;
              break;
            case 25:
              comp.op = MULTU;
              break;
            case 26:
              comp.op = DIV;
              break;
            case 27:
              comp.op = DIVU;
              break;
            case 32:
              comp.op = ADD;
              break;
            case 33:
              comp.op = ADDU;
              break;
            case 34:
              comp.op = SUB;
              break;
            case 35:
              comp.op = SUBU;
              break;
            case 36:
              comp.op = AND;
              break;
            case 37:
              comp.op = OR;
              break;
            case 38:
              comp.op = XOR;
              break;
            case 39:
              comp.op = NOR;
              break;
            case 42:
              comp.op = SLT;
              break;
            case 43:
              comp.op = SLTU;
              break;
          }
          insereFila(fi, comp);
          break;
        case 1:
          switch (rt) {
            case 0:
              comp.op = BLTZ;
              break;
            case 1:
              comp.op = BGEZ;
              break;
            case 16:
              comp.op = BLTZAL;
              break;
            case 17:
              comp.op = BGEZAL;
              break;
          }
          comp.rd = 0;
          comp.rs = rs;
          comp.rt = rt;
          comp.address = a;
          comp.imm = 0;
          insereFila(fi, comp);
          pause = PAUSE_BRANCH;
          break;
        case 2: //J
          somadorPC(imm, 1);
          break;
        case 3: //jal
          register_bank[$ra].value = PC;
          register_bank[$ra].qi = 0;
          somadorPC(imm, 1);
          break;
        case 4://beq
        case 5://bne
        case 6://blez
        case 7://bgtz
          switch (op) {
            case 4:
              comp.op = BEQ;
              break;
            case 5:
              comp.op = BNE;
              break;
            case 6:
              comp.op = BLEZ;
              break;
            case 7:
              comp.op = BGTZ;
              break;
          }
          comp.rd = 0;
          comp.rs = rs;
          comp.rt = rt;
          comp.address = a;
          comp.imm = 0;
          insereFila(fi, comp);
          pause = PAUSE_BRANCH;
          break;
        case 8:  //addi
        case 9: //addiu
        case 10://slti
        case 11://sltiu
        case 12://andi
        case 13://ori
        case 14://xori
        case 15: //lui
          if(op == 8){
            comp.op = ADDI;
          }else if(op == 9){
            comp.op = ADDIU;
          }else if(op == 10){
            comp.op = SLTI;
          }else if(op == 11){
            comp.op = SLTIU;
          }else if(op == 15){
            comp.op = LUI;
          }else if(op == 12){
            comp.op = ANDI;
          }else if(op == 13){
            comp.op = ORI;
          }else if(op == 14){
            comp.op = XORI;
          }
          comp.rd = rt;
          comp.rs = rs;
          comp.rt = 0;
          comp.address = 0;
          comp.imm = a;
          insereFila(fi, comp);
          break;
        case 28: //mul, clo, clz
          comp.rd = rd;
          comp.rs = rs;
          comp.rt = rt;
          comp.address = 0;
          comp.imm = 0;
          switch (funct) {
            case 2:
              comp.op = MUL;
              break;
            case 32:
              comp.op = CLZ;
              break;
            case 33:
              comp.op = CLO;
              break;
          }
          insereFila(fi, comp);
          break;
        case 35: //lw
        case 43: //sw
        case 34: //lwl
        case 38: //lwr
        case 42: //swl
        case 46: //swr
          if(op == 35){
            comp.op = LW;
          }else if(op == 43){
            comp.op = SW;
          }else if(op == 34){
            comp.op = LWL;
          }else if(op == 38){
            comp.op = LWR;
          }else if(op == 42){
            comp.op = SWL;
          }else if(op == 46){
            comp.op = SWR;
          }
          comp.rs = rs;
          comp.address = a;
          comp.imm = 0;
          comp.rt = rt;
          insereFila(fi, comp);
          break;
      }
    }
    IR[0] = '\0';
  }
}

void II(){
  int i;
  if(!filaVazia(fi)){
    type *aux = primeiroFila(fi);
    switch (aux->op) {
      case ADDIU:
      case ADDI:
      case ADD:
      case ADDU:
      case LUI:
      case SUB:
      case SUBU:
      case NOP:
      case AND:
      case ANDI:
      case OR:
      case ORI:
      case XOR:
      case XORI:
      case NOR:
      case SLT:
      case SLTU:
      case SLTI:
      case SLTIU:
      case MOVN:
      case MOVZ:
      case MFHI:
      case MFLO:
      case MTHI:
      case MTLO:
      case CLZ:
      case CLO:
        for(i = ADD1; i <= ADD3; i++){
          if(!reservation_stations[i][BUSY]){
            if(register_bank[aux->rs].qi == 0){
              reservation_stations[i][VJ] = register_bank[aux->rs].value;
              reservation_stations[i][QJ] = 0;
            }else{
              reservation_stations[i][QJ] = register_bank[aux->rs].qi;
            }
            if(aux->op == ADD || aux->op == ADDU || aux->op == SUB || aux->op == SUBU ||
               aux->op == NOP || aux->op == OR || aux->op == XOR  || aux->op == NOR ||
               aux->op == AND || aux->op == SLT || aux->op == SLTU || aux->op == MOVN ||
               aux->op == MOVZ || aux->op == MFHI || aux->op == MFLO || aux->op == MTHI ||
               aux->op == MTLO || aux->op == CLO || aux->op == CLZ){
              if(register_bank[aux->rt].qi == 0){
                reservation_stations[i][VK] = register_bank[aux->rt].value;
                reservation_stations[i][QK] = 0;
              }else{
                reservation_stations[i][QK] = register_bank[aux->rt].qi;
              }
            }else if(aux->op == ADDI || aux->op == LUI || aux->op == SLTI || aux->op == SLTIU || aux->op == ANDI || aux->op == ORI
            || aux->op == XORI || aux->op == ADDIU){//imm
              reservation_stations[i][VK] = aux->imm;
              reservation_stations[i][QK] = 0;
            }
            switch (aux->op) {
              case ADD:
                reservation_stations[i][BUSY] = CLOCK_ADD;
                break;
              case ADDU:
                reservation_stations[i][BUSY] = CLOCK_ADDU;
                break;
              case SUB:
                reservation_stations[i][BUSY] = CLOCK_SUB;
                break;
              case SUBU:
                reservation_stations[i][BUSY] = CLOCK_SUBU;
                break;
              case NOP:
                reservation_stations[i][BUSY] = CLOCK_NOP;
                break;
              case OR:
                reservation_stations[i][BUSY] = CLOCK_OR;
                break;
              case XOR:
                reservation_stations[i][BUSY] = CLOCK_XOR;
                break;
              case XORI:
                reservation_stations[i][BUSY] = CLOCK_XORI;
                break;
              case NOR:
                reservation_stations[i][BUSY] = CLOCK_NOR;
                break;
              case AND:
                reservation_stations[i][BUSY] = CLOCK_AND;
                break;
              case SLT:
                reservation_stations[i][BUSY] = CLOCK_SLT;
                break;
              case SLTU:
                reservation_stations[i][BUSY] = CLOCK_SLTU;
                break;
              case MOVN:
                reservation_stations[i][BUSY] = CLOCK_MOVN;
                break;
              case MOVZ:
                reservation_stations[i][BUSY] = CLOCK_MOVZ;
                break;
              case MFHI:
                reservation_stations[i][BUSY] = CLOCK_MFHI;
                break;
              case MFLO:
                reservation_stations[i][BUSY] = CLOCK_MFLO;
                break;
              case MTHI:
                reservation_stations[i][BUSY] = CLOCK_MTHI;
                break;
              case MTLO:
                reservation_stations[i][BUSY] = CLOCK_MTLO;
                break;
              case ADDI:
                reservation_stations[i][BUSY] = CLOCK_ADDI;
                break;
              case LUI:
                reservation_stations[i][BUSY] = CLOCK_LUI;
                break;
              case SLTI:
                reservation_stations[i][BUSY] = CLOCK_SLTI;
                break;
              case SLTIU:
                reservation_stations[i][BUSY] = CLOCK_SLTIU;
                break;
              case ANDI:
                reservation_stations[i][BUSY] = CLOCK_ANDI;
                break;
              case ORI:
                reservation_stations[i][BUSY] = CLOCK_ORI;
                break;
              case ADDIU:
                reservation_stations[i][BUSY] = CLOCK_ADDIU;
                break;
              case CLO:
                reservation_stations[i][BUSY] = CLOCK_CLO;
                break;
              case CLZ:
                reservation_stations[i][BUSY] = CLOCK_CLZ;
                break;
            }
            reservation_stations[i][OP] = aux->op;
            if(aux->op != NOP && aux->op){
              register_bank[aux->rd].qi = i;
            }
            reservation_stations[i][D] = aux->rd;
            removeFila(fi);
            break;
          }
        }
        break;
      case DIV:
      case DIVU:
      case MULT:
      case MULTU:
        for(i = MUL1; i <= MUL2; i++){
          if(!reservation_stations[i][BUSY]){
            if(register_bank[aux->rs].qi == 0){
              reservation_stations[i][VJ] = register_bank[aux->rs].value;
              reservation_stations[i][QJ] = 0;
            }else{
              reservation_stations[i][QJ] = register_bank[aux->rs].qi;
            }
            if(register_bank[aux->rt].qi == 0){
              reservation_stations[i][VK] = register_bank[aux->rt].value;
              reservation_stations[i][QK] = 0;
            }else{
              reservation_stations[i][QK] = register_bank[aux->rt].qi;
            }
            reservation_stations[i][OP] = aux->op;
            register_bank[LO].qi = i;
            register_bank[HI].qi = i;
            if(aux->op == MULT){
              reservation_stations[i][BUSY] = CLOCK_MULT;
            }else if(aux->op == DIV){
              reservation_stations[i][BUSY] = CLOCK_DIV;
            }else if(aux->op == DIVU){
              reservation_stations[i][BUSY] = CLOCK_DIVU;
            }else if(aux->op == MULTU){
              reservation_stations[i][BUSY] = CLOCK_MULTU;
            }
            removeFila(fi);
            break;
          }
        }
        break;
      case MUL:
        for(i = MUL1; i <= MUL2; i++){
          if(!reservation_stations[i][BUSY]){
            if(register_bank[aux->rs].qi == 0){
              reservation_stations[i][VJ] = register_bank[aux->rs].value;
              reservation_stations[i][QJ] = 0;
            }else{
              reservation_stations[i][QJ] = register_bank[aux->rs].qi;
            }
            if(register_bank[aux->rt].qi == 0){
              reservation_stations[i][VK] = register_bank[aux->rt].value;
              reservation_stations[i][QK] = 0;
            }else{
              reservation_stations[i][QK] = register_bank[aux->rt].qi;
            }
            reservation_stations[i][OP] = aux->op;
            reservation_stations[i][BUSY] = CLOCK_MUL;
            reservation_stations[i][D] = aux->rd;
            register_bank[aux->rd].qi = i;
            removeFila(fi);
            break;
          }
        }
        break;
      case BEQ:
      case BNE:
      case BLEZ:
      case BGTZ:
      case JR:
      case JALR:
        for(i = ADD1; i <= ADD3; i++){
          if(reservation_stations[i][BUSY] == 0){
            if(register_bank[aux->rs].qi == 0){
              reservation_stations[i][VJ] = register_bank[aux->rs].value;
              reservation_stations[i][QJ] = 0;
            }else{
              reservation_stations[i][QJ] = register_bank[aux->rs].qi;
            }
            if(register_bank[aux->rt].qi == 0){
              reservation_stations[i][VK] = register_bank[aux->rt].value;
              reservation_stations[i][QK] = 0;
            }else{
              reservation_stations[i][QK] = register_bank[aux->rt].qi;
            }
            reservation_stations[i][OP] = aux->op;
            reservation_stations[i][A] = aux->address;
            if(aux->op == BEQ){
              reservation_stations[i][BUSY] = CLOCK_BEQ;
            }else if(aux->op == BNE){
              reservation_stations[i][BUSY] = CLOCK_BNE;
            }else if(aux->op == BLEZ){
              reservation_stations[i][BUSY] = CLOCK_BLEZ;
            }else if(aux->op == BGTZ){
              reservation_stations[i][BUSY] = CLOCK_BGTZ;
            }else if(aux->op == JR){
              reservation_stations[i][BUSY] = CLOCK_JR;
            }else if(aux->op == JALR){
              reservation_stations[i][BUSY] = CLOCK_JALR;
            }
            removeFila(fi);
            break;
          }
        }
        break;
      case BLTZ:
      case BLTZAL:
      case BGEZ:
      case BGEZAL:
        for(i = ADD1; i <= ADD3; i++){
          if(reservation_stations[i][BUSY] == 0){
            if(register_bank[aux->rs].qi == 0){
              reservation_stations[i][VJ] = register_bank[aux->rs].value;
              reservation_stations[i][QJ] = 0;
            }else{
              reservation_stations[i][QJ] = register_bank[aux->rs].qi;
            }
            reservation_stations[i][VK] = 0;
            reservation_stations[i][QK] = 0;
            reservation_stations[i][OP] = aux->op;
            reservation_stations[i][A] = aux->address;
            switch (aux->op) {
              case BLTZ:
                reservation_stations[i][BUSY] = CLOCK_BLTZ;
                break;
              case BLTZAL:
                reservation_stations[i][BUSY] = CLOCK_BLTZAL;
                break;
              case BGEZ:
                reservation_stations[i][BUSY] = CLOCK_BGEZ;
                break;
              case BGEZAL:
                reservation_stations[i][BUSY] = CLOCK_BGEZAL;
                break;
            }
            removeFila(fi);
            break;
          }
        }
        break;
      case SLL:
      case SRA:
      case SRL:
      case SLLV:
      case SRAV:
      case SRLV:
        for(i = ADD1; i <= ADD3; i++){
          if(reservation_stations[i][BUSY] == 0){
            if(register_bank[aux->rs].qi == 0){
              reservation_stations[i][VJ] = register_bank[aux->rs].value;
              reservation_stations[i][QJ] = 0;
            }else{
              reservation_stations[i][QJ] = register_bank[aux->rs].qi;
            }
            if(aux->op == SLLV || aux->op == SRLV || aux->op == SRAV){
              if(register_bank[aux->rt].qi == 0){
                reservation_stations[i][VK] = register_bank[aux->rt].value;
                reservation_stations[i][QK] = 0;
              }else{
                reservation_stations[i][QK] = register_bank[aux->rt].qi;
              }
            }else if(aux->op == SLL || aux->op == SRA || aux->op == SRL){
              reservation_stations[i][VK] = aux->imm;
              reservation_stations[i][QK] = 0;
            }
            reservation_stations[i][OP] = aux->op;
            reservation_stations[i][A] = 0;
            register_bank[aux->rd].qi = i;
            switch (aux->op) {
              case SLL:
                reservation_stations[i][BUSY] = CLOCK_SLL;
                break;
              case SLLV:
                reservation_stations[i][BUSY] = CLOCK_SLLV;
                break;
              case SRA:
                reservation_stations[i][BUSY] = CLOCK_SRA;
                break;
              case SRL:
                reservation_stations[i][BUSY] = CLOCK_SRL;
                break;
              case SRAV:
                reservation_stations[i][BUSY] = CLOCK_SRAV;
                break;
              case SRLV:
                reservation_stations[i][BUSY] = CLOCK_SRLV;
                break;
            }
            reservation_stations[i][D] = aux->rd;
            removeFila(fi);
            break;
          }
        }
        break;
      case LW:
      case SW:
      case LWL:
      case LWR:
      case SWL:
      case SWR:
        for(i = LD1; i <= LD10; i++){
          if(reservation_stations[i][BUSY] == 0){
            if(register_bank[aux->rs].qi == 0){
              reservation_stations[i][VJ] = register_bank[aux->rs].value;
              reservation_stations[i][QJ] = 0;
            }else{
              reservation_stations[i][QJ] = register_bank[aux->rs].qi;
            }
            reservation_stations[i][A] = aux->address;
            if(aux->op == SW || aux->op == SWL || aux->op == SWR){
              if(register_bank[aux->rt].qi == 0){
                reservation_stations[i][VK] = register_bank[aux->rt].value;
                reservation_stations[i][QK] = 0;
              }else{
                reservation_stations[i][QK] = register_bank[aux->rt].qi;
              }
              reservation_stations[i][BUSY] = CLOCK_SW;
            }else{
              reservation_stations[i][D] = aux->rt;
              register_bank[aux->rt].qi = i;
              reservation_stations[i][BUSY] = CLOCK_LW;
            }
            reservation_stations[i][OP] = aux->op;
            removeFila(fi);
            break;
          }
        }
        break;
    }
  }
}

void EX(){
  int i, numc,k, control_aux = 2;
  int inicio, fim;
  inicio = clock;
  fim = control_rs + 6;
  for(inicio; inicio <= fim; inicio++){
    i = inicio % 7;
    if(i == LD1){ //load and store
      if(control_ls != 0 && reservation_stations[control_ls][BUSY] == 0){
        control_aux = 0;
        for(k = control_ls+1; k <= QTD_RS; k++){
          if(reservation_stations[k][BUSY] != 0){
            control_ls = k;
            control_aux = 1;
            break;
          }
        }
      }
      if(control_aux == 0 || control_ls == 0){
        for(k = LD1; k <= QTD_RS; k++){
          if(reservation_stations[k][BUSY] != 0){
            control_ls = k;
            control_aux = 1;
            break;
          }
        }
        if(control_aux == 0){
          control_ls = 0;
        }
      }
      if(control_ls != 0){
        if(reservation_stations[control_ls][BUSY] == 1 && bussCDB.controlBus == 0){
          if((reservation_stations[control_ls][OP] == LW || reservation_stations[control_ls][OP] == LWL
            || reservation_stations[control_ls][OP] == LWR)  && reservation_stations[control_ls][QJ] == 0){
            reservation_stations[control_ls][A] = reservation_stations[control_ls][A] + reservation_stations[control_ls][VJ];
            cpu_cache.addressBus = reservation_stations[control_ls][A];
            cpu_cache.controlBus = CACHE_D;
            read_cache();
            numc = twos_complementsBD(cpu_cache.dataBus, 32);
            bussCDB.controlBus = 1;
            bussCDB.addressBus = control_ls;
            if(reservation_stations[control_ls][OP] == LWL){
              numc = numc >> 16;
            }else if(reservation_stations[control_ls][OP] == LWR){
              numc = 65535 & numc;
            }
            bussCDB.dataBus = numc;
          }else if(reservation_stations[control_ls][QJ] == 0 && reservation_stations[control_ls][QK] == 0){
            reservation_stations[control_ls][A] = reservation_stations[control_ls][A] + reservation_stations[control_ls][VJ];
            bussCDB.controlBus = 2;
            bussCDB.addressBus = control_ls;
            bussCDB.dataBus = reservation_stations[control_ls][VK];
            if(reservation_stations[control_ls][OP] == SWL){
              bussCDB.dataBus = bussCDB.dataBus >> 16;
            }else if(reservation_stations[control_ls][OP] == SWR){
              bussCDB.dataBus = 65535 & bussCDB.dataBus;
            }
          }
        }else if(reservation_stations[control_ls][OP] == LW && reservation_stations[control_ls][BUSY] > 1 && reservation_stations[control_ls][QJ] == 0){
          reservation_stations[control_ls][BUSY] = reservation_stations[control_ls][BUSY] - 1;
        }else if(reservation_stations[control_ls][BUSY] > 1 && reservation_stations[control_ls][QJ] == 0 && reservation_stations[control_ls][QK] == 0){
          reservation_stations[control_ls][BUSY] = reservation_stations[control_ls][BUSY] - 1;
        }
      }
    }else{//add and mul
      if(reservation_stations[i][BUSY] == 1 && bussCDB.controlBus == 0){
        if(reservation_stations[i][QJ] == 0 && reservation_stations[i][QK] == 0){
          switch (reservation_stations[i][OP]) {
            case ADD:
            case ADDI:
            case ADDU:
            case ADDIU:
            case SUB:
            case SUBU:
            case NOP:
            case NOR:
            case OR:
            case ORI:
            case AND:
            case ANDI:
            case XOR:
            case XORI:
            case SLT:
            case SLTU:
            case SLTI:
            case SLTIU:
              bussCDB.controlBus = 1;
              switch (i) {
                case 1:
                  if(reservation_stations[i][OP] == ADD || reservation_stations[i][OP] == ADDI || reservation_stations[i][OP] == ADDU
                  || reservation_stations[i][OP] == ADDIU){
                    bussCDB.dataBus = functional_unit_1(reservation_stations[i][VJ], reservation_stations[i][VK], 1);
                  }else if(reservation_stations[i][OP] == SUB || reservation_stations[i][OP] == SUBU){
                    bussCDB.dataBus = functional_unit_1(reservation_stations[i][VJ], reservation_stations[i][VK], 2);
                  }else if(reservation_stations[i][OP] == AND || reservation_stations[i][OP] == ANDI || reservation_stations[i][OP] == OR || reservation_stations[i][OP] == XOR ||
                  reservation_stations[i][OP] == NOR || reservation_stations[i][OP] == ORI || reservation_stations[i][OP] == XORI){
                    switch (reservation_stations[i][OP]) {
                      case 10:
                      case 27:
                        bussCDB.dataBus = functional_unit_1(reservation_stations[i][VJ], reservation_stations[i][VK], 3);
                        break;
                      case 11:
                      case 29:
                        bussCDB.dataBus = functional_unit_1(reservation_stations[i][VJ], reservation_stations[i][VK], 6);
                        break;
                      case 12:
                        bussCDB.dataBus = functional_unit_1(reservation_stations[i][VJ], reservation_stations[i][VK], 5);
                        break;
                      case 13:
                      case 28:
                        bussCDB.dataBus = functional_unit_1(reservation_stations[i][VJ], reservation_stations[i][VK], 4);
                    }
                  }else if(reservation_stations[i][OP] == SLT || reservation_stations[i][OP] == SLTU || reservation_stations[i][OP] == SLTI
                    || reservation_stations[i][OP] == SLTIU){
                    if(reservation_stations[i][VJ] < reservation_stations[i][VK]){
                      bussCDB.dataBus = functional_unit_1(1, 0, 0);
                    }else{
                      bussCDB.dataBus = functional_unit_1(0, 0, 0);
                    }
                  }else{
                    bussCDB.dataBus = functional_unit_1(0, 0, 0);
                  }
                  bussCDB.addressBus = ADD1;
                  break;
                case 2:
                  if(reservation_stations[i][OP] == ADD || reservation_stations[i][OP] == ADDI || reservation_stations[i][OP] == ADDU
                  || reservation_stations[i][OP] == ADDIU){
                    bussCDB.dataBus = functional_unit_2(reservation_stations[i][VJ], reservation_stations[i][VK], 1);
                  }else if(reservation_stations[i][OP] == SUB || reservation_stations[i][OP] == SUBU){
                    bussCDB.dataBus = functional_unit_2(reservation_stations[i][VJ], reservation_stations[i][VK], 2);
                  }else if(reservation_stations[i][OP] == AND || reservation_stations[i][OP] == ANDI || reservation_stations[i][OP] == OR || reservation_stations[i][OP] == XOR ||
                  reservation_stations[i][OP] == NOR || reservation_stations[i][OP] == ORI || reservation_stations[i][OP] == XORI){
                    switch (reservation_stations[i][OP]) {
                      case 10:
                      case 27:
                        bussCDB.dataBus = functional_unit_2(reservation_stations[i][VJ], reservation_stations[i][VK], 3);
                        break;
                      case 11:
                      case 29:
                        bussCDB.dataBus = functional_unit_2(reservation_stations[i][VJ], reservation_stations[i][VK], 6);
                        break;
                      case 12:
                        bussCDB.dataBus = functional_unit_2(reservation_stations[i][VJ], reservation_stations[i][VK], 5);
                        break;
                      case 13:
                      case 28:
                        bussCDB.dataBus = functional_unit_2(reservation_stations[i][VJ], reservation_stations[i][VK], 4);
                    }
                  }else if(reservation_stations[i][OP] == SLT || reservation_stations[i][OP] == SLTU || reservation_stations[i][OP] == SLTI
                    || reservation_stations[i][OP] == SLTIU){
                    if(reservation_stations[i][VJ] < reservation_stations[i][VK]){
                      bussCDB.dataBus = functional_unit_2(1, 0, 0);
                    }else{
                      bussCDB.dataBus = functional_unit_2(0, 0, 0);
                    }
                  }else{
                    bussCDB.dataBus = functional_unit_2(0, 0, 0);
                  }
                  bussCDB.addressBus = ADD2;
                  break;
                case 3:
                  if(reservation_stations[i][OP] == ADD || reservation_stations[i][OP] == ADDI || reservation_stations[i][OP] == ADDU
                  || reservation_stations[i][OP] == ADDIU){
                    bussCDB.dataBus = functional_unit_3(reservation_stations[i][VJ], reservation_stations[i][VK], 1);
                  }else if(reservation_stations[i][OP] == SUB || reservation_stations[i][OP] == SUBU){
                    bussCDB.dataBus = functional_unit_3(reservation_stations[i][VJ], reservation_stations[i][VK], 2);
                  }else if(reservation_stations[i][OP] == AND || reservation_stations[i][OP] == ANDI || reservation_stations[i][OP] == OR || reservation_stations[i][OP] == XOR ||
                  reservation_stations[i][OP] == NOR || reservation_stations[i][OP] == ORI || reservation_stations[i][OP] == XORI){
                    switch (reservation_stations[i][OP]) {
                      case 10:
                      case 27:
                        bussCDB.dataBus = functional_unit_3(reservation_stations[i][VJ], reservation_stations[i][VK], 3);
                        break;
                      case 11:
                      case 29:
                        bussCDB.dataBus = functional_unit_3(reservation_stations[i][VJ], reservation_stations[i][VK], 6);
                        break;
                      case 12:
                        bussCDB.dataBus = functional_unit_3(reservation_stations[i][VJ], reservation_stations[i][VK], 5);
                        break;
                      case 13:
                      case 28:
                        bussCDB.dataBus = functional_unit_3(reservation_stations[i][VJ], reservation_stations[i][VK], 4);
                    }
                  }else if(reservation_stations[i][OP] == SLT || reservation_stations[i][OP] == SLTU || reservation_stations[i][OP] == SLTI
                    || reservation_stations[i][OP] == SLTIU){
                    if(reservation_stations[i][VJ] < reservation_stations[i][VK]){
                      bussCDB.dataBus = functional_unit_3(1, 0, 0);
                    }else{
                      bussCDB.dataBus = functional_unit_3(0, 0, 0);
                    }
                  }else{
                    bussCDB.dataBus = functional_unit_3(0, 0, 0);
                  }
                  bussCDB.addressBus = ADD3;
                  break;
              }
              break;
            case LUI:
              bussCDB.controlBus = 1;
              switch (i) {
                case 1:
                  bussCDB.dataBus = functional_unit_1(reservation_stations[i][VK]<<16, 0, 0);
                  bussCDB.addressBus = ADD1;
                  break;
                case 2:
                  bussCDB.dataBus = functional_unit_2(reservation_stations[i][VK]<<16, 0, 0);
                  bussCDB.addressBus = ADD2;
                  break;
                case 3:
                  bussCDB.dataBus = functional_unit_3(reservation_stations[i][VK]<<16, 0, 0);
                  bussCDB.addressBus = ADD3;
                  break;
              }
              break;
            case MOVZ:
            case MOVN:
              switch (i) {
                case 1:
                  bussCDB.controlBus = 5;
                  bussCDB.addressBus = ADD1;
                  if(reservation_stations[i][VK] != 0 && reservation_stations[i][OP] == MOVN){
                    bussCDB.controlBus = 1;
                    bussCDB.dataBus = functional_unit_1(reservation_stations[i][VJ], 0, 0);
                  }else if(reservation_stations[i][VK] == 0 && reservation_stations[i][OP] == MOVZ){
                    bussCDB.controlBus = 1;
                    bussCDB.dataBus = functional_unit_1(reservation_stations[i][VJ], 0, 0);
                  }
                  break;
                case 2:
                  bussCDB.addressBus = ADD2;
                  bussCDB.controlBus = 5;
                  if(reservation_stations[i][VK] != 0 && reservation_stations[i][OP] == MOVN){
                    bussCDB.controlBus = 1;
                    bussCDB.dataBus = functional_unit_2(reservation_stations[i][VJ], 0, 0);
                  }else if(reservation_stations[i][VK] == 0 && reservation_stations[i][OP] == MOVZ){
                    bussCDB.controlBus = 1;
                    bussCDB.dataBus = functional_unit_2(reservation_stations[i][VJ], 0, 0);
                  }
                  break;
                case 3:
                  bussCDB.addressBus = ADD3;
                  bussCDB.controlBus = 5;
                  if(reservation_stations[i][VK] != 0 && reservation_stations[i][OP] == MOVN){
                    bussCDB.controlBus = 1;
                    bussCDB.dataBus = functional_unit_3(reservation_stations[i][VJ], 0, 0);
                  }else if(reservation_stations[i][VK] == 0 && reservation_stations[i][OP] == MOVZ){
                    bussCDB.controlBus = 1;
                    bussCDB.dataBus = functional_unit_3(reservation_stations[i][VJ], 0, 0);
                  }
                  break;
              }
              break;
            case MFHI:
            case MFLO:
            case MTHI:
            case MTLO:
              bussCDB.controlBus = 1;
              bussCDB.addressBus = i;
                switch (i) {
                  case ADD1:
                    bussCDB.dataBus = functional_unit_1(reservation_stations[i][VJ], 0, 0);
                    break;
                  case ADD2:
                    bussCDB.dataBus = functional_unit_2(reservation_stations[i][VJ], 0, 0);
                    break;
                  case ADD3:
                    bussCDB.dataBus = functional_unit_3(reservation_stations[i][VJ], 0, 0);
                    break;
                }
                break;
            case SLL:
            case SLLV:
              bussCDB.controlBus = 1;
              bussCDB.addressBus = i;
              switch (i) {
                case ADD1:
                  bussCDB.dataBus = functional_unit_1(reservation_stations[i][VJ], reservation_stations[i][VK], 7);
                  break;
                case ADD2:
                  bussCDB.dataBus = functional_unit_2(reservation_stations[i][VJ], reservation_stations[i][VK], 7);
                  break;
                case ADD3:
                  bussCDB.dataBus = functional_unit_3(reservation_stations[i][VJ], reservation_stations[i][VK], 7);
                  break;
              }
              break;
            case SRA:
            case SRL:
            case SRLV:
            case SRAV:
              bussCDB.controlBus = 1;
              bussCDB.addressBus = i;
              switch (i) {
                case ADD1:
                  bussCDB.dataBus = functional_unit_1(reservation_stations[i][VJ], reservation_stations[i][VK], 8);
                  break;
                case ADD2:
                  bussCDB.dataBus = functional_unit_2(reservation_stations[i][VJ], reservation_stations[i][VK], 8);
                  break;
                case ADD3:
                  bussCDB.dataBus = functional_unit_3(reservation_stations[i][VJ], reservation_stations[i][VK], 8);
                  break;
              }
              break;
            case DIV:
            case MULT:
            case MULTU:
            case DIVU:
              bussCDB.controlBus = 3;
              switch (i) {
                case 4:
                  bussCDB.addressBus = MUL1;
                  if(reservation_stations[i][OP] == DIV || reservation_stations[i][OP] == DIVU){
                    bussCDB.dataBus = functional_unit_4(reservation_stations[MUL1][VJ], reservation_stations[MUL1][VK], 1);
                  }else if(reservation_stations[i][OP] == MULT){
                    bussCDB.dataBus = functional_unit_4(reservation_stations[MUL1][VJ], reservation_stations[MUL1][VK], 3);
                  }else{
                    bussCDB.dataBus = functional_unit_4(reservation_stations[MUL1][VJ], reservation_stations[MUL1][VK], 5);
                  }
                  break;
                case 5:
                  bussCDB.addressBus = MUL2;
                  if(reservation_stations[i][OP] == DIV || reservation_stations[i][OP] == DIVU){
                    bussCDB.dataBus = functional_unit_5(reservation_stations[MUL2][VJ], reservation_stations[MUL2][VK], 1);
                  }else if(reservation_stations[i][OP] == MULT){
                    bussCDB.dataBus = functional_unit_5(reservation_stations[MUL2][VJ], reservation_stations[MUL2][VK], 3);
                  }else{
                    bussCDB.dataBus = functional_unit_5(reservation_stations[MUL2][VJ], reservation_stations[MUL2][VK], 5);
                  }
                  break;
              }
              break;
            case MUL:
              bussCDB.controlBus = 1;
              switch (i) {
                case 4:
                  bussCDB.addressBus = MUL1;
                  bussCDB.dataBus = functional_unit_4(reservation_stations[MUL1][VJ], reservation_stations[MUL1][VK], 3);
                  break;
                case 5:
                  bussCDB.addressBus = MUL2;
                  bussCDB.dataBus = 1;
                  bussCDB.dataBus = functional_unit_5(reservation_stations[MUL2][VJ], reservation_stations[MUL2][VK], 3);
                  break;
              }
              break;
            case CLO:
            case CLZ:
              bussCDB.controlBus = 1;
              switch (i) {
                case ADD1:
                  bussCDB.addressBus = ADD1;
                  if(reservation_stations[i][OP] == CLZ){
                    bussCDB.dataBus = functional_unit_1(__builtin_clz(reservation_stations[ADD1][VJ]), 0, 0);
                  }else{
                    bussCDB.dataBus = functional_unit_1(__builtin_clz(~reservation_stations[ADD1][VJ]), 0, 0);
                  }
                  break;
                case ADD2:
                  bussCDB.addressBus = ADD2;
                  if(reservation_stations[i][OP] == CLZ){
                    bussCDB.dataBus = functional_unit_2(__builtin_clz(reservation_stations[ADD2][VJ]), 0, 0);
                  }else{
                    bussCDB.dataBus = functional_unit_2(__builtin_clz(~reservation_stations[ADD2][VJ]), 0, 0);
                  }
                  break;
                case ADD3:
                  bussCDB.addressBus = ADD3;
                  if(reservation_stations[i][OP] == CLZ){
                    bussCDB.dataBus = functional_unit_3(__builtin_clz(reservation_stations[ADD3][VJ]), 0, 0);
                  }else{
                    bussCDB.dataBus = functional_unit_3(__builtin_clz(~reservation_stations[ADD3][VJ]), 0, 0);
                  }
                  break;
              }
              break;
            case JR:
              somadorPC(reservation_stations[i][VJ], 1);
              //PC = reservation_stations[i][VJ];
              pause = 0;
              reservation_stations[i][BUSY] = 0;
              break;
            case JALR:
              register_bank[$ra].value = PC;
              register_bank[$ra].qi = 0;
              //PC = reservation_stations[i][VJ];
              somadorPC(reservation_stations[i][VJ], 1);
              pause = 0;
              reservation_stations[i][BUSY] = 0;
              break;
            case BEQ:
              if(reservation_stations[i][VJ] == reservation_stations[i][VK]){
                somadorPC(reservation_stations[i][A], 1);
                //PC = reservation_stations[i][A];
              }
              pause = 0;
              reservation_stations[i][BUSY] = 0;
              break;
            case BNE:
              if(reservation_stations[i][VJ] != reservation_stations[i][VK]){
                somadorPC(reservation_stations[i][A], 1);
                //PC = reservation_stations[i][A];
              }
              pause = 0;
              reservation_stations[i][BUSY] = 0;
              break;
            case BLEZ:
              if(reservation_stations[i][VJ] <= 0){
                somadorPC(reservation_stations[i][A], 1);
                //PC = reservation_stations[i][A];
              }
              pause = 0;
              reservation_stations[i][BUSY] = 0;
              break;
            case BGTZ:
              if(reservation_stations[i][VJ] > 0){
                somadorPC(reservation_stations[i][A], 1);
                //PC = reservation_stations[i][A];
              }
              pause = 0;
              reservation_stations[i][BUSY] = 0;
              break;
            case BLTZ:
              if(reservation_stations[i][VJ] < 0){
                somadorPC(reservation_stations[i][A], 1);
                //PC = reservation_stations[i][A];
              }
              pause = 0;
              reservation_stations[i][BUSY] = 0;
              break;
            case BLTZAL:
              if(reservation_stations[i][VJ] < 0){
                register_bank[$ra].value = PC;
                register_bank[$ra].qi = 0;
                somadorPC(reservation_stations[i][A], 1);
                //PC = reservation_stations[i][A];
              }
              pause = 0;
              reservation_stations[i][BUSY] = 0;
              break;
            case BGEZ:
              if(reservation_stations[i][VJ] >= 0){
                somadorPC(reservation_stations[i][A], 1);
                //PC = reservation_stations[i][A];
              }
              pause = 0;
              reservation_stations[i][BUSY] = 0;
              break;
            case BGEZAL:
              if(reservation_stations[i][VJ] >= 0){
                register_bank[$ra].value = PC;
                register_bank[$ra].qi = 0;
                somadorPC(reservation_stations[i][A], 1);
                //PC = reservation_stations[i][A];
              }
              pause = 0;
              reservation_stations[i][BUSY] = 0;
              break;
          }
        }
      }else if(bussCDB.controlBus == 4){//div e mul 2° parte
        bussCDB.controlBus = 1;
        switch (bussCDB.addressBus) {
          case 4:
            if(reservation_stations[MUL1][OP] == DIV || reservation_stations[MUL1][OP] == DIVU){
              bussCDB.dataBus = functional_unit_4(reservation_stations[MUL1][VJ], reservation_stations[MUL1][VK], 2);
            }else if(reservation_stations[MUL1][OP] == MULT){
              bussCDB.dataBus = functional_unit_4(reservation_stations[MUL1][VJ], reservation_stations[MUL1][VK], 4);
            }else{
              bussCDB.dataBus = functional_unit_4(reservation_stations[MUL1][VJ], reservation_stations[MUL1][VK], 6);
            }
            break;
          case 5:
            if(reservation_stations[MUL2][OP] == DIV || reservation_stations[MUL2][OP] == DIVU){
              bussCDB.dataBus = functional_unit_5(reservation_stations[MUL2][VJ], reservation_stations[MUL2][VK], 2);
            }else if(reservation_stations[MUL2][OP] == MULT){
              bussCDB.dataBus = functional_unit_5(reservation_stations[MUL2][VJ], reservation_stations[MUL2][VK], 4);
            }else{
              bussCDB.dataBus = functional_unit_5(reservation_stations[MUL2][VJ], reservation_stations[MUL2][VK], 6);
            }
            break;
        }
    }else if(reservation_stations[i][BUSY] > 1 && reservation_stations[i][QJ] == 0 && reservation_stations[i][QK] == 0){
      reservation_stations[i][BUSY] = reservation_stations[i][BUSY] - 1;
    }
    }
  }
  control_rs++;
}

void WB(){
  int i;
  if(bussCDB.controlBus == 1){
    for(i = 0; i < 34; i++){//escreve no register_bank
      if(register_bank[i].qi == bussCDB.addressBus){
        register_bank[i].qi = 0;
        register_bank[i].value = bussCDB.dataBus;
      }
    }
    for(i = 1; i <= QTD_RS; i++){//escreve nas reservation_stations
      if(reservation_stations[i][QJ] == bussCDB.addressBus && reservation_stations[i][OP] == MFLO){
        reservation_stations[i][QJ] = 0;
        reservation_stations[i][VJ] = register_bank[LO].value;
      }
      if(reservation_stations[i][QJ] == bussCDB.addressBus){
        reservation_stations[i][QJ] = 0;
        reservation_stations[i][VJ] = bussCDB.dataBus;
      }
      if(reservation_stations[i][QK] == bussCDB.addressBus){
        reservation_stations[i][QK] = 0;
        reservation_stations[i][VK] = bussCDB.dataBus;
      }
    }
    reservation_stations[bussCDB.addressBus][BUSY] = 0;
    bussCDB.controlBus = 0;
  }else if(bussCDB.controlBus == 2){ //store
    cpu_cache.controlBus = CACHE_D;
    cpu_cache.addressBus = reservation_stations[bussCDB.addressBus][A];
    twos_complementsDB(cpu_cache.dataBus, bussCDB.dataBus, 32);
    write_cache();
    reservation_stations[bussCDB.addressBus][BUSY] = 0;
    bussCDB.controlBus = 0;
  }else if(bussCDB.controlBus == 3){ //div 1° parte
    if(register_bank[LO].qi == bussCDB.addressBus){
      register_bank[LO].value = bussCDB.dataBus;
      register_bank[LO].qi = 0;
      bussCDB.controlBus = 4;
    }
  }else if(bussCDB.controlBus == 5){//movn e movz
    for(i = 0; i < 34; i++){//escreve no register_bank
      if(register_bank[i].qi == bussCDB.addressBus){
        register_bank[i].qi = 0;
      }
    }
    for(i = 1; i <= QTD_RS; i++){//escreve nas reservation_stations
      if(reservation_stations[i][QJ] == bussCDB.addressBus){
        reservation_stations[i][QJ] = 0;
      }
      if(reservation_stations[i][QK] == bussCDB.addressBus){
        reservation_stations[i][QK] = 0;
      }
    }
    reservation_stations[bussCDB.addressBus][BUSY] = 0;
    bussCDB.controlBus = 0;
  }
}

void pipeline(){
  WB(); //escrever
  EX(); //executar
  II(); //emitir
  ID(); //decodificar e inserir na fila
  IF(); //buscar
}

void _clock(){
  clock = 1;
  while(!exit_program()){
    if(option == OP_DETAILED){
      printf("\n\nCLOCK %d\n\n\n", clock);
    }
    pipeline();
    if(option == OP_DETAILED){
      printf_reservation_stations(reservation_stations);
      printf_register_bank(register_bank);
      printf("\ndigit enter to continue...");
      __fpurge(stdin);
      getchar();
    }
    clock++;
  }
}
