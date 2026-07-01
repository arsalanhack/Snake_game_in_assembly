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

 ; Set starting position
    mov dh, 2       ; row = 2 (top border row)
    mov dl, 2       ; col = 2 (start from left)

    mov cx, 76      ; how many columns to draw? you figure this out

top_row:

    push cx         ; save loop counter (mul might affect things)
    push dx

    mov ax, dx      ; dx(row,column)--> ax(ah(row),al(column))
    mov al, ah
    xor ah, ah      ; 0 out ah 

    mov bx, 80
    mul bx

    pop dx          ; restore DH=row, DL=col
    push dx  

    xor bh,bh
    mov bl, dl
    add ax, bx

    shl ax, 1
    mov bx, ax
    ; Write the block character
    mov byte [es:bx], 0xDB        ; what character?
    mov byte [es:bx+1], 0x0E      ; what color?

    pop dx          ; restore DX again
    pop cx 
    
    ; Move to next column
    inc dl
    loop top_row


    mov dh, 22      ; row = 22 (Bottem border row)
    mov dl, 2       ; col = 2 (start from left)
    mov cx, 76      ; Length -2 -1

  bottem_row:

      push cx         ; save loop counter (mul might affect things)
      push dx

      mov ax, dx      ; dx(row,column)--> ax(ah(row),al(column))
      mov al, ah
      xor ah, ah      ; 0 out ah 

      mov bx, 80
      mul bx

      pop dx          ; restore DH=row, DL=col
      push dx  

      xor bh,bh
      mov bl, dl
      add ax, bx

      shl ax, 1
      mov bx, ax
      ; Write the block character
      mov byte [es:bx], 0xDB        ; what character?
      mov byte [es:bx+1], 0x0E      ; what color?

      pop dx          ; restore DX again
      pop cx 
      
      ; Move to next column
      inc dl
      loop bottem_row

    
   mov dh, 2       ; row = 2 (top border row)
   mov dl, 2       ; col = 2 (start from left)
   mov cx, 21

  left_row:

      push cx         ; save loop counter (mul might affect things)
      push dx

      mov ax, dx      ; dx(row,column)--> ax(ah(row),al(column))
      mov al, ah
      xor ah, ah      ; 0 out ah 

      mov bx, 80
      mul bx

      pop dx          ; restore DH=row, DL=col
      push dx  

      xor bh,bh
      mov bl, dl
      add ax, bx

      shl ax, 1
      mov bx, ax
      ; Write the block character
      mov byte [es:bx], 0xDB        ; what character?
      mov byte [es:bx+1], 0x0E      ; what color?

      pop dx          ; restore DX again
      pop cx 
      
      ; Move to next column
      inc dh
      loop left_row

  mov dh, 2       ; row = 2 (top border row)
   mov dl, 77       ; col = 2 (start from left)
   mov cx, 21

  right_row:

      push cx         ; save loop counter (mul might affect things)
      push dx

      mov ax, dx      ; dx(row,column)--> ax(ah(row),al(column))
      mov al, ah
      xor ah, ah      ; 0 out ah 

      mov bx, 80
      mul bx

      pop dx          ; restore DH=row, DL=col
      push dx  

      xor bh,bh
      mov bl, dl
      add ax, bx

      shl ax, 1
      mov bx, ax
      ; Write the block character
      mov byte [es:bx], 0xDB        ; what character?
      mov byte [es:bx+1], 0x0E      ; what color?

      pop dx          ; restore DX again
      pop cx 
      
      ; Move to next column
      inc dh
      loop right_row


  ; --- Step 5: Wait for any keypress before exiting ---
    mov ah, 00h
    int 16h

    ; --- Step 6: Exit cleanly ---
    mov ah, 4Ch
    mov al, 0
    int 21h