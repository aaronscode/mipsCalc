# file: lexer.asm
.globl lex_init
.globl lex_advance
.globl lex_skip_whitespace
.globl lex_integer

.include "macros.asm"

.data
# class data
input_len:		.space 1 
cur_char:		.space 1 # current char lexer is examining
cur_pos:		.space 1

# temporary string for converting digits to int
lex_int_str:	.space 64

.text
# method: lexer_init
#	init an instance of the lexer object by populating global variables
# arguments:
#	$a0 - location of input string
# return:
#	$v0 - current char
lex_init:
	push($ra)
	# set cur_pos = 0 
	sb   $zero, cur_pos
	# set cur_char = input_string[0]
	lbu	 $t1, 0($a0) 
	sb   $t1, cur_char

	# set the length of the input text
	jal  str_len
	sb   $v0, input_len

	la $v0, cur_char
	lbu $v0, 0($v0)
	return()

# method: advance
#	advance pointer to next character in input string
# arguments:
#	$a0 - location of input text string
#	implicit: location of cur_char, cur_pos, len of input string
# return:
#	$v0 - new cur_char, implicity modify value of cur_char, cur_pos
lex_advance:
	push($ra)	
	# incremnt cur_pos
	la   $t0, cur_pos # load address of cur_pos into $t0
	lbu  $t1, 0($t0)  # load value of cur_pos into $t1
	inc($t1)		  # increment cur_pos	
	sb   $t1, 0($t0)  # store cur_pos at address of cur_pos
	
	# if current pos is less than length, get next char
	la	 $t2, input_len # load address of length of input string
	lbu  $t2, 0($t2)    # load length of input string
	blt  $t1, $t2, adv_not_eoi # if cur_pos is less than length of string
	j adv_eoi # else jump to end of input
adv_not_eoi: # not end of input
	# set cur_char = input_text[cur_pos]
	add  $t1, $t1, $a0
	lbu  $t3, 0($t1)
	sb   $t3, cur_char
	move $v0, $t3
	return()
adv_eoi:	
	li   $t3, 0
	sb   $t3, cur_char
	move $v0, $t3
	return()

# method: skip_whitespace
#	advance the cur_pos pointer over whitespace characters
# arguments:
#	$a0 - location of input text string
#	implicit: location of cur_char, cur_pos, len of input string
# return:
#	$v0 - new cur_char, implicity modify value of cur_char, cur_pos
lex_skip_whitespace:
	push($ra)
	push($s0) # address of input text
	push($s1) # cur_char
	push($s2) # null character

	move $s0, $a0 # copy input arg to local var
	la   $s2, null_char # copy value of null char
	lbu  $s2, 0($s2)
lex_skip_whitespace_loop:
	# check if cur_char is null
	la   $s1, cur_char
	lbu  $s1, 0($s1)
	# if not, check if it's whitespace
	bne  $s1, $s2, lex_skip_whitespace_not_null 

	# if it is null, end function
	j lex_skip_whitespace_end
lex_skip_whitespace_not_null:
	la $a0, cur_char
	jal is_white # check if current character is whitespace

	beqz $v0, lex_skip_whitespace_end # if it isn't whitespace, end

	move $a0, $s0 # if it is whitespace, advance to next character
	jal lex_advance

	j lex_skip_whitespace_loop # go back to top of loop

lex_skip_whitespace_end:
	move $v0, $s1
	pop($s2)
	pop($s1)
	pop($s0)
	return()
	
# method: integer
#	advance the cur_pos pointer over whitespace characters
# arguments:
#	$a0 - location of input text string
#	implicit: location of cur_char, cur_pos, len of input string
# return:
#	$v0 - next integer value in input text
#   $v1 - number of characters making up integer
lex_integer:
	push($ra)
	local_var($s0, $a0) # local var for holding input text address
	push($s1) # local var for holding null
	push($s2) # local var for holding address of temp string
	local_var($s3, $zero) # local var for holding loop counter

	la   $s1, null_char # load null character into $s0
	lbu  $s1, 0($s1)
	
	la   $s2, lex_int_str

	add  $t0, $zero, $zero # 0 out look counter
lex_integer_L1: # loop for nulling out temp string
	add	 $t1, $t0, $s2 # address of current char in tmp string
	lbu  $t2, 0($t1) # value of current char in tmp string

	# check if current char is null
	beq  $t2, $s1, lex_integer_L2 # if it is, exit loop and go to second

	sb   $s1, 0($t1) # if not, set that byte equl to null
	inc($t0) # increment loop counter
	j lex_integer_L1 # jump to top of loop

	
lex_integer_L2: # loop for accumulating digits into tmp string
	# check if current character is null
	la   $a0, cur_char
	lbu  $t0, 0($a0)
	bne  $t0, $s1, lex_integer_not_null
	j lex_integer_end

lex_integer_not_null:
	# $a0 alread set to address of cur_char from above
	jal is_digit # check if current character is a digit
	beqz $v0, lex_integer_end # if it is not a digit, end function
	
	# if it is a digit, copy digit to temp string
	la   $t0, cur_char
	lbu  $t0, 0($t0)

	# add base address of string and loop counter to get address of cur char
	add  $t1, $s2, $s3
	sb   $t0, 0($t1)
	
	# advance the lexer forward one character
	move $a0, $s0
	jal lex_advance

	inc($s3) # increment loop counter
	j lex_integer_L2 # jump back to top of loop

lex_integer_end:
	la   $a0, lex_int_str
	jal  atoi # convert string to integer (returns value in $v0)
	pop($s3)
	pop($s2)
	pop($s1)
	pop($s0)
	return()
