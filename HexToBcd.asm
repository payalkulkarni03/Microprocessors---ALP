;HEX TO BCD NUMBER CONVERSION

section .data
	msg1 db "Enter the HEX number:"
	msg1len equ $-msg1

	msg2 db "The BCD equivalent of entered HEX is:"
	msg2len equ $-msg2

	new db 10

	%macro disp 4															
	mov rax,%1								;Macro call
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall
	%endmacro

section .bss
	product resd 1
	num resb 5
	result1 resb 1
	count resb 1

section .text
	global _start

_start:
	
mov dword[product],00h
	
	disp 1,1,msg1,msg1len							;Displaying the statement "Enter the HEX number"
	disp 0,0,num,5				;Accepting the HEX number
	disp 1,1,msg2,msg2len							;Displaying the statement "The BCD number is:"

	mov bx,00h
	mov ax,00h
	mov byte[count],00h
	mov cx,0Ah
	mov esi,num
loop2:	mov bl,[esi]								;Packing logic
	cmp bl,0Ah	;enter key
	jz loop3
	cmp bl,39h
	jbe down2
	sub bl,07h								;Conversion from ASCII to HEX
down2:	sub bl,30h	
	rol ax,4
	add ax,bx
	inc esi
	jmp loop2	
	
	
loop3:	mov dx,00h								
	div cx									;Conversion from HEX to BCD
	push dx			;Pushing the remainder on the stack
	inc byte[count]
	cmp ax,00h
	jnz loop3
	
loop4:	pop cx									;Popping the remainder
	add cl,30h
	mov byte[result1],cl
	disp 1,1,result1,1							;Printing the result
	dec byte[count]
	jnz loop4

	mov rax,60								;Exit call
	mov rdi,0
	syscall
