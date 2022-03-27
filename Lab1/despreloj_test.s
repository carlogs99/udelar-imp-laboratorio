
.text

ld sp, 0x0000

loop_test:
	call despreloj
	break_test:
	jr loop_test

.include "subrutinas.s"

.end
