org 0100h

; 搬运代码至0000:0200
mov ax, cs
mov ds, ax
mov si, INT_0_START					; ds:si -> 源地址
mov ax, 0000h
mov es, ax
mov di, 0200h						; es:di -> 目标地址
mov cx, INT_0_END - INT_0_START		; cx = 传输长度
cld									; 传输方向为正
rep movsb


; 设置中断向量表
; 中断向量存放区域: 0000:0000~0000:03E8
mov ax, 0000h					; 中断向量表的段地址
mov ds, ax
mov bx, 0200h
mov word [INTCODE*4], bx		; IP
mov bx, 0000h		
mov word [INTCODE*4+2], bx		; CS

INTCODE equ 0

; 测试
int 0h
ret

; ------------------------中断例程源代码, 中断类型码: 0h--------------------
; --------------------------向屏幕中央显示字符串"Hello"-----------------------
; 8086CPU的显存: b8000~bffff (b800:0~bfff:f)
INT_0_START:
mov ax, cs
mov ds, ax
mov si, MessageOffset		; 设置ds:0200+si指向字符串
mov ax, 0b800h
mov es, ax
mov di, 12*160+36*2			; 设置es:di指向显存的中间位置
mov cx, Strlen
_loop:
mov al,[0200h+si]
mov ah, 0ch					; 红色
mov [es:di], ax
inc si
add di, 2
loop _loop
iret
Message: db "Hello",0
Strlen equ 5
MessageOffset equ Message-INT_0_START
INT_0_END:
; ----------------------------------------------------------------------------
