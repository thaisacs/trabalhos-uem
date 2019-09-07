#ifndef SO_H
#define SO_H

#define PAUSE_SYSCALL 1
#define PAUSE_BRANCH 2
#define PAUSE_JUMP 3
#define PAUSE_MOV 4

int program_finaly;
int pause;

int system_call(int op);
int exit_program();
int tomasulo_empty();
void start();
#endif
