#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <utils.h>

extern int yyparse();
extern int yylineno;
extern FILE *yyin;
extern FILE *yyout;

void to_compile(char nomeArq[]){
  FILE *file_open =  fopen(nomeArq, "r");
  if(file_open == NULL){
    printf("file not found\n");
    exit(1);
  }
  FILE *file_out =  fopen("compiler/labels.out", "w");
  create_labels(file_open, file_out);
  fclose(file_open);
  fclose(file_out);
  yyin = fopen(nomeArq, "r");
  yyout = fopen("./compiler/out.o", "w");
  yyparse();
  fclose(yyout);
}
