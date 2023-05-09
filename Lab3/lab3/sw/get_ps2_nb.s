;;; -------------------------------------------
;;; get_ps2_nb: non blocking get_ps2
;;; -------------------------------------------
get_ps2_nb:
    push bc ; preserva registros
    ld a,(rx_done) ; rx_done tiene en 0 los bits correspondientes
    cpl			   ; a los que no se han leido y 1 los que si de rx_byte
    or 0
    jr nz, not_yet
ready:
    ld a,0
    ld (rx_done),a	; cuando el dato esta completo se ponen todos los bit a cero
    ld a, (rx_byte) ; y se carga en a el byte completo
not_yet:
    pop bc	; restaura registros
    ret
    