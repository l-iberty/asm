org 0100h

LABLE_BEGIN:
mov ax, cs
mov ds, ax
mov ax, 0020h
mov es, ax
mov bx, 0
mov cx, LABLE_END - LABLE_BEGIN
_loop:
mov al, [bx + $$]
mov [es:bx], al
inc bx
loop _loop
LABLE_END:

ret