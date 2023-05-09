
.text

ld sp, 0x0000
; seleccionar interrupciones modo 2
im 2
; inicializar tabla de interrupciones
ld hl, tabla_int
ld a, h
ld i, a
; se inicializan en nivel alto los puertos salidaCLK y salidaDATA:
ld a, 1d
out (salidaCLK), a
out (salidaDATA), a
; incializar variable contador y mostrarlo en displays
ld a, 0d
ld (int_cpl), a
ld (int_count), a
call pbcda7seg
ld a, c
out (HEX0), a
ld a, b
out (HEX1), a
; apagar HEX2
ld a, 0xff
out (HEX2), a
; inicializar variable reloj
ld a, 90d
ld (reloj), a
ld (reloj+1), a
ld a, 0d
ld (reloj+2), a
; incializar variable datos_ps2
ld a, 0d
ld (datos_ps2), a
ld (datos_ps2+1), a
ld (datos_ps2+2), a
ld ix, datos_ps2
; inicializar variables de recepcion
ld a, 0d
ld (rx_done), a
ld (rx_byte), a
ld (num_bit), a
; inicializar controlador de interrupciones 1 y 2
ld a, 6d
out (CSINT1_VINT), a
out (CSINT1_CLR), a
ld a, 4d
out (CSINT2_VINT), a
out (CSINT2_CLR), a
; inicializar contador 
ld a, 1d
out (CSCOUNTER_CTE), a
ld a, 01000000B ;se desactiva esta interrupcion
out (CSCOUNTER_CONTROL), a
; incializar timer
ld a, 75d
out (CSTIMER_CTE), a
ld a, 11001111B
out (CSTIMER_CONTROL), a
; habilitar interrupciones
ei


loop_get_ps2_test:
	call get_ps2_nb
	jr nz, loop_get_ps2_test

		; rotacion circular de datos:
		; (ix+2) <-- (ix+1)
		ld e, (ix+1)
		ld (ix+2), e
		; (ix+1) <-- (ix)
		ld e, (ix)
		ld (ix+1), e
		; (ix) <-- a (ultimo dato)
		ld (ix), a
		
		; mostrar ultimo dato
		call pbcda7seg
		ld a, c
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
		
		ld a, 0d
		ld (rx_byte), a
		
	jr loop_get_ps2_test
	
.include "subrutinas.s"

.end
