.data
num:   .word 0
v1:    .word 0
v2:    .word 0
.text
.globl main
subi:  lw   $t0, v1
       lw   $t1, v2
       sub  $t0, $t0, $t1
       sw   $t0, num
       jal  print
       j    fim
soma:  lw $t0, v1
       lw $t1, v2
       add  $t0, $t1, $t0
       sw   $t0, num
       jal  print
       j    fim
multi: lw   $t0, v1
       lw   $t1, v2
       mul $t0, $t0, $t1
       sw   $t0, num
       jal  print
       j    fim
divi:  lw   $t0, v1
       lw   $t1, v2
       div  $t0, $t1
       mflo $t0
       sw   $t0, num
       jal  print
       mfhi $t0
       sw   $t0, num
       jal  print
       j    fim
main:  addi $v0, $zero, 5
       syscall
       add  $t0, $zero, $v0

       addi $v0, $zero, 5
       syscall
       sw   $v0, v1
       addi $v0, $zero, 5
       syscall
       sw   $v0, v2

       addi $t1, $zero, 1
       beq  $t0, $t1, soma
       addi $t1, $zero, 2
       beq  $t0, $t1, subi
       addi $t1, $zero, 3
       beq  $t0, $t1, multi
       addi $t1, $zero, 4
       beq  $t0, $t1, divi
fim:   addi $v0, $zero, 10
       syscall
print: lw   $a0, num($zero)
       addi $v0, $zero, 1
       syscall
       jr $ra
#entrada: um número
#saida:
# se o número de entrada for 1, lê dois números e soma
# se o número de entrada for 2, lê dois números e subtrai
# se o número de entrada for 3, lê dois números e multiplica
# se o número de entrada for 4, lê dois números e divide
