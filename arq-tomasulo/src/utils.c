#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include </usr/include/sys/types.h>
#include </usr/include/sys/mman.h>
#include </usr/include/sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <utils.h>
#include "converters.h"
#include "colors.h"
#include "options.h"

#define FILEPATH "mmap_memory.bin"
#define TAM_MEMORY (2147483644)
#define FILESIZE (TAM_MEMORY*sizeof(byte))
#define DATA_SEGMENT (268435456)
#define TEXT_SEGMENT (0)
#define STACK_SEGMENT (2147483644)
#define LOAD_DATA 1
#define LOAD_TEXT 0

unsigned int data_segment;
unsigned int text_segment;
unsigned int stack_segment;

void substring(char string[], char dest[], int inicio, int fim){
  int i;
  for(i = inicio; i <= fim; i++){
    dest[i-inicio] = string[i];
  }
  dest[fim-inicio+1] = '\0';
}

void start_memory(byte *map){
  unsigned int i;
  byte t;
  char b[9];
  b[0] = '0';
  b[1] = '0';
  b[2] = '0';
  b[3] = '0';
  b[4] = '0';
  b[5] = '0';
  b[6] = '0';
  b[7] = '0';
  b[0] = '\0';
  memset(&t, '\0', sizeof(t));
  strcpy(t.bits, b);
  for(i = STACK_SEGMENT; i >= 2147483630; i--){
    map[i] = t;
  }
}

void cabecalho(){
  foreground(RED);
  printf("       _________.__              .__          __                \n");
  printf("      /   _____/|__| _____  __ __|  | _____ _/  |_  ___________ \n");
  printf("      \\_____  \\ |  |/     \\|  |  \\  | \\__  \\    __\\/  _  \\_  __ \\ \n");
  printf("      /        \\|  |  Y Y  \\  |  /  |__/ __ \\|  | (  <_> )  |  \\/\n");
  printf("     /_______  /|__|__|_|  /____/|____(____  /__|  \\____/|__|   \n");
  printf("             \\/          \\/                \\/                   \n");
  printf("                         by: Thais Camacho\n");
  style(RESETALL);
}

byte* create_memory(){
  int result;
  int fd;
  byte *map;
  fd = open(FILEPATH, O_RDWR | O_CREAT | O_TRUNC, 0600);
  if(fd == -1){
    perror("Error opening file for writing");
    exit(EXIT_FAILURE);
  }

  result = lseek(fd, FILESIZE-1, SEEK_SET);
  if(result == -1){
    close(fd);
    perror("Error calling lseek() to 'stretch' the file");
	  exit(EXIT_FAILURE);
  }

  result = write(fd, "", 1);
  if(result != 1){
    close(fd);
	  perror("Error writing last byte of the file");
	  exit(EXIT_FAILURE);
  }

  map = mmap(0, FILESIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
  if (map == MAP_FAILED) {
	  close(fd);
	  perror("Error mmapping the file");
	  exit(EXIT_FAILURE);
  }

  data_segment = DATA_SEGMENT;
  text_segment = TEXT_SEGMENT;
  stack_segment = STACK_SEGMENT;
  start_memory(map);
  return map;
}


void _help(){
  printf("simulator: version 1.0 of July, 2017.\nCopyright (c) by Thais Camacho.\nAll Rights Reserved.\n");
  printf("\nUsage: ./bin/simulator {-options} executable\n");
  printf("\n#\n");
  printf("# -option                       # description\n");
  printf("#\n");
  printf("-h                              # print help message\n");
  printf("-d                              # enable debug message\n");
  printf("\n");
  printf("# examples\n");
  printf("./bin/simulator -h\n");
  printf("./bin/simulator tests/fatorial.asm\n");
  printf("./bin/simulator -d tests/fatorial.asm\n");
  printf("\n\n");
}

cache* create_cache(){
  cache *l = (cache*) malloc(2048*sizeof(cache));
  int i;
  for(i = 0; i < 2048; i++){
    memset(l[i].tag, '\0', 19);
  }
  return l;
}

void store_program(byte *map, FILE *file){
  char b1[9], b2[9], b3[9], b4[9];
  char dado[50];
  char byteBuffer[33];
  byte t;
  unsigned int num, i = 0;
  while(fscanf(file, "%s", dado) != EOF){
    if(strcmp(dado, "#") != 0){
      num = atoi(dado);
      if(i < 100){
        twos_complementsDB(byteBuffer, num, 32);
        substring(byteBuffer, b1, 0, 7);
        substring(byteBuffer, b2, 8, 15);
        substring(byteBuffer, b3, 16, 23);
        substring(byteBuffer, b4, 24, 31);
        strcpy(t.bits, b4);
        map[data_segment] = t;
        data_segment++;
        strcpy(t.bits, b3);
        map[data_segment] = t;
        data_segment++;
        strcpy(t.bits, b2);
        map[data_segment] = t;
        data_segment++;
        strcpy(t.bits, b1);
        map[data_segment] = t;
        data_segment++;
      }else{
        to_convertDB(byteBuffer, num, 32);
        substring(byteBuffer, b1, 0, 7);
        substring(byteBuffer, b2, 8, 15);
        substring(byteBuffer, b3, 16, 23);
        substring(byteBuffer, b4, 24, 31);
        strcpy(t.bits, b4);
        map[text_segment] = t;
        text_segment++;
        strcpy(t.bits, b3);
        map[text_segment] = t;
        text_segment++;
        strcpy(t.bits, b2);
        map[text_segment] = t;
        text_segment++;
        strcpy(t.bits, b1);
        map[text_segment] = t;
        text_segment++;
      }
    }
    i++;
  }
}

int count_digit(int number){
  int qtd = 0;
  if (number == 0){
    qtd = 1;
  }else{
    while (number != 0){
      qtd = qtd + 1;
      number = number / 10;
    }
  }
  return qtd;
}

void printf_reservation_stations(int reservation_stations[16][8]){
  int i, j;
  foreground(RED);
  printf("-----------------------------------------------------------------------------------------------\n");
  printf("|");
  printf("                                     RESERVATION STATIONS                                    ");
  printf("|\n");
  printf("-----------------------------------------------------------------------------------------------\n");
  printf("|");
  printf("            BUSY        OP      D       VJ            VK      QJ   QK        A               ");
  printf("|\n");
  printf("-----------------------------------------------------------------------------------------------\n");
  style(RESETALL);
  for(i = 1; i < 16; i++){
    foreground(RED);
    printf("|  ");
    switch (i) {
      case 1:
      case 2:
      case 3:
        printf("ADD%d   ", i);
        break;
      case 4:
        printf("MULT%d  ", 1);
        break;
      case 5:
        printf("MULT%d  ", 2);
        break;
      case 6:
      case 7:
      case 8:
      case 9:
      case 10:
      case 11:
      case 12:
      case 13:
      case 14:
        printf("LS%d    ", i-5);
        break;
      case 15:
        printf("LS%d   ", i-5);
        break;
    }
    style(RESETALL);
    for(j = 0; j < 8; j++){
      if(j == 0){
        printf("    %d      ", reservation_stations[i][j]);
      }else if(j == 1){
        switch (reservation_stations[i][j]) {
          case 1:
            printf("   ADD     ");
            break;
          case 2:
            printf("   ADDI    ");
            break;
          case 3:
            printf("   ADDU    ");
            break;
          case 4:
            printf("   LUI     ");
            break;
          case 5:
            printf("    J      ");
            break;
          case 6:
            printf("   LW      ");
            break;
          case 7:
            printf("   NOP     ");
            break;
          case 8:
            printf("   SUB     ");
            break;
          case 9:
            printf("   SW      ");
            break;
          case 10:
            printf("   AND     ");
            break;
          case 11:
            printf("   XOR     ");
            break;
          case 12:
            printf("   NOR     ");
            break;
          case 13:
            printf("   OR      ");
            break;
          case 14:
            printf("  SUBU     ");
            break;
          case 15:
            printf("   DIV     ");
            break;
          case 16:
            printf("   BEQ     ");
            break;
          case 17:
            printf("   JAL     ");
            break;
          case 18:
            printf("   JR      ");
            break;
          case 19:
            printf("   JALR    ");
            break;
          case 20:
            printf("   SLT     ");
            break;
          case 21:
            printf("   BNE     ");
            break;
          case 22:
            printf("   BLEZ    ");
            break;
          case 23:
            printf("   BGTZ    ");
            break;
          case 24:
            printf("   ADDIU   ");
            break;
          case 25:
            printf("   SLTI    ");
            break;
          case 26:
            printf("   SLTIU   ");
            break;
          case 27:
            printf("   ANDI    ");
            break;
          case 28:
            printf("   ORI     ");
            break;
          case 29:
            printf("   XORI    ");
            break;
          case 30:
            printf("   MULT    ");
            break;
          case 31:
            printf("   MUL     ");
            break;
          case 32:
            printf("   SLTU    ");
            break;
          case 33:
            printf("   MOVN    ");
            break;
          case 34:
            printf("   MOVZ    ");
            break;
          case 35:
            printf("   MFHI    ");
            break;
          case 36:
            printf("   MTHI    ");
            break;
          case 37:
            printf("   MFLO    ");
            break;
          case 38:
            printf("   MTLO    ");
            break;
          case 39:
            printf("   SLL     ");
            break;
          case 40:
            printf("   SLLV    ");
            break;
          case 41:
            printf("   SRA     ");
            break;
          case 42:
            printf("   SRAV    ");
            break;
          case 43:
            printf("   SRL     ");
            break;
          case 44:
            printf("   SRLV    ");
            break;
          case 45:
            printf("   DIVU    ");
            break;
          case 46:
            printf("   MULTU   ");
            break;
          case 47:
            printf("   CLO     ");
            break;
          case 48:
            printf("   CLZ     ");
            break;
          case 49:
            printf("   BLTZ    ");
            break;
          case 50:
            printf("   BLTZAL  ");
            break;
          case 51:
            printf("   BGEZ    ");
            break;
          case 52:
            printf("   BGEZAL  ");
            break;
          case 53:
            printf("   LWL     ");
            break;
          case 54:
            printf("   LWR     ");
            break;
          case 55:
            printf("   SWL     ");
            break;
          case 56:
            printf("   SWR     ");
            break;
          default:
            printf("   ---     ");
        }
      }else if(j == 2 || j == 5 || j == 6){
        if(reservation_stations[i][j] == 0){
          printf("00   ");
        }else{
          switch (count_digit(reservation_stations[i][j])) {
            case 1:
              printf("0%d   ", reservation_stations[i][j]);
              break;
            default:
              printf("%d   ", reservation_stations[i][j]);
          }
        }
      }else{
        if(reservation_stations[i][j] >= 0){
          printf("0");
        }
        switch (count_digit(reservation_stations[i][j])) {
          case 1:
            printf("000000000%d  ", reservation_stations[i][j]);
            break;
          case 2:
            printf("00000000%d  ", reservation_stations[i][j]);
            break;
          case 3:
            printf("0000000%d  ", reservation_stations[i][j]);
            break;
          case 4:
            printf("000000%d  ", reservation_stations[i][j]);
            break;
          case 5:
            printf("00000%d  ", reservation_stations[i][j]);
            break;
          case 6:
            printf("0000%d  ", reservation_stations[i][j]);
            break;
          case 7:
            printf("000%d  ", reservation_stations[i][j]);
            break;
          case 8:
            printf("00%d  ", reservation_stations[i][j]);
            break;
          case 9:
            printf("0%d  ", reservation_stations[i][j]);
            break;
          case 10:
            printf("%d  ", reservation_stations[i][j]);
            break;
        }
      }
    }
    foreground(RED);
    printf("        |\n");
    style(RESETALL);
    }
    foreground(RED);
    printf("-----------------------------------------------------------------------------------------------\n");
    style(RESETALL);
}

void start_reservation_stations(int reservation_stations[16][8]){
  int i, j;
  for(i = 1; i < 16; i++){
    for(j = 0; j < 8; j++){
      reservation_stations[i][j] = 0;
    }
  }
}


void read_memory(byte *map){
  unsigned int i;
  byte t;
  foreground(RED);
  printf("---------------------------------------------------------------------------------\n");
  printf("                          DATA MEMORY                                           |\n");
  printf("---------------------------------------------------------------------------------\n");
  style(RESETALL);
  for(i = DATA_SEGMENT; i < data_segment; i++){
    t = map[i];
    printf("%s\n", t.bits);
  }
  foreground(RED);
  printf("---------------------------------------------------------------------------------\n");
  printf("                        INSTRUCTION MEMORY                                      |\n");
  printf("---------------------------------------------------------------------------------\n");
  style(RESETALL);
  for(i = 536870912; i < 536870928; i++){
    t = map[i];
    printf("%s\n", t.bits);
  }
  foreground(RED);
  printf("---------------------------------------------------------------------------------\n");
  printf("                        INSTRUCTION MEMORY                                      |\n");
  printf("---------------------------------------------------------------------------------\n");
  style(RESETALL);
  for(i = TEXT_SEGMENT; i < text_segment; i++){
    t = map[i];
    printf("%d %s\n", i, t.bits);
  }
}

void printf_if(char i[], int address){
  printf("        IF: %s\n", i);
  printf("   ADDRESS: %d\n\n", address);
}

void printf_id(char i[]){
  printf("        ID: %s\n\n", i);
}

void printf_cache_instruction_miss(char instruction[]){
  if(option == OP_DETAILED){
    printf("CACHE INSTRUCTION\n");
    printf("CACHE MISS: %s\n\n", instruction);
  }
}

void printf_data_instruction_miss(char data[]){
  if(option == OP_DETAILED){
    printf("CACHE DATA\n");
    printf("CACHE MISS: %s\n\n", data);
  }
}

void create_labels(FILE *file_open, FILE *file_out){
  int linha = 1, control_line = 0;
  unsigned int data_seg = 268435456;
  unsigned int text_seg = 4;
  if(file_open != NULL){
    char buffer;
    char word[100];
    int index = 0;
    /*
     *Se data == 1, então estamos no .data, caso contrário, estamos no .text
     */
    int data = 0;
    memset(word, '\0', 100);
    while((buffer = fgetc(file_open)) != EOF){
        if(buffer != ' '){
            if(buffer == '\n'){
              if(control_line != 1){
                control_line = 1;
                linha++;
                if(data == 1 && linha > 1){
                  data_seg = data_seg + 4;
                }else if(data == 0 && linha > 1){
                  text_seg = text_seg + 4;
                }
              }
              index = 0;
              memset(word, '\0', 100);
            }else{
              control_line = 0;
              switch(buffer){
                case 'a': case 'c': case 'd': case 'e': case 'f': case 'g': case 'h': case 'i': case 'j':
                case 'k': case 'm': case 'n': case 'o': case 'p': case 'q': case 'r': case 't':
                case 'u': case 'v': case 'w': case 'x': case 'y': case 'z': case 'A': case 'C': case 'D':
                case 'E': case 'F': case 'G': case 'H': case 'I': case 'J': case 'K': case 'M': case 'N':
                case 'O': case 'P': case 'Q': case 'R': case 'T': case 'U': case 'V': case 'W': case 'X':
                case 'Y': case 'Z': case '_': case 'b': case 'B':
                case '0': case '1': case '2': case '3': case '4': case '5': case '6': case '7': case '8': case '9':
                  word[index] = buffer;
                  index++;
                  break;
                case 'L':
                case 'l':
                case 's':
                case 'S':
                  word[index] = buffer;
                  index++;
                  if(data != 1){
                    buffer = fgetc(file_open);
                    if(buffer == 'w' || buffer == 'W'){
                      word[index] = buffer;
                      index++;
                      buffer = fgetc(file_open);
                      if(buffer != ' '){
                        word[index] = buffer;
                        index++;
                        break;
                      }
                      while(buffer == ' '){
                        index = 0;
                        memset(word, '\0', 100);
                        buffer = fgetc(file_open);
                      }
                      while(buffer != ' '){
                        word[index] = buffer;
                        index++;
                        buffer = fgetc(file_open);
                      }
                      while(buffer == ' '){
                        index = 0;
                        memset(word, '\0', 100);
                        buffer = fgetc(file_open);
                      }
                      if(buffer != '0' && buffer != '1' && buffer != '2' && buffer != '3' && buffer != '4' && buffer != '5' && buffer != '6' &&
                      buffer != '7' && buffer != '8' && buffer != '9'){
                        text_seg = text_seg + 8;
                        index = 0;
                        memset(word, '\0', 100);
                      }else{
                        word[index] = buffer;
                        index++;
                      }
                    }else if(buffer == ' '){
                      index = 0;
                      memset(word, '\0', 100);
                    }else if(buffer == ':'){
                      word[index] = '\0';
                      if(data == 1){
                        fprintf(file_out, "%s %u\n", word, data_seg);
                      }else{
                        fprintf(file_out, "%s %u\n", word, text_seg);
                      }
                      index = 0;
                      memset(word, '\0', 100);
                    }else{
                      word[index] = buffer;
                      index++;
                    }
                  }
                  break;
                case '.': //apenas .data e .text poderam ter '.' (tratando o .word tbm)
                  buffer = fgetc(file_open);
                  if(buffer != EOF && buffer != 'w' && buffer != 'g'){
                    linha = 0;
                    data = !data;
                  }
                  if(buffer == 'g'){
                    linha = 0;
                  }
                  index = 0;
                  memset(word, '\0', 100);
                  break;
                case ':':
                      control_line = 1;
                      word[index] = '\0';
                      if(data == 1){
                        fprintf(file_out, "%s %u\n", word, data_seg);
                      }else{
                        fprintf(file_out, "%s %u\n", word, text_seg);
                      }
                      index = 0;
                      memset(word, '\0', 100);
                      break;
                case ',':
                      if(data == 1){
                        data_seg = data_seg + 4;
                      }
                      break;
              }
            }
        }else{
          index = 0;
          memset(word, '\0', 100);
        }
    }
  }
}

void start_register_bank(register_type register_bank[]){
  int i;
  for(i = 0; i < 34; i++){
    register_bank[i].qi = 0;
    register_bank[i].value = 0;
  }
}

void printf_register_bank(register_type register_bank[]){
  int i;
  foreground(RED);
  printf("-------------------------------------------\n");
  printf("|             REGISTER BANK               |\n");
  printf("-------------------------------------------\n");
  printf("               QI   VALUE\n\n");
  style(RESETALL);
  for(i = 0; i < 32; i++){
    if( i < 10){
      foreground(RED);
      printf("           0%d", i);
      style(RESETALL);
    }else{
      foreground(RED);
      printf("           %d", i);
      style(RESETALL);
    }
    printf("   %d     %d\n", register_bank[i].qi, register_bank[i].value);
  }
  printf("\n");
  foreground(RED);
  printf("           lo");
  style(RESETALL);
  printf("   %d     %d\n", register_bank[32].qi, register_bank[32].value);
  foreground(RED);
  printf("           hi");
  style(RESETALL);
  printf("   %d     %d\n", register_bank[33].qi, register_bank[33].value);
}

void _head(){
  system("clear");
  cabecalho();
  printf("\n         OPTION: ");
  switch (option) {
    case 1:
      printf("HELP\n");
      break;
    case 2:
      printf("DETAILED\n");
      break;
    default:
      printf("NORMAL\n");
  }
  foreground(RED);
  printf("-----------------------------------------------------------------------------------------------\n");
  if(option != 1) printf("starting program...\n");
  style(RESETALL);
}
