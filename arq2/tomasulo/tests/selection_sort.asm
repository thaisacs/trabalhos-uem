		.data
		.text
		.globl main
main:
		addi	$v0, $zero, 5
		syscall
		add	$s2, $zero, $v0
		sll	$s0, $v0, 2
		sub	$sp, $sp, $s0
		add	$s1, $zero, $zero
for_get:
    sub $t9, $s1, $s2
    bgez	$t9, exit_get
		sll	$t0, $s1, 2
		add	$t1, $t0, $sp
		addi	$v0, $zero, 5
		syscall
		sw	$v0, 0($t1)
		addi	$s1, $s1, 1
		j	for_get
exit_get:	add	$a0, $zero, $sp
		add	$a1, $zero, $s2
		jal	isort
		addi	$s1, $zero, 0
for_print:
    sub $t9, $s1, $s2
    bgez	$t9, exit_print
		sll	$t0, $s1, 2
		add	$t1, $sp, $t0
		lw	$a0, 0($t1)
		addi	$v0, $zero, 1
		syscall
		addi	$s1, $s1, 1
		j	for_print
exit_print:	add	$sp, $sp, $s0
		addi	$v0, $zero, 10
		syscall
isort:		addi	$sp, $sp, -20
		sw	$ra, 0($sp)
		sw	$s0, 4($sp)
		sw	$s1, 8($sp)
		sw	$s2, 12($sp)
		sw	$s3, 16($sp)
		addi 	$s0, $a0, 0
		addi	$s1, $zero, 0
		addi	$s2, $a1, -1
isort_for:
    sub $t9, $s1, $s2
    bgez 	$t9, isort_exit
		addi	$a0, $s0, 0
		addi	$a1, $s1, 0
		addi	$a2, $s2, 0
		jal	mini
		addi	$s3, $v0, 0
		addi	$a0, $s0, 0
		addi	$a1, $s1, 0
		addi	$a2, $s3, 0
		jal	swap
		addi	$s1, $s1, 1
		j	isort_for
isort_exit:	lw	$ra, 0($sp)
		lw	$s0, 4($sp)
		lw	$s1, 8($sp)
		lw	$s2, 12($sp)
		lw	$s3, 16($sp)
		addi	$sp, $sp, 20
		jr	$ra
mini:		addi	$t0, $a0, 0
		addi	$t1, $a1, 0
		addi	$t2, $a2, 0
		sll	$t3, $t1, 2
		add	$t3, $t3, $t0
		lw	$t4, 0($t3)
		addi	$t5, $t1, 1
mini_for:
    sub $t9, $t5, $t2
    bgtz	$t9, mini_end
		sll	$t6, $t5, 2
		add	$t6, $t6, $t0
		lw	$t7, 0($t6)
    sub $t9, $t7, $t4
		bgez	$t9, mini_if_exit
		addi	$t1, $t5, 0
		addi	$t4, $t7, 0
mini_if_exit:	addi	$t5, $t5, 1
		j	mini_for
mini_end:	add $v0, $zero, $t1
		jr	$ra
swap:		sll	$t1, $a1, 2
		add	$t1, $a0, $t1
		sll	$t2, $a2, 2
		add	$t2, $a0, $t2
		lw	$t0, 0($t1)
		lw	$t3, 0($t2)
		sw	$t3, 0($t1)
		sw	$t0, 0($t2)
		jr	$ra
#utiliza vetor dinâmico
#entrada
#	1. quantidade de números a serem ordenados
# 2. os números a serem ordenados
#saída
# 1. imprime no terminal a ordenação
