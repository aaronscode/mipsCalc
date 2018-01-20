.globl math_pow

.include "macros.asm"

.text
# method: math_pow
#   (integer) raise one number to the power of another
# arguments:
#   $a0 - a value x, the base
#   $a1 - a value y, the power we are raising x to
# return:
#   $v0 - if y > 0 :  x^y
#         else     :  1
math_pow:
    push($ra)
    
    # if the power we're raising it to is 0, result is 1
    addi $v0, $zero, 1
    ble $a1, $zero, math_pow_end

    # else
    move $t0, $zero # zero out the loop counter

math_pow_L:

    mul  $v0, $v0, $a0
    inc($t0)
    beq  $a1, $t0, math_pow_end
    j    math_pow_L
math_pow_end:
    return()
