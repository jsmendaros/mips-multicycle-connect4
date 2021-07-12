.data 0x3000
0x100			#0x3000
0x0			#0x3004
0x0			#0x3008
0x0			#0x300c
0x0			#0x3010
0x0			#0x3014
0x30000			#0x3018

#testbench
.text
main:
addi $t0, $0, 0x3000
lw $t2, 0($t0) #get 0x3000 values
sub $t0, $t0, $t0 #reset t0 to 0

check3000:
srl $t2, $t2, 1	#shift 0x3000
beq $t2, $0, CNcheck #when done, check if input was c or n	
addi $t0, $t0, 1 #get position of bit
beq $0, $0, check3000

#t0 has bit position of t2
CNcheck:
add $s7, $t0, $0
sub $t2, $t2, $t2
addi $t2, $0, 5	#check if input C				
beq $t2, $t0, clearbutton
sub $t2, $t2, $t2 
addi $t2, $0, 11 #check if N
beq $t2, $t0, newbutton	
beq $0, $0, colorcheck	#must be color

clearbutton:
sub $t1, $t1, $t1
addi $t1, $0, 0x3000 #init 3000
sw $0, 4($t1) #reset to 0
sw $0, 8($t1)
sw $0, 12($t1)
sw $0, 16($t1)
sw $0, 20($t1)
beq $0, $0, continue #next round

#HANDLE LATER
newbutton:
sub $t1, $t1, $t1
addi $t1, $0, 0x3000
sw $0, 4($t1)#reset to 0
sw $0, 8($t1) #reset to 0
sw $0, 12($t1) #reset to 0
sw $0, 16($t1) #reset to 0
sw $0, 20($t1) #reset to 0
add $t4, $a1, $a2 #return set enable int, enable score bits
sw $t4, 24($t1)
beq $0, $0, continue

colorcheck:
#color button checking
#t0 has position of bit
redtest:
sub $t1, $t1, $t1
add $t1, $0, $t0 #copy to t1
beq $t1, $0, red_pressed #r1
addi $t1, $t1, -1
beq $t1, $0, red_pressed #r2
addi $t1, $t1, -1
beq $t1, $0, red_pressed #r3
addi $t1, $t1, -1
beq $t1, $0, red_pressed #r4
addi $t1, $t1, -1
beq $t1, $0, red_pressed #r5
beq $0, $0, yellow_pressed #must be yellow then

# eliminated first whether c or n, then red, then yellow

#t0 has position of bit
red_pressed:
sub $t1, $t1, $t1
addi $t3, $0, 5	# max rows of board
addi $t1, $0, 0x3000	
sub $t2, $t2, $t2
#t0 has position of bit
redrowloop:
beq $t3, $0, continue #if all pairs filled, continue
addi $t6, $0, 30 #max shift bit pair
addi $t1, $t1, 0x0004 #check next reg
lw $t4, 0($t1)	#load contents of next reg
addi $t2, $0, 8	#max shift till lsb
add $t8, $t0, $t0 # multiply by 2 since bit pair
sub $t2, $t2, $t8 #8-2x
sub $t6, $t6, $t2 #30-8-2x = amount of needed shifts
add $k0, $0, $t6		
add $t7, $t4, $0	
#t4 has laman ng 30xx reg -> which column pushed
#now t7 has it	
#t6 has amount to wipe nasa likod ng bit in 30xx reg		
isored1:
sll $t7, $t7, 1	#shift 30xx reg once
addi $k0, $k0, -1 #shift counter
bne $k0, $0, isored1	
srl $t7, $t7, 30 #pang remove ng mga nasa harap ni bit

#bit pair now at lsb
addi $t3, $t3, -1 #decrement counter
bne $t7, $0, redrowloop	#loop to the next row above


addi $k1, $0, 1	
addi $t2, $t2, 1 #add 1 to account for yellow bit
sub $t6, $t6, $t6 #reset counter to 0
beq $0, $t2, continue2redscore

isored2:
sll $k1, $k1, 1	
addi $t6, $t6, 1
bne $t6, $t2, isored2

continue2redscore:
add $t4, $t4, $k1
sw $t4, 0($t1)	#return orig reg
beq $0, $0, red_scorecheck #check if scored


#t0 has position of bit
yellow_pressed:
addi $s7, $s7, -6 #move to LSB of reg
sub $t1, $t1, $t1
addi $t3, $0, 5	# max rows of board
addi $t1, $0, 0x3000	
sub $t2, $t2, $t2
#t0 has position of bit
yellowrowloop:
beq $t3, $0, continue #if all pairs filled, continue
addi $t6, $0, 30 #max shift bit pair
addi $t1, $t1, 0x0004 #check next reg
lw $t4, 0($t1)	#load contents of next reg
addi $t2, $0, 8	#max shift till lsb
add $t8, $s7, $s7 # multiply by 2 since bit pair
sub $t2, $t2, $t8 #8-2x
sub $t6, $t6, $t2 #30-8-2x = amount of needed shifts
add $k0, $0, $t6		
add $t7, $t4, $0	
#t4 has laman ng 30xx reg -> which column pushed
#now t7 has it	
#t6 has amount to wipe nasa likod ng bit in 30xx reg		
isoyellow1:
sll $t7, $t7, 1	#shift 30xx reg once
addi $k0, $k0, -1 #shift counter
bne $k0, $0, isoyellow1	
srl $t7, $t7, 30 #pang remove ng mga nasa harap ni bit

#bit pair now at lsb
addi $t3, $t3, -1 #decrement counter
bne $t7, $0, yellowrowloop #loop to the next row above


addi $k1, $0, 1	
sub $t6, $t6, $t6 #reset counter to 0
beq $0, $t2, continue2redscore

isoyellow2:
sll $k1, $k1, 1	
addi $t6, $t6, 1
bne $t6, $t2, isoyellow2
add $t4, $t4, $k1
sw $t4, 0($t1)	#return orig reg
beq $0, $0, yellow_scorecheck #check if scored

red_scorecheck:
sub $t0, $t0, $t0
sub $t1, $t1, $t1
sub $t2, $t2, $t2
sub $t3, $t3, $t3
sub $t4, $t4, $t4
sub $a3, $a3, $a3
sub $s0, $s0, $s0
sub $s1, $s1, $s1
sub $s2, $s2, $s2
sub $s3, $s3, $s3
sub $s4, $s4, $s4
sub $s5, $s5, $s5
addi $t0, $0, 0x3000 #base reg
addi $a3, $0, 8	#10 + 10 + 10 + 10 = 8
red_checkcolumn:
lw $t0, 4($t0) #load succeeding 30xx registers into t0->t4
lw $t1, 8($t0)
lw $t2, 12($t0)	
lw $t3, 16($t0)	
lw $t4, 20($t0)
# column 1
srl $s0, $t0, 8	#isolate column 1 bit pairs
srl $s1, $t1, 8	
srl $s2, $t2, 8	
srl $s3, $t3, 8	
srl $s4, $t4, 8	
add $s5, $s0, $s1
add $s5, $s5, $s2
add $s5, $s5, $s3
beq $s5, $a3, add_red_score
sub $s5, $s5, $s0
add $s5, $s5, $s4
beq $s5, $a3, add_red_score
# column 2
sll $s0, $t0, 24
srl $s0, $s0, 30
sll $s1, $t1, 24
srl $s1, $s1, 30
sll $s2, $t2, 24
srl $s2, $s2, 30
sll $s3, $t3, 24
srl $s3, $s3, 30
sll $s4, $t4, 24
srl $s4, $s4, 30
add $s5, $s0, $s1
add $s5, $s5, $s2
add $s5, $s5, $s3
beq $s5, $a3, add_red_score
sub $s5, $s5, $s0
add $s5, $s5, $s4
beq $s5, $a3, add_red_score
# column 3
sll $s0, $t0, 26
srl $s0, $s0, 30
sll $s1, $t1, 26
srl $s1, $s1, 30
sll $s2, $t2, 26
srl $s2, $s2, 30
sll $s3, $t3, 26
srl $s3, $s3, 30
sll $s4, $t4, 26
srl $s4, $s4, 30
add $s5, $s0, $s1
add $s5, $s5, $s2
add $s5, $s5, $s3
beq $s5, $a3, add_red_score
sub $s5, $s5, $s0
add $s5, $s5, $s4
beq $s5, $a3, add_red_score
# column 4
sll $s0, $t0, 28
srl $s0, $s0, 30
sll $s1, $t1, 28
srl $s1, $s1, 30
sll $s2, $t2, 28
srl $s2, $s2, 30
sll $s3, $t3, 28
srl $s3, $s3, 30
sll $s4, $t4, 28
srl $s4, $s4, 30
add $s5, $s0, $s1
add $s5, $s5, $s2
add $s5, $s5, $s3
beq $s5, $a3, add_red_score
sub $s5, $s5, $s0
add $s5, $s5, $s4
beq $s5, $a3, add_red_score
# column 5
sll $s0, $t0, 30
srl $s0, $s0, 30
sll $s1, $t1, 30
srl $s1, $s1, 30
sll $s2, $t2, 30
srl $s2, $s2, 30
sll $s3, $t3, 30
srl $s3, $s3, 30
sll $s4, $t4, 30
srl $s4, $s4, 30
add $s5, $s0, $s1
add $s5, $s5, $s2
add $s5, $s5, $s3
beq $s5, $a3, add_red_score
sub $s5, $s5, $s0
add $s5, $s5, $s4
beq $s5, $a3, add_red_score

red_checkrow:
addi $t0, $0, 0x3000 #base reg
addi $t3, $0, 0xAA #10101010
addi $t5, $0, 5
checkredrows_loop:
addi $t0, $t0, 4 #next row
lw $t1, 0($t0)
srl $t2, $t1, 2
beq $t2, $t3, add_red_score
sll $t2, $t1, 24
srl $t2, $t2, 24
beq $t2, $t3, add_red_score
addi $t5, $t5, -1 #row counter
bne $t5, $0, checkredrows_loop
beq $0, $0, continue


yellow_scorecheck:
sub $t0, $t0, $t0
sub $t1, $t1, $t1
sub $t2, $t2, $t2
sub $t3, $t3, $t3
sub $t4, $t4, $t4
sub $a3, $a3, $a3
sub $s0, $s0, $s0
sub $s1, $s1, $s1
sub $s2, $s2, $s2
sub $s3, $s3, $s3
sub $s4, $s4, $s4
sub $s5, $s5, $s5
addi $t0, $0, 0x3000 #load base reg
addi $a3, $0, 4 #01 + 01 + 01 + 01 = 4
yellow_checkcolumn:
lw $t0, 4($t0) #store in t0->t4
lw $t1, 8($t0)
lw $t2, 12($t0)	
lw $t3, 16($t0)	
lw $t4, 20($t0)	
#c1
srl $s0, $t0, 8	#isolate column 1 bit pairs
srl $s1, $t1, 8	
srl $s2, $t2, 8	
srl $s3, $t3, 8	
srl $s4, $t4, 8	
add $s5, $s0, $s1
add $s5, $s5, $s2
add $s5, $s5, $s3
beq $s5, $a3, add_yellow_score
sub $s5, $s5, $s0
add $s5, $s5, $s4
beq $s5, $a3, add_yellow_score
#c2
sll $s0, $t0, 24
srl $s0, $s0, 30
sll $s1, $t1, 24
srl $s1, $s1, 30
sll $s2, $t2, 24
srl $s2, $s2, 30
sll $s3, $t3, 24
srl $s3, $s3, 30
sll $s4, $t4, 24
srl $s4, $s4, 30
add $s5, $s0, $s1
add $s5, $s5, $s2
add $s5, $s5, $s3
beq $s5, $a3, add_yellow_score
sub $s5, $s5, $s0
add $s5, $s5, $s4
beq $s5, $a3, add_yellow_score
#c3
sll $s0, $t0, 26
srl $s0, $s0, 30
sll $s1, $t1, 26
srl $s1, $s1, 30
sll $s2, $t2, 26
srl $s2, $s2, 30
sll $s3, $t3, 26
srl $s3, $s3, 30
sll $s4, $t4, 26
srl $s4, $s4, 30
add $s5, $s0, $s1
add $s5, $s5, $s2
add $s5, $s5, $s3
beq $s5, $a3, add_yellow_score
sub $s5, $s5, $s0
add $s5, $s5, $s4
beq $s5, $a3, add_yellow_score
#c4
sll $s0, $t0, 28
srl $s0, $s0, 30
sll $s1, $t1, 28
srl $s1, $s1, 30
sll $s2, $t2, 28
srl $s2, $s2, 30
sll $s3, $t3, 28
srl $s3, $s3, 30
sll $s4, $t4, 28
srl $s4, $s4, 30
add $s5, $s0, $s1
add $s5, $s5, $s2
add $s5, $s5, $s3
beq $s5, $a3, add_yellow_score
sub $s5, $s5, $s0
add $s5, $s5, $s4
beq $s5, $a3, add_yellow_score
#c5
sll $s0, $t0, 30
srl $s0, $s0, 30
sll $s1, $t1, 30
srl $s1, $s1, 30
sll $s2, $t2, 30
srl $s2, $s2, 30
sll $s3, $t3, 30
srl $s3, $s3, 30
sll $s4, $t4, 30
srl $s4, $s4, 30
add $s5, $s0, $s1
add $s5, $s5, $s2
add $s5, $s5, $s3
beq $s5, $a3, add_yellow_score
sub $s5, $s5, $s0
add $s5, $s5, $s4
beq $s5, $a3, add_yellow_score

yellow_checkrow:
addi $t0, $0, 0x3000
addi $t3, $0, 0x55 # 10101010
addi $t5, $0, 5

checkyellowrows_loop:
addi $t0, $t0, 4	
lw $t1, 0($t0)	
srl $t2, $t1, 2	
beq $t2, $t3, add_yellow_score
sll $t2, $t1, 24
srl $t2, $t2, 24
beq $t2, $t3, add_yellow_score
addi $t5, $t5, -1 #counter
bne $t5, $0, checkyellowrows_loop
beq $0, $0, continue

add_red_score:
sub $t0, $t0, $t0
addi $t0, $, 0x3018 #initialize score reg
lw $t1, 0($t0)
sub $t2, $t2, $t2
addi $t2, $0, 1
sll $t2, $t2, 8	#move to red score bit pos
add $t1, $t1, $t2
sw $t1, 0($t0) #update score
beq $0, $0, continue


add_yellow_score:
sub $t0, $t0, $t0
addi $t0, $0, 0x3018 #initialize score reg
lw $t1, 0($t0)
sub $t2, $t2, $t2
addi $t2, $0, 1
add $t1, $t1, $t2
sw $t1, 0($t0)
beq $0, $0, continue

continue:
sub $t1, $t1, $t1
addi $t1, $0, 0x3018 #initialize score reg
lw $v0, 0($t1)
add $v0, $v0, $a0 #return clear int bit once
sw $v0, 0($t1)
sub $v0, $v0, $a0 #return to normal
sw $v0, 0($t1)
eret