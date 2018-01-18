.globl main
.globl newline_char
.globl space_char
.globl comma_space
.globl null_char
.globl input_str
.globl token_list
.globl shunting_stack
.globl shunting_ids
.globl variable_array
.globl var_init_flags

.include "macros.asm"

.eqv MAX_STR_LEN 	64	# constant for defining string length

.data
# printing strings
newline_char:		.asciiz "\n"
space_char:			.asciiz " "
comma_space:		.asciiz ", "
null_char:			.asciiz "\0"
ans_string:			.asciiz "ans = "
err_string:			.asciiz "An error occured!"

# storage space
input_str:		.space	MAX_STR_LEN # text to read in from user



# list of null-separated strings
token_list: 	.space 	128 

# stack of values, operators, or parens - each item on the stack takes up 4 bytes
# stack of id's for wheter item is number, variable, paren, or operator
.align 2
shunting_stack: .space 	256
.align 2
shunting_ids: 	.space 	256

# array for keeping track of single letter var values,
# array for keeping track of which vars have been initialized
variable_array: .space  58
var_init_flags: .space  58

user_prompt:	.asciiz "calc> "


.text
main: # main program - entry point

	jal tests 	# run test cases
	exit() 		# quit when done
# main loop prompting user for input, 
#prompt_loop:
	# read user input
	#print_string(user_prompt)
	#read_string(input_str, MAX_STR_LEN)
	
	# tokenize input string into token_list
	#la $a0, input_str
	#la $a1, token_list
	#jal tokenize_input
	#beqz $v0, error_occured
	
	# parse tokens into shunting stack
	#jal mk_shunt_stack
	#beqz $v0, error_occured
	
	# evaluate shunting stack to reach a number
	
	# print output 
	#print_string(ans_string)
	
	#j prompt_loop
#error_occured:
	#print_string(err_string)
	#print_string(newline_char)
	#j prompt_loop
