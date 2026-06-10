; =============================================
; STAGE 0 — Video mode + write one character
; Compile: nasm -f bin stage0.asm -o stage0.com
; =============================================

org 0x100           ; COM files always start at offset 0x100

start:
    ; --- Step 1: Set 80x25 color text mode ---
    mov ah, 00h
    mov al, 03h
    int 10h

    ; --- Step 2: Hide the cursor ---
    mov ah, 01h
    mov ch, 0x26
    mov cl, 0x07
    int 10h

    ; --- Step 3: Point ES to video memory segment ---
    mov ax, 0xB800
    mov es, ax          ; ES now = 0xB800

    ; --- Step 4: Write 'S' in bright green at row 12, col 38 (center-ish) ---
    ; offset = (12 * 80 + 38) * 2 = (960 + 38) * 2 = 998 * 2 = 1996 = 0x07CC
    mov ax, 12
    mov bx, 80
    mul bx
    add ax, 38
    shl ax, 1
    mov bx, ax
    mov byte [es:bx],   '#'     ; ASCII character
    mov byte [es:bx+1], 0x0C    ; bright green on black

    ; --- Step 5: Wait for any keypress before exiting ---
    mov ah, 00h
    int 16h

    ; --- Step 6: Exit cleanly ---
    mov ah, 4Ch
    mov al, 0
    int 21h