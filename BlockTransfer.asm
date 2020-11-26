;OVERLAP AND NONOVERLAP BLOCK TRANSFER

section .data
arr db "ABCDE00000"
msg1 db "Enter 1. for non overlapping block transfer without string instruction",10
msg2 db "Enter 2. for non overlapping block transfer with string instruction",10
msg3 db "Enter 3. for  overlapping block transfer without string instruction",10
msg4 db "Enter 4. for  overlapping block transfer with string instruction",10 
msg5 db "Enter 5. EXIT",10 
msglen equ $-msg1
msg6 db "Enter  an offset",10
msg6len equ $-msg6

section .bss
choice resb 2
off resd 1

%macro inout 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro

section .text
global _start
_start:

inout 1,1,msg1,msglen

inout 0,0,choice,2


cmp byte[choice],31H
 je label1
cmp byte[choice],32H
 je label2
cmp byte[choice],33H
 je label3
cmp byte[choice],34H
 je label4

cmp byte[choice],35H
 je exit
   
label1:
	mov ecx,5H
	mov esi,arr
	mov edi,arr
	add edi,5H

again:	mov al,[esi]
	mov [edi],al
	inc esi
	inc edi
	dec ecx
	jnz again
	inout 1,1,arr,10
	jmp exit
label2:
	mov ecx,5H
	mov esi,arr
	mov edi,arr
	add edi,5H

	CLD
	REP MOVSB	 
	inout 1,1,arr,10
	jmp exit
label3:
	inout 1,1,msg6,msg6len
	inout 0,0,off,1
	sub dword[off],30H
	
	mov ecx,5H
	mov esi,arr
	mov edi,arr
	add esi,4H
	add edi,4H
	add edi,dword[off]
	
up:	mov al,[esi]
	mov [edi],al
	dec esi
	dec edi
	dec ecx
	jnz up
	inout 1,1,arr,10
	 
	jmp exit

label4:
	inout 1,1,msg6,msg6len
	inout 0,0,off,1
	sub dword[off],30H
	
	mov ecx,5H
	mov esi,arr
	mov edi,arr
	add esi,4H
	add edi,4H
	add edi,dword[off]
	
	STD
	REP MOVSB

	inout 1,1,arr,10
	jmp  exit	
	
exit:
mov rax,60
mov rsi,0
syscall
