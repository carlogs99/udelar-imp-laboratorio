--
-- Bloque de control de las señales M1 e IORQ hacia un periferico diseñado para modo 1.

-- Maneja señales M1 e IORQ a conectar a un dispositivo diseñado para modo 1.
-- Se usa la señal SRV para que M1 = IORQ = 0 sólo luego de terminado el ciclo INTA correspondiente 
-- al dispositivo, para contemplar el retardo de propagación IEO - IEI.


library ieee;
use ieee.std_logic_1164.all;


entity control_INTA_modo1 is

port(
	CK : in std_logic;
	RESET : in std_logic;
	M1 : in std_logic;
	IORQ : in std_logic;

	IRQ : in std_logic;
	SRV : in std_logic;

	M1_out_n : out std_logic;
	IORQ_out_n : out std_logic 
	);

end control_INTA_modo1;

architecture behav of control_INTA_modo1 is


type estados_ack is (reposo, esconder_INTA_pend, dar_INTA, esconder_INTA_srv);
signal state_ack, next_state_ack: estados_ack;

begin

process (IRQ, SRV, state_ack, M1, IORQ)

begin

case state_ack is

when reposo =>

 M1_out_n <= M1 or (not IORQ);
 IORQ_out_n <= (not M1) or IORQ;

if (IRQ = '0') then
	next_state_ack <= reposo;
else
	next_state_ack <= esconder_INTA_pend;
end if;

when esconder_INTA_pend =>

 M1_out_n <= M1 or (not IORQ);
 IORQ_out_n <= (not M1) or IORQ;

if (SRV = '0') then
	next_state_ack <= esconder_INTA_pend;
else
	next_state_ack <= dar_INTA;
end if;

when dar_INTA =>

 M1_out_n <= '0';
 IORQ_out_n <= '0';

 next_state_ack <= esconder_INTA_srv;

when esconder_INTA_srv =>

 M1_out_n <= M1 or (not IORQ);
 IORQ_out_n <= (not M1) or IORQ;

if (SRV = '1') then
	next_state_ack <= esconder_INTA_srv;
else
	next_state_ack <= reposo;
end if;

end case;
end process;

--Generacion de la memoria de la maquina de estados_ack
process (state_ack, CK, RESET)
begin
if (RESET = '0') then
		state_ack <= reposo;
elsif (CK'event and CK = '1') then
		state_ack <= next_state_ack;
end if;
end process;

end behav;