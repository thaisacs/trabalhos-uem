.data
.text
.globl main
fibonacci:      addi $sp, $sp, -12
                sw $ra, 8($sp)
                sw $s0, 4($sp)
                sw $s1, 0($sp)
                add $s0, $zero, $a0
                addi $v0, $zero, 1
                addi $t3, $s0, -2
                blez $t3, fibonacciExit
                addi $a0, $s0, -1
                jal fibonacci
                add $s1,$zero, $v0
                addi $a0, $s0, -2
                jal fibonacci
                add $v0, $s1, $v0
fibonacciExit:  lw $ra, 8($sp)
                lw $s0, 4($sp)
                lw $s1, 0($sp)
                addi $sp, $sp, 12
                jr $ra
main:           addi $v0, $zero, 5
                syscall
                add $a0, $zero, $v0
                jal fibonacci
                add $a1,$zero, $v0
                addi $v0, $zero, 1
                add $a0, $zero, $a1
                syscall
                addi $v0, $zero, 10
                syscall
#entrada: pede um número
#saida:   fibonacci do número lido
