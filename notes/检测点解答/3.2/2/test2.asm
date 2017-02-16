org 0100h

mov ax, 2000h
mov ds, ax

mov ax, 1000h
mov ss, ax
mov sp, 0010h

pop word [0eh]
pop word [0ch]
pop word [0ah]
pop word [8]
pop word [6]
pop word [4]
pop word [2]
pop word [0]

ret