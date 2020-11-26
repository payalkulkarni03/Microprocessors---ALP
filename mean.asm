;TO OBTAIN MEAN,VARIANCE AND STANDARD DEVIATION

section .data

	new db 10
	msg db "Program for Mean,Variance and Standard Deviation",10
	msglen equ $-msg

	msg1 db "Mean is:"
	msg1len equ $-msg1

	msg2 db "Variance is:"
	msg2len equ $-msg2

	msg3 db "Standard Deviation is:"
	msg3len equ $-msg3

	dot db "."
	arr dd 10.13,20.1,30.8,12.4,16.5				;declaring array of floating point numbers
	divisor dd 5.0							;divisor to divide the sum of five numbers by five
	mult dd 10000.0							
	mean dt 0.0
	var dt 0.0
	sd dt 0.0
	temp1 dd 0.0		
	temp2 dd 0.0
	count db 5

	%macro operate 4						;macro call
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall
	%endmacro 

section .bss

	result resb 1
	temp resb 1
	counter resb 1
	counter2 resb 1
	variance resd 1

section .text

global _start:

_start:
	operate 1,1,msg,msglen
	operate 1,1,msg1,msg1len
	call mean1						;calling the procedure to calculte mean
	mov ebp,mean						;pointing to the variable which has mean stored
	call display
	operate 1,1,new,1					;introducing a new line in the program

	operate 1,1,msg2,msg2len
	call variance1						;calling the procedure to calculate mean
	mov ebp,var						;pointing to the variable which has variance stored
	call display
	operate 1,1,new,1

	operate 1,1,msg3,msg3len
	call sd1						;calling the procedure to calculate standard deviation
	mov ebp,sd				;pointing to the variable which has standard deviation stored
	call display
	operate 1,1,new,1
	operate 60,0,0,0					;exit call
	; MEAN
mean1:	
	mov esi,arr
	mov cl,5
	fldz							;loading zero to all locations of the stack
     up1:
fadd dword[esi]		;adding the elements of the array one by one with the top of stack
	add esi,4			;incrementing esi to point to the next location
	dec cl
	jnz up1	
	fdiv dword[divisor]					;dividing the sum of numbers by five
	fst dword[temp1] 
;storing the mean in a temporary variable which will berequiredto calculate variance
	fmul dword[mult]					;multiplying the mean by 10,000
	fbstp tword[mean]					;storing the stack contents in the variable mean
	ret

	;VARIANCE

variance1:

	mov dword[variance],00h
	mov dl,05h
	mov esi,arr
   up2:	fldz
	fadd dword[esi]						;adding the each array element with the top of stack
	fsub dword[temp1]					;subtracting the mean from the element
	fmul st0						;taking square of this subtracted value
	fld dword[variance]					;loading the variance of the previous loop on the stack top
	fadd							;adding the new variance with the old variance value
	fstp dword[variance]					;storing this value in the variable variance
	add esi,4
	dec dl	
	jnz up2

	fld dword[variance]
	fdiv dword[divisor]
	fst dword[temp2]
	fmul dword[mult]
	fbstp tword[var]
	ret

	;STANDARD DEVIATION

   sd1:
	fldz
	fadd dword[temp2]
	fsqrt							;finding square root of the variance stored on top of stack
	fmul dword[mult]
	fbstp tword[sd]
	ret


	;PRINTING

display:
	mov bx,00h
	
	add ebp,09h
	mov byte[counter],0Ah
	
   up4:	cmp byte[ebp],00h
	je down1
	cmp byte[counter],02h
	jne down2
	operate 1,1,dot,1
 down2:	mov byte[counter2],02h
	mov bl,[ebp]
   up3:	rol bl,4						;Rotate bx left by 4 bits
	mov byte[temp],bl					;Store rotated number in any temporary variable
	and bl,0Fh						;AND with 0Fh to get the last digit
	cmp bl,09h
	jbe down3
	add bl,07h
 down3:	add bl,30h
	mov byte[result],bl					;Copy the obtained bit in result
	operate 1,1,result,1					;Display the obtained bit
	mov bl,byte[temp]
	dec byte[counter2]
	jnz up3
 down1:	dec ebp
	dec byte[counter]
	jnz up4
	ret
