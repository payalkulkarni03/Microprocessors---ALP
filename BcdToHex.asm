;BCD TO HEX NUMBER CONVERSION

section .data
	msg1 db "Enter the BCD number:"
	msg1len equ $-msg1
	
	msg2 db "The HEX equivalent of entered BCD is:"
	msg2len equ $-msg2

	new db 10

	%macrodisp4															
	mov rax,%1							;Defining a macro
	mov rdi,%2			
	mov rsi,%3
	mov rdx,%4
	syscall
	%endmacro

section .bss
	product resd 1
	num resb 6
	result resb 1

section .text
	global _start

_start:
	
	;BCD TO HEX

	mov dword[product],00h
	
	disp 1,1,msg1,msg1len						;Displaying the statement "Enter the BCD number"
	disp 0,0,num,6							;Accepting the number

	mov esi,num							;Conversion from BCD to HEX
	mov ecx,0
	mov eax,dword[product]
	mov bx,0Ah
again:	mul bx								;Multiplying contents of bx with ax register
	mov cl,byte[esi]
	sub cl,30h
	add eax,ecx
	inc esi
	cmp byte[esi],0Ah
	jnz again
	mov dword[product],eax

	disp 1,1,msg2,msg2len						;Displaying the statement "The HEX number is"

	mov ebp,08h							;Printing logic
	mov ebx,dword[product]
loop1:	rol ebx,4
	mov dword[product],ebx
	and ebx,000Fh
	cmp bl,09h
	jbe down1
	add bl,07h							;converting into ASCII value
down1:	add bl,30h
	mov byte[result],bl

	disp 1,1,result,1						;Printing the result

	mov ebx,dword[product]
	dec ebp
	jnz loop1

	mov rax,60
	mov rdi,0
	syscall
