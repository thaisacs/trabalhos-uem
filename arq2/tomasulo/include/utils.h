#ifndef UTILS_H
#define UTILS_H
#include <registers.h>
#include <memory.h>
#include <cache.h>

void start_memory(byte *map);
void substring(char string[], char dest[], int inicio, int fim);
void cabecalho();
byte* create_memory();
void store_program(byte *map, FILE *file);
void read_memory(byte *map);
void _help();
cache* create_cache();
int count_digit(int number);
void printf_reservation_stations(int reservation_stations[16][8]);
void start_reservation_stations(int reservation_stations[16][8]);
void printf_if(char i[], int address);
void printf_cache_instruction_miss(char instruction[]);
void printf_data_instruction_miss(char data[]);
void create_labels(FILE *file_open, FILE *file_out);
void start_register_bank(register_type register_bank[]);
void printf_register_bank(register_type register_bank[]);
void _head();
void printf_id(char i[]);

#endif
