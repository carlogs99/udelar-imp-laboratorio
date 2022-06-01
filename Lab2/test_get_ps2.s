
.text

ld sp, 0x0000
; se inicializan en nivel alto los puertos salidaCLK y salidaDATA:
ld a, 1d
out (salidaCLK), a
out (salidaDATA), a
out (clearFF), a

ld ix, datos_ps2

loop_get_ps2_test:
	; esperamos un dato nuevo y lo guardamos en registro a
	call get_ps2
	
	; (ix+2) <-- (ix+1)
	ld e, (ix+1)
	ld (ix+2), e
	
	; (ix+1) <-- (ix)
	ld e, (ix)
	ld (ix+1), e
	
	; (ix) <-- a (ultimo dato)
	ld (ix), a
	
	; mostrar ultimo dato
	push af	; preservamos el flag de carry
	call pbcda7seg
	pop af	; recuperamos el flag de carry
	ld a, c
	jr nc, paridad_cero
	and 01111111B
	paridad_cero:
	out (HEX0), a
	ld a, b
	out (HEX1), a
	; mostrar penultimo dato
	ld a, (ix+1)
	call pbcda7seg
	ld a, c
	out (HEX2), a
	ld a, b
	out (HEX3), a
	; mostramos antepenultimo dato
	ld a, (ix+2)
	out (LEDG), a
	
	jp loop_get_ps2_test

.include "subrutinas.s"

.end
