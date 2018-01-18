# file: lexer.asm
.globl lex_init
.globl lex_advance

.include "macros.asm"

.data
# class data
input_len:		.space 1 # current char lexer is examining
cur_char:		.space 2 # 
cur_pos:		.space 1

.text
# method: lexer_init
#	init an instance of the lexer object by populating global variables
# arguments:
#	$a0 - location of input string
# return:
#	none - but init cur_pos and cur_char
lex_init:
	push($ra)
	# set cur_pos = 0 
	sb   $zero, cur_pos
	# set cur_char = input_string[0]
	lbu	 $t1, 0($a0) 
	sb   $t1, cur_char
	# set the current byte of cur_char to '\0'
	la   $t2, cur_char
	inc($t2)
	sb   $zero, 0($t2)
	# set the length of the input text
	jal  str_len
	sb   $v0, input_len
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
