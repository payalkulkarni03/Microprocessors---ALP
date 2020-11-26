;TERMINATE BUT STAY RESIDENT (TSR)
;TSR TO GENERATE PATTERN OF FREQUENCY TONES

.model tiny
.code
org 100h
ptr_ivt dd ?
mov ax,02       ; initialise video driver
int 10h                   
push cs
pop ds
mov al,08h      ; Get interrupt address
mov ah,35h
int 21h
mov word ptr ptr_ivt,bx              ; read from IVT
mov word ptr ptr_ivt+2,es
mov dx,offset start_isr              ; Set interrupt address
mov al,08h
mov ah,25h
int 21h                              ; TSR ( Terminate and Stay Resident )
mov al,00
mov ah,31h
mov dx,2000      ; Amount of memory to be reserved
int 21h

start_isr:

push ax
push bx
push cx
push dx
push es
push ss
push si
push di
push ds
push cs
pop ds

mov ax,0b800h      ; Video Display adapter location
mov es,ax
mov bx,3984        ; Location of Timer on the screen

mov ah,02h         ; Get time
int 1Ah            ; Real Time Clock Driver

mov al,ch          ; Hours
call proc_vram
call proc_colon

mov al,cl          ; Minutes
call proc_vram
call proc_colon

mov al,dh          ; Seconds and Daylight Saving Mode
call proc_vram

pop ds
pop di
pop si
pop ss
pop es
pop dx
pop cx
pop bx
pop ax

jmp cs:ptr_ivt
proc_vram proc near

mov dl,al
mov ah,cl
mov cl,04h
shr dl,cl
mov cl,ah
add dl,30h
mov es:[bx],dl
inc bx
mov byte ptr es:[bx],0fh
inc bx
mov dl,al
and dl,0fh
add dl,30h
mov es:[bx],dl
inc bx
mov byte ptr es:[bx],0fh
inc bx
ret
endp

proc_colon proc near
mov dl,':'
mov es:[bx],dl
inc bx
mov byte ptr es:[bx],0fh
inc bx
ret
endp
end
