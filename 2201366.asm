.data


.text
main:
addi $s0, $0, 0x66  # iV = 66

lw $s1, 0($a1)# input is in S1
lb $s1, 0($s1)
addi $s1, $s1, -48 
#addi $s1, $0, 2
 
srl $t1, $s1, 24 #first 8-bits in t1

sll $t2, $s1, 8
srl $t2, $t2, 24 #second 8-bits in t2

sll $t3, $s1, 16
srl $t3, $t3, 24 #third 8-bits in t3

sll $t4, $s1, 24
srl $t4, $t4, 24 #last 8-bits in t4

xor $a0, $s0, $t1 #iv xor first 8-bits
jal hash_fn

add $a0, $v0, $0
xor $a0, $a0, $t2
jal hash_fn

add $a0, $v0, $0
xor $a0, $a0, $t3
jal hash_fn

add $a0, $v0, $0
xor $a0, $a0, $t4
jal hash_fn

add $a0, $v0, $0
#
#addi $v0, $0, 1
#syscall
#to remove later

lui $t1, 0x1001
sw $a0, 0($t1)


addi $v0, $0, 10
syscall

hash_fn:

sll $a0, $a0, 24
srl $a0, $a0, 24
#-156x^2
addi $s3, $0, 1
add $t7, $0, $a0
start:
slt $t6, $s3, $a0
beq $t6, $0, exitLoop
add $t7, $t7, $a0
addi $s3, $s3, 1
j start
exitLoop: 
#this loop is for x^2 result is in $t7

sll $s3, $t7, 7
sll $s4, $t7, 4
sll $s5, $t7, 3
sll $s6, $t7, 2

addi $t7, $s3, 0
add $t7, $t7, $s4
add $t7, $t7, $s5
add $t7, $t7, $s6

nor $t7, $t7, $0
addi $t7, $t7, 1
#this implements -156x^2

#31x
sll $s2, $a0, 5
sub $s2, $s2, $a0


#-156x^2+31x
add $t7, $t7, $s2

#78
addi $s2, $0, 78

#-156x^2+31x+78
add $t7, $t7, $s2

add $v0, $t7, $0
sll $v0, $v0, 24
srl $v0, $v0, 24

jr $ra
