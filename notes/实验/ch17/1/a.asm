org 0100h

; ------------------------------------------------------------------
; 接收键盘输入, 若按键为R,G,B, 则将屏幕上的字符设为red,green,blue
; ------------------------------------------------------------------

; 在彩色显示器里，如 CGA、EGA、VGA 等，常用一个字节 ( 8 个位 ) 来表示文字颜色和背景颜色，
; 通常以第 0～3 位表示文字本身颜色；第 4～6 位表示背景颜色，第 7 个位，表示是否闪烁，
; 0 表示不闪烁，1 表示闪烁。

; 颜色值:
; R 0100
; G 0010
; B 0001
; Gray 1000
; 淡红 1100
; 淡绿 1010
; 淡蓝 1001

mov ah, 0
int 16h

mov ah, 1
cmp al, 'r'
je RED
cmp al, 'g'
je GREEN
cmp al, 'b'
je BLUE
jmp _END_

RED:
shl ah, 1
GREEN:
shl ah, 1
BLUE:
mov bx, 0b800h
mov es, bx
mov di, 1
mov cx, 2000
_loop:
and byte [es:di], 11111000b		; 保持背景色不变; 保持灰色文字颜色不变. (经验证, cmd和DOS实模式中文字颜色默认为银灰0111)
or [es:di], ah					; 保持背景色不变; 如果文字原来是灰色, 红绿蓝变成淡红,淡绿,淡蓝
add di, 2
loop _loop

_END_:
mov ax, 4c00h
int 21