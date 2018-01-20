.globl intrp_init
.globl intrp_eat
.globl intrp_expr
.globl intrp_term
.globl intrp_factor
.globl intrp_power

.data
tok_type:       .space 1
tok_val:        .space 1

.text
# method: lex_init
#	init an instance of the lexer object by populating global variables
# arguments:
#	$a0 - location of input string
# return:
#	$v0 - current char
intrp_init:
intrp_eat:
intrp_expr:
intrp_term:
intrp_factor:
intrp_power:
