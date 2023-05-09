HEX0 equ 0x80
HEX1 equ 0x81
HEX2 equ 0x82
HEX3 equ 0x83
SW equ 0x80
BTN equ 0x81
LEDS equ 0x84
; Puertos agregados en Práctica 2:
clearFF equ 0x87
salidaDATA equ 0x85
salidaCLK equ 0x86
entradaDATA equ 0x85
entradaCLK equ 0x86
; Puertos agregados en Práctica 3:
CSTIMER_CTE equ 0x90
CSTIMER_CONTROL equ 0x91
CSCOUNTER_CTE equ 0xa0
CSCOUNTER_CONTROL equ 0xa1
CSINT1_CLR equ 0xb1
CSINT1_RDSTATE equ 0xb1
CSINT1_VINT equ 0xb0
CSINT2_CLR equ 0xc1
CSINT2_RDSTATE equ 0xc1
CSINT2_VINT equ 0xc0
; Scodes comandos:
SCODE_ENTER equ 0x5a
SCODE_SPACE equ 0x29
; Codificacion de estados:
STATE_INITIAL equ 0x00
STATE_COUNTING equ 0x01
STATE_FINISHED equ 0x02
STATE_PAUSED equ 0x03
STATE_EDIT equ 0x04
; Constantes:
DEFAULT_SECS equ 24d

.text


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
	; inc ix
	ld a, (ix+1)				; cargamos las centesimas al acumulador
	call binapbcd
	call pbcda7seg			; en bc tenemos las centesimas codificadas a 7seg
	ld a, b
	out (HEX1), a
	ld a, c
	out (HEX0), a
	; inc ix			
	ld a, (ix+2)		
	cp 0d					; evalua como cero solo si la flag es 0x00
	jp nz, fin_despreloj	; si no vale 0x00, vale 0xFF y no se debe agregar punto decimal
	ld a, e					; recuperamos lo que va en HEX2
	and 01111111B			; mascara para prender el punto decimal
	out (HEX2), a
	fin_despreloj: 
	; dec ix					; restauramos el registro ix
	; dec ix
	pop de
	pop bc
	pop af
	ret
	
decreloj:
	push af
	push bc
	ld b,(ix) ; cargar los segundos
	ld a,(ix+1)	; cargar las centesimas
	cp 10d		
	jp m, cent_neg	; centesimas-10 >= 0? (underflow centesimas)
	sub 10d			; si no hay underflow, restamos 10
	ld (ix+1), a
	jp fin_decreloj	; y saltamos al final
	cent_neg: 		; si hay underflow en las centesimas:
		ld c,(ix+1)	
		ld a,b
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
; o devuelve 100d si la tecla presionada no es un digito
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
		ld a, 100d ; a no es digito, devuelve 100d
		pop bc
		ret

rutint_counter:
	ei
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
	reti
		
rutint_leds:
	ei
	push af
	ld a, (int_cpl)
	cpl
	ld (int_cpl), a
	out (HEX3), a
	pop af
	reti
	
rutint_timer:
	ei
	push af
	push ix
	ld a, (pause)
	cp 0xff
	jr z, fin_rutint_timer
	ld ix, time_s
	call decreloj
	call despreloj
	fin_rutint_timer:
	pop ix
	pop af
	reti
	
get_ps2_nb:
    push bc ; preserva registros
    ld a,(rx_done) ; rx_done tiene en 0 los bits correspondientes
    cpl			   ; a los que no se han leido y 1 los que si de rx_byte
    or 0
    jr nz, not_yet
	ready:
		ld a,0
		ld (rx_done),a	; cuando el dato esta completo se ponen todos los bit a cero
		ld a, (rx_byte) ; y se carga en a el byte completo
	not_yet:
		pop bc	; restaura registros
		ret
    
get_tecla_nb:
	call get_ps2_nb
	jr z, llego_dato
	ret
	llego_dato:
		push bc
		ld b, a
		ld a, 0d
		ld (rx_byte), a
		ld a, b
		cp 0xf0
		jr nz, not_f0
			ld a, 1d
			ld (llego_f0), a
			or 1d
			pop bc
			ret
		not_f0:
			ld a, (llego_f0)
			cp 1d
			jr nz, tecla_presionada
				ld a, 0d
				ld (llego_f0), a
				ld a, b
				cp a
				pop bc
				ret
			tecla_presionada:
				or 1d
				pop bc
				ret
				
ps2clk_isr:
	ei
	push af
	push bc
	ld a, (num_bit)
	cp 0d
	jr nz, num_bit_not_cero ; if num_bit == 0 llego bit de start
		inc a
		ld (num_bit), a
		pop bc
		pop af
		reti
	num_bit_not_cero:
	cp 9d
	jr nz, num_bit_not_nueve ; if num_bit == 9 llego bit de paridad
		inc a
		ld (num_bit), a
		pop bc
		pop af
		reti
	num_bit_not_nueve:
	cp 10d 
	jr nz, num_bit_not_diez ; if num_bit == 10 llego bit de stop
		ld a, 0d
		ld (num_bit), a
		pop bc
		pop af
		reti
	num_bit_not_diez: ; else, el dato entrante es un bit de dato
		inc a
		ld (num_bit), a ; num_bit += 1
		; recibir y enmascarar dato serie:
		in a, (entradaDATA) 
		and 0x01
		ld b, a
		; rotamos los datos ya recibidos a la derecha:
		; (se pone el ultimo dato recibido en el LSB)
		ld a, (rx_byte)
		or b
		rrc a
		; el resultado se guarda a memoria:
		ld (rx_byte), a
		; se agrega un 1 a rx_done desde la derecha:
		ld a, (rx_done)
		rlc a
		or 1d
		ld (rx_done), a
		; restaurar registros y retornar:
		pop bc
		pop af
		reti

; 10*a = 8*a + 2*a
por_10:
	push bc
	sla a
	ld b, a
	sla a
	sla a
	add a, b
	fin_por_10:
		pop bc
		ret

.end
