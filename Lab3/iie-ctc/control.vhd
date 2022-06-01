--control--

--========================================
--	Generacion del paquete que
--	contiene el componete control
--========================================
LIBRARY ieee;
USE ieee.std_logic_1164.all; 

package pk_control is
     COMPONENT control is
     PORT(
		A0 :  IN  STD_LOGIC;
		M1_n :  IN  STD_LOGIC;
		CE_n :  IN  STD_LOGIC;
		IORQ_n :  IN  STD_LOGIC;
		RD_n :  IN  STD_LOGIC;
		ZC :  IN  STD_LOGIC;
		RESET :  IN  STD_LOGIC;
		clk :  IN  STD_LOGIC;
		datos :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		INTA_n :  IN  STD_LOGIC;
		
		flanco :  OUT  STD_LOGIC;
		start :  OUT  STD_LOGIC;
		trg_config :  OUT  STD_LOGIC;
		INT_ACK :  OUT  STD_LOGIC;
		INT_SEL :  OUT  STD_LOGIC;
		mostrar_c :  OUT  STD_LOGIC;
		prescaler :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
		llego :  OUT  STD_LOGIC;
		salida :  OUT  STD_LOGIC
     );
     END COMPONENT;
END package;
     

--========================================
--	Generacion de la entidad
--	control
--========================================


LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;
USE work.pk_registro8bits.registro8bits;
USE work.PK_generador_pulsos.generador_pulsos;

ENTITY control IS 
	PORT
	(
		A0 :  IN  STD_LOGIC;
		M1_n :  IN  STD_LOGIC;
		CE_n :  IN  STD_LOGIC;
		IORQ_n :  IN  STD_LOGIC;
		RD_n :  IN  STD_LOGIC;
		ZC :  IN  STD_LOGIC;
		RESET :  IN  STD_LOGIC;
		clk :  IN  STD_LOGIC;
		datos :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		INTA_n :  IN  STD_LOGIC;
		
		flanco :  OUT  STD_LOGIC;
		start :  OUT  STD_LOGIC;
		trg_config :  OUT  STD_LOGIC;
		INT_ACK :  OUT  STD_LOGIC;
		INT_SEL :  OUT  STD_LOGIC;
		mostrar_c :  OUT  STD_LOGIC;
		prescaler :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
		llego :  OUT  STD_LOGIC;
		salida :  OUT  STD_LOGIC
	);
END control;



ARCHITECTURE bdf_type OF control IS 


signal cicloEscritura, cicloLectura1, cicloLectura0, cicloInterup, start_aux, CE_ack: STD_LOGIC;
signal registro : STD_LOGIC_VECTOR(7 DOWNTO 0);
type estados is (q0,q1,q2,q3,q4);
signal state, next_state: estados;
type estados1 is (p0,p1,p2,p3);
signal estado, prox_state: estados1;
BEGIN

cicloEscritura 	<= ( A0 and (not CE_n) and (not IORQ_n) and (RD_n) and M1_n);
cicloLectura1	<= (A0 and (not CE_n) and (not IORQ_n) and (not RD_n) and M1_n);
cicloLectura0	<= ( (not A0) and (not CE_n) and (not IORQ_n) and (not RD_n) and M1_n);
-- cicloInterup	<= ((not IORQ_n) and (not M1_n));
cicloInterup	<= (not INTA_n);
--------registro palabra control-----
reg: registro8bits
	PORT MAP
	(
		rstn => (not RESET),
		clk  => clk,
		ena  => cicloEscritura,
		D    => datos,
		Q    => registro
	);
--------------------------

----------registro zc---------
llego_p : process (cicloLectura0, zc, reset, clk)
	BEGIN
		IF (clk'event and clk='1') THEN
			IF reset = '1' THEN
				llego <= '0';
			ELSIF (CE_ack = '1' )THEN
				llego <= '0';
			ELSIF (zc = '1') THEN
				llego <= '1';
			END IF;
		END IF;
	END PROCESS;

------ciclo lectura-------

sel_salida : process (cicloLectura1, cicloLectura0, clk)
BEGIN
	IF (clk'event and clk = '1' and cicloLectura1 = '1') THEN
		salida <= '1';
	ELSIF (clk'event and clk = '1' and cicloLectura0 = '1') THEN
		salida <= '0';
	END IF;
END PROCESS;


mostrar: process (clk, cicloLectura1)
BEGIN
IF (clk'event and clk = '1') THEN
 mostrar_c <= cicloLectura1;
END IF;
END PROCESS;
 
 llego_pro : process (cicloLectura0, estado)

BEGIN
	CASE estado IS
		WHEN p0 =>
			IF cicloLectura0 = '0' THEN
				prox_state <= p0;
			ELSE
				prox_state <= p1;
			END IF;
			CE_ack <= '0';
		WHEN p1 =>
			prox_state <= p2;
			CE_ack <= '0';
		WHEN p2 =>
			prox_state <= p3;
			CE_ack <= '0';
		WHEN p3 =>
			prox_state <= p0;
			CE_ack <= '1';
	END CASE;
END PROCESS;
 -----------------------------
 
 
 
 ------ciclo reconocimiento de int-----
 

 intcic: process (clk, cicloInterup)
BEGIN
IF (clk'event and clk = '1') THEN
 INT_ACK <= cicloInterup;
END IF;
END PROCESS;
 ----------------------------------
 
 
 --------maquina de estados para escritura-------
 
 combin : PROCESS (cicloEscritura, datos, ZC, state)

BEGIN
	CASE state IS
		WHEN q0 =>
			IF (cicloEscritura = '0') THEN
			next_state <= q0;
			ELSE 	
					next_state <= q4;
			END IF;
			start_aux <= '0';
		WHEN q1 =>
			IF (cicloEscritura = '0') THEN
			next_state <= q1;
			ELSE 	if (datos(5) = '0') then
					next_state <= q2;
					else
					next_state <= q4;
					end if;
			END IF;
			start_aux <= '0';
		WHEN q2 =>
			IF (cicloEscritura = '0') THEN
				if (ZC = '0') then
					next_state <= q2;
					else
					next_state <= q3;
					end if;
			ELSE 	if (datos(5) = '0') then
					next_state <= q2;
					else
					next_state <= q3;
					end if;
			END IF;
			start_aux <= '0';
		WHEN q3 =>
			next_state <= q1;
			start_aux <= '1';
		WHEN q4 =>
			next_state <= q3;
			start_aux <= '0';
	END CASE;
END PROCESS;

start <= start_aux;

int: process (start_aux, clk)
BEGIN

if (clk'event and clk='1') then
	if(start_aux='1') then
		INT_SEL <= registro(7);
	end if;
end if;

END PROCESS;

prescaler <= registro(3 downto 0);
trg_config <= registro(4);
flanco <= registro(6);

sync: PROCESS (clk, reset, state, estado)

BEGIN
	IF reset ='1' THEN
		state <= q0;
		estado <= p0;
	ELSIF (clk'event AND clk='1') THEN
		state <= next_state;
		estado <= prox_state;
	END IF;
END PROCESS;
 
 ------------------
END bdf_type;
