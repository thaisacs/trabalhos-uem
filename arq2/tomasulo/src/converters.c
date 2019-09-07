#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
extern FILE *yyout;
extern int yyerror(char *s);

void to_convertDB(char byte[], unsigned int num, int tam){
  int binario[tam];
  int i, j = 0;
  for(i = 0; i < tam; i++){
    binario[i] = 0;
  }
  i = 0;
  while(num > 0 && i < tam){
    if(i < tam){
      binario[i] = num % 2;
      num = num / 2;
    }
    i++;
  }
  if(num > 0){
    yyerror("error: estouro");
  }
  for(i = tam-1;i >= 0; i--){
    if(binario[i]==1){
      byte[j] = '1';
    }else{
      byte[j] = '0';
    }
    j++;
  }
  byte[j] = '\0';
}

unsigned int to_convertBD(char binario[]){
  int i;
  int j = 0;
  unsigned int num = 0;
  for(i = strlen(binario)-1; i >= 0; i--){
    if(binario[i] == '1'){
      num = num + pow(2, j);
    }
    j++;
  }
  return num;
}

long int twos_complementsBD(char num[], int tam){
  long int imm;
  int i;
  if(num[0] == '0'){
    imm = to_convertBD(num);
  }else{
    for(i = 0; i < tam; i++){
      if(num[i] == '0'){
        num[i] = '1';
      }else{
        num[i] = '0';
      }
    }
    for(i = tam-1; i >= 0; i--){
      if(num[i] == '0'){
        num[i] = '1';
        break;
      }else{
        num[i] = '0';
      }
    }
    imm = to_convertBD(num);
    imm = - imm;
  }
  return imm;
}

void twos_complementsDB(char num_convertido[], int num, int tam){
  int i;
  if(num < 0){
    to_convertDB(num_convertido, num*-1, tam);
    for(i = 0; i < tam; i++){
      if(num_convertido[i] == '0'){
        num_convertido[i] = '1';
      }else{
        num_convertido[i] = '0';
      }
    }
    for(i = tam-1; i >= 0; i--){
      if(num_convertido[i] == '0'){
        num_convertido[i] = '1';
        break;
      }else{
        num_convertido[i] = '0';
      }
    }
  }else{
    to_convertDB(num_convertido, num, tam);
    if(num_convertido[0] == '1'){
      yyerror("error: estouro: twos_complementsDB: num > 0");
    }
  }
}

/*
 *Gerencia as instruções do tipo R
 */
void set_instruction(char m[], char rd[], char rs[], char rt[], int shamp, char func[]){
  char i[33] = "", aux[6];
  to_convertDB(aux, shamp, 5);
  strcat(i, m);
  strcat(i, rs);
  strcat(i, rt);
  strcat(i, rd);
  strcat(i, aux);
  strcat(i, func);
  unsigned int num = to_convertBD(i);
  i[32] = '\0';
  fprintf(yyout, "%u\n", num );
}
/*
 *Gerencia as instruções do tipo I
 */
void set_instruction_imm(char m[], char rt[], char rs[], int num){
  char i[33] = "", aux[17];
  twos_complementsDB(aux, num, 16);
  strcat(i, m);
  strcat(i, rs);
  strcat(i, rt);
  strcat(i, aux);
  i[32] = '\0';
  unsigned int numc = to_convertBD(i);
  fprintf(yyout, "%u\n", numc );
}
/*
 *Gerencia as instruções do tipo BRANCH e JUMP
 */
void set_instruction_jump(char m[], char label[]){
  char i[33] = "", aux[27];
  char buffer[100];
  long int address;
  int control = 0;
  FILE *file = fopen("compiler/labels.out", "r");
  strcat(i, m);
  while(fscanf(file, "%s %d", buffer, &address) != EOF){
    if(!strcmp(buffer, label)){
      control = 1;
      break;
    }
  }
  if(!control){
    yyerror("Existe label que foi usada, mas nao declarada");
  }
  to_convertDB(aux, address, 26);
  strcat(i, aux);
  i[32] = '\0';
  unsigned int numc = to_convertBD(i);
  fprintf(yyout, "%u\n", numc );
}

void set_instruction_branch(char m[], char rt[], char rs[], char label[]){
  int control = 0, j;
  char buffer[100], aux[16];
  int address;
  FILE *file = fopen("compiler/labels.out", "r");
  while(fscanf(file, "%s %d", buffer, &address) != EOF){
    if(!strcmp(buffer, label)){
      control = 1;
      break;
    }
  }
  if(!control){
    yyerror("Existe label que foi usada, mas nao declarada");
    exit(0);
  }
  set_instruction_imm(m, rt, rs, address);
}
/*
 *Gerencia a instrução LOAD
 */
void set_load_store(char m[], char rs[], char rt[], char label[]){
  int control = 0;
  char buffer[100], aux[16];
  int address, valor_no_so = 268435456;
  FILE *file = fopen("compiler/labels.out", "r");
  while(fscanf(file, "%s %d", buffer, &address) != EOF){
    if(!strcmp(buffer, label)){
      control = 1;
      break;
    }
  }
  if(!control){
    yyerror("Existe label que foi usada, mas nao declarada");
  }
  address = address - valor_no_so;
  set_instruction_imm("001111", "10000","00000", 4096);
  set_instruction("000000", "10000", "10000", rs, 0,"100001");
  set_instruction_imm(m, rt, "10000", address);
}
