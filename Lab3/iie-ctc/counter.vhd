--counter--
--==============================
--	Generacion del paquete
--==============================
LIBRARY ieee ;
USE ieee.std_logic_1164.all;

package pk_counter is
     COMPONENT counter is
     PORT
	(
		const		:	 IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		flanco		:	 IN STD_LOGIC;
		start		:	 IN STD_LOGIC;
		clk			:	 IN STD_LOGIC;
		trg			:	 IN STD_LOGIC;
		RESET		:	 IN STD_LOGIC;
		ZC			:	 OUT STD_LOGIC;
		cuenta		:	 OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
     END COMPONENT;
END package;

--==============================
--	Generacion de la entidad
--==============================

LIBRARY ieee ;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
library work;
use work.pk_contador8bits.contador8bits;

entity counter is
	PORT
	(
		const		:	 IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		flanco		:	 IN STD_LOGIC;
		start		:	 IN STD_LOGIC;
		clk			:	 IN STD_LOGIC;
		trg			:	 IN STD_LOGIC;
		RESET		:	 IN STD_LOGIC;
		ZC			:	 OUT STD_LOGIC;
		cuenta		:	 OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END counter;

architecture arq of counter is

signal trg_aux, flanco_aux : STD_LOGIC;
signal contar : STD_LOGIC;
signal recargar : STD_LOGIC;
type estados is (q0,q1,q2,q3,q4);
signal state, next_state: estados;
BEGIN
-------maquina de estados que controla el cont-----
 combin : PROCESS (start,trg_aux, state)

BEGIN
	CASE state IS
		WHEN q0 =>
			IF (start = '0') THEN
			next_state <= q0;
			ELSE 
			next_state <= q1;	
			END IF;
			contar <= '0';
			recargar <= '0';
		WHEN q1 =>
			IF (trg_aux = '0') THEN
			next_state <= q2;
			ELSE 
			next_state <= q4;	
			END IF;
			contar <= '0';
			recargar <= '1';		
		WHEN q2 =>
			IF (start = '0') THEN
				IF (trg_aux = '0') THEN
				next_state <= q2;
				ELSE 
				next_state <= q3;	
				END IF;
			ELSE 
			next_state <= q1;	
			END IF;
			contar <= '0';
			recargar <= '0';
		WHEN q3 =>
			IF (start = '0') THEN
				IF (trg_aux = '0') THEN
				next_state <= q2;
				ELSE 
				next_state <= q4;	
				END IF;
			ELSE 
			next_state <= q1;	
			END IF;
			contar <= '1';
			recargar <= '0';
		WHEN q4 =>
			IF (start = '0') THEN
				IF (trg_aux = '0') THEN
				next_state <= q2;
				ELSE 
				next_state <= q4;	
				END IF;
			ELSE 
			next_state <= q1;	
			END IF;
			contar <= '0';
			recargar <= '0';
	END CASE;
END PROCESS;

sync: PROCESS (clk, reset, state)
BEGIN
	IF RESET ='1' THEN
		state <= q0;
	ELSIF (clk'event AND clk='1') THEN
		state <= next_state;
	END IF;
END PROCESS;
-----------------
-------trigger------

trig: PROCESS (flanco, start, clk)
BEGIN
	IF (clk'event and clk='1') then
		IF (start='1') then
		flanco_aux <= flanco;
		end if;
	END IF;
END PROCESS;

trg_aux <= (trg and flanco_aux) or ((not trg) and (not flanco_aux));

----------
cont8: contador8bits
PORT MAP
   	(
        clk      => clk,
   		clear	 => RESET or recargar,
		enable   => contar,
		const    => const,
		count    => cuenta,
		zc		 => ZC
   	);
   	

END arq; 