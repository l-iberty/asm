org 0100h

mov bx, LABLE_DATA
mov dx, 4
loop_1:
mov si, 0
mov cx, 3
loop_2:
mov al, [bx+si]
and al, 11011111b
mov [bx+si], al
inc si
loop loop_2
mov cx, dx
dec dx
add bx, 10h		; 定位到下一行
loop loop_1
ret

LABLE_DATA:
db "ibm             "
db "dec             "
db "dos             "
db "vax             "