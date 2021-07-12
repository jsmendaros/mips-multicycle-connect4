.text
main:
addi $t0, $zero, 0x3000 #base reg
sw $0, 0($t0) #initialize to 0	
sw $0, 4($t0) #initialize to 0	
sw $0, 8($t0) #initialize to 0	
sw $0, 12($t0) #initialize to 0	
sw $0, 16($t0) #initialize to 0	
sw $0, 20($t0) #initialize to 0	
	
addi $t1, $zero, 1 #set bit
sll $a1, $t1, 16 #score bit=1	
sll $a2, $t1, 17 #enable interrupt bit =1
sll $a0, $t1, 18 #clr int
add $t1, $a1, $a2 #set both bits, store	
sw $t1, 24($t0)	
sub $t0, $t0, $t0 #reseet t0

loop:
beq $zero, $zero, loop	#waiting for stuff to do
#a0 = clr int bit
#a1 = enable score bit


#a2 = enable int bit