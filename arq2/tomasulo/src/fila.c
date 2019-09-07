#include <stdio.h>
#include <stdlib.h>
#include "fila.h"

fila* criaFila(){
  fila *f = (fila*) malloc(sizeof(fila));
  if(f != NULL){
    f->fim = NULL;
    f->inicio = NULL;
  }
  return f;
}

int filaVazia(fila *Q){
  if(Q->inicio == NULL){
    return 1;
  }
  return 0;
}

int insereFila(fila *Q, type instruct){
  no *aux = (no*) malloc(sizeof(no));
  if(aux == NULL){
    return 0;
  }
  aux->dados = instruct;
  aux->prox = NULL;
  if(Q->fim == NULL){
    Q->inicio = aux;
  }else{
    Q->fim->prox = aux;
  }
  Q->fim = aux;
  return 1;
}

type* removeFila(fila *Q){
  no *R = Q->inicio;
  if(filaVazia(Q)) return NULL;
  type *aux = (type*) malloc(sizeof(type));
  type t = R->dados;
  aux->op = t.op;
  aux->rd = t.rd;
  aux->rs = t.rt;
  aux->rt = t.rt;
  aux->address = t.address;
  aux->imm = t.imm;
  Q->inicio = Q->inicio->prox;
  if(Q->inicio == NULL){
    Q->fim = NULL;
  }
  free(R);
  return aux;
}

type* primeiroFila(fila *Q){
  no *R = Q->inicio;
  if(filaVazia(Q)) return NULL;
  type *aux = (type*) malloc(sizeof(type));
  type t = R->dados;
  aux->op = t.op;
  aux->rd = t.rd;
  aux->rs = t.rs;
  aux->rt = t.rt;
  aux->imm = t.imm;
  aux->address = t.address;
  return aux;
}

void percorreFila(fila *Q){
  if(!filaVazia(Q)){
    no *R = Q->inicio;
    while(R!= NULL){
      type t = R->dados;
      printf("%d\n", t.op);
      R = R->prox;
    }
  }
}
