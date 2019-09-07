.data
A: .word 40, 5, 0, -7, 84, 90, 10, -20, 1, 3
.text
.globl main
main:   addi $a0, $zero, 10
        sll $a0, $a0, 2
outer:  addi $t0, $a0, -8
        addi $t1, $zero, 0
inner:  addi $v1, $t0, 4
        lw $t2, A($v1)
        lw $t3, A($t0)
        sub $v1,$t2, $t3
        bgtz $v1, nout
        sw $t2, A($t0)
        addi $v1, $t0, 4
        sw $t3, A($v1)
        addi $t1, $zero, 1
nout:   addi $t0, $t0, -4
        bgez $t0, inner
        addi $v1, $zero, 0
        bne $t1, $v1, outer
        addi $t0, $zero, 10
        addi $t1, $zero, 0
loop:   lw   $a0, A($t1)
        addi $v0, $zero, 1
        syscall
        addi  $t1, $t1, 4
        addi  $t0, $t0, -1
        bgtz  $t0, loop
fim:    addi $v0, $zero, 10
        syscall
#entrada: nula
#saida:   vetor A ordenado e escrito na tela em ordem
