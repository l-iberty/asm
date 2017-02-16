org 0100h

call CopyMemory
ret

CopyMemory:
	mov ax, Src
	mov si, ax
	mov ax, Des
	mov di, ax
	mov cx, Len
	_loop:
	mov al, [si]
	mov [di], al
	inc si
	inc di
	loop _loop
	ret

Src: db "hello, world"
Des: times 12 db 0
Len equ 12