
.text

ld sp, 0x0000
; se inicializan en nivel alto los puertos salidaCLK y salidaDATA:
ld a, 1d
out (salidaCLK), a
out (salidaDATA), a
out (clearFF), a

; cada vez que llega un flaco de bajada en CLK 
; incrementa un contador y lo muestra en HEX0 y HEX1
ld e, 0d
loop_test:
	call esperoflanco ; espera a que llegue un flanco de bajada en CLK 
	inc e
	ld a, e
	call binapbcd
	call pbcda7seg
	ld a, c
	out (HEX0), a
	ld a, b
	out (HEX1), a
	jr loop_test

.include "subrutinas.s"

.end
