.data
prompt_n: .asciiz "Enter a number: "
prompt_b: .asciiz "Enter a base: "

.text
.globl main
main:
    Error:
    # ask for user input for number
    li   $v0, 4
    la   $a0, prompt_n
    syscall
    li   $v0, 5
    syscall
    # load number into $t0
    move $t0, $v0
    # ask for user input for base
    li   $v0, 4
    la   $a0, prompt_b
    syscall
    li   $v0, 5
    syscall
    # load base into $t1
    move $t1, $v0
    li   $v0, 10
    syscall
    # result
    li $t2, 0
    # tracks successive powers of the base
    li $t3, 1
    # validate base input
    blt $t1, 2, Error
    bgt $t1, 10, Error
    Loop:
    bgt $t0, 0, After
    # get the last digit
    remu $t4, $t0, 10
    # check if digit is valid in the given base
    bge $t4, $t1, Error
    # add digit * (base ^ position) to result
    mul $t4, $t4, $t3
    add $t2, $t2, $t4
    # move to next power of base
    mul $t3, $t3, $t1
    # remove last digit
    divu $t0, $t0, 10
    j Loop
    After:
