.data
# prompts and messages
prompt_n: .asciiz "Enter a number: "
prompt_b: .asciiz "Enter a base: "
result_msg: .asciiz "Result: "

.text
.globl main
main:
    Error:
    # print prompt_n
    li   $v0, 4
    la   $a0, prompt_n
    syscall
    # read number input
    li   $v0, 5
    syscall
    # load number into $t0
    move $t0, $v0
    # print prompt_b
    li   $v0, 4
    la   $a0, prompt_b
    syscall
    # read base input
    li   $v0, 5
    syscall
    # load base into $t1
    move $t1, $v0
    # result
    li $t2, 0
    # tracks successive powers of the base
    li $t3, 1
    # validate base input
    blt $t1, 2, Error
    bgt $t1, 10, Error
    Loop:
    # exit once number is 0
    beq  $t0, $zero, After
    # get the last digit
    remu $t4, $t0, 10
    # check if digit is valid in the given base
    bge $t4, $t1, Error
    # add digit * base^position to result
    mul $t4, $t4, $t3
    add $t2, $t2, $t4
    # move to next power of base
    mul $t3, $t3, $t1
    # remove last digit
    divu $t0, $t0, 10
    j Loop
    After:
    # print result message
    li   $v0, 4
    la   $a0, result_msg
    syscall
    # print value in $t2
    li   $v0, 1
    move $a0, $t2
    syscall
    # exit
    li   $v0, 10
    syscall
