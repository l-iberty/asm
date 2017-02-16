org 0100h

mov bx, 0
mov cx, 0ch
_loop:
mov ax, 0ffffh
mov ds, ax
mov dl, [bx]
mov ax, 0020h
mov ds, ax
mov [bx], dl
inc bx
loop _loop

ret