# file: strings.asm

.globl str_cpy
.globl str_cmpr # string compare
.globl str_len
.globl is_white # 
.globl is_alpha
.globl is_digit
.globl is_operator
.globl is_paren
.globl atoi

.include "macros.asm"

.text
str_cpy:
	push($s0)
	add  $s0, $zero, $zero	# i = 0
cpy_L1:	add  $t1, $s0, $a1	# addr of y[i] in $t1
	lbu  $t2, 0($t1)	# $t2 = y[i]
	add  $t3, $s0, $a0	# addr of x[i] in $t3
	sb   $t2, 0($t3)	# x[i] = y[i]
	beq  $t2, $zero, cpy_L2	# exit loop if y[i] == 0
	addi $s0, $s0, 1	# i++
	j    cpy_L1		# next iteration of the loop
cpy_L2:	pop($s0)
	jr   $ra

# method: str_cmpr
#	compare two null terminated strings character by character
# arguments:
#	$a0 - location of the first null-terminated string
#	$a1 - location of the second null-terminated string
# return:
#	$v0 - 0 if strings are the same, 
#	      1 if str1 is greater (in length or first different char),
#	     -1 if str2 is greater (in length or first different char)
.eqv  str_1 $a0
.eqv  str_2 $a1
.eqv  ch1   $t1
.eqv  ch2   $t2
str_cmpr:
	push($ra)
	push($s0)
	
	# initialize local vars
	la   $t0, null_char
	lbu  $t0, 0($t0)	# load null char character into $t0
	li  $v0, 0		# init return value to 0
	
	add  $s0, $zero, $zero 	# init loop count to 0
str_cmpr_L1: # add address of string to current loop index to increment-
	add  ch1, $s0, str_1	# to next digit in string
	add  ch2, $s0, str_2
	lbu  ch1, 0(ch1)
	lbu  ch2, 0(ch2)
	# check for the end of strings
	beq  ch1, $t0, str_cmpr_end_of_1 	# if ch1 is null
	beq  ch2, $t0, str_cmpr_1_grtr  # if instead ch2 is null
	beq  ch1, ch2, str_cmpr_L1_end  # if chars are equal, go to next char
	bgt  ch1, ch2, str_cmpr_1_grtr	# if ch1 greater than ch2
	j str_cmpr_2_grtr		# last case, ch2 greater than ch1
str_cmpr_L1_end:
	addi $s0, $s0, 1	# increment loop counter
	j    str_cmpr_L1	# next iteration of the loop
	
str_cmpr_end_of_1:
	beq  ch2, $t0, str_cmpr_end
	j str_cmpr_2_grtr
str_cmpr_1_grtr:
	li   $v0, 1
	j str_cmpr_end
str_cmpr_2_grtr:
	li   $v0, -1
	j str_cmpr_end
	
str_cmpr_end:
	pop($s0)
	return()
	
# method: str_len
#	find the length of a string
# arguments:
#	$a0 - address of a null terminated string
# return:
#	$v0 - the number of characters in the string up to but not including the null terminator
str_len:
	push($ra)
	local_var($s0, $zero)

	la   $t0, null_char
	lbu  $t0, 0($t0)	# load null char character into $t0
	li   $v0, 0		# init return value to 0
str_len_L1:
	add  $t1, $s0, $a0
	lbu  $t1, 0($t1)
	
	beq $t0, $t1, str_len_end
	inc($s0)
	j str_len_L1

str_len_end:
	move $v0, $s0
	pop($s0)
	return()

# method: is_white
#	determine if a single char is a whitespace characer (i.e. space or tab)
# arguments:
#	$a0 - address of a single character
# return:
#	$v0 - 1 if character is space or tab, 0 otherwise
is_white:
	push($ra)
	li   $v0, 1
	li   $t0, 9
	li   $t1, 32
	lbu  $t3, 0($a0)
	beq  $t3, $t1, is_white_end
	beq  $t3, $t0, is_white_end
	li   $v0, 0
is_white_end:
	return()
	
# method: is_alpha
#	determine if a single char is an alphabetic character (i.e. A-Z or a-z)
# arguments:
#	$a0 - address of a single character
# return:
#	$v0 - 1 if character is A-Z or a-z, 0 otherwise
is_alpha:
	push($ra)
	li   $v0, 0
	li   $t0, 65
	li   $t1, 90
	li   $t2, 97
	li   $t3, 122
	lbu  $t4, 0($a0)
	blt  $t4, $t0, is_alpha_end		# number less than start of upper case letters (A)
	bgt  $t4, $t1, is_alpha_not_upper	# number greater than end of upper case letters (Z)
	j is_alpha_almost_end			# if here, number is between A and Z
is_alpha_not_upper:
	blt  $t4, $t2, is_alpha_end		# number less than start of lower case letters (a)
	bgt  $t4, $t3, is_alpha_end		# number greater than end of lower case letters (z)
is_alpha_almost_end:
	li   $v0, 1				# number either between A-Z or a-z, return 1
is_alpha_end:	
	return()

# method: is_digit
#	determine if a single char is a digit
# arguments:
#	$a0 - address of a single character
# return:
#	$v0 - 1 if character is 0-9, 0 otherwise
is_digit:
	push($ra)
	li   $v0, 0
	li   $t0, 48
	li   $t1, 57
	lbu  $t2, 0($a0)
	blt  $t2, $t0, is_digit_end
	bgt  $t2, $t1, is_digit_end
	li   $v0, 1
is_digit_end:	
	return()

# method: is_operator
#	determine if a single char is an operator
# arguments:
#	$a0 - address of a single character
# return:
#	$v0 - 0 if character is not an operator
#	      1 if character is "+"
#	      2 if character is "-"
# 	      3 if character is "*"
#         4 if character is "/"
#		  7 if character is "="
is_operator:
	push($ra)
	li   $v0, 1
	li   $t0, 43		# + ascii value
	li   $t1, 45		# - ascii value
	li   $t2, 42		# * ascii value
	li   $t3, 47		# / ascii value
	li 	 $t5, 61		# = ascii value
	lbu  $t4, 0($a0)
	beq  $t4, $t0, is_operator_end
	li   $v0, 2
	beq  $t4, $t1, is_operator_end
	li   $v0, 3
	beq  $t4, $t2, is_operator_end
	li   $v0, 4
	beq  $t4, $t3, is_operator_end
	li   $v0, 7
	beq  $t4, $t5, is_operator_end
	li   $v0, 0
is_operator_end:
	return()

# method: is_paren
#	determine if a single char is a parenthesis
# arguments:
#	$a0 - address of a single character
# return:
#	$v0 - 1 if character is open paren, -1 if close paren, 0 otherwise
is_paren:
	push($ra)
	li   $v0, 1
	li   $t0, 40		# open paren ascii value
	li   $t1, 41		# closed paren ascii value
	lbu  $t3, 0($a0)
	beq  $t3, $t0, is_paren_end
	li   $v0, -1
	beq  $t3, $t1, is_paren_end
	li   $v0, 0
is_paren_end:
	return()
	
# method: atoi
#	convert a string containing only digits into a positive integer
#	method assumes number is using base 10
#	@assert a valid string is passed
# arguments:
#	$a0 - location of the null-terminated string to convert to an interger
# return:
#	$v0 - interger value from string
#	$v1 - number of characters parsed
atoi:
	push($ra)
	push($s0)
	# local var initialization
	la   $t0, null_char 	# load the address of the null char
	lbu  $t0, 0($t0)	# load null char character into $t0 
	li  $t3, 10		# use base 10 for each digit
	li  $v0, 0		# init return value to 0
	add  $s0, $zero, $zero 	# i = 0
	# add address of string to current loop index to increment
ati_L1: add  $t1, $s0, $a0	# to next digit in string
	lbu  $t2, 0($t1)	# load that char into $t2
	beq  $t2, $t0, ati_L2	# if current char is null, end of string so jump to exit
	subi $t2, $t2, 48	# convert char to int
	add  $v0, $v0, $t2	# add current digit to return/accumulator
	mul  $v0, $v0, $t3	# multiply return by 10 to shift one digit
	addi $s0, $s0, 1	# increment loop counter
	j ati_L1		# next iteration of the loop
# during the loop, the value is multiplied by an extra 10 so do some cleanup on the return values
ati_L2:	div  $v0, $v0, $t3	# divide by 10 to get get digits in right place
	move $v1, $s0
	pop($s0)
	return()
