;TO FIND ROOTS OF QUADARTIC EQUATION
section .data

	msg db "Program for calculating quadratic roots",10
	msglen equ $-msg
        msg1 db "Roots are real and distinct:"
	msg1len equ $-msg1
        msg2 db "Roots are real and identical:"
	msg2len equ $-msg2
	msg3 db "Roots are imaginary!"
	msg3len equ $-msg3
        msg4 db "  "
	msg4len equ $-msg4
        dot db "."
	tenthousand dd 10000.0
	two dd 2.0
	four dd 4.0

	a dd 1.0
	b dd -4.0
	c dd 4.0
	
	new db 10

	%macro operate 4						;macro call
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall
	%endmacro 

section .bss
	
	count1 resb 1
	count2 resb 1
	delta resd 1
	delta1 resd 1
	temp1 resd 1
	temp2 resb 1
	temp resb 1
	value1 resd 1
	value2 resd 1
	denominator resd 1
	root1 resd 1
	root2 resd 2
	answer rest 1
	result resb 1
	

section .text

global _start:

_start:

	; CALCULATION OF ROOTS

	operate 1,1,msg,msglen
	
	fldz
	fld dword[a]
	fmul dword[two]						;2a
	fstp dword[denominator]					;storing the above value in variable denominator
	
	fldz	
	fld dword[a]
	fmul dword[c]
	fmul dword[four]
	fstp dword[temp1]					;storing 4ac in temp1
	
	fld dword[b]
	fmul dword[b]						;b^2
	fsub dword[temp1]					;b^2-4ac
	
	fst dword[delta1]
	
     ftst							;comparing the stack top contents with zero
	fstsw ax						;acquiring the machine status word in ax
	sahf							;status reflected in the flag register
	jz down4
	ja down5
	
	operate 1,1,msg3,msg3len				;for negative delta i.e for imaginary roots
	operate 60,0,0,0					;exit call	

	
	
 down4:	fldz							;for delta equal to zero
	fsub dword[b]						;-b
	fdiv dword[denominator]					;-b/2a
	fst dword[root1]
	
	fmul dword[tenthousand]
	fbstp tword[answer]
	operate 1,1,msg2,msg2len
	call print
	operate 60,0,0,0					;exit call	

	


 down5:	fldz
	fld dword[delta1]					;loading (b^2-4ac) on the stack
	fsqrt							;sqrt of (b^2-4ac)
	fstp dword[delta]					;storing the square root in the variable delta
	
	
	fldz
	fsub dword[b]						;-b
	fadd dword[delta]					;-b+sqrt(b^2-4ac)
	fstp dword[value1]					;storing the above value in variable value1
	
	
	fldz
	fsub dword[b]						;-b
	fsub dword[delta]					;-b-sqrt(b^2-4ac)
	fstp dword[value2]					;storing the above value in variable value2
		
	
	fld dword[value1]
	fdiv dword[denominator]					;[-b+sqrt(b^2-4ac)]/2a
	fstp dword[root1]
	
	fld dword[value2]
	fdiv dword[denominator]					;[-b-sqrt(b^2-4ac)]/2a
	fstp dword[root2]
	

	operate 1,1,msg1,msg1len
	fld dword[root1]
	fmul dword[tenthousand]
	fbstp tword[answer]
	call print
	operate 1,1,msg4,msg4len
	

	fld dword[root2]
	fmul dword[tenthousand]
	fbstp tword[answer]
	call print
  	operate 60,0,0,0					;exit call	


	;PRINTING

  print:
  
	mov bx,00h
	mov ebp,answer
	add ebp,09h
	mov byte[count1],10
	
   up4:	cmp byte[ebp],00h
	je down1
	cmp byte[count1],02h
	jne down2
	operate 1,1,dot,1
 down2:	mov byte[count2],02h
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
	dec byte[count2]
	jnz up3
 down1:	dec ebp
	dec byte[count1]
	jnz up4
	ret
