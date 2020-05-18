;
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; *									  *
; *	  Convert 16-bit binary number in [archive] to hexadecimal	  *
; *									  *
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
    bin2hex:
;
	push ax 		   ; save the registers to the stack
	push bx
	push cx
	push dx
	push bp
	push di
	push si
;
	mov bp,hex_4096 	   ; Set placeholder pointer
	mov di,0		   ; Set pointer offset
	mov cx,4		   ; Set counter to 4 placeholders
	xor al,al		   ; Clear the placeholders for next calc
;
    clr_next_place:
	mov [bp+di],al
	inc di
	loop clr_next_place	   ; Until counter = 0
;
	mov di,0		   ; Set pointer offset
	mov cx,4		   ; Set counter to 4 placeholders
	mov bx,4096		   ; Set register BX to initial placeholder
				   ; divisor
	mov ax,[archive]	   ; Retrieve a 16-bit binary number
	mov [scratchpad],ax	   ; Copy it to the scratchpad
;
    next_hexadecimal_place:
	mov ax,[scratchpad]	   ; Retrieve it from the scratchpad
	xor dx,dx		   ; Prepare register DX for division
	div bx			   ; Divide number by placeholder divisor
	add [bp+di],al		   ; Add quotient in al to current placeholder
	mov [scratchpad],dx	   ; Save remainder in dx to scratchpad
	mov ax,bx		   ; Prepare for new placeholder divisor
	xor dx,dx
	mov bx,10h
	div bx			   ; Divide old placeholder by 16
	mov bx,ax		   ; Set new placeholder divisor
	inc di			   ; Point to next placeholder
	loop next_hexadecimal_place; Until counter = 0
;
; Now convert placeholder values to ASCII
; (figure out how to suppress leading zeros in a future version)
;
	mov di,0		   ; Point to placeholder
	mov cx,4		   ; Set counter to 4 placeholders
    convert_next_place:
	mov al,[bp+di]		   ; Retrieve placeholder value
	add al,30h		   ; Convert to ASCII
;
	cmp al,39h		   ; If ASCII placeholder value > 39h "9"
	jle save_placeholder
	add al,07h		   ; add 07h for ASCII characters "A" - "F"
;
    save_placeholder:		   ; Otherwise
	mov [bp+di],al		   ; Save ASCII value in placeholder
	inc di			   ; Point to next placeholder
	loop convert_next_place    ; Until counter = 0
;
	pop si		; restore the registers from the stack
	pop di
	pop bp
	pop dx
	pop cx
	pop bx
	pop ax
;
;RETURN
    ret
;
archive dw 0		; 16-bit binary input value
scratchpad dw 0
;
; bin2hex output:
;
hex_4096 db 0	; = n*16^3 (0-F)
hex_256 db 0	; = n*16^2 (0-F)
hex_16 db 0	; = n*16^1 (0-F)
hex_01 db 0	; = n*16^0 (0-F)
db 24h
