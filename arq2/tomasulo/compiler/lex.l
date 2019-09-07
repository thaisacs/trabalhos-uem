%option noyywrap
%option noinput
%option nounput
%option yylineno
%{
  #include <stdio.h>
  #include <string.h>
  #include "grammar.tab.h"
  extern int count_data;
%}

whitespace        [\r\t\v\f]
type              .word
number            -?[0-9]+
comments          #(.)*
letter            [a-zA-Z]
labelT            _*{letter}(_|{letter}|{number})*:
labelC            _*{letter}(_|{letter}|{number})*
main              .globl[ ]+main
%%

{labelT}          {                                              }
".data"           { return DATA;                                 }
".text"           { return TEXT;                                 }
{main}            { return GLOBAL;                               }
{type}            { return TYPE;                                 }
{number}          { yylval.nint = atof(yytext);  return NUMBER;  }
{comments}        {                                              }
","               { return V;                                    }
"("               { return A_PAREN;                              }
")"               { return F_PAREN;                              }

"add"             { return ADD;                                  }
"addi"            { return ADDI;                                 }
"addu"            { return ADDU;                                 }
"addiu"           { return ADDIU;                                }

"sub"             { return SUB;                                  }
"subu"            { return SUB;                                  }

"and"             { return AND;                                  }
"andi"            { return ANDI;                                 }
"or"              { return OR;                                   }
"ori"             { return ORI;                                  }
"xor"             { return XOR;                                  }
"xori"            { return XORI;                                 }
"nor"             { return NOR;                                  }

"mul"             { return MUL;                                  }
"div"             { return DIV;                                  }
"divu"            { return DIVU;                                 }
"mult"            { return MULT;                                 }
"multu"           { return MULTU;                                }

"clo"             { return CLO;                                  }
"clz"             { return CLZ;                                  }

"lw"              { return LW;                                   }
"sw"              { return SW;                                   }
"lui"             { return LUI;                                  }
"lwl"             { return LWL;                                  }
"lwr"             { return LWR;                                  }
"swl"             { return SWL;                                  }
"swr"             { return SWR;                                  }

"slt"             { return SLT;                                  }
"slti"            { return SLTI;                                 }
"sltu"            { return SLTU;                                 }
"sltiu"           { return SLTIU;                                }

"sll"             { return SLL;                                  }
"sllv"            { return SLLV;                                 }
"sra"             { return SRA;                                  }
"srl"             { return SRL;                                  }
"srlv"            { return SRLV;                                 }
"srav"            { return SRAV;                                 }

"j"               { return J;                                    }
"jal"             { return JAL;                                  }
"jr"              { return JR;                                   }
"jalr"            { return JALR;                                 }

"blez"            { return BLEZ;                                 }
"beq"             { return BEQ;                                  }
"bne"             { return BNE;                                  }
"bgtz"            { return BGTZ;                                 }
"bltz"            { return BLTZ;                                 }
"bltzal"          { return BLTZAL;                               }
"bgez"            { return BGEZ;                                 }
"bgezal"          { return BGEZAL;                               }

"movn"            { return MOVN;                                 }
"movz"            { return MOVZ;                                 }

"mfhi"            { return MFHI;                                 }
"mflo"            { return MFLO;                                 }
"mthi"            { return MTHI;                                 }
"mtlo"            { return MTLO;                                 }

"syscall"         { return SYSCALL;                              }
"nop"             { return NOP;                                  }

"$zero"           { yylval.str = strdup("00000"); return REG;    }
"$at"             { yylval.str = strdup("00001"); return REG;    }
"$v0"             { yylval.str = strdup("00010"); return REG;    }
"$v1"             { yylval.str = strdup("00011"); return REG;    }
"$a0"             { yylval.str = strdup("00100"); return REG;    }
"$a1"             { yylval.str = strdup("00101"); return REG;    }
"$a2"             { yylval.str = strdup("00110"); return REG;    }
"$a3"             { yylval.str = strdup("00111"); return REG;    }
"$t0"             { yylval.str = strdup("01000"); return REG;    }
"$t1"             { yylval.str = strdup("01001"); return REG;    }
"$t2"             { yylval.str = strdup("01010"); return REG;    }
"$t3"             { yylval.str = strdup("01011"); return REG;    }
"$t4"             { yylval.str = strdup("01100"); return REG;    }
"$t5"             { yylval.str = strdup("01101"); return REG;    }
"$t6"             { yylval.str = strdup("01110"); return REG;    }
"$t7"             { yylval.str = strdup("01111"); return REG;    }
"$s0"             { yylval.str = strdup("10000"); return REG;    }
"$s1"             { yylval.str = strdup("10001"); return REG;    }
"$s2"             { yylval.str = strdup("10010"); return REG;    }
"$s3"             { yylval.str = strdup("10011"); return REG;    }
"$s4"             { yylval.str = strdup("10100"); return REG;    }
"$s5"             { yylval.str = strdup("10101"); return REG;    }
"$s6"             { yylval.str = strdup("10110"); return REG;    }
"$s7"             { yylval.str = strdup("10111"); return REG;    }
"$t8"             { yylval.str = strdup("11000"); return REG;    }
"$t9"             { yylval.str = strdup("11001"); return REG;    }
"$k0"             { yylval.str = strdup("11010"); return REG;    }
"$k1"             { yylval.str = strdup("11011"); return REG;    }
"$gp"             { yylval.str = strdup("11100"); return REG;    }
"$sp"             { yylval.str = strdup("11101"); return REG;    }
"$fp"             { yylval.str = strdup("11110"); return REG;    }
"$ra"             { yylval.str = strdup("11111"); return REG;    }
{labelC}          { yylval.str = strdup(yytext);  return LABEL;  }

[ ]               {                                              }
"\n"              {                                              }

%%
