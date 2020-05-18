;
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; *									  *
; *	    Convert 16-bit binary number in [archive] to decimal	  *
; *									  *
; * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;
    bin2dec:
;
	push ax 		   ; save the registers to the stack
	push bx
	push cx
	push dx
	push bp
	push di
	push si
;
	mov bp,ten_thou_place	   ; Set placeholder pointer
	mov di,0		   ; Set pointer offset
	mov cx,5		   ; Set counter to 5 placeholders
	xor al,al		   ; Clear the placeholders for next calc
;
    clr_next_one:
	mov [bp+di],al
	inc di
	loop clr_next_one	   ; Until counter = 0
;
	mov di,0		   ; Set pointer offset
	mov cx,5		   ; Set counter to 5 placeholders
	mov bx,10000		   ; Set register BX to initial placeholder
				   ; divisor
	mov ax,[archive]	   ; Retrieve a 16-bit binary number
	mov [scratchpad],ax	   ; Copy it to the scratchpad
;
    next_decimal_place:
	mov ax,[scratchpad]	   ; Retrieve it from the scratchpad
	xor dx,dx		   ; Prepare register DX for division
	div bx			   ; Divide number by placeholder divisor
	add [bp+di],al		   ; Add quotient in al to current placeholder
	mov [scratchpad],dx	   ; Save remainder in dx to scratchpad
	mov ax,bx		   ; Prepare for new placeholder divisor
	xor dx,dx
	mov bx,10
	div bx			   ; Divide old placeholder by 10
	mov bx,ax		   ; Set new placeholder divisor
	inc di			   ; Point to next placeholder
	loop next_decimal_place    ; Until counter = 0
;
; Now convert placeholder values to ASCII
; (figure out how to suppress leading zeros in a future version)
;
	mov di,0		   ; Point to placeholder
	mov cx,5		   ; Set counter to 5 placeholders
    convert_next_one:
	mov al,[bp+di]		   ; Retrieve placeholder value
	add al,30h		   ; Convert to ASCII
	mov [bp+di],al		   ; Save ASCII value in placeholder
	inc di			   ; Point to next placeholder
	loop convert_next_one	   ; Until counter = 0
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
ten_thou_place db 0	; These are the ASCII decimal outputs that can be
thou_place db 0 	; directly displayed on the console as a string.
hund_place db 0
tens_place db 0
ones_place db 0
db 24h		    ; end it in a dollar sign to display the numerical value
		    ; as an ASCII string
