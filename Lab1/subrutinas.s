
.data
tab_h7s:	  	 ; _gfedcba 
	db 11000000B ; 0 
	db 11111001B ; 1 
	db 10100100B ; 2 
	db 10110000B ; 3
	db 10011001B ; 4
	db 10010010B ; 5
	db 10000010B ; 6
	db 11111000B ; 7
	db 10000000B ; 8
	db 10011000B ; 9
	db 10001000B ; A
	db 10000011B ; b
	db 10100111B ; c
	db 10100001B ; d
	db 10000110B ; E
	db 10001110B ; F

.text

hexa7seg:
	push hl
	ld hl, tab_h7s
	and 0x0f
	ld l, a
	ld a, (hl)
	pop hl
	ret 
 
.end
