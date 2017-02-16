org 0100h

; 搬运代码至0000:0200
mov ax, cs
mov ds, ax
mov si, INT_7C_START				; ds:si -> 源地址
mov ax, 0000h
mov es, ax
mov di, 0200h						; es:di -> 目标地址
mov cx, INT_7C_END - INT_7C_START	; cx = 传输长度
cld									; 传输方向为正
rep movsb


; 设置中断向量表
; 中断向量存放区域: 0000:0000~0000:03E8
mov ax, 0000h				; 中断向量表的段地址
mov ds, ax
mov bx, 0200h
mov word [INTCODE*4], bx	; IP
mov bx, 0000h		
mov word [INTCODE*4+2], bx	; CS

INTCODE equ 7ch

; 测试
mov ax, 0aabbh
int 7ch
ret

; ------------------------中断例程源代码, 中断类型码: 7ch--------------------
; ------------------------功能: 求一word型数据的平方-------------------------
; ------------------------参数: ax = 代计算的数值----------------------------
; ------------------------返回值: dx,ax中存放高16位和低16位------------------
INT_7C_START:
mul ax
iret
INT_7C_END:
; ----------------------------------------------------------------------------
