;MULTIPLICATION OF 2 8-BIT HEXADECIMAL NUMBERS USING SUCCESSIVE ADDITION AND ADD & SHIFT METHOD

section .data
	msg1 db "Enter the multiplicand:"
	msg1len equ $-msg1

	msg7 db "Enter the multiplier:"
	msg7len equ $-msg7
	
	msg2 db "Enter the your choice:",10
	msg3 db "1.Successive addition",10
	msg4 db "2.Shift and add",10
	msg5 db "3.Exit"
	msg2len equ $-msg2

	msg6 db "The result is:"
	msg6len equ $-msg6

	new db 10

	%macro disp 4															
	mov rax,%1					;Defining a macro
	mov rdi,%2			
	mov rsi,%3
	mov rdx,%4
	syscall
	%endmacro

section .bss
	 prod resb 2
	 num1 resb 3
	 num2 resb 3
	 temp resb 3
	 result resb 1
	 choice resb 2

section .text
	global _start

_start:
	mov word[prod],00h
	mov ax,word[prod]
	
	disp 1,1,msg2,msg2len
	disp 0,0,choice,2
	
	disp 1,1,msg1,msg1len				;Displaying the statement "Enter the Multiplicand"
	disp 0,0,temp,3					;Accepting the number
	mov esi,num1
	call pack

	disp 1,1,msg7,msg7len				;Displaying the statement "Enter the Multiplier"
	disp 0,0,temp,3					;Accepting the number
	mov esi,num2
	call pack

	mov al,byte[choice]
	cmp al,31h
	je label1
	cmp al,32h
	je label2
	cmp al,33h
	je label3
	
label1:	call succadd
	call print
	jmp label3
	
label2:	call shiftadd
	call print
	jmp label3	

label3:	mov rax,60					;Exit call
	mov rdi,0
	syscall



	;PACKING

	pack:	
		mov edi,temp
		mov bx,00h
		mov ax,00h
	loop4:	mov bl,byte[edi]			;Packing logic
		cmp bl,0Ah
		jz loop5
		cmp bl,39h				;Converting to ASCII value
		jbe down2
		sub bl,07h						
	down2:	sub bl,30h	
		rol ax,4				;Rotating the contents of ax and adding the extracted digit to it
		add ax,bx
		inc edi					;Pointing to the next location





		jmp loop4		
	loop5:	mov word[esi],ax
		ret

	
	;SUCCESSIVE ADDITION
	
	succadd:
		mov ax,00h				;Initializing the registers
		mov dx,00h
		mov dl,byte[num1]
		mov cl,byte[num2]
	back1:	add ax,dx
		dec cl
		jnz back1
		mov word[prod],ax
		ret


	;SHIFT AND ADD

	shiftadd:
		mov bx,00h				;Initializing the register
		mov al,byte[num2]
		mov bl,byte[num1]
		mov cx,00h
		mov dx,08h
	back2:	shl cx,01				;Rotationg the product
		shl al,01				;Rotating the multiplier
		jnc down1				;If carry is not generated it indicates that the msb bit is 0
		add cx,bx				;If carry is generated add the multiplicand to the product
	down1:	dec dx					;Decrement the counter
		jnz back2 
		mov word[prod],cx
		ret


	;PRINTING LOGIC
	

	print:	
		disp 1,1,msg6,msg6len
		mov bx,00h
		mov ebp,04h			;Set counter to total number of digits wanted
		mov bx,[prod]
	up2:	rol bx,4			;Rotate bx left by 4 bits
		mov [prod],bx			;Store rotated number in product variable
		and bl,0Fh			;AND with 0Fh to get the last digit
		cmp bl,09h
		jbe down4
		add bl,07h
	down4:	add bl,30h
		mov byte[result],bl		;Copy the obtained bit in result
		disp 1,1,result,1		;Display the obtained bit
		mov bx,[prod]			;Copy the rotated number back in bx
		dec ebp				;Decrement counter
		jnz up2	
		ret	
