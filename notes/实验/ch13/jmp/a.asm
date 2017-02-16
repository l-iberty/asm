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

; 测试, 向屏幕中央显示以0结尾的字符串
; 8086CPU的显存: b8000~bffff (b800:0~bfff:f)
mov ax, cs
mov ds, ax
mov si, String				; ds:si -> 串地址
mov ax, 0b800h
mov es, ax
mov di, 12*160+36*2			; es:di -> 显存的中间位置
mov bx, ok-s
s:
mov al, [si]
test al, al
jz ok
mov ah, 0ch					; 红色
mov [es:di], ax
inc si
add di, 2
int 7ch
ok:
ret
	

; ------------------------中断例程源代码, 中断类型码: 7ch--------------------
; ------------------------功能: 实现jmp指令的功能----------------------------
; ------------------------参数: bx存放跳转偏移量-----------------------------
;
; 使用int调用中断例程后, 标志寄存器、CS、IP依次入栈, CS:IP指向int指令后第一条
; 指令的起始地址. 因此栈映像如下:
;
;				|		|
;				|_______|
;	   SS:SP -> |__IP___|
;				|__CS___|
;				|_Flag__|
;
;
INT_7C_START:
push bp
;
;				|_______|
;	   SS:SP -> |__BP___|
;	   			|__IP___|
;				|__CS___|
;				|_Flag__|
;
mov bp, sp
sub [bp+2], bx			; 将IP设置为s的偏移地址, 从而iret返回后CS:IP指向s.
l_iret:					; 若CX=0, 则返回后的CS:IP指向"int 7ch"后第一条指令.
pop bp
iret
INT_7C_END:
; ----------------------------------------------------------------------------

String: db "Hello, OS World!",0