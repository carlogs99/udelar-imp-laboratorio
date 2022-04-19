
btn_1_mask equ 00000010B
btn_2_mask equ 00000100B

.text

ld sp, 0x0000

ld ix, reloj
ld a, 99d
ld (ix), a
ld a, 23d
ld (ix+1), a
ld a, 0x00
ld (ix+2), a
call despreloj

loop_test:
	ld b, 10d
	loop_espero:
	call espero
	djnz loop_espero
	call decreloj
	call despreloj
jr loop_test


.include "subrutinas.s"

.end
