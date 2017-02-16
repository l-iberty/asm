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
mov ax, cs
mov ds, ax
mov si, String				; ds:si -> 串地址
call DispStr
int 7ch
mov ax, cs
mov ds, ax
mov si, String
call DispStr
ret

DispStr:	; 8086CPU的显存: b8000~bffff (b800:0~bfff:f)
	push ds
	push si
	mov ax, 0b800h
	mov es, ax
	mov di, 12*160+36*2			; 设置es:di指向显存的中间位置
	_lb:
	mov al, [ds:si]
	test al, al
	jz ok
	mov ah, 0ch					; 红色
	mov [es:di], ax
	inc si
	add di, 2
	jmp _lb
	ok:
	pop si
	pop ds
	ret
	

; ------------------------中断例程源代码, 中断类型码: 7ch--------------------
; ------------------------功能: 将以0结尾的字符串转换为大写------------------
; ------------------------参数: ds:si指向字符串------------------------------
INT_7C_START:
_loop:
mov al, [ds:si]
test al, al
jz OK
and al, 11011111b
mov [ds:si], al
inc si
jmp _loop
OK:
iret
INT_7C_END:
; ----------------------------------------------------------------------------

String: db "iNfOrMaTiOn",0