
.text

loop_test:
	call despreloj
	dec ix
	dec ix
break_test:
	jr loop_test

.include "subrutinas.s"

.end
