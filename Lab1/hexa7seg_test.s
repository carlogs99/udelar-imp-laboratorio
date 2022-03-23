
Hex0 EQU 0x80
Sw EQU 0x80

.text

LD SP, 0x0000

loop:
	IN A, (Sw)
	CALL hexa7seg
	OUT (Hex0), A
	JR loop


.include "subrutinas.s"
.end
