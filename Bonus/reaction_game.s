
btn_1_mask equ 00000010B
btn_2_mask equ 00000100B

.text

ld sp, 0x0000
ld ix, reloj
ld a, 0x00
ld (ix+2), a

pregame_loop:
	ld (ix), 0d
	ld (ix+1), 0d
	ld a, (ix+2)
	cpl
	ld b, 20d
	blink_dot:
		call espero
		djnz blink_dot
	ld (ix+2), a
	call despreloj
	in a, (BTN)
	and btn_2_mask
	jp nz, pregame_loop
	call rand_8
	ld b, a				; carga numero rand en b
	sla b
	sla b
	sla b
	sla b
	sla b
	sla b				; multiplico por b por 64
	wait_randms:
		call espero
		djnz wait_randms
	game_loop:
		ld b, 10d
		wait_10ms:
			call espero
			djnz wait_10ms
		call increloj
		call despreloj
		in a, (BTN)
		and btn_2_mask
		jp nz, game_loop
		result_loop:
			in a, (BTN)
			and btn_1_mask
			jp nz, result_loop
			jp pregame_loop

.include "subrutinas.s"

.end
