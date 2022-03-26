
.text

ld sp, 0x0000

loop_test:
	in a, (SW)
	call pbcda7seg
	ld a, c
	out (HEX0), a
	ld a, b
	out (HEX1), a
	jr loop_test


.include "subrutinas.s"
.end
