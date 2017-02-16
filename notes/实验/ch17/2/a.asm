org 0100h

; ----------------------------------字符串输入与显示---------------------------------
; 功能:
; 1. 接收键盘输入并显示到屏幕
; 2. 使用 Backspace 键删除, 并在屏幕上显示结果
; 3. 按下 Enter 键表示输入完毕, 并退出程序
; 4. 字符串以0结尾
; -----------------------------------------------------------------------------------


; 设置字符串显示位置:
mov dh, 12				; 行号 12
mov dl, 20				; 列号 20

_1_:
mov ah, 0
int 16h					; 返回值: ah = 扫描码, al = 字符码
cmp ah, 1ch				; Enter 键的通码: 1ch
je _2_
cmp ah, 0eh				; Backspace 键的通码: 0eh
je _delete_
mov ah, 0
call CharOp				; 字符入栈
mov ah, 2
call CharOp
jmp _1_


_delete_:
mov ah, 1
call CharOp
mov ah, 2
call CharOp
jmp _1_					

_2_:
mov ax, 4c00h
int 21h


; ---------------------------字符的入栈、出栈和显示---------------------------
; 参数说明:
; ah 为功能号. 0-入栈, 1-出栈, 2-显示栈中所有字符
; 0: al=入栈字符
; 1: al=返回字符
; 2: dh, dl分别等于字符串在屏幕上显示的行、列位置
;-----------------------------------------------------------------------------
CharOp:
jmp _begin_

Opt: dw charpush, charpop, charshow
Stack: times 256 db 0
TopOfStack: dw 0

; Stack以 0 填充, 否则为了正常显示字符串, 每次接收键盘输入后
; 还需向字符栈中压入0.

_begin_:
; 除ax外, 例程中用到的寄存器需压栈保存, 以便恢复现场
push bx
push cx
push dx
push es
push di
push ds
push si

cmp ah, 2
ja _end_
mov bl, ah
mov bh, 0
add bx, bx
jmp [Opt+bx]

charpush:
mov bx, Stack
mov si, [TopOfStack]
mov [bx+si], al
inc si
mov [TopOfStack], si		; 更新 TopOfStack
jmp _end_

charpop:
mov si, [TopOfStack]
cmp si, 0
je _end_					; 栈判空
dec si
mov bx, Stack
mov al, [bx+si]				; 从栈里取出字符
mov byte [bx+si], 0			; 清除字符
mov [TopOfStack], si		; 更新 TopOfStack
jmp _end_

charshow:
mov bx, 0b800h
mov es, bx

; ---------------Calculate DI------------------------
; DH = 行号, DL = 列号 ==> DI = DH*160 + DL*2
; DH*160 = DH*128 + DH*32
mov al, dh
mov ah, 0
mov di, ax
mov cl, 7
shl di, cl
mov cl, 5
shl ax, cl
add di, ax
mov dh, 0
add dx, dx
add di, dx
; ------------------OK--------------------------------
; 此时 es:di -> 显示位置

; -------------------清除上次显示的内容---------------------------
; 方法: 用黑色覆盖
; 注意: * 无论栈空与否, 必须先清屏, 否则第一个字符无法从屏幕上清除
;       * inc cx 非常重要
push di
mov si, [TopOfStack]
mov cx, si
inc cx
_clean:
mov word [es:di], 0
add di, 2
loop _clean
pop di
; ----------------------------------------------------------------

mov si, [TopOfStack]
cmp si, 0
je _end_					; 栈判空

mov bx, Stack
mov si, 0					; 初始化 bx+si -> 栈底
mov ah, 0ch					; 红色
_loop:
mov al, [bx+si]
cmp al, 0
je _end_					; 字符串是否结束?
mov [es:di], ax
inc si
add di, 2
jmp _loop


_end_:
pop si
pop ds
pop di
pop es
pop dx
pop cx
pop bx
ret
; ---------------------------End of CharOp-------------------------------------