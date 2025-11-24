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
    # push return address on stack
    addi $sp, $sp, -4
    sw   $ra, 0($sp)
    # push number on stack
    addi $sp, $sp, -4
    sw   $t0, 0($sp)
    # push base on stack
    addi $sp, $sp, -4
    sw   $t1, 0($sp)
    # push result on stack
    addi $sp, $sp, -4
    sw   $t2, 0($sp)
    # push power on stack
    addi $sp, $sp, -4
    sw   $t3, 0($sp)
    # jump to function
    jal Function
    # pop power from stack
    lw   $t3, 0($sp)
    addi $sp, $sp, 4
    # pop result from stack
    lw   $t2, 0($sp)
    addi $sp, $sp, 4
    # pop base from stack
    lw   $t1, 0($sp)
    addi $sp, $sp, 4
    # pop number from stack
    lw   $t0, 0($sp)
    addi $sp, $sp, 4
    # pop return address from stack
    lw   $ra, 0($sp)
    addi $sp, $sp, 4
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
    # start of function
    Function:
    # load number into $t0
    lw   $t0, 12($sp)
    # load base into $t1
    lw   $t1, 8($sp)
    # load power into $t3
    lw   $t3, 0($sp)
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
    # return from function
    sw  $t2, 4($sp)
    jr $ra
