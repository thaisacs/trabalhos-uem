#include <stdio.h>
#include <stdlib.h>
#include "memory.h"
#include "compiler.h"
#include "processor.h"
#include "colors.h"
#include "cache.h"
#include "utils.h"
#include "options.h"
#include "string.h"
#include "so.h"

int main(int argc, char *argv[]){
  FILE *file;
  if(argc != 1){
    if(argc == 2){
      if(!strcmp(argv[1], "-h")){
        option = OP_HELP;
      }else{
        to_compile(argv[1]);
        option = OP_NORMAL;
      }
    }else if(argc == 3){
      if(!strcmp(argv[1], "-h")){
        option = OP_HELP;
      }else if(!strcmp(argv[1], "-d")){
        option = OP_DETAILED;
        to_compile(argv[2]);
      }else{
        printf("option does not exist\n");
        exit(1);
      }
    }else{
      exit(1);
    }
  }
  _head();
  if(option == OP_HELP){
    _help();
  }else{
    file = fopen("compiler/out.o", "r");
    if(file == NULL){
      printf("file not found\n");
      exit(1);
    }
    memory = create_memory();
    li = create_cache();
    ld = create_cache();
    store_program(memory, file);
    fclose(file);
    start();
  }
  return 0;
}
