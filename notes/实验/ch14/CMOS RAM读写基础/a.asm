org 0100h

call TestRead
call TestWrite
call TestRead
mov ax, 4c00h
int 21h

TestRead:
; 读取 CMOS RAM 的2号单元的内容
mov al, 2
out 70h, al				; 将2送入端口70h(地址端口)
in al, 71h				; 从71h(数据端口)读出2号单元的内容
ret


TestWrite:
; 向 CMOS RAM 的2号单元写入0
mov al, 2
out 70h, al				; 将2送入端口70h(地址端口)
mov al, 0
out 71h, al				; 写入
ret