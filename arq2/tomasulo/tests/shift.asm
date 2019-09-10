.data
.text
.globl  main
main:  addi $v0, $zero, 5
       syscall
       add $s0, $zero, $v0
       addi $v0, $zero, 1
       sll  $a0, $s0, 1
       syscall
       sra  $a0, $s0, 1
       syscall
fim:   addi $v0, $zero, 10
       syscall
