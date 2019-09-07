.data
vet:  .word 5, 0, 0
.text
.globl   main
teste: addi $a0, $ra, 0
       addi $v0, $zero, 1
       syscall
       jalr $ra
main:  addi $a0, $zero, 5
       sw   $a0, vet
       addi $v0, $zero, 1
       lw   $a0, 0($gp)
       lw   $a0, vet
       syscall
fim:   addi $v0, $zero, 10
       syscall
#testa o write back da cache
#alterar gp
