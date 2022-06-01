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
;;; ... COMPLETAR ...
;;; ------------------------------------------------------------

;;; ------------------------------------------------------------
;;; 2) INIT PERIFIERICOS: timer, counter, puertos PSDAT_O y PSCLK_O, mouse_init si es necsario
;;; ... COMPLETAR ...
;;; ------------------------------------------------------------

;;; ------------------------------------------------------------
;;; 3) INIT CONTROLADORES INTERRUPCION: controlador  ps2clk, controlador timer/counter
;;;    IMPORTANTE!: borrar interrupciones pendientes de ambos controladores
;;; ... COMPLETAR ...
;;; ------------------------------------------------------------

;;; ------------------------------------------------------------
;;; 4) INIT DE RUTINAS AUXILIARES:
;;;    Ej:, variables necesarias para get_ps2_nb, get_packet_nb, etc.
;;; ... COMPLETAR ...

;;; ------------------------------------------------------------
;;; RUTINA PRINCIPAL COMIENZA AQUI




main:
   ld a, 0xFF
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
   call s_finished
   jr while_end              ; break

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
    jr nz, s_i_done                  ; el boton PP no estaba apretado, lo ignoramos
s_i_got_pp:
    ;; recibimos boton PP
    ld a, STATE_COUNTING
    ld (state), a                    ; cambiar a estado "contando"
    ld a, 0
    ld (pause), a                    ; deshabilitar pausa
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
    jr nz, s_c_check_time       ; no fue restart, continuo con comparacion de tiempo
s_c_got_restart:
    ;; recibimos boton restart
    ld a, STATE_INITIAL
    ld (state),a                ; estado = "inicial"
    ld a, DEFAULT_SECS          ; cuenta = 24.00
    ld (time_s), a
    ld a, 0
    ld (time_c), a
    ld a, 0xFF
    ld (pause), a               ; pause = true
    ld ix, time_s
    call despreloj
    ld a, 0                     ; apagar leds
    out (LEDS), a

s_c_check_time:
    ld a, (time_s)
    ld b, a
    ld a, (time_c)
    or b
    jr nz, s_c_done             ; no ha llegado a 00:00

s_c_timeout:                    ; llego a cero
    ld a, STATE_FINISHED        ; estado = "termine"
    ld (state), a
    ld a, 0xFF                  ; pause = true
    ld (pause), a
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
    ld a, 0xFF
    ld ix, time_s
    call despreloj
    ld (pause), a               ; pause = true
    ld a,0
    out (LEDS), a
s_f_done:
    ret

;;; ------------------------------------------------------------
;;; reserva de memoria para variables de la aplicacion
;;; ------------------------------------------------------------
.data
state:     db 0                   ; estado actual (ver constantes STATE_*)
pause:     db 0                   ; 0xFF si pausado
time_s:    db 0                   ; segundos restantes
time_c:    db 0                   ; centesimas restantes
;;;
;;; otras variables usadas para el resto de sus rutinas (si necesario)

.end
