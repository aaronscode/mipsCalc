# file: tests.asm
.globl tests

.include "macros.asm"

.data
random_msg: .asciiz "derpderpderpderp"
dash_line: .asciiz "-------------------------------------------------------------"

expected_str:	.asciiz "Expected Value: "
actual_str:		.asciiz "Actual Value: "
test_passed:	.asciiz "Test Passed!"
test_failed:	.asciiz "Test Failed!"

string_test:	.asciiz "   -------------   String class tests   -------------"
atoi_test:		.asciiz "atoi tests:"
str_cmpr_test:	.asciiz "str_cmpr tests:"
str_len_test:   .asciiz "str_len tests:"
rtrim_test:     .asciiz "rtrim tests:"
is_white_test:	.asciiz "is_white tests:"
is_alpha_test:	.asciiz "is_alpha tests:"
is_digit_test:	.asciiz "is_digit tests:"
is_op_test:		.asciiz "is_operator tests:"
is_paren_test:	.asciiz "is_paren tests:"

lexer_test:		.asciiz "   -------------   Lexer class tests   -------------"
init_adv_test:	.asciiz "init + advance tests:"
skp_white_test:	.asciiz "skip whitespace tests:"
integer_test:   .asciiz "interger tests:"
get_next_tok_test:   .asciiz "get_next_token tests:"

interp_test:	.asciiz "   -------------   Interpreter class tests   -------------"
interp_init_test: .asciiz "interpreter init tests:"
# test vectors for string class -------------------------------------------------
atoi_test_1:	.asciiz "1234"
atoi_test_2:	.asciiz "0"
atoi_test_3:	.asciiz "1"
atoi_test_4:	.asciiz "10"

str_cmpr_test_1: .asciiz "hello"
str_cmpr_test_2: .asciiz "hello"
str_cmpr_test_3: .asciiz "helloooo"
str_cmpr_test_4: .asciiz "hdllo"
str_cmpr_test_5: .asciiz "hfllo"

str_len_test_1: .asciiz "fiz"
str_len_test_2: .asciiz "bang"
str_len_test_3: .asciiz " "
str_len_test_4: .asciiz "a"
str_len_test_5: .asciiz ""

rtrim_test_1:   .asciiz "no newline"
rtrim_test_2:   .asciiz "one newline\n"
rtrim_test_3:   .asciiz "two newlines\n\n"

is_white_test_1: .asciiz "n"
is_white_test_2: .asciiz " "
is_white_test_3: .asciiz "	"

is_alpha_test_1: .asciiz "a"
is_alpha_test_2: .asciiz "b"
is_alpha_test_3: .asciiz "z"
is_alpha_test_4: .asciiz "A"
is_alpha_test_5: .asciiz "G"
is_alpha_test_6: .asciiz "Z"
is_alpha_test_7: .asciiz "@"
is_alpha_test_8: .asciiz "["
is_alpha_test_9: .asciiz "{"
is_alpha_test_10: .asciiz "`"
is_alpha_test_11: .asciiz "1"

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
advance_test_1:			.asciiz "words 2 + 3 bannana"
skip_white_test_1:		.asciiz "a    lot of space"
integer_test_1:			.asciiz "123    432"
get_next_tok_test_1:	.asciiz "123 + 2 * 5"
get_next_tok_test_2:	.asciiz "+-/^ *()1234"
get_next_tok_test_3:	.asciiz ""

# test vectors for interpreter -------------------------------------------
interp_init_test_1:     .asciiz "222"

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
	print_stringnl(string_test)
	
	# atoi tests, should print out the same number as string and as int,
	# followed by length of string
	print_stringnl(atoi_test)

	print_stringnl(atoi_test_1)
	la   $a0, atoi_test_1
	jal  atoi
	print_intnl($v0)
	print_intnl($v1)
	print_string(newline_char)
	
	print_stringnl(atoi_test_2)
	la   $a0, atoi_test_2
	jal  atoi
	print_intnl($v0)
	print_intnl($v1)
	print_string(newline_char)
	
	print_stringnl(atoi_test_3)
	la   $a0, atoi_test_3
	jal  atoi
	print_intnl($v0)
	print_intnl($v1)
	print_string(newline_char)
	
	print_stringnl(atoi_test_4)
	la   $a0, atoi_test_4
	jal  atoi
	print_intnl($v0)
	print_intnl($v1)
	print_string(newline_char)
	
	print_stringnl(dash_line)
	
	# string compare tests ---------------------------------------------------------
	print_stringnl(str_cmpr_test)
	# "hello" vs. "hello" - should print out 0
	print_stringnl(str_cmpr_test_1)
	print_stringnl(str_cmpr_test_2)
	la    $a0, str_cmpr_test_1
	la    $a1, str_cmpr_test_2
	jal str_cmpr
	print_intnl($v0)
	print_string(newline_char)
	
	# "hellooo" vs. "hello" - should print 1
	print_stringnl(str_cmpr_test_3)
	print_stringnl(str_cmpr_test_1)
	la    $a0, str_cmpr_test_3
	la    $a1, str_cmpr_test_1
	jal str_cmpr
	print_intnl($v0)
	print_string(newline_char)
	
	# "hello" vs. "hellooo" - should print -1
	print_stringnl(str_cmpr_test_1)
	print_stringnl(str_cmpr_test_3)
	la    $a0, str_cmpr_test_1
	la    $a1, str_cmpr_test_3
	jal str_cmpr
	print_intnl($v0)
	print_string(newline_char)
	
	# "hello" vs. "hdllo" - should print 1
	print_stringnl(str_cmpr_test_1)
	print_stringnl(str_cmpr_test_4)
	la    $a0, str_cmpr_test_1
	la    $a1, str_cmpr_test_4
	jal str_cmpr
	print_intnl($v0)
	print_string(newline_char)
	
	# "hello" vs. "hfllo" - should print -1
	print_stringnl(str_cmpr_test_1)
	print_stringnl(str_cmpr_test_5)
	la    $a0, str_cmpr_test_1
	la    $a1, str_cmpr_test_5
	jal str_cmpr
	print_intnl($v0)
	print_stringnl(dash_line)
	
	# str_len tests ------------------------------------------------------------------
	print_stringnl(str_len_test)
	
	print_stringnl(str_len_test_1)
	la $a0, str_len_test_1
	jal str_len
	print_intnl($v0)
	print_string(newline_char)

	print_stringnl(str_len_test_2)
	la $a0, str_len_test_2
	jal str_len
	print_intnl($v0)
	print_string(newline_char)

	print_stringnl(str_len_test_3)
	la $a0, str_len_test_3
	jal str_len
	print_intnl($v0)
	print_string(newline_char)

	print_stringnl(str_len_test_4)
	la $a0, str_len_test_4
	jal str_len
	print_intnl($v0)
	print_string(newline_char)

	print_stringnl(str_len_test_5)
	la $a0, str_len_test_5
	jal str_len
	print_intnl($v0)
	print_stringnl(dash_line)

	# rtrim tests ------------------------------------------------------------------
	print_stringnl(rtrim_test)

    print_stringnl(rtrim_test_1)
    la $a0, rtrim_test_1
    jal rtrim
    print_stringnl(rtrim_test_1)

    print_stringnl(rtrim_test_2)
    la $a0, rtrim_test_2
    jal rtrim
    print_stringnl(rtrim_test_2)

    print_stringnl(rtrim_test_3)
    la $a0, rtrim_test_3
    jal rtrim
    print_stringnl(rtrim_test_3)
	print_stringnl(dash_line)

	# is_white tests ------------------------------------------------------------------
	print_stringnl(is_white_test)

	print_stringnl(is_white_test_1)
	la $a0, is_white_test_1
	jal is_white
	print_intnl($v0)
	print_string(newline_char)
	
	print_stringnl(is_white_test_2)
	la $a0, is_white_test_2
	jal is_white
	print_intnl($v0)
	print_string(newline_char)
	
	print_stringnl(is_white_test_3)
	la $a0, is_white_test_3
	jal is_white
	print_intnl($v0)
	print_stringnl(dash_line)
	
	# is_alpha tests ------------------------------------------------------------------
	print_stringnl(is_alpha_test)

	# test 'a'
	print_stringnl(is_alpha_test_1) 
	la $a0, is_alpha_test_1
	jal is_alpha
	print_intnl($v0)
	print_string(newline_char)
	
	# test 'b'
	print_stringnl(is_alpha_test_2)
	la $a0, is_alpha_test_2
	jal is_alpha
	print_intnl($v0)
	print_string(newline_char)
	
	# test 'z'
	print_stringnl(is_alpha_test_3)
	la $a0, is_alpha_test_3
	jal is_alpha
	print_intnl($v0)
	print_string(newline_char)
	
	# test 'A'
	print_stringnl(is_alpha_test_4)
	la $a0, is_alpha_test_4
	jal is_alpha
	print_intnl($v0)
	print_string(newline_char)
	
	# test 'G'
	print_stringnl(is_alpha_test_5)
	la $a0, is_alpha_test_5
	jal is_alpha
	print_intnl($v0)
	print_string(newline_char)
	
	# test 'Z'
	print_stringnl(is_alpha_test_6)
	la $a0, is_alpha_test_6
	jal is_alpha
	print_intnl($v0)
	print_string(newline_char)
	
	# test '@'
	print_stringnl(is_alpha_test_7)
	la $a0, is_alpha_test_7
	jal is_alpha
	print_intnl($v0)
	print_string(newline_char)
	
	# test '['
	print_stringnl(is_alpha_test_8)
	la $a0, is_alpha_test_8
	jal is_alpha
	print_intnl($v0)
	print_string(newline_char)
	
	# test '{'
	print_stringnl(is_alpha_test_9)
	la $a0, is_alpha_test_9
	jal is_alpha
	print_intnl($v0)
	print_string(newline_char)
	
	# test '`'
	print_stringnl(is_alpha_test_10)
	la $a0, is_alpha_test_10
	jal is_alpha
	print_intnl($v0)
	print_string(newline_char)
	
	# test '1'
	print_stringnl(is_alpha_test_11)
	la $a0, is_alpha_test_11
	jal is_alpha
	print_intnl($v0)
	
	print_stringnl(dash_line)
	
	# is_digit tests ------------------------------------------------------------------
	print_stringnl(is_digit_test)

	# test '0'
	print_stringnl(is_digit_test_1) 
	la $a0, is_digit_test_1
	jal is_digit
	print_intnl($v0)
	print_string(newline_char)
	
	# test '1'
	print_stringnl(is_digit_test_2) 
	la $a0, is_digit_test_2
	jal is_digit
	print_intnl($v0)
	print_string(newline_char)
	
	# test '9'
	print_stringnl(is_digit_test_3) 
	la $a0, is_digit_test_3
	jal is_digit
	print_intnl($v0)
	print_string(newline_char)
	
	# test '/'
	print_stringnl(is_digit_test_4) 
	la $a0, is_digit_test_4
	jal is_digit
	print_intnl($v0)
	print_string(newline_char)
	
	# test ':'
	print_stringnl(is_digit_test_5) 
	la $a0, is_digit_test_5
	jal is_digit
	print_intnl($v0)
	
	print_stringnl(dash_line)
	
	# is_operator tests ------------------------------------------------------------------
	print_stringnl(is_op_test)

	# test '+'
	print_stringnl(is_operator_test_1) 
	la $a0, is_operator_test_1
	jal is_operator
	print_intnl($v0)
	print_string(newline_char)
	
	# test '-'
	print_stringnl(is_operator_test_2) 
	la $a0, is_operator_test_2
	jal is_operator
	print_intnl($v0)
	print_string(newline_char)
	
	# test '*'
	print_stringnl(is_operator_test_3) 
	la $a0, is_operator_test_3
	jal is_operator
	print_intnl($v0)
	print_string(newline_char)
	
	# test '/'
	print_stringnl(is_operator_test_4) 
	la $a0, is_operator_test_4
	jal is_operator
	print_intnl($v0)
	print_string(newline_char)
	
	# test ')'
	print_stringnl(is_operator_test_5) 
	la $a0, is_operator_test_5
	jal is_operator
	print_intnl($v0)
	
	print_stringnl(dash_line)
	
	# is_paren tests ------------------------------------------------------------------
	print_stringnl(is_paren_test)
	# test '('
	print_stringnl(is_paren_test_1) 
	la $a0, is_paren_test_1
	jal is_paren
	print_intnl($v0)
	print_string(newline_char)
	
	# test ')'
	print_stringnl(is_paren_test_2) 
	la $a0, is_paren_test_2
	jal is_paren
	print_intnl($v0)
	print_string(newline_char)
	
	# test '4'
	print_stringnl(is_paren_test_3) 
	la $a0, is_paren_test_3
	jal is_paren
	print_intnl($v0)

	print_stringnl(dash_line)
	
###########################################################
#							 							  #
# Tests for methods in lexer class						  #
#														  #
###########################################################
	print_stringnl(lexer_test)
	
	# init + advance method tests ----------------------------------
	print_stringnl(init_adv_test)

	# test "words 2 + 3 bannana"
	print_stringnl(advance_test_1)
	la $a0, advance_test_1
	jal lex_init
	jal lex_advance
	print_intnl($v0)
	jal lex_advance
	print_intnl($v0)
	jal lex_advance
	print_intnl($v0)
	jal lex_advance
	print_intnl($v0)
	jal lex_advance
	print_intnl($v0)
	jal lex_advance
	print_intnl($v0)

	print_stringnl(dash_line)

	# skip whitespace method tests ----------------------------------
	print_stringnl(skp_white_test)
	
	# test "a    lot of space"
	print_stringnl(skip_white_test_1)
	la   $a0, skip_white_test_1
	jal  lex_init
	print_intnl($v0)

	jal  lex_advance
	print_intnl($v0)

	jal  lex_skip_whitespace
	print_intnl($v0)

	print_stringnl(dash_line)

	# integer parsing method tests ----------------------------------
	print_stringnl(integer_test)

	# test "123    432"
	print_stringnl(integer_test_1)
	la   $a0, integer_test_1
	jal lex_init
	print_intnl($v0)

	jal  lex_integer
	print_intnl($v0)
	
	jal lex_skip_whitespace
	print_intnl($v0)

	jal  lex_integer
	print_intnl($v0)

	print_stringnl(dash_line)

	# get next token method tests ----------------------------------
	print_stringnl(get_next_tok_test)

	# test "123 + 2 * 5"
	print_stringnl(get_next_tok_test_1)
	la   $a0, get_next_tok_test_1
	jal lex_init
	jal  lex_get_next_token
	print_intnl($v0)
	print_intnl($v1)
	jal  lex_get_next_token
	print_intnl($v0)
	print_intnl($v1)
	jal  lex_get_next_token
	print_intnl($v0)
	print_intnl($v1)
	jal  lex_get_next_token
	print_intnl($v0)
	print_intnl($v1)
	jal  lex_get_next_token
	print_intnl($v0)
	print_intnl($v1)
	jal  lex_get_next_token
	print_intnl($v0)
	print_intnl($v1)
	print_string(newline_char)

	# test "+-/^ *()1234"
	print_stringnl(get_next_tok_test_2)
	la   $a0, get_next_tok_test_2
	jal lex_init
	jal  lex_get_next_token
	print_intnl($v0)
	print_intnl($v1)
	jal  lex_get_next_token
	print_intnl($v0)
	print_intnl($v1)
	jal  lex_get_next_token
	print_intnl($v0)
	print_intnl($v1)
	jal  lex_get_next_token
	print_intnl($v0)
	print_intnl($v1)
	jal  lex_get_next_token
	print_intnl($v0)
	print_intnl($v1)
	jal  lex_get_next_token
	print_intnl($v0)
	print_intnl($v1)
	jal  lex_get_next_token
	print_intnl($v0)
	print_intnl($v1)
	jal  lex_get_next_token
	print_intnl($v0)
	print_intnl($v1)
	jal  lex_get_next_token
	print_intnl($v0)
	print_intnl($v1)
	print_string(newline_char)

	# test ""
	print_stringnl(get_next_tok_test_3)
	la   $a0, get_next_tok_test_3
	jal lex_init
	jal  lex_get_next_token
	print_intnl($v0)
	print_intnl($v1)

	print_stringnl(dash_line)
###########################################################
#														  #
# Tests for methods in interpreter class				  #
#														  #
###########################################################
	print_stringnl(interp_test)
	
	# init method tests ----------------------------------
	print_stringnl(interp_init_test)
    
    print_stringnl(interp_init_test_1)
    la   $a0, interp_init_test_1
    jal lex_init
    jal intrp_init

###########################################################
#														  #
# END OF TESTS											  #
#														  #
###########################################################
	pop($a1)
	pop($a0)
	return() # implicit pop($ra); jr $ra
