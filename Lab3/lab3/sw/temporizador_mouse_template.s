;;;
;;; Filename: temporizador_mouse_template.s
;;;
;;; Description:
;;;
;;; Plantilla con esqueleto de una máquina de estados que implementa
;;; un temporizador de 24 seg controlado mediante un dispositivo de
;;; entrada PS2 (mouse).

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

;;  posicion de bit asociado a cada boton del mouse
.equ M_BUTTON_LEFT,   0
.equ M_BUTTON_RIGHT,  1
.equ M_BUTTON_MIDDLE, 2
;;; main app state
.equ STATE_INITIAL,  0         ; inicial (detenido esperando PP)
.equ STATE_COUNTING, 1         ; contando (esperando fin del tiempo)
.equ STATE_FINISHED, 2         ; terminado (tiempo alcanzo 00.00)

.equ DEFAULT_SECS, 24          ; tiempo por defecto para reinicio


;;; -------------------------------------------
;;; main: rutina principal
;;; -------------------------------------------
;;; Implementa una maquina de estados para manejo del reloj.
;;;
;;; Notacion:
;;;   pp: indica que se recibio un comando de PLAY/PAUSE desde mouse/teclado
;;;   restart: indica que se recibio un comando de RESTART desde mouse/teclado

;;;
;;; /* inicializacion */
;;; estado = inicial
;;; pause = false
;;; cuenta = 24.00
;;; leds(off)
;;;
;;; while(true)
;;;   {
;;;    switch (estado)
;;;      {
;;;       case inicial:
;;;          if pp then
;;;            {
;;;             estado = contando
;;;             pause = false
;;;            }
;;;          break
;;;
;;;       case contando:
;;;          if restart then
;;;            {
;;;               estado = inicial
;;;               cuenta = 24.00
;;;               pause = true
;;;               leds(off)
;;;            }
;;;          if cuenta==00.00 then
;;;            {
;;;               estado = termine
;;;               pause = true
;;;               leds(on)
;;;            }
;;;          break
;;;
;;;       case termine:
;;;          if restart then
;;;            {
;;;               estado = inicial
;;;               cuenta = 24.00
;;;               pause = true
;;;               leds(off)
;;;            }
;;;
;;;      } // fin switch
;;;   } // fin while
;;;

main:
   ld a, DEFAULT_SECS
   ld (time_s),a                ; cuenta = 24:00
   ld a, 0
   ld (time_c),a
   ld ix, time_s
   call despreloj
   ld a, 0                      ; leds (off)
   out (LEDS), a
   ld a, 0xFF                   ; pause = true
   ld (pause), a
   ld a, STATE_INITIAL          ; state = inicial
   ld (state), a
   ei

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
    ld ix, last_pkt
    call get_packet_nb
    jr nz, s_i_done                  ; no se ha recibido comando desde ps2
s_i_got_cmd:
    bit M_BUTTON_LEFT, (ix+5)
    jr z, s_i_done                   ; el boton PP no estaba apretado, lo ignoramos
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
    ld ix, last_pkt
    call get_packet_nb
    jr nz, s_c_check_time       ; no se ha recibido comando desde ps2
s_c_got_cmd:
    bit M_BUTTON_RIGHT, (ix+5)
    jr z, s_c_check_time        ; no fue restart, continuo con comparacion de tiempo
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
    ld ix, last_pkt
    call get_packet_nb
    jr nz, s_f_done             ; no se ha recibido comando desde ps2
s_f_got_cmd:
    bit M_BUTTON_RIGHT, (ix+5)
    jr z, s_f_done              ; no fue restart, sigo en este estado
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
last_pkt:  ds 6                   ; paquete recibido con get_packet_nb
time_s:    db 0                   ; segundos restantes
time_c:    db 0                   ; centesimas restantes
;;;
;;; otras variables usadas para el resto de sus rutinas (si necesario)

;;; FIN
.end
