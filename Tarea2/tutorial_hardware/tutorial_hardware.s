;Puerto de entrada:
SW equ 0x80
;Puerto salida:
Leds equ 0x84

.text
	Loop:	IN A, (SW)
			OUT (Leds), A
			JR Loop
.end
