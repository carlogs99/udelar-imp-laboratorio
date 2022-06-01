
.text

ld sp, 0x0000 ; inicializaciones
ld a, 1d
out (salidaCLK), a
out (salidaDATA), a
ld ix, datos_ps2
out (clearFF), a

loop_get_digito_test:
	; esperamos un dato nuevo y lo guardamos en a
	call get_tecla
	call scodeadigito
	
	; scodeadigito devuelve 100 si la tecla no es digito
	cp 0xff 
	jp z, loop_get_digito_test
	
	; (ix+2) <-- (ix+1)
	ld e, (ix+1)
	ld (ix+2), e
	
	; (ix+1) <-- (ix)
	ld e, (ix)
	ld (ix+1), e
	
	; (ix) <-- a (ultimo dato)
	ld (ix), a
	
	; mostramos ultimo dato
	push af	; preservamos el flag de carry
	call hexa7seg
	ld b, a
	pop af	; recuperamos el flag de carry
	ld a, b
	jr nc, paridad_cero
	and 01111111B
	paridad_cero:
	out (HEX0), a
	ld a, 0xff
	out (HEX1), a
	; mostraemos penultimo dato
	ld a, (ix+1)
	call hexa7seg
	out (HEX2), a
	ld a, 0xff
	out (HEX3), a
	; mostramos antepenultimo dato
	ld a, (ix+2)
	out (LEDG), a
	
	jp loop_get_digito_test

.include "subrutinas.s"

.end
