.data
_vet:  .word 10
num:   .word 0
_vet2: .word 10, 5, 0
.text
.globl  main
main:  addi $s1, $zero, 2
       addi $s0, $zero, 3
       addi $v0, $zero, 1
       or  $a0, $s1, $s0
       # syscall
       and $a0, $s1, $s0
       # syscall
       xor $a0, $s1, $s0
       # syscall
       nor $a0, $s1, $s0
       # syscall
       ori $a0, $s1, 3
       # syscall
       andi $a0, $s1, 3
       # syscall
       xori $a0, $s1, 3
       # syscall
fi_m:  addi $v0, $zero, 10
       syscall
