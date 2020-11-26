;POSITIVE AND NEGATIVE NUMBERS IN AN ARRAY

section .data
	msg1 db 'Number of Positive numbers are:'
	msg1len equ $-msg1
	msg2 db 'Number of Negative numbers are:'
	msg2len equ $-msg2
	new db 10
	array dq 10H,-54H,67H,89H,-23H,-11H,43H,-18H,-0A2H,-74H		;Defining the array elements
	%macro disp 4							;defining macrocall
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall
	%endmacro

section .bss
	pos resb 1			;taking pos as the counter variable for positive numbers
	neg1 resb 1							;taking neg1 as the counter variable for negative numbers

section .text 
	global _start

_start:
	mov ebx,array							;ebx will point to the first array element
	mov rcx,10							;storing the total number of elements in the array
	up:BT qword[ebx],63						;testing the msb bit
	jnc positive							
	inc byte[neg1]							;if negative then increment the neg1 counter
	jmp down
	
	positive:
	inc byte[pos]							;if positive then increment the pos counter
	
	down:
	add ebx,8							;to obtain the next digit we increment by 8
	dec rcx								;decrement the total count
	jnz up							
	
	add byte[pos],30H						;converting the count to its ASCII value
	add byte[neg1],30H						;converting the count to its ASCII value

	disp 1,1,msg1,msg1len						;printing 'Number of Postive numbers are:'
	disp 1,1,pos,1							;printing the positve number count
	disp 1,1,new,1							;introducing new line
	disp 1,1,msg2,msg2len						;printing 'Number of Negative numbers are:'
	disp 1,1,neg1,1							;printing the negative number count
	disp 1,1,new,1							;introducing new line

	disp 60,0,0,0							;macro call for exit
