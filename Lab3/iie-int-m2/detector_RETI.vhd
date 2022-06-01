--
--Bloque detector de la instruccion RETI
--Version sincrona
--

library ieee;
use ieee.std_logic_1164.all;


entity detector_RETI is

port(
	--Entradas
	CK : in std_logic;
	RESET : in std_logic;
	M1 : in std_logic;
	--MREQ : in std_logic;
	RD : in std_logic;
	D : in std_logic_vector (7 downto 0);
	--Salidas
	RETI_detectado : out std_logic;
	M1_sig_ED : out std_logic
	);
	
end detector_RETI;

architecture behav of detector_RETI is

-- Estados de la maquina para detectar fin de M1
type estados_finM1 is (Q0, Q_M1, Q_finM1);
signal state_finM1, next_state_finM1 : estados_finM1;


-- Estados de la maquina para detectar instruccion RETI
type estados_detRETI is (Q_reposo, Q_aux1, Q_aux2, Q_ED, Q_RETI);
signal state_detRETI, next_state_detRETI : estados_detRETI;


signal hubo_ED, hubo_4D : std_logic;
signal ciclo_M1, fin_M1, grabar : std_logic;
signal D_reg : std_logic_vector (7 downto 0);


begin

--Maquina de estados de fin de M1
process (state_finM1, ciclo_M1)
begin

case state_finM1 is

when Q0 =>
fin_M1 <= '0';
if (ciclo_M1 = '1' ) then
		grabar <= '0';
		next_state_finM1 <= Q0;
else	grabar <= '1';
		next_state_finM1 <= Q_M1;
end if;

when Q_M1 =>
fin_M1 <= '0';
if (ciclo_M1 = '0') then
		grabar <= '1';
		next_state_finM1 <= Q_M1;

else	grabar <= '0';
		next_state_finM1 <= Q_finM1;
end if;

when Q_finM1 =>
	fin_M1 <= '1';
	grabar <= '0';
	next_state_finM1 <= Q0;
	
when others => 
	next_state_finM1 <= Q0;

end case;
end process;

--Generacion de la memoria de la maquina de estados para detectar fines de M1

process (CK, RESET)
begin
if RESET = '0' then
		state_finM1 <= Q0;
elsif (CK'event and CK = '1') then
		state_finM1 <= next_state_finM1;
end if;
end process;

--Maquina de estados detector de RETI
process (state_detRETI, fin_M1, ciclo_M1, hubo_ED, hubo_4D)
begin

case state_detRETI is

when Q_reposo =>
RETI_detectado <= '0';
if (fin_M1 = '1') then 
	if (hubo_ED = '1') then
		next_state_detRETI <= Q_ED;
	else	
		next_state_detRETI <= Q_aux1;
	end if;
else 
	next_state_detRETI <= Q_reposo;
end if;

when Q_aux1 =>
RETI_detectado <= '0';
if (ciclo_M1 = '0') then 
		next_state_detRETI <= Q_aux2;
	else
		next_state_detRETI <= Q_reposo;
end if;
	
when Q_aux2 =>
RETI_detectado <= '0';
if (fin_M1 = '0') then 
	next_state_detRETI <= Q_aux2;
else
		next_state_detRETI <= Q_aux1;
end if;

when Q_ED =>
RETI_detectado <= '0'; 
if (fin_M1 = '0') then
		next_state_detRETI <= Q_ED;
elsif (hubo_4D = '0') then 
		next_state_detRETI <= Q_reposo;
else 	next_state_detRETI <= Q_RETI;
end if;

when Q_RETI =>
	RETI_detectado <= '1';
	next_state_detRETI <= Q_reposo;

when others => 
	next_state_detRETI <= Q_reposo;
		
end case;
end process;

--Generacion de la memoria de la maquina de estados para detectar RETI

process (state_detRETI, CK, RESET)
begin
if RESET = '0' then
		state_detRETI <= Q_reposo;
elsif (CK'event and CK = '1') then
		state_detRETI <= next_state_detRETI;
end if;
end process;


--Generacion de la memoria para D_reg

process (CK, grabar)
begin

if (CK'event and CK = '1' and grabar = '1') then
		D_reg <= D;
end if;
end process;

--Generacion de señales
hubo_ED <= '1' when D_reg = x"ED" else '0';
hubo_4D <= '1' when D_reg = x"4D" else '0';
ciclo_M1 <= M1 or RD;
M1_sig_ED <= '1' when (state_detRETI = Q_ED or state_detRETI = Q_RETI) else '0';

end behav;