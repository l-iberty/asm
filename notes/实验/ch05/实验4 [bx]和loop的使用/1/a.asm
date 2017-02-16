org 0100h

; 0:200~023F <==> 0020:0~0020:3F
; 传送的数据为 0~3F

mov ax, 0020h
mov ds, ax
mov cx, 40h
mov bx, 0
_loop:
mov [bx], bx
inc bx
loop _loop

ret