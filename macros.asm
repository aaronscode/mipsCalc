# file: macros.asm

# syscall constants
.eqv PRNT_INT_ID	1	# syscall ID for printing an int
.eqv PRNT_STR_ID 	4	# syscall ID for printing a string
.eqv READ_INT_ID 	5	# syscall ID for reading an int
.eqv READ_STR_ID 	8	# syscall ID for reading in a string
.eqv EXIT_ID		10	# syscall ID for exiting a program

# macro for executing a speficic syscall
# accepts an immediate value as a syscall code as the ide and expects registers
# used by syscall to be set up correctly
.macro do_syscall ($syscall_code)
	li   $v0, $syscall_code
	syscall
.end_macro

# performs a syscall to print the string at address $addr
.macro print_string($addr)
	la $a0, $addr
	do_syscall(PRNT_STR_ID)
.end_macro

# print string and newline
.macro print_stringnl($addr)
	print_string($addr)
	print_string(newline_char)
.end_macro

# performs a syscall to print the int in the register $val
.macro print_int($val)
	move $a0, $val
	do_syscall(PRNT_INT_ID)
.end_macro

# print int and newline
.macro print_intnl($val)
	print_int($val)
	print_string(newline_char)
.end_macro

# performs a syscall to read a string into the address $addr with
# lenght allocated being $size bytes
.macro read_string($addr, $size)
	la $a0, $addr
	la $a1, $size
	do_syscall(READ_STR_ID)
.end_macro

# reads an interger in. Int stored implicitly in $v0
.macro read_int()
	do_syscall(READ_INT_ID)
.end_macro

# performs a syscall to exit the program and stop execution
# usefull for keeping code from running over into subroutine
# definitions without having to set up an infinite empty loop
.macro exit()
	do_syscall(EXIT_ID)
.end_macro

# macro for incrementing the value in the register $val
.macro inc($val)
	addi $val, $val, 1
.end_macro

# push an item onto the stack
.macro push($reg)
	addi $sp, $sp, -4 	# adjust stack for 1 item
	sw   $reg, 0($sp)	# save the register on the stack
.end_macro

# pop an item from the stack
.macro pop($reg)
	lw   $reg, 0($sp)	# load off the stack into $reg
	addi $sp, $sp, 4	# move the stack pointer
.end_macro

# allocate a local var by pushing a saved register ($s0-$s7) to
# stack and initializing it with $value
.macro local_var($reg, $value)
	push($reg)
	move $reg, $value
.end_macro

.macro return()
	pop($ra)
	jr $ra
.end_macro

