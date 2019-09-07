#ifndef CONVERTERS_H
#define CONVERTERS_H

void to_convertDB(char byte[], unsigned int num, int tam);
unsigned int to_convertBD(char binario[]);
long int twos_complementsBD(char num[], int tam);
void twos_complementsDB(char num_convertido[], int num, int tam);
void set_instruction(char m[], char rd[], char rs[], char rt[], int shamp, char func[]);
void set_instruction_imm(char m[], char rt[], char rs[], int num);
void set_instruction_jump(char m[], char label[]);
void set_instruction_branch(char m[], char rt[], char rs[], char label[]);
void set_load_store(char m[], char rs[], char rt[], char label[]);
void set_syscall(char m[], char rd[], char rs[], char rt[], int shamp, char func[]);
void set_load_store_imm(char m[], char rs[], char rt[], int address);
#endif
