
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
; inicializar controlador de interrupciones 1 y 2
ld a, 0d
out (CSINT1_VINT), a
out (CSINT1_CLR), a
ld a, 2d
out (CSINT2_VINT), a
out (CSINT2_CLR), a
; inicializar contador 
ld a, 1d
out (CSCOUNTER_CTE), a
ld a, 11000000B
out (CSCOUNTER_CONTROL), a
; incializar timer
ld a, 75d
out (CSTIMER_CTE), a
ld a, 11001111B
out (CSTIMER_CONTROL), a
; habilitar interrupciones
ei

loop_rutint_leds_test:
	in a, (SW)
	out (LEDG), a
	jr loop_rutint_leds_test
	

	
	
	
.include "subrutinas.s"

.end
