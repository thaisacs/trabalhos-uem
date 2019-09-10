#ifndef TOMASULO_H
#define TOMASULO_H

int reservation_stations[16][8];

struct busCDB{
  int controlBus;
  int addressBus;
  int dataBus;
} typedef CDB;

int control_ls;
int control_rs;

CDB bussCDB;

#define QTD_RS 15
//linha
#define ADD1 1
#define ADD2 2
#define ADD3 3
#define MUL1 4
#define MUL2 5
#define LD1 6
#define LD2 7
#define LD3 8
#define LD4 9
#define LD5 10
#define LD6 11
#define LD7 12
#define LD8 13
#define LD9 14
#define LD10 15
//colunas
#define BUSY 0
#define OP   1
#define D    2
#define VJ   3
#define VK   4
#define QJ   5
#define QK   6
#define A    7
//op
#define ADD 1
#define ADDI 2
#define ADDU 3
#define LUI 4
#define J 5
#define LW 6
#define NOP 7
#define SUB 8
#define SW 9
#define AND 10
#define XOR 11
#define NOR 12
#define OR 13
#define SUBU 14
#define DIV 15
#define BEQ 16
#define JAL 17
#define JR 18
#define JALR 19
#define SLT  20
#define BNE 21
#define BLEZ 22
#define BGTZ 23
#define ADDIU 24
#define SLTI 25
#define SLTIU 26
#define ANDI 27
#define ORI 28
#define XORI 29
#define MULT 30
#define MUL 31
#define SLTU 32
#define MOVN 33
#define MOVZ 34
#define MFHI 35
#define MTHI 36
#define MFLO 37
#define MTLO 38
#define SLL 39
#define SLLV 40
#define SRA 41
#define SRAV 42
#define SRL 43
#define SRLV 44
#define DIVU 45
#define MULTU 46
#define CLO 47
#define CLZ 48
#define BLTZ 49
#define BLTZAL 50
#define BGEZ 51
#define BGEZAL 52
#define LWL 53
#define LWR 54
#define SWL 55
#define SWR 56
//clocks
#define CLOCK_AND 1
#define CLOCK_OR 1
#define CLOCK_NOR 1
#define CLOCK_XOR 1
#define CLOCK_ADD 2
#define CLOCK_ADDU 2
#define CLOCK_SUB 2
#define CLOCK_SUBU 2
#define CLOCK_ADDI 2
#define CLOCK_LW 4
#define CLOCK_SW 4
#define CLOCK_LUI 4
#define CLOCK_NOP 1
#define CLOCK_DIV 5
#define CLOCK_MULT 5
#define CLOCK_MUL 5
#define CLOCK_BEQ 2
#define CLOCK_BNE 2
#define CLOCK_SLT 2
#define CLOCK_BLEZ 2
#define CLOCK_BGTZ 2
#define CLOCK_SLTU 2
#define CLOCK_SLTIU 2
#define CLOCK_SLTI 2
#define CLOCK_MOVN 2
#define CLOCK_MOVZ 2
#define CLOCK_MFHI 2
#define CLOCK_MTLO 2
#define CLOCK_MFLO 2
#define CLOCK_MTLO 2
#define CLOCK_MTHI 2
#define CLOCK_JR 1
#define CLOCK_JALR 1
#define CLOCK_SLL 1
#define CLOCK_SLLV 1
#define CLOCK_SRA 1
#define CLOCK_SRAV 1
#define CLOCK_SRL 1
#define CLOCK_SRLV 1
#define CLOCK_ANDI 1
#define CLOCK_ORI 1
#define CLOCK_XORI 1
#define CLOCK_ADDIU 2
#define CLOCK_DIVU 5
#define CLOCK_MULTU 5
#define CLOCK_CLZ 1
#define CLOCK_CLO 1
#define CLOCK_BLTZ 2
#define CLOCK_BLTZAL 2
#define CLOCK_BGEZ 2
#define CLOCK_BGEZAL 2
#endif
