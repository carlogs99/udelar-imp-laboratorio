;;;
;;; Filename: temporizador_kbd_template.s
;;;
;;; Description:
;;;
;;; Plantilla con esqueleto de una máquina de estados que implementa
;;; un temporizador de 24 seg controlado mediante un dispositivo de
;;; entrada PS2 (teclado).

;;; El código debe completarse con las rutinas, inicializaciones y
;;; constantes necesarias para su funcionamiento.

;;; ------------------------------------------------------------
;;; Codigo comienza AQUI
;;; ------------------------------------------------------------

.text

;;; ------------------------------------------------------------
;;; 1) INIT GENERAL: stack, modo interrupciones, tabla interrupciones
;;; ------------------------------------------------------------
ld sp, 0x0000
im 2
; tabla
ld hl, tabla_int
ld a, h
ld i, a
;;; ------------------------------------------------------------
;;; 2) INIT PERIFIERICOS: timer, counter, puertos PSDAT_O y PSCLK_O, mouse_init si es necsario
;;; ------------------------------------------------------------
; se inicializan en nivel alto los puertos PSDAT_O y PSCLK_O:
ld a, 1d
out (salidaCLK), a
out (salidaDATA), a
; inicializar contador:
ld a, 1d
out (CSCOUNTER_CTE), a
ld a, 11000000B
out (CSCOUNTER_CONTROL), a
; incializar timer:
ld a, 75d
out (CSTIMER_CTE), a
ld a, 11001111B
out (CSTIMER_CONTROL), a
;;; ------------------------------------------------------------
;;; 3) INIT CONTROLADORES INTERRUPCION: controlador  ps2clk, controlador timer/counter
;;;    IMPORTANTE!: borrar interrupciones pendientes de ambos controladores
;;; ------------------------------------------------------------
; inicializar controlador de interrupciones 1:
ld a, 6d
out (CSINT1_VINT), a
out (CSINT1_CLR), a
; inicializar controlador de interrupciones 2:
ld a, 4d
out (CSINT2_VINT), a
out (CSINT2_CLR), a
;;; ------------------------------------------------------------
;;; 4) INIT DE RUTINAS AUXILIARES:
;;;    Ej:, variables necesarias para get_ps2_nb, get_packet_nb, etc.
; incializar variable datos_ps2:
ld a, 0d
ld (datos_ps2), a
ld (datos_ps2+1), a
ld (datos_ps2+2), a
ld ix, datos_ps2
; inicializar variables de recepcion ps2:
ld a, 0d
ld (rx_done), a
ld (rx_byte), a
ld (num_bit), a
ld (llego_f0), a
; inicializar reloj:
ld a, 24d
ld (time_s), a
ld a, 0d
ld (time_c), a
ld ix, time_s
call despreloj
;;; ------------------------------------------------------------
;;; RUTINA PRINCIPAL COMIENZA AQUI
ei



main:
   ld a, 0xff
   ld (pause), a
   ld a, STATE_INITIAL
   ld (state), a

while:
   ld a, (state)

check_1:
   cp STATE_INITIAL
   jr nz, check_2
   call s_initial
   jr while_end              ; break

check_2:
   cp STATE_COUNTING
   jr nz, check_3
   call s_counting
   jr while_end              ; break

check_3:
   cp STATE_FINISHED
   jr nz, check_4
   call s_finished
   jr while_end              ; break

check_4:
	cp STATE_PAUSED
	jr nz, check_5
	call s_paused
	jr while_end			; break
	
check_5:
	cp STATE_EDIT
	call s_edit

while_end:
   jr while

;;; ------------------------------------------------------------
;;; FIN RUTINA PRINCIPAL
;;; ------------------------------------------------------------


;;; ---------------------------------------
;;; En estado "inicial"
;;; ---------------------------------------
s_initial:
    call get_tecla_nb
    jr nz, s_i_done                  ; no se ha recibido comando desde ps2
s_i_got_cmd:
    cp SCODE_SPACE
    jr z, s_i_got_pp                 ; el boton PP no estaba apretado, lo ignoramos
	cp SCODE_ENTER
	jr z, s_i_got_restart
	jr s_i_done
s_i_got_pp:
    ;; recibimos boton PP
    ld a, STATE_COUNTING
    ld (state), a                    ; cambiar a estado "contando"
    ld a, 0
    ld (pause), a                    ; deshabilitar pausa
	jr s_i_done
s_i_got_restart:
	ld a, STATE_EDIT
	ld (state), a
	ld a, 0
	ld (time_s), a
	ld (time_c), a
	call despreloj
	ld a, 0xf0
	out (LEDS), a
s_i_done:
    ret

;;; ---------------------------------------
;;; En estado "contando"
;;; ---------------------------------------
s_counting:
    call get_tecla_nb
    jr nz, s_c_check_time       ; no se ha recibido comando desde ps2
s_c_got_cmd:
    cp SCODE_ENTER
    jr z, s_c_got_restart     ; no fue restart, continuo con comparacion de tiempo
	cp SCODE_SPACE
	jr z, s_c_got_pause
	jr s_c_check_time

s_c_got_restart:
    ;; recibimos boton restart
    ld a, STATE_INITIAL
    ld (state),a                ; estado = "inicial"
    ld a, DEFAULT_SECS          ; cuenta = 24.00
    ld (time_s), a
    ld a, 0
    ld (time_c), a
    ld a, 0xff
    ld (pause), a               ; pause = true
    ld ix, time_s
    call despreloj
    ld a, 0                     ; apagar leds
    out (LEDS), a
	jr s_c_done
	
s_c_got_pause:
	ld a, STATE_PAUSED
	ld (state), a
	ld a, 0xff
	ld (pause), a
	jr s_c_done

s_c_check_time:
    ld a, (time_s)
    ld b, a
    ld a, (time_c)
    or b
    jr nz, s_c_done             ; no ha llegado a 00:00

s_c_timeout:                    ; llego a cero
    ld a, STATE_FINISHED        ; estado = "termine"
    ld (state), a
    ld a, 0xff                  ; pause = true
    ld (pause), a
	ld a, 0x0f
    out (LEDS), a               ; encender leds
	
s_c_done:
    ret

;;; ---------------------------------------
;;; En estado "termine"
;;; ---------------------------------------
s_finished:
    call get_tecla_nb
    jr nz, s_f_done             ; no se ha recibido comando desde ps2
s_f_got_cmd:
    cp SCODE_ENTER
    jr nz, s_f_done             ; no fue restart, sigo en este estado
s_f_got_restart:
    ;; recibimos boton restart
    ld a, STATE_INITIAL
    ld (state),a                ; estado = "inicial"
    ld a, DEFAULT_SECS
    ld (time_s), a              ; cuenta = 24.00
    ld a, 0
    ld (time_c), a
    ld a, 0xff
    ld ix, time_s
    call despreloj
    ld (pause), a               ; pause = true
    ld a,0
    out (LEDS), a
s_f_done:
    ret
	
;;; ---------------------------------------
;;; En estado "pausado"
;;; ---------------------------------------
s_paused:
	call get_tecla_nb
	jr nz, s_p_done
s_p_got_cmd:
	cp SCODE_SPACE
	jr nz, s_p_done
s_p_got_pp:
    ;; recibimos boton PP
    ld a, STATE_COUNTING
    ld (state), a                    ; cambiar a estado "contando"
    ld a, 0
    ld (pause), a                    ; deshabilitar pausa
s_p_done:
    ret

;;; ---------------------------------------
;;; En estado "editar"
;;; ---------------------------------------
s_edit:
	call get_tecla_nb
	jr nz, s_e_done
s_e_got_cmd:
	cp SCODE_ENTER
	jr nz, s_e_not_enter
	; se apreto restart:
	ld a, 0
	out (LEDS), a
	ld a, STATE_INITIAL
	ld (state), a
	jr s_e_done
s_e_not_enter:
	call scodeadigito
	cp 100
	jr z, s_e_done	; se presiono tecla invalida
	ld b, a			; cargamos en b el digito nuevo
	ld a, (time_s)
	call binapbcd
	and 0x0f		; en a quedan las unidades de time_s
	call por_10
	add a, b
	ld (time_s), a
	ld ix, time_s
	call despreloj
s_e_done:
	ret
	
	
;;; ------------------------------------------------------------
;;; reserva e inicializacion de tablas
;;; ------------------------------------------------------------

.org 0x200
tab_h7s:	  	 ; _gfedcba 
	db 11000000B ; 0 
	db 11111001B ; 1 
	db 10100100B ; 2 
	db 10110000B ; 3
	db 10011001B ; 4
	db 10010010B ; 5
	db 10000010B ; 6
	db 11111000B ; 7
	db 10000000B ; 8
	db 10011000B ; 9
	db 10001000B ; a
	db 10000011B ; b
	db 10100111B ; c
	db 10100001B ; d
	db 10000110B ; e
	db 10001110B ; F

tab_scodeadigito:
	db 0x70 ; 0
	db 0x69 ; 1
	db 0x72 ; 2
	db 0x7a ; 3
	db 0x6b ; 4
	db 0x73 ; 5
	db 0x74 ; 6
	db 0x6c ; 7
	db 0x75 ; 8
	db 0x7d ; 9
	
.org 0x300
tabla_int:
	dw rutint_counter
	dw rutint_leds
	dw rutint_timer
	dw ps2clk_isr

;;; ------------------------------------------------------------
;;; reserva de memoria para variables de la aplicacion
;;; ------------------------------------------------------------
.data
state:     db 0                   ; estado actual (ver constantes STATE_*)
pause:     db 0                   ; 0xFF si pausado
time_s:    db 0                   ; segundos restantes
time_c:    db 0                   ; centesimas restantes
time_dp:	db 0
;;;
;;; otras variables usadas para el resto de sus rutinas (si necesario)
datos_ps2:
	db 0d
	db 0d
	db 0d
int_count:	db 0d	
int_cpl:	db 0d
num_bit:	db 0d
rx_byte:	db 0d
rx_done:	db 0d
llego_f0:	db 0d

.include "subrutinas_g.s"

.end
