.data
num: .word 0
.text
.globl main
 main: addi $v0,$zero,5
      syscall
      addi $a0,$v0,0
      jal fact
      addi $a0,$v0,0
      addi $v0,$zero, 1
      syscall
      addi $v0,$zero, 10
      syscall
fact: addi $sp,$sp,-8
      sw $ra, 4($sp)
      sw $a0, 0($sp)
      addi $t3, $zero, 1
      slt $t0,$a0,$t3
      beq $t0,$zero,l1
      addi $v0,$zero,1
      addi $sp,$sp,8
      jr $ra
l1:   addi $a0,$a0,-1
      jal fact
      lw $a0, 0($sp)
      lw $ra, 4($sp)
      addi $sp,$sp,8
      mul $v0,$a0,$v0
      jr $ra
#entrada: pede um número
#saida:   fatorial do número lido
