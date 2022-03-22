;-------------------------------------------------------------
;----------------- Tarea 1 2022 ---- Version 4 ---------------
;-------------------------------------------------------------
;---------------- Carlos Gruss - CI:4.911.609-4 --------------
;-------------------------------------------------------------

; defino las constantes a utilizar
alpha equ 0x91
beta equ 0x09

; debe comenzar con la linea .text
.text

inicio: call calc		; llama a la subrutina escrita
fin:    jp fin			; queda en loop infinito
        
calc:
	; (B401h) <-- alpha NAND beta :
	LD A, alpha 		; A <-- alpha
	AND beta 			; A <-- alpha AND beta
	CPL 				; A <-- NOT A
	LD (0xB401), A 		; (B401h) <-- A
	
	; (B400h) <-- [(beta) XOR (beta+1) XOR ... XOR (beta + alpha -1)] :
	LD HL, beta			; HL <-- beta
	LD A, (HL)			; A <-- (HL) ~ A <-- (beta)
	LD B, alpha-1 		; B <-- alpha-1 (#iteraciones)
	loop: 
		INC HL 			; HL <-- HL + 1
		XOR (HL) 		; A <-- A XOR (HL) ~ A <-- (x) XOR (x+1)
		DJNZ loop		; B <-- B-1, si B!=0 vuelve a loop, en caso contrario sigue.
	LD (0xB400), A 		; (B400h) <-- A

	; retorno de la subrutina
    ret	

; debe terminar con la linea .end
.end
  
