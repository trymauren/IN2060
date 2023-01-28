.text
.global main

main:
    MOV r0, #13 
    MOV r1, #0  
    MOV r2, #1  

loop:
	MOV r12, r1
	ADD r1, r1, r2
	MOV r2, r12
	SUBS r0, r0, #1
	BNE loop
	MOV r0, r1
	B exit
exit:
    BX lr
