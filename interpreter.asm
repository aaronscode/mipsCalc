.globl intrp_init
.globl intrp_eat
.globl intrp_expr
.globl intrp_term
.globl intrp_factor
.globl intrp_power

.include "macros.asm"

.data
invalid_syntax: .asciiz "Invalid Syntax!"


tok_type:       .space 1
.align 2 # align on a full word
tok_value:        .space 4

.text
# method: intrp_init
#	init an instance of the interpreter object by initializing class variables
#   @assert that lexer_init has been called to init the lexer object
# arguments:
#   none
# return:
#   none
intrp_init:
    push($ra)
    jal  lex_get_next_token
    sb   $v0, tok_type
    sw   $v1, tok_value
    return()

# method: intrp_eat
#	compare current token type with the expected token type, and if they match,
#   then assign current token to next token. Otherwise there's a syntax error
# arguments:
#   $a0 - expected token type
# return:
#   none
intrp_eat:
    push($ra)

    # check if current token type matches expected
    lbu  $t0, tok_type
    bne  $a0, $t0, intrp_eat_error # if types don't match, throw error

    # tokens matched
    # get next token and assign to current token
    jal  lex_get_next_token 
    sb   $v0, tok_type
    sw   $v1, tok_value

    return()
intrp_eat_error: # TODO throw a proper exception and return to input loop
    print_stringnl(invalid_syntax)
    exit()

# method: intrp_expr
#	try to interpret an expression from the input text
#   @assert that intrp_init has been called to init the interpreter object
# arguments:
#   none
# return:
#   none
intrp_expr:
intrp_term:
intrp_factor:
intrp_power:
