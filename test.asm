# file: tests.asm
.globl tests

.include "macros.asm"

.data
random_msg: .asciiz "derpderpderpderp"
dash_line: .asciiz "-------------------------------------------------------------"

# test vectors for string class -------------------------------------------------
atoi_test_1: .asciiz "1234"
atoi_test_2: .asciiz "0"
atoi_test_3: .asciiz "1"
atoi_test_4: .asciiz "10"

str_cmpr_test_1: .asciiz "hello"
str_cmpr_test_2: .asciiz "hello"
str_cmpr_test_3: .asciiz "helloooo"
str_cmpr_test_4: .asciiz "hdllo"
str_cmpr_test_5: .asciiz "hfllo"

is_white_test_1: .asciiz "n"
is_white_test_2: .asciiz " "
is_white_test_3: .asciiz "	"

is_alpah_test_1: .asciiz "a"
is_alpah_test_2: .asciiz "b"
is_alpah_test_3: .asciiz "z"
is_alpah_test_4: .asciiz "A"
is_alpah_test_5: .asciiz "G"
is_alpah_test_6: .asciiz "Z"
is_alpah_test_7: .asciiz "@"
is_alpah_test_8: .asciiz "["
is_alpah_test_9: .asciiz "{"
is_alpah_test_10: .asciiz "`"
is_alpah_test_11: .asciiz "1"

is_digit_test_1: .asciiz "0"
is_digit_test_2: .asciiz "1"
is_digit_test_3: .asciiz "9"
is_digit_test_4: .asciiz "/"
is_digit_test_5: .asciiz ":"

is_operator_test_1: .asciiz "+"
is_operator_test_2: .asciiz "-"
is_operator_test_3: .asciiz "*"
is_operator_test_4: .asciiz "/"
is_operator_test_5: .asciiz ")"

is_paren_test_1: .asciiz "("
is_paren_test_2: .asciiz ")"
is_paren_test_3: .asciiz "4"

# test vectors for lexer -------------------------------------------------
tokenize_input_test_1: .asciiz "3 + 8"
tokenize_input_test_2: .asciiz "a 5 7 9 bananna"
tokenize_input_test_3: .asciiz "()+	-*/a8"
tokenize_input_test_4: .asciiz "dsakjdla&9999"
tokenize_input_test_5: .asciiz "12345 678 ++++"
tokenize_input_test_6: .asciiz "abc 123 ()9"

# test vectors for parser ------------------------------------------------
mk_shunt_stack_test_1: .asciiz "3 4 51 8"
mk_shunt_stack_test_2: .asciiz "3 4 (22 58 2)5"
mk_shunt_stack_test_3: .asciiz "3+4"
mk_shunt_stack_test_4: .asciiz "3+4*(2?1)"

.text
tests:
	push($ra)
	push($a0)
	push($a1)
	
###########################################################
#														  #
# Tests for methods in string class						  #
#														  #
###########################################################
	
	# atoi tests, should print out the same number as string and as int -----------------
	print_string(atoi_test_1)
	print_string(newline_char)
	la   $a0, atoi_test_1
	jal  atoi
	print_int($v0)
	print_string(newline_char)
	print_int($v1)
	print_string(newline_char)
	
	print_string(atoi_test_2)
	print_string(newline_char)
	la   $a0, atoi_test_2
	jal  atoi
	print_int($v0)
	print_string(newline_char)
	print_int($v1)
	print_string(newline_char)
	
	print_string(atoi_test_3)
	print_string(newline_char)
	la   $a0, atoi_test_3
	jal  atoi
	print_int($v0)
	print_string(newline_char)
	print_int($v1)
	print_string(newline_char)
	
	print_string(atoi_test_4)
	print_string(newline_char)
	la   $a0, atoi_test_4
	jal  atoi
	print_int($v0)
	print_string(newline_char)
	print_int($v1)
	print_string(newline_char)
	
	print_string(dash_line)
	print_string(newline_char)
	
	# string compare tests ---------------------------------------------------------
	# "hello" vs. "hello" - should print out 0
	print_string(str_cmpr_test_1)
	print_string(newline_char)
	print_string(str_cmpr_test_2)
	print_string(newline_char)
	la    $a0, str_cmpr_test_1
	la    $a1, str_cmpr_test_2
	jal str_cmpr
	print_int($v0)
	print_string(newline_char)
	
	# "hellooo" vs. "hello" - should print 1
	print_string(str_cmpr_test_3)
	print_string(newline_char)
	print_string(str_cmpr_test_1)
	print_string(newline_char)
	la    $a0, str_cmpr_test_3
	la    $a1, str_cmpr_test_1
	jal str_cmpr
	print_int($v0)
	print_string(newline_char)
	
	# "hello" vs. "hellooo" - should print -1
	print_string(str_cmpr_test_1)
	print_string(newline_char)
	print_string(str_cmpr_test_3)
	print_string(newline_char)
	la    $a0, str_cmpr_test_1
	la    $a1, str_cmpr_test_3
	jal str_cmpr
	print_int($v0)
	print_string(newline_char)
	
	# "hello" vs. "hdllo" - should print 1
	print_string(str_cmpr_test_1)
	print_string(newline_char)
	print_string(str_cmpr_test_4)
	print_string(newline_char)
	la    $a0, str_cmpr_test_1
	la    $a1, str_cmpr_test_4
	jal str_cmpr
	print_int($v0)
	print_string(newline_char)
	
	# "hello" vs. "hfllo" - should print -1
	print_string(str_cmpr_test_1)
	print_string(newline_char)
	print_string(str_cmpr_test_5)
	print_string(newline_char)
	la    $a0, str_cmpr_test_1
	la    $a1, str_cmpr_test_5
	jal str_cmpr
	print_int($v0)
	print_string(newline_char)
	print_string(dash_line)
	print_string(newline_char)
	
	# is_white tests ------------------------------------------------------------------
	print_string(is_white_test_1)
	print_string(newline_char)
	la $a0, is_white_test_1
	jal is_white
	print_int($v0)
	print_string(newline_char)
	
	print_string(is_white_test_2)
	print_string(newline_char)
	la $a0, is_white_test_2
	jal is_white
	print_int($v0)
	print_string(newline_char)
	
	print_string(is_white_test_3)
	print_string(newline_char)
	la $a0, is_white_test_3
	jal is_white
	print_int($v0)
	print_string(newline_char)
	print_string(dash_line)
	print_string(newline_char)
	
	# is_alpha tests ------------------------------------------------------------------
	# test 'a'
	print_string(is_alpah_test_1) 
	print_string(newline_char)
	la $a0, is_alpah_test_1
	jal is_alpha
	print_int($v0)
	print_string(newline_char)
	
	# test 'b'
	print_string(is_alpah_test_2)
	print_string(newline_char)
	la $a0, is_alpah_test_2
	jal is_alpha
	print_int($v0)
	print_string(newline_char)
	
	# test 'z'
	print_string(is_alpah_test_3)
	print_string(newline_char)
	la $a0, is_alpah_test_3
	jal is_alpha
	print_int($v0)
	print_string(newline_char)
	
	# test 'A'
	print_string(is_alpah_test_4)
	print_string(newline_char)
	la $a0, is_alpah_test_4
	jal is_alpha
	print_int($v0)
	print_string(newline_char)
	
	# test 'G'
	print_string(is_alpah_test_5)
	print_string(newline_char)
	la $a0, is_alpah_test_5
	jal is_alpha
	print_int($v0)
	print_string(newline_char)
	
	# test 'Z'
	print_string(is_alpah_test_6)
	print_string(newline_char)
	la $a0, is_alpah_test_6
	jal is_alpha
	print_int($v0)
	print_string(newline_char)
	
	# test '@'
	print_string(is_alpah_test_7)
	print_string(newline_char)
	la $a0, is_alpah_test_7
	jal is_alpha
	print_int($v0)
	print_string(newline_char)
	
	# test '['
	print_string(is_alpah_test_8)
	print_string(newline_char)
	la $a0, is_alpah_test_8
	jal is_alpha
	print_int($v0)
	print_string(newline_char)
	
	# test '{'
	print_string(is_alpah_test_9)
	print_string(newline_char)
	la $a0, is_alpah_test_9
	jal is_alpha
	print_int($v0)
	print_string(newline_char)
	
	# test '`'
	print_string(is_alpah_test_10)
	print_string(newline_char)
	la $a0, is_alpah_test_10
	jal is_alpha
	print_int($v0)
	print_string(newline_char)
	
	# test '1'
	print_string(is_alpah_test_11)
	print_string(newline_char)
	la $a0, is_alpah_test_11
	jal is_alpha
	print_int($v0)
	print_string(newline_char)
	
	print_string(dash_line)
	print_string(newline_char)
	
	# is_digit tests ------------------------------------------------------------------
	# test '0'
	print_string(is_digit_test_1) 
	print_string(newline_char)
	la $a0, is_digit_test_1
	jal is_digit
	print_int($v0)
	print_string(newline_char)
	
	# test '1'
	print_string(is_digit_test_2) 
	print_string(newline_char)
	la $a0, is_digit_test_2
	jal is_digit
	print_int($v0)
	print_string(newline_char)
	
	# test '9'
	print_string(is_digit_test_3) 
	print_string(newline_char)
	la $a0, is_digit_test_3
	jal is_digit
	print_int($v0)
	print_string(newline_char)
	
	# test '/'
	print_string(is_digit_test_4) 
	print_string(newline_char)
	la $a0, is_digit_test_4
	jal is_digit
	print_int($v0)
	print_string(newline_char)
	
	# test ':'
	print_string(is_digit_test_5) 
	print_string(newline_char)
	la $a0, is_digit_test_5
	jal is_digit
	print_int($v0)
	print_string(newline_char)
	
	print_string(dash_line)
	print_string(newline_char)
	
	# is_operator tests ------------------------------------------------------------------
	# test '+'
	print_string(is_operator_test_1) 
	print_string(newline_char)
	la $a0, is_operator_test_1
	jal is_operator
	print_int($v0)
	print_string(newline_char)
	
	# test '-'
	print_string(is_operator_test_2) 
	print_string(newline_char)
	la $a0, is_operator_test_2
	jal is_operator
	print_int($v0)
	print_string(newline_char)
	
	# test '*'
	print_string(is_operator_test_3) 
	print_string(newline_char)
	la $a0, is_operator_test_3
	jal is_operator
	print_int($v0)
	print_string(newline_char)
	
	# test '/'
	print_string(is_operator_test_4) 
	print_string(newline_char)
	la $a0, is_operator_test_4
	jal is_operator
	print_int($v0)
	print_string(newline_char)
	
	# test ')'
	print_string(is_operator_test_5) 
	print_string(newline_char)
	la $a0, is_operator_test_5
	jal is_operator
	print_int($v0)
	print_string(newline_char)
	
	print_string(dash_line)
	print_string(newline_char)
	
	# is_paren tests ------------------------------------------------------------------
	# test '('
	print_string(is_paren_test_1) 
	print_string(newline_char)
	la $a0, is_paren_test_1
	jal is_paren
	print_int($v0)
	print_string(newline_char)
	
	# test ')'
	print_string(is_paren_test_2) 
	print_string(newline_char)
	la $a0, is_paren_test_2
	jal is_paren
	print_int($v0)
	print_string(newline_char)
	
	# test '4'
	print_string(is_paren_test_3) 
	print_string(newline_char)
	la $a0, is_paren_test_3
	jal is_paren
	print_int($v0)
	print_string(newline_char)
	
	print_string(dash_line)
	print_string(newline_char)
	
###########################################################
#							 							  #
# Tests for methods in lexer class						  #
#														  #
###########################################################
	
###########################################################
#														  #
# Tests for methods in parser class						  #
#														  #
###########################################################


###########################################################
# 							  #
# END OF TESTS						  #
#							  #
###########################################################
	pop($a1)
	pop($a0)
	return() # implicit pop($ra); jr $ra
