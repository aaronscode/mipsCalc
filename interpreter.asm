.globl intrp_init
.globl intrp_eat
.globl intrp_expr
.globl intrp_term
.globl intrp_factor
.globl intrp_power

.include "macros.asm"

# define token types
.eqv TOK_EOF		0
.eqv TOK_INTEGER	1
.eqv TOK_PLUS		2
.eqv TOK_MINUS		3
.eqv TOK_MUL		4
.eqv TOK_DIV		5
.eqv TOK_EXP		6
.eqv TOK_LPAREN		7
.eqv TOK_RPAREN		8

.data

invalid_syntax: .asciiz "Invalid Syntax!"

tok_type:       .space 1
.align 2 # align on a full word
tok_value:        .space 4


# Grammer definition:
#
# expr  :   term((PLUS|MINUS)term)*
# term  :   power((MUL|DIV)power)*
# power :   factor(EXP factor)*
# factor:   INTEGER | LAPREN expr RPAREN

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
#   $v0 - integer result
intrp_expr:
    push($ra)

    local_var($s0, $zero) # our result

    jal  intrp_term # try to interpet a term from the input
    move $s0, $v0   # copy the term to our result

intrp_expr_L1:
    # check if token type is PLUS or MINUS
    lbu  $t0, tok_type
    beq  $t0, TOK_PLUS, intrp_expr_PLUS
    beq  $t0, TOK_MINUS, intrp_expr_MINUS
    j intrp_expr_end

intrp_expr_PLUS:
    move $a0, $t0
    jal  intrp_eat
    jal  intrp_term
    add  $s0, $s0, $v0
    j intrp_expr_L1

intrp_expr_MINUS:
    move $a0, $t0
    jal  intrp_eat
    jal  intrp_term
    sub  $s0, $s0, $v0
    j intrp_expr_L1

intrp_expr_end:
    move $v0, $s0
    pop($s0)
    return()

# method: intrp_term
#	try to parse a term as defined in the grammar from the input
# arguments:
#   none
# return:
#   $v0 - integer result
intrp_term:
    push($ra)

    local_var($s0, $zero) # our result

    jal  intrp_power
    move $s0, $v0

intrp_term_L1:
    # check if token type is MUL or DIV
    lbu  $t0, tok_type
    beq  $t0, TOK_MUL, intrp_term_MUL
    beq  $t0, TOK_DIV, intrp_term_DIV
    j intrp_term_end

intrp_term_MUL:
    move $a0, $t0
    jal  intrp_eat
    jal  intrp_power
    mul  $s0, $s0, $v0
    j intrp_term_L1

intrp_term_DIV:
    move $a0, $t0
    jal  intrp_eat
    jal  intrp_power
    div  $s0, $s0, $v0
    j intrp_term_L1

intrp_term_end:
    move $v0, $s0
    pop($s0)
    return()

# method: intrp_factor
#	try to parse a factor as defined in the grammar from the input
# arguments:
#   none
# return:
#   $v0 - integer result
intrp_factor:
    push($ra)
    local_var($s0, $zero)
    
    lbu  $t0, tok_type
    beq  $t0, TOK_PLUS, intrp_factor_INT
    beq  $t0, TOK_LPAREN, intrp_factor_LPAREN

intrp_factor_INT:
    lw   $s0, tok_value # save the value of the token before we eat it

    move $a0, $t0 # eat our INT token
    jal  intrp_eat
    
    j intrp_factor_end

intrp_factor_LPAREN:
    # eat our LPAREN token
    move $a0, $t0
    jal intrp_eat
    
    # parse an expression and set our result equal to that
    jal intrp_expr
    move $s0, $v0
    
    # eat the expected RPAREN token
    lbu  $a0, tok_type
    jal intrp_eat
    
    j intrp_factor_end

intrp_factor_end:
    move $v0, $s0 
    pop($s0)
    return()

# method: intrp_power
#	try to parse a power as defined in the grammar from the input
# arguments:
#   none
# return:
#   $v0 - integer result
intrp_power:
    push($ra)

    local_var($s0, $zero) # our result

    jal  intrp_factor
    move $s0, $v0

intrp_power_L1:
    lbu  $t0, tok_type
    beq  $t0, TOK_EXP, intrp_power_EXP
    j intrp_power_end

intrp_power_EXP:
    move $a0, $t0
    jal intrp_eat
    jal intrp_factor
    move $a0, $s0
    move $a1, $v0
    jal math_pow
    move $s0, $v0
    j intrp_power_L1

intrp_power_end:
    move $v0, $s0
    pop($s0)
    return()
