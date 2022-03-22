


Hex0 EQU 0x80
Sw EQU 0x80

.include "subrutinas.s"

.text

LD SP, 0x0000

loop:
	IN A, Sw
	JP hexa7seg
	OUT Hex0, A
	JR loop

.end
