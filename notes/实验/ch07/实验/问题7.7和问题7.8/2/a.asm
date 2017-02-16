org 0100h

mov bx, LABLE_DATA
mov cx, 4
loop_1:
mov dx, cx
mov si, 0
mov cx, 3
loop_2:
mov al, [bx+si]
and al, 11011111b
mov [bx+si], al
inc si
loop loop_2
add bx, 10h		; 定位到下一行
mov cx, dx
loop loop_1
ret

LABLE_DATA:
db "ibm             "
db "dec             "
db "dos             "
db "vax             "