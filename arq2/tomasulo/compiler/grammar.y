%{
  #include <stdio.h>
  #include <stdlib.h>
  #include "converters.h"
  int yylex();
  int yyerror();
  extern FILE *yyout;
  int count_data = 0;                    //controla a quantidade de dados para preencher com 0 os 400 bytes
%}

%union
{
  char *str;
  int nint;
}
%token DATA TEXT GLOBAL

%token <nint> NUMBER
%token TYPE
%token <str> REG LABEL
%token ADD    ADDU    ADDI      ADDIU   AND      ANDI   CLO    CLZ     DIV     DIVU    MULT   MULTU   MUL    LWL     LWR
       NOR    OR      ORI       SLL     SLLV     SRA    SRAV   SRL     SRLV    XOR     XORI   SUB     SUBU   SLT     SLTU
       SLTI      SLTIU   TEQ      TEQI   TNE    TNEQ    TGE     TGEU    TGEI   TGEIU   TLT    TLTU    TLTI   SWL     SWR
       TLTIU  BEQ     BGEZ      BGEZAL  BGTZ     BLTZAL BLTZ   BNE     BLEZ    MFHI    MFLO    MTHI   MTLO    MFC0   MFC1
       MTC0   MTC1    MOVN      MOVZ    JR       JAL    J      JALR    LW      SW
       LUI    ERET    SYSCALL   NOP
%token A_PAREN
       F_PAREN
       V
%start program

%%
program:  dataSection textSection { }
       ;

dataSection: /*empty*/                     { int i; for(i=count_data;i<100;i++){ fprintf(yyout, "%c\n", '#');}            }
             | DATA numbers                { int i; for(i=count_data;i<100;i++){ fprintf(yyout, "%c\n", '#');} set_instruction_jump("000010", "main");     }
             ;

textSection: /*empty*/
           | TEXT GLOBAL instructions
           ;

numbers: /* empty */
       | number nums numbers
       ;

number: TYPE NUMBER                                  { fprintf(yyout, "%d\n", $2); count_data++;                          }
      ;

nums: /*empty*/
    | nums V NUMBER                                  { fprintf(yyout, "%d\n", $3); count_data++;                          }
    ;

instructions: /* empty */
            | instruction instructions
            ;

instruction: ADD    REG V REG V REG                  { set_instruction("000000", $2, $4, $6, 0,"100000");                 }
           | ADDI   REG V REG V NUMBER               { set_instruction_imm("001000", $2, $4, $6);                         }
           | ADDU   REG V REG V REG                  { set_instruction("000000", $2, $4, $6, 0,"100001");                 }
           | ADDIU  REG V REG V NUMBER               { set_instruction_imm("001001", $2, $4, $6);                         }
           | SUB    REG V REG V REG                  { set_instruction("000000", $2, $4, $6, 0, "100010");                }
           | SUBU   REG V REG V REG                  { set_instruction("000000", $2, $4, $6, 0, "100011");                }
           | LUI    REG V NUMBER                     { set_instruction_imm("001111", $2, "00000", $4);                    }

           | LW     REG V LABEL A_PAREN REG F_PAREN  { set_load_store("100011", $6, $2, $4);                              }
           | SW     REG V LABEL A_PAREN REG F_PAREN  { set_load_store("101011", $6, $2, $4);                              }
           | LW     REG V LABEL                      { set_load_store("100011", "00000", $2, $4);                         }
           | SW     REG V LABEL                      { set_load_store("101011", "00000", $2, $4);                         }
           | LW     REG V NUMBER A_PAREN REG F_PAREN { set_instruction_imm("100011", $2, $6, $4);                         }
           | SW     REG V NUMBER A_PAREN REG F_PAREN { set_instruction_imm("101011", $2, $6, $4);                         }

           | LWL    REG V LABEL A_PAREN REG F_PAREN  { set_load_store("100010", $6, $2, $4);                              }
           | LWL    REG V LABEL                      { set_load_store("100010", "00000", $2, $4);                         }
           | LWL    REG V NUMBER A_PAREN REG F_PAREN { set_instruction_imm("100010", $2, $6, $4);                         }
           | LWR    REG V LABEL A_PAREN REG F_PAREN  { set_load_store("100110", $6, $2, $4);                              }
           | LWR    REG V LABEL                      { set_load_store("100110", "00000", $2, $4);                         }
           | LWR    REG V NUMBER A_PAREN REG F_PAREN { set_instruction_imm("100110", $2, $6, $4);                         }

           | SWL    REG V LABEL A_PAREN REG F_PAREN  { set_load_store("101010", $6, $2, $4);                              }
           | SWL    REG V LABEL                      { set_load_store("101010", "00000", $2, $4);                         }
           | SWL    REG V NUMBER A_PAREN REG F_PAREN { set_instruction_imm("101010", $2, $6, $4);                         }
           | SWR    REG V LABEL A_PAREN REG F_PAREN  { set_load_store("101110", $6, $2, $4);                              }
           | SWR    REG V LABEL                      { set_load_store("101110", "00000", $2, $4);                         }
           | SWR    REG V NUMBER A_PAREN REG F_PAREN { set_instruction_imm("101110", $2, $6, $4);                         }

           | AND    REG V REG V REG                  { set_instruction("000000", $2, $4, $6, 0, "100100");                }
           | ANDI   REG V REG V NUMBER               { set_instruction_imm("001100", $2, $4, $6);                         }
           | NOR    REG V REG V REG                  { set_instruction("000000", $2, $4, $6, 0, "100111");                }
           | OR     REG V REG V REG                  { set_instruction("000000", $2, $4, $6, 0, "100101");                }
           | ORI    REG V REG V NUMBER               { set_instruction_imm("001101", $2, $4, $6);                         }
           | XOR    REG V REG V REG                  { set_instruction("000000", $2, $4, $6, 0, "100110");                }
           | XORI   REG V REG V NUMBER               { set_instruction_imm("001110", $2, $4, $6);                         }

           | DIV    REG V REG                        { set_instruction("000000", "00000", $2, $4, 0, "011010");           }
           | DIVU   REG V REG                        { set_instruction("000000", "00000", $2, $4, 0, "011011");           }
           | MULT   REG V REG                        { set_instruction("000000", "00000", $2, $4, 0, "011000");           }
           | MULTU  REG V REG                        { set_instruction("000000", "00000", $2, $4, 0, "011001");           }

           | CLO    REG V REG                        { set_instruction("011100", $2, $4, "00000", 0, "100001");           }
           | CLZ    REG V REG                        { set_instruction("011100", $2, $4, "00000", 0, "100000");           }

           | SLL    REG V REG V NUMBER               { set_instruction("000000", $2, "00000", $4, $6, "000000");          }
           | SLLV   REG V REG V REG                  { set_instruction("000000", $2, $4, $6, 0, "000100");                }
           | SRA    REG V REG V NUMBER               { set_instruction("000000", $2, "00000", $4, $6, "000011");          }
           | SRAV   REG V REG V REG                  { set_instruction("000000", $2, $4, $6, 0, "000111");                }
           | SRL    REG V REG V NUMBER               { set_instruction("000000", $2, "00000", $4, $6, "000010");          }
           | SRLV   REG V REG V REG                  { set_instruction("000000", $2, $4, $6, 0, "000110");                }

           | SLT    REG V REG V REG                  { set_instruction("000000", $2, $4, $6, 0, "101010");                }
           | SLTU   REG V REG V REG                  { set_instruction("000000", $2, $4, $6, 0, "101011");                }
           | SLTI   REG V REG V NUMBER               { set_instruction_imm("001010", $2, $4, $6);                         }
           | SLTIU  REG V REG V NUMBER               { set_instruction_imm("001011", $2, $4, $6);                         }

           | BEQ    REG V REG V LABEL                { set_instruction_branch("000100", $2, $4, $6);                      }
           | BNE    REG V REG V LABEL                { set_instruction_branch("000101", $2, $4, $6);                      }
           | BGEZ   REG V LABEL                      { set_instruction_branch("000001", "00001", $2, $4);                 }
           | BGEZAL REG V LABEL                      { set_instruction_branch("000001", "10001", $2, $4);                 }
           | BGTZ   REG V LABEL                      { set_instruction_branch("000111", "00000", $2, $4);                 }
           | BLEZ   REG V LABEL                      { set_instruction_branch("000110", "00000", $2, $4);                 }
           | BLTZAL REG V LABEL                      { set_instruction_branch("000001", "10000",$2, $4);                 }
           | BLTZ   REG V LABEL                      { set_instruction_branch("000001", "00000", $2, $4);                 }
           | J      LABEL                            { set_instruction_jump("000010", $2);                                }
           | JAL    LABEL                            { set_instruction_jump("000011", $2);                                }
           | JR     REG                              { set_instruction("000000", "00000", $2, "00000", 0, "001000");      }
           | JALR   REG                              { set_instruction("000000", "11111", $2, "00000", 0, "001001");      }

           | MUL    REG V REG V REG                  { set_instruction("011100", $2, $4, $6, 0, "000010");                }

           | MOVN   REG V REG V REG                  { set_instruction("000000", $2, $4, $6, 0, "001011");                }
           | MOVZ   REG V REG V REG                  { set_instruction("000000", $2, $4, $6, 0, "001010");                }

           | MFHI   REG                              { set_instruction("000000", $2, "00000", "00000", 0, "010000");      }
           | MFLO   REG                              { set_instruction("000000", $2, "00000", "00000", 0, "010010");      }
           | MTHI   REG                              { set_instruction("000000", "00000", $2, "00000", 0, "010001");      }
           | MTLO   REG                              { set_instruction("000000", "00000", $2, "00000", 0, "010011");      }

           | SYSCALL                                 { set_instruction("000000", "00000", "00000", "00000", 0, "001100"); }
           | NOP                                     { set_instruction("000000", "00000", "00000", "00000", 0, "000000"); }
           ;
%%

int yyerror(char *s)
{
  printf("%s\n", s);
  exit(0);
}
