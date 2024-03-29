HEX0 equ 0x80
HEX1 equ 0x81
HEX2 equ 0x82
HEX3 equ 0x83
SW equ 0x80
BTN equ 0x81
CTE16bit equ 19229d

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
	
reloj:
	db 0d
	db 0d
	db 0d
	
r_seed:
	db	1d		; prng seed byte (must not be zero)

.text

espero:
	push AF
	push DE
	ld DE, CTE16bit
	loop: dec DE
	ld A,D
	or E
	jr NZ, loop
	pop DE
	pop AF
	ret

hexa7seg:
	push hl
	ld hl, tab_h7s
	and 0x0f
	ld l, a
	ld a, (hl)
	pop hl
	ret 

pbcda7seg:
	ld b, a			; preservar el contenido del acumulador
	call hexa7seg
	ld c, a
	ld a, b			; restaurar el acumulador original
	sra a			; rotar cuatro posiciones hacia la derecha
	sra a
	sra a
	sra a
	call hexa7seg
	ld b, a
	ret
	
binapbcd:					; falto preservar bc
	push bc
	ld b, 0d
	loop_binapbcd: 
		cp 10d
		jp m, fin_binapbcd	; if (A - 10d) > 0 then jump a fin_binapbcd
		sub 10d				; else restar 10 e incrementar contador
		inc b
		jp loop_binapbcd
	fin_binapbcd: 
		sla b				; rotar cuatro posiciones a la izquierda
		sla b
		sla b
		sla b
		or  b
	pop bc
	ret

despreloj:
	push af
	push bc
	push de
	ld a, (ix)				; cargamos los segundos al acumulador
	call binapbcd
	call pbcda7seg			; en bc tenemos los segundos codificados a 7seg
	ld a, b			
	out (HEX3), a	
	ld a, c
	ld e, a					; preservamos lo que va en HEX2
	out (HEX2), a			; por si hay que agregarle punto decimal
	ld a, (ix+1)			; cargamos las centesimas al acumulador
	call binapbcd
	call pbcda7seg			; en bc tenemos las centesimas codificadas a 7seg
	ld a, b
	out (HEX1), a
	ld a, c
	out (HEX0), a		
	ld a, (ix+2)		
	cp 0d					; evalua como cero solo si la flag es 0x00
	jp nz, fin_despreloj	; si no vale 0x00, vale 0xFF y no se debe agregar punto decimal
	ld a, e					; recuperamos lo que va en HEX2
	and 01111111B			; mascara para prender el punto decimal
	out (HEX2), a
	fin_despreloj: 
	pop de
	pop bc
	pop af
	ret
	
decreloj:
	push af
	push bc
	ld b,(ix) 			; cargar los segundos
	ld a,(ix+1)			; cargar las centesimas
	cp 10d		
	jp m, cent_neg		; centesimas-10 >= 0? (underflow centesimas)
	sub 10d				; si no hay underflow, restamos 10
	ld (ix+1), a
	jp fin_decreloj		; y saltamos al final
	cent_neg: 			; si hay underflow en las centesimas:
		ld c,(ix+1)	
		ld a, b
		cp 1d		
		jp m , seg_neg	; segundos-1 >= 0? (underflow segundos)
		sub 1d			; si no hay, restamos 1
		ld (ix), a
		ld a, c
		add a, 90d		; las centesimas valen 90+resto previo
		ld (ix+1), a
		ld a, (ix+2)
		cpl				; complementar la bandera
		ld (ix+2), a
		jp fin_decreloj
	seg_neg:			; si hay underflow en los segundos:
		ld (ix), 0d		; satura a cero el contador
		ld (ix+1), 0d
	fin_decreloj:
	pop bc
	pop af
	ret
	
increloj:
	push af
	push bc
	ld b, (ix) 			; cargar los segundos
	ld a, (ix+1)		; cargar las centesimas
	cp 90d
	jp p, cent_ovflw	; centesimas-90 >= 0? (overlflow centesimas)
	add a, 10d
	ld (ix+1), a
	jp fin_increloj
	cent_ovflw:
		ld c,(ix+1)	
		ld a, b
		cp 98d			; overflow segundos
		jp p, seg_ovflw
		add a, 1d
		ld (ix), a
		ld a, c
		sub 90d
		ld (ix+1), a
		ld a, (ix+2)
		cpl
		ld (ix+2), a
		jp fin_increloj
	seg_ovflw:
		ld (ix), 0d
		sub 90d
		ld (ix+1), a
	fin_increloj:
	pop bc
	pop af
	ret


; returns pseudo random 8 bit number in A. Only affects A.
; (r_seed) is the byte from which the number is generated and MUST be
; initialised to a non zero value or this function will always return
; zero. Also r_seed must be in RAM, you can see why......

rand_8:
	ld	a, (r_seed)			; get seed
	and	0xB8				; mask non feedback bits
	scf						; set carry
	jp	po, no_clr			; skip clear if odd
	ccf						; complement carry (clear it)
	no_clr:
		ld	a, (r_seed)		; get seed back
		rla					; rotate carry into byte
		ld	(r_seed), a		; save back for next prn
		ret					; done

.end
