HEX0 equ 0x80
HEX1 equ 0x81
HEX2 equ 0x82
HEX3 equ 0x83
SW equ 0x80

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
	db 10001000B ; a
	db 10000011B ; b
	db 10100111B ; c
	db 10100001B ; d
	db 10000110B ; e
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

pbcda7seg:
	ld b, a
	call hexa7seg
	ld c, a
	ld a, b
	sra a
	sra a
	sra a
	sra a
	call hexa7seg
	ld b, a
	ret
	
binapbcd:
	ld b, 0d
	loop_binapbcd: 
		cp 10d
		jp m, fin_binapbcd
		sub 10d
		inc b
		jp loop_binapbcd
	fin_binapbcd: 
		sla b
		sla b
		sla b
		sla b
		or  b
	ret

despreloj:
	ld a, (ix)
	call binapbcd
	call pbcda7seg
	ld a, b
	out (HEX3), a
	ld a, C
	ld e, a
	out (HEX2), a
	INC ix
	ld a, (ix)
	call binapbcd
	call pbcda7seg
	ld a, b
	out (HEX1), a
	ld a, c
	out (HEX0), a
	INC ix
	ld a, (ix)
	cp 0d
	jp nz, fin_despreloj
	ld a, e
	and 01111111B
	out (HEX2), a
	fin_despreloj: 
		ret
	
.end
