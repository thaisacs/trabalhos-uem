.globl functional_unit_1
.type functional_unit_1, @function
.globl functional_unit_2
.type functional_unit_2, @function
.globl functional_unit_3
.type functional_unit_3, @function
.globl functional_unit_4
.type functional_unit_4, @function
.globl functional_unit_5
.type functional_unit_5, @function
.section .data
.section .text
functional_unit_1:
  cmpl $1, %edx
  je  op_add_1
  cmpl $2, %edx
  je  op_sub_1
  cmpl $3, %edx
  je  op_and_1
  cmpl $4, %edx
  je  op_or_1
  cmpl $5, %edx
  je  op_nor_1
  cmpl $6, %edx
  je  op_xor_1
  cmpl $7, %edx
  je  op_sll_1
  cmpl $8, %edx
  je  op_srl_1
  jmp default_1
op_add_1: # 1
  addl %edi, %esi
  movl %esi, %eax
  jmp  fim_1
op_sub_1: # 2
  subl %esi, %edi
  movl %edi, %eax
  jmp  fim_1
op_and_1: # 3
  andl %esi, %edi
  movl %edi, %eax
  jmp  fim_1
op_or_1: # 4
  orl  %esi, %edi
  movl %edi, %eax
  jmp  fim_1
op_nor_1: # 5
  orl %esi, %edi
  notl %edi
  movl %edi, %eax
  jmp  fim_1
op_xor_1: # 6
  xorl %esi, %edi
  movl %edi, %eax
  jmp  fim_1
op_sll_1: # 7
  movl %esi, %ecx
  sall %cl, %edi
  movl %edi, %eax
  jmp  fim_1
op_srl_1: # 8
  movl %esi, %ecx
  sarl %cl, %edi
  movl %edi, %eax
  jmp  fim_1
default_1:
  movl %edi, %eax
fim_1:
  ret

functional_unit_2:
  cmpl $1, %edx
  je  op_add_2
  cmpl $2, %edx
  je  op_sub_2
  cmpl $3, %edx
  je  op_and_2
  cmpl $4, %edx
  je  op_or_2
  cmpl $5, %edx
  je  op_nor_2
  cmpl $6, %edx
  je  op_xor_2
  cmpl $7, %edx
  je  op_sll_2
  cmpl $8, %edx
  je  op_srl_2
  jmp default_2
op_add_2: # 1
  addl %edi, %esi
  movl %esi, %eax
  jmp  fim_2
op_sub_2: # 2
  subl %esi, %edi
  movl %edi, %eax
  jmp  fim_2
op_and_2: # 3
  andl %esi, %edi
  movl %edi, %eax
  jmp  fim_2
op_or_2: # 4
  orl  %esi, %edi
  movl %edi, %eax
  jmp  fim_2
op_nor_2: # 5
  orl %esi, %edi
  notl %edi
  movl %edi, %eax
  jmp  fim_2
op_xor_2: # 6
  xorl %esi, %edi
  movl %edi, %eax
  jmp  fim_2
op_sll_2: # 7
  movl %esi, %ecx
  sall %cl, %edi
  movl %edi, %eax
  jmp  fim_2
op_srl_2: # 8
  movl %esi, %ecx
  sarl %cl, %edi
  movl %edi, %eax
  jmp  fim_2
default_2:
  movl %edi, %eax
fim_2:
  ret

functional_unit_3:
  cmpl $1, %edx
  je  op_add_3
  cmpl $2, %edx
  je  op_sub_3
  cmpl $3, %edx
  je  op_and_3
  cmpl $4, %edx
  je  op_or_3
  cmpl $5, %edx
  je  op_nor_3
  cmpl $6, %edx
  je  op_xor_3
  cmpl $7, %edx
  je  op_sll_3
  cmpl $8, %edx
  je  op_srl_3
  jmp default_3
op_add_3: # 1
  addl %edi, %esi
  movl %esi, %eax
  jmp  fim_3
op_sub_3: # 2
  subl %esi, %edi
  movl %edi, %eax
  jmp  fim_3
op_and_3: # 3
  andl %esi, %edi
  movl %edi, %eax
  jmp  fim_3
op_or_3: # 4
  orl  %esi, %edi
  movl %edi, %eax
  jmp  fim_3
op_nor_3: # 5
  orl %esi, %edi
  notl %edi
  movl %edi, %eax
  jmp  fim_3
op_xor_3: # 6
  xorl %esi, %edi
  movl %edi, %eax
  jmp  fim_3
op_sll_3: # 7
  movl %esi, %ecx
  sall %cl, %edi
  movl %edi, %eax
  jmp  fim_3
op_srl_3: # 8
  movl %esi, %ecx
  sarl %cl, %edi
  movl %edi, %eax
  jmp  fim_3
default_3:
  movl %edi, %eax
fim_3:
  ret

functional_unit_4:
  cmpl $1, %edx
  je  op_div_4
  cmpl $2, %edx
  je  op_mod_4
  cmpl $3, %edx
  je  op_mul_4
  cmpl $4, %edx
  je  op_mul_2_4
  cmpl $5, %edx
  je  op_mulu_4
  cmpl $6, %edx
  je  op_mulu_2_4
  jmp default_4
op_div_4: # 1
  movl %edi, %eax
  cltd
  idivl %esi
  jmp fim_4
op_mod_4: # 2
  movl %edi, %eax
  cltd
  idivl %esi
  movl %edx, %eax
  jmp fim_4
op_mul_4: # 3
  movl %edi, %eax
  movl %esi, %ebx
  imull %ebx
  jmp fim_4
op_mul_2_4: # 4
  movl %edi, %eax
  imull %esi
  movl %edx, %eax
  jmp fim_4
op_mulu_4:
  movl %edi, %eax
  movl %esi, %ebx
  mull %ebx
  jmp fim_4
op_mulu_2_4:
  movl %edi, %eax
  mull %esi
  movl %edx, %eax
  jmp fim_4
default_4:
  movl %edi, %eax
fim_4:
  ret

functional_unit_5:
  cmpl $1, %edx
  je  op_div_5
  cmpl $2, %edx
  je  op_mod_5
  cmpl $3, %edx
  je  op_mul_5
  cmpl $4, %edx
  je  op_mul_2_5
  jmp default_5
op_div_5: # 1
  movl %edi, %eax
  cltd
  idivl %esi
  jmp fim_5
op_mod_5: # 2
  movl %edi, %eax
  cltd
  idivl %esi
  movl %edx, %eax
  jmp fim_5
op_mul_5: # 3
  movl %edi, %eax
  movl %esi, %ebx
  imull %ebx
  jmp fim_5
op_mul_2_5: # 4
  movl %edi, %eax
  imull %esi
  movl %edx, %eax
  jmp fim_5
op_mulu_5: # 5
  movl %edi, %eax
  movl %esi, %ebx
  mull %ebx
  jmp fim_5
op_mulu_2_5: # 6
  movl %edi, %eax
  mull %esi
  movl %edx, %eax
  jmp fim_5
default_5:
  movl %edi, %eax
fim_5:
  ret
# edi
# esi
# edx
