#ifndef FILA_H
#define FILA_H


struct type{
  int op, rd, rs, rt, address, imm;
}typedef type;

struct no{
  struct type dados;
  struct no *prox;
}typedef no;

struct fila{
  no *inicio;
  no *fim;
}typedef fila;

fila *fi;

fila* criaFila();
void percorreFila(fila *Q);
type* removeFila(fila *Q);
type* primeiroFila(fila *Q);

#endif
