org 0100h

; 搬运代码至0000:0204
mov ax, cs
mov ds, ax
mov si, INT_9_START					; ds:si -> 源地址
mov ax, 0000h
mov es, ax
mov di, 0204h						; es:di -> 目标地址
mov cx, INT_9_END - INT_9_START		; cx = 传输长度
cld									; 传输方向为正
rep movsb


; 将原来的9号中断入口地址保存在0000:0200~0000:0203
mov ax, 0000h
mov ds, ax
mov ax, [INTCODE*4]
mov word [0200h], ax
mov ax, [INTCODE*4+2]
mov word [0202h], ax


; 设置中断向量表
; 中断向量存放区域: 0000:0000~0000:03E8
mov ax, 0000h						; 中断向量表的段地址
mov ds, ax
cli
mov word [INTCODE*4], 0204h			; IP
mov word [INTCODE*4+2], 0000h		; CS
sti

mov ax, 4c00h
int 21h


; ------------------------中断例程源代码, 中断类型码: 9h--------------------
INT_9_START:
; 读取60h端口中的扫描码
in al, 60h
pushf
call dword [cs:0200h]				; 执行此中断例程时 CS = 0

; 判断是否为'A'键的断码
cmp al, 9Eh							; 断码9Eh = 通码1Eh + 80h
jne _END_

mov al, 'A'
mov di, 0
;--------------------DispAL----------------------------
DispAL:
push ax
mov ax, 0b800h
mov es, ax
pop ax
mov ah, 0ch							; 红色
mov [es:di], ax						; es:di -> 显存
;------------------DispAL End--------------------------
jmp _END_
_END_:
iret
INT_9_END:

INTCODE equ 9
