org 0100h

mov ax, 1000h
mov ds, ax

mov ax, 2000h
mov ss, ax
mov sp, 0020h

push word [0]
push word [2]
push word [4]
push word [6]
push word [8]
push word [0ah]
push word [0ch]
push word [0eh]

ret