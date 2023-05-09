
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
ld (int_count), a
call pbcda7seg
ld a, c
out (HEX0), a
ld a, b
out (HEX1), a
; inicializar controlador de interrupciones 1 
ld a, 0d
out (CSINT1_VINT), a
out (CSINT1_CLR), a
; habilitar interrupciones
ei

loop_rutint_counter_test:
	in a, (SW)
	out (LEDG), a
	jr loop_rutint_counter_test
	

	
	
	
.include "subrutinas.s"

.end
