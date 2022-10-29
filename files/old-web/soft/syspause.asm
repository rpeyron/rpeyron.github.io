code segment

	assume cs:code,ds:code
	
	org 0
	
debut   dw -1,-1
	dw 0000000000000100b
	dw offset strat
	dw offset intr
	db "PAUSEDRV"

ptrdata dw (?),(?)
	
exestart proc far
	push cs
	pop ds
	
	mov ah,09h
	mov dx,offset exemes
	int 21h
	
	mov ah,07h
	int 21h
	
	mov ax,4c00h
	int 21h
	
exestart endp

exemes db "RP-PauseEXE : Veuillez appuyer sur une touche pour continuer.",13,10,"$"
sysmes db "RP-PauseSYS : Veuillez appuyer sur une touche pour continuer.",13,10,"$"

strat proc far
	mov cs:ptrdata,bx
	mov cs:ptrdata+2,es
	ret
strat endp

intr proc far
	push ax
	push dx
	push ds
	push es
	push di
	pushf
	push cs
	pop ds
	
	les di,dword ptr ptrdata
	mov ax,8003h
	cmp byte ptr es:[di+2],00h
	jne short nein
	
	mov word ptr es:[di+14],offset fin
	mov es:[di+14+2],cs

	mov ah,09h
	mov dx,offset sysmes
	int 21h
	
	mov ah,07h
	int 21h

	xor ax,ax

nein label near 
	or ax,0100h
	mov es:[di+3],ax
	
	popf
	pop di
	pop es
	pop ds
	pop dx
	pop ax

	ret
intr endp

fin label near

code ends
     end exestart
