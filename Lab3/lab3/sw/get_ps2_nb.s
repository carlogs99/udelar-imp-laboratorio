;;; -------------------------------------------
;;; get_ps2_nb: non blocking get_ps2
;;; -------------------------------------------
get_ps2_nb:
    push bc
    ld a,(rx_done)
    cpl
    or 0
    jr nz, not_yet
ready:
    ld a,0
    ld (rx_done),a
    ld a, (rx_byte)
not_yet:
    pop bc
    ret
    