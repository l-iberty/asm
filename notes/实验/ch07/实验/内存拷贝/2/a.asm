org 0100h

call CopyMemory
ret

CopyMemory:
	mov ax, Src
	mov si, ax
	mov bx, 0
	mov cx, Len
	_loop:
	mov al, [bx+si]
	mov [bx+si+Len], al
	inc bx
	loop _loop
	ret

Src: db "hello, world"
Des: times 12 db 0
Len equ 12