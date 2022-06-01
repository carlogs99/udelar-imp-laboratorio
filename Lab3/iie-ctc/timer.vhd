--timer--

--==============================
--	Generacion del paquete
--==============================
LIBRARY ieee ;
USE ieee.std_logic_1164.all;

package pk_timer is
     COMPONENT timer is
     PORT
	(
		const		:	 IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		flanco		:	 IN STD_LOGIC;
		start		:	 IN STD_LOGIC;
		clk		:	 IN STD_LOGIC;
		clk_div		:	 IN STD_LOGIC;
		trg		:	 IN STD_LOGIC;
		trg_config	:	 IN STD_LOGIC;
		RESET		:	 IN STD_LOGIC;
		ZC		:	 OUT STD_LOGIC;
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

entity timer is
	PORT
	(
		const		:	 IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		flanco		:	 IN STD_LOGIC;
		start		:	 IN STD_LOGIC;
		clk			:	 IN STD_LOGIC;
		clk_div		:	 IN STD_LOGIC;
		trg			:	 IN STD_LOGIC;
		trg_config	:	 IN STD_LOGIC;
		RESET		:	 IN STD_LOGIC;
		ZC			:	 OUT STD_LOGIC;
		cuenta		:	 OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END timer;

architecture arq of timer is

signal clk_aux, flanco_aux, trg_aux : STD_LOGIC; --POR AHORA
signal	cuenta_aux		:	  STD_LOGIC_VECTOR(7 DOWNTO 0);
signal contar : STD_LOGIC;
signal recargar : STD_LOGIC;

type estados is (q0,q1,q2,q3,q4,q5,q6);
signal state, next_state: estados;
BEGIN
-------maquina de estados que controla el cont-----
 combin : PROCESS (start, trg_config, trg, clk_aux, state, trg_aux)

BEGIN
	CASE state IS
		WHEN q0 =>
			IF (start = '0') THEN
			next_state <= q0;
			ELSIF (trg_config ='0') THEN
			next_state <= q1;
			ELSE
			next_state <= q6;	
			END IF;
			contar <= '0';
			recargar <= '0';
		WHEN q1 =>
			IF clk_aux = '1' THEN
			next_state <= q3;
			ELSE
			next_state <= q5;
			END IF;
			contar <= '0';
			recargar <= '1';
		WHEN q2 =>
			IF (start = '1') THEN
				IF (trg_config = '0') THEN
				next_state <= q1;
				ELSE
				next_state <= q6;
				END IF;
				contar <= '0';
				recargar <= '0';
			ELSIF (trg_aux = '1') THEN
				IF clk_aux = '1' THEN
				next_state <= q3;
				ELSE
				next_state <= q5;
				END IF;
				contar <= '0';
				recargar <= '1';
			ELSE
				next_state <= q2;
				contar <= '0';
				recargar <= '0';
			END IF;
		WHEN q3 =>
			IF (start = '0') THEN
				IF (clk_aux = '0') THEN
				next_state <= q3;
				ELSE 
				next_state <= q4;	
				END IF;
			ELSIF (trg_config ='0') THEN
			next_state <= q1;
			ELSE
			next_state <= q6;	
			END IF;
			contar <= '0';
			recargar <= '0';
		WHEN q4 =>
			IF (start = '0') THEN
				IF (clk_aux = '0') THEN
				next_state <= q3;
				ELSE 
				next_state <= q5;	
				END IF;
			ELSIF (trg_config ='0') THEN
			next_state <= q1;
			ELSE
			next_state <= q6;	
			END IF;
			contar <= '1';
			recargar <= '0';
		WHEN q5 =>
			IF (start = '0') THEN
				IF (clk_aux = '0') THEN
				next_state <= q3;
				ELSE 
				next_state <= q5;	
				END IF;
			ELSIF (trg_config ='0') THEN
			next_state <= q1;
			ELSE
			next_state <= q6;	
			END IF;
			contar <= '0';
			recargar <= '0';
		WHEN q6 =>
			IF (start = '1') THEN
				IF (trg_config = '0') THEN
				next_state <= q1;
				ELSE
				next_state <= q6;
				END IF;
				contar <= '0';
				recargar <= '0';
			ELSIF (trg_aux = '1') THEN
				next_state <= q6;
				
			ELSE
				next_state <= q2;
				contar <= '0';
				recargar <= '0';
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
-------trigger y clock------

trig: PROCESS (flanco, start, clk)
BEGIN
	IF (clk'event and clk='1') then
		IF (start='1') then
		flanco_aux <= flanco;
		end if;
	END IF;
END PROCESS;

clk_aux <= (clk_div and flanco_aux) or ((not clk_div) and (not flanco_aux));
trg_aux <= (trg and flanco_aux) or ((not trg) and (not flanco_aux));
----------
cont8: contador8bits
PORT MAP
   	(
        clk      => clk,
   		clear	 => RESET or recargar,
		enable   => contar,
		const    => const,
		count    => cuenta_aux,
		zc		 => ZC
   	);
   	


cuenta <= cuenta_aux;
END arq; 