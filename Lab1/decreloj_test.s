
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

btn_2_loop:
	in a, (BTN)
	and btn_2_mask
	jp nz, btn_2_loop
	call decreloj
	call despreloj
	btn_1_loop:
		in a, (BTN)
		and btn_1_mask
		jp nz, btn_1_loop
		jp btn_2_loop

.include "subrutinas.s"

.end
