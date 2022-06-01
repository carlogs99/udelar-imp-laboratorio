---------------------------------------------------------
--generador_pulsos, modificado para pulsos de 2 periodos
---------------------------------------------------------

-----------------------------------------------------------
-----generador_pulsos
-----------------------------------------------------------
LIBRARY ieee ;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

PACKAGE PK_generador_pulsos IS
   COMPONENT generador_pulsos IS
   	PORT(
          	edge, clk, reset     : IN  STD_LOGIC;
   		 pulse    : OUT STD_LOGIC
   		);
   END COMPONENT;
END PACKAGE;

-----------------------------------------------------------
----- ENTITY generador_pulsos
-----------------------------------------------------------
LIBRARY ieee ;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


ENTITY generador_pulsos IS
   	PORT(
          	edge, clk, reset     : IN  STD_LOGIC;
   		 pulse    : OUT STD_LOGIC
   		);
END generador_pulsos;

ARCHITECTURE estados of generador_pulsos IS

---STATES 	
TYPE estados IS
	(q0, q1, q2);

SIGNAL state, next_state : estados;


BEGIN


combin : PROCESS (state, edge)

BEGIN
	CASE state IS
		WHEN q0 =>
			IF (edge = '0') THEN
			next_state <= q0;
			ELSE
			next_state <= q1;
			END IF;
			pulse <= '0';
		WHEN q1 =>
			IF (edge = '0') THEN
				next_state <=q0;
			ELSE
				next_state <= q2;
			END IF;
			pulse <= '1';
		WHEN q2 =>
			IF (edge = '0') THEN
				next_state <=q0;
			ELSE
				next_state <= q2;
			END IF;
			pulse <= '0';
		
	END CASE;
END PROCESS;

sync: PROCESS (clk, reset, state)

BEGIN
	IF reset ='1' THEN
		state <= q0;
	ELSIF (clk'event AND clk='1') THEN
		state <= next_state;
	END IF;
END PROCESS;



			
END estados;
