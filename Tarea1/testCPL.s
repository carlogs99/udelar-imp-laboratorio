

;Definición de puertos 
;Puerto entrada:
SW    equ 0x80
  
;Puerto salida
Disp0 equ 0x80
Disp1 equ 0x81
Leds  equ 0x84

.text
    LD B, 0xFE
    LD HL, dato
    LD (HL), 0

Loop:
    LD A, %00000000
	CPL 
	JR Loop
	

.data
dato: db 0
.end

