#ifndef MEMORY_H
#define MEMORY_H

struct byte{
  char bits[9];
};

typedef struct byte byte;

byte *memory;

void store();
void load();

#endif
