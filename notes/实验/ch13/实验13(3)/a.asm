org 0100h

mov ax, cs
mov ds, ax
mov bx, s					
mov si, RowNo
mov cx, RowsNum
_loop:
push bx						; save BX
mov ah, 2					; 10h中断, 2号子例程 -> 置光标
mov bh, 0					; 页号: 0
mov dh,	[si]				; 行号
mov dl, 0					; 列号
int 10h
pop bx						; resume BX
mov dx, [bx]				; ds:dx -> 串地址
mov ah, 9					; 21h中断, 9号子例程 -> 在光标处显示字符串
int 21h
add bx, 2
inc si
loop _loop
mov ax, 4c00h
int 21h

s1: db 'Good,better,best','$'
s2: db 'Never let it rest','$'
s3: db 'Till good is better','$'
s4: db 'And better,best','$'
s: dw s1,s2,s3,s4
RowsNum equ 4
RowNo: db 2,4,6,8