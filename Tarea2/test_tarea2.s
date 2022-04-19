dirin equ 0x91
dirout equ 0x96
test_byte equ 0x42

.text
	loop:	ld a, test_byte
			out (dirout), a
			in a, (dirin)
			ld b, a
			jr loop
.end
