org 0100h

;========================在屏幕中央显示当前日期=========================
; CMOS RAM中:
; second:0	min:2	hour:4	day:7	month:8	 year: 9
; 6个信息的长度都是1B, 意味着十进制'2017'对应的BCD码————
; 0010 0000 0001 0111 的高8位将丢失

mov di, DI_PTR		; 初始化DI

mov al, YEAR
call GetTime
mov al, '/'
mov cx, 0
call DispAL

mov al, MONTH
call GetTime
mov al, '/'
mov cx, 0
call DispAL

mov al, DAY
call GetTime
mov al, ' '
mov cx, 0
call DispAL

mov al, HOUR
call GetTime
mov al, ':'
mov cx, 0
call DispAL

mov al, MIN
call GetTime
mov al, ':'
mov cx, 0
call DispAL

mov al, SECOND
call GetTime

mov ax, 4c00h
int 21h


GetTime:
out 70h, al
in al, 71h
mov bl, al			; 将AL拷贝一份到BL
mov cl, 4
shr al, cl 			; 取出十位
mov cx, 1
call DispAL
mov al, bl
and al, 00001111b	; 取出个位
mov cx, 1
call DispAL
ret


DispAL:
push ax
mov ax, 0b800h
mov es, ax
pop ax
jcxz not_digit
add al, '0'
not_digit:
mov ah, 0ch					; 红色
mov [es:di], ax				; es:di -> 显存
add di, 2					; DI指向下一个位置
ret


DI_PTR equ 12*160+36*2
SECOND equ 0
MIN equ 2
HOUR equ 4
DAY equ 7
MONTH equ 8
YEAR equ 9
