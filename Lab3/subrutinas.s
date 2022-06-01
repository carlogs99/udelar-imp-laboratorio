HEX0 equ 0x80
HEX1 equ 0x81
HEX2 equ 0x82
HEX3 equ 0x83
SW equ 0x80
BTN equ 0x81
LEDG equ 0x84
; Puertos agregados en Práctica 2:
clearFF equ 0x87
salidaDATA equ 0x86
salidaCLK equ 0x85
entradaDATA equ 0x86
entradaCLK equ 0x85
; Puertos agregados en Práctica 3:
CSTIMER equ 0x90
CSCOUNTER equ 0xa0
CSINT1_CLR equ 0xb1
CSINT1_RDSTATE equ 0xb1
CSINT1_VINT equ 0xb0

; CTE16bit equ 19229d

.org 0x100
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

tab_scodeadigito:
	db 0x70 ; 0
	db 0x69 ; 1
	db 0x72 ; 2
	db 0x7a ; 3
	db 0x6b ; 4
	db 0x73 ; 5
	db 0x74 ; 6
	db 0x6c ; 7
	db 0x75 ; 8
	db 0x7d ; 9
	
.org 0x200
tabla_int:
	dw rutint_counter
	

.data

; reloj:
	; db 0d
	; db 0d
	; db 0d

datos_ps2:
	db 0d
	db 0d
	db 0d
	
int_count:
	db 0d

.text

;espero:
;	push af
;	push de
;	ld de, CTE16bit
;	loop: dec de
;	ld a,d
;	or e
;	jr NZ, loop
;	pop de
;	pop af
;	ret

; recibe en cuatro bits menos significativos de a
; un numero binario y lo pasa a su representacion
; hexa en display 7 segmentos
hexa7seg:
	push hl
	ld hl, tab_h7s
	and 0x0f
	ld l, a
	ld a, (hl)
	pop hl
	ret 

; recibe en a un numero y lo pasa a su representacion 
; hexa en display 7 segmentos
; devuelve en BC los dos digitos 
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
	
binapbcd:					
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

; despreloj:
	; push af
	; push bc
	; push de
	; ld a, (ix)				; cargamos los segundos al acumulador
	; call binapbcd
	; call pbcda7seg			; en bc tenemos los segundos codificados a 7seg
	; ld a, b			
	; out (HEX3), a	
	; ld a, c
	; ld e, a					; preservamos lo que va en HEX2
	; out (HEX2), a			; por si hay que agregarle punto decimal
	inc ix
	; ld a, (ix+1)				; cargamos las centesimas al acumulador
	; call binapbcd
	; call pbcda7seg			; en bc tenemos las centesimas codificadas a 7seg
	; ld a, b
	; out (HEX1), a
	; ld a, c
	; out (HEX0), a
	inc ix			
	; ld a, (ix+2)		
	; cp 0d					; evalua como cero solo si la flag es 0x00
	; jp nz, fin_despreloj	; si no vale 0x00, vale 0xFF y no se debe agregar punto decimal
	; ld a, e					; recuperamos lo que va en HEX2
	; and 01111111B			; mascara para prender el punto decimal
	; out (HEX2), a
	; fin_despreloj: 
	dec ix					; restauramos el registro ix
	dec ix
	; pop de
	; pop bc
	; pop af
	; ret
	
; decreloj:
	; push af
	; push bc
	; ld b,(ix) ; cargar los segundos
	; ld a,(ix+1)	; cargar las centesimas
	; cp 10d		
	; jp m, cent_neg	; centesimas-10 >= 0? (underflow centesimas)
	; sub 10d			; si no hay underflow, restamos 10
	; ld (ix+1), a
	; jp fin_decreloj	; y saltamos al final
	; cent_neg: 		; si hay underflow en las centesimas:
		; ld c,(ix+1)	
		; ld a,b
		; cp 1d		
		; jp m , seg_neg	; segundos-1 >= 0? (underflow segundos)
		; sub 1d			; si no hay, restamos 1
		; ld (ix), a
		; ld a, c
		; add a, 90d		; las centesimas valen 90+resto previo
		; ld (ix+1), a
		; ld a, (ix+2)
		; cpl				; complementar la bandera
		; ld (ix+2), a
		; jp fin_decreloj
	; seg_neg:			; si hay underflow en los segundos:
		; ld (ix), 0d		; satura a cero el contador
		; ld (ix+1), 0d
	; fin_decreloj:
	; pop bc
	; pop af
	; ret

; espera un flanco de bajada de la señal PSCLK y retorna
esperoflanco: 				
	; out (clearFF), a 		; se pone a cero el FF de entrada por si se encontraba en uno
	loop_esperoflanco:
		in a, (entradaCLK)
		bit 0, a 			; la señal PSCLK está en el bit 0 del puerto de entrada
		jr z , loop_esperoflanco
	out (clearFF), a		; se pone a cero el FF una vez que se detectó el flanco
	ret
	
; recibe un dato ps2 y lo devuelve en acumulador
; devuelve el bit de paridad en el flag de carry
get_ps2:	
	push bc		; preservar registros
	ld b, 8d	; inicializar contador para djnz
	ld c, 0d	; inicializar registro de recepcion de datos
	call esperoflanco
	loop_get_ps2:
		call esperoflanco
		in a, (entradaDATA) ; todos los bits salvo el LSB son cero
		and 00000001B
		or c				
		ld c, a				; pone bit recibido en LSB de c, sin modificar los demas
		rrc c	; rotacion circular hacia la derecha
		djnz loop_get_ps2
	call esperoflanco
	in a, (entradaDATA)	; recepcion del bit de paridad
	and 00000001B
	cp 0d
	scf					; encender el flag de carry
	jr nz, paridad_uno
	ccf					; si el bit de paridad es cero, lo apago
	paridad_uno:
	call esperoflanco	; esperar al bit de stop
	ld a, c
	pop bc				; restaurar registros
	ret

; devuelve en a el scode de una tecla presionada
get_tecla: 
	call get_ps2 ; lee el primer dato (siempre hay uno al menos)
	loop_get_tecla:
		call get_ps2
		cp 0xf0
		jp nz, loop_get_tecla ; lee hasta que llega 0xF0
	call get_ps2	; lee el scode de la tecla
	ret

; recibe un scode en a y devuelve el digito correspondiente
; o recibe 100d si la tecla presionada no es un digito
scodeadigito: 
	push bc
	ld c, a ; cargar el scode en c
	ld b, 0d ; incializar b como contador
	ld hl, tab_scodeadigito ; carga el origen de la tabla en hl
	loop_tabla:
		ld a, (hl) 
		cp c	; compara el scode con el lugar de la table en hl
		jr z, digito_encontrado ; si coincide salta
		inc b	; se incrementa el contador
		ld a, b
		cp 10d	; si se paso de 9 significa que no es digito
		jr z, no_digito
		inc hl	; se baja una fila en la tabla
		jr loop_tabla
	digito_encontrado:
		ld a, b	; el numero en el contador es el digito correspondiente
		pop bc
		ret
	no_digito:
		ld a, 0xff ; a no es digito, devuelve 100d
		pop bc
		ret

rutint_counter:
	push af
	push bc
	ld a, (int_count)
	inc a
	ld (int_count), a
	call pbcda7seg
	ld a, c
	out (HEX0), a
	ld a, b
	out (HEX1), a
	pop bc
	pop af
	ei 
	reti
		
.end
