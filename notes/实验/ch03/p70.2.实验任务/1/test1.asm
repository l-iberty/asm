org 0100h

mov ax, 0ffffh
mov ds, ax

mov ax, 2200h
mov ss, ax
mov sp, 0100h

mov ax, [0]
mov ax, [2]
mov bx, [4]
mov bx, [6]
push ax
push bx
pop ax
pop bx
push word [4]
push word [6]

ret