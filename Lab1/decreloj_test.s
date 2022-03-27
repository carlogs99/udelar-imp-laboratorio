
btn_1_mask equ 00000010B
btn_2_mask equ 00000100B

.text

ld sp, 0x0000

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
