
HEX0 equ 0x80
SW equ 0x80

.text

ld sp, 0x0000

loop:
	in a, (SW)
	call hexa7seg
	out (HEX0), a
	jr loop


.include "subrutinas.s"
.end
