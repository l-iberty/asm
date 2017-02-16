org 0100h

mov bx, 0
mov cx, 0ch

mov ax, 0ffffh
mov ds, ax
mov ax, 0020h
mov es, ax
_loop:
mov dl, [bx]
mov [es:bx], dl
inc bx
loop _loop

ret