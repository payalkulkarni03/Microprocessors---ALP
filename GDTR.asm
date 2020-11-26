;TO SWITCH FROM REAL MODE TO PROTECTED MODE AND DISPLAY CONTENTS OF GDTR,LDTR,IDTR,TR,MSW

section .data
	msg1 db "GDTR contents are:"
	msg1len equ $-msg1
	
	msg2 db "IDTR contents are:"
	msg2len equ $-msg2

	msg3 db "LDTR contents are:"
	msg3len equ $-msg3

	msg4 db "TR contents are:"
	msg4len equ $-msg4

	msg5 db "MSW contents are:"
	msg5len equ $-msg5

	msg6 db "Base Address:"
	msg6len equ $-msg6

	msg7 db "Offset Address:"
	msg7len equ $-msg7

	new db 10

	%macro disp 4															
	mov rax,%1					;Defining a macro
	mov rdi,%2			
	mov rsi,%3
	mov rdx,%4
	syscall
	%endmacro

section .bss
	gdtr resq 1
	gdtrlimit resw 1
	idtr resq 1
	idtrlimit resw 1
	
	ldtr resw 1
	tr resw 1
	msw resw 1
	
	temp64 resq 1
	temp16 resw 1
	temp1 resb 1
	count resb 1


section .text
	global _start

_start:
	
	disp 1,1,msg1,msg1len				;Displaying the statement"GDTR contents are:"
	disp 1,1,new,1
	
	disp 1,1,msg6,msg6len				;Displaying the statement"Base Address:"
	mov esi,gdtr
	sgdt[esi]
	call disp64

	disp 1,1,new,1
	disp 1,1,msg7,msg7len				;Displaying the statement"Offset Address:"
	mov esi,gdtrlimit
	call disp16                    
	disp 1,1,new,1
	disp 1,1,new,1


	disp 1,1,msg2,msg2len				;Displaying the statement"IDTR contents are:"
	disp 1,1,new,1

	disp 1,1,msg6,msg6len				;Displaying the statement"Base Address:"
	mov esi,idtr
	sidt [esi]
	call disp64
	disp 1,1,new,1

	disp 1,1,msg7,msg7len				;Displaying the statement"Offset Address:"
	mov esi,idtrlimit
	call disp16
	disp 1,1,new,1
	disp 1,1,new,1


	disp 1,1,msg3,msg3len				;Displaying the statement"LDTR contents are:"
	mov esi,ldtr
	sldt[esi]
	call disp16
	disp 1,1,new,1

	disp 1,1,msg4,msg4len				;Displaying the statement"TR contents are:"
	mov esi,tr
	str[esi]
	call disp16
	disp 1,1,new,1

	disp 1,1,msg5,msg5len				;Displaying the statement"MSW contents are:"
	mov esi,msw
	smsw[esi]
	call disp16
	disp 1,1,new,1

	disp 60,0,0,0


	disp64:
		mov byte[count],16			;Taking count as 16
		mov rax,qword[esi]
	up1:	rol rax,4
		mov qword[temp64],rax			;Storing the rotated contents into another variable
		and rax,0Fh
		cmp rax,09h				;Converting into ASCII
		jbe down1
		add rax,07h
	down1:	add rax,30h
		mov byte[temp1],al			
		disp 1,1,temp1,1			;Displaying one byte at a time
		mov rax,[temp64]			;Loading the initially rotated contents back to rax register
		dec byte[count]				;Decrementing the counter
		jnz up1
		ret


	disp16:
		mov byte[count],04			;Taking count as 4
		mov ax,word[esi]
	up2:	rol ax,4
		mov word[temp16],ax			;Storing the rotated contents into another variable
		and ax,0Fh
		cmp ax,09h				;Converting into ASCII
		jbe down2
		add ax,07h
	down2:	add ax,30h
		mov byte[temp1],al	
		disp 1,1,temp1,1			;Displaying one byte at a time
		mov ax,[temp16]				;Loading the initially rotated contents back to ax register
		dec byte[count]				;Decrementing the counter
		jnz up2
		ret
