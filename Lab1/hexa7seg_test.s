
.text

ld sp, 0x0000

loop_test:
	in a, (SW)
	call hexa7seg
	out (HEX0), a
	jr loop_test


.include "subrutinas.s"
.end
