org 0100h

call DispStr

call ToUppercase
call DispStr

call ToLowercase
call DispStr

ToUppercase:
	mov ax, cs
	mov ds, ax
	mov bx, Message
	mov cx, 11
	loop_u:
	mov al, [bx]
	or al, 00100000b
	mov [bx], al
	inc bx
	loop loop_u
	ret
	
ToLowercase:
	mov ax, cs
	mov ds, ax
	mov bx, Message
	mov cx, 11
	loop_l:
	mov al, [bx]
	and al, 11011111b
	mov [bx], al
	inc bx
	loop loop_l
	ret

DispStr:
	mov	ax, Message
	mov	bp, ax			; ES:BP = 串地址
	mov	cx, 11			; CX = 串长度
	mov	ax, 01301h		; AH = 13,  AL = 01h
	mov	bx, 000ch		; 页号为0(BH = 0) 黑底红字(BL = 0Ch,高亮)
	mov	dl, 0
	int	10h				; 10h 号中断
	ret

Message: db "iNfOrMaTiOn"
