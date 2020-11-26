;TO FIND FACTORIAL OF A GIVEN INTEGER NO. ON COMMAND LINE BY USING RECURSION.	

section .data
msg db "Enter number: ",10
msglen equ $-msg
msg1 db "Factorial = ",10
msg1len equ $-msg1

section .bss
ans resw 1
num resb 1
temp resb 1

%macro operate 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro

section .text
global _start:
_start:
operate 1,1,msg,msglen
operate 0,0,num,1

mov ax,1
mov bl,byte[num]
sub bl,30h
up:
cmp bl,1h
je label1
mul bl
dec bl
jnz up


label1:
mov word[ans],ax
mov ebp,4
up1:
mov ax,word[ans]
rol ax,4
mov word[ans],ax
and ax,0FH
cmp al,09
jbe down1
add al,07H
down1:
add al,30H
mov byte[temp],al

operate 1,1,temp,1
mov ax,word[ans]
dec ebp
jnz up1
mov rax,60
mov rsi,60
syscall
 
