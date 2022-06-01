--bloquetimer-
--==============================
--	Generacion del paquete
--==============================
LIBRARY ieee;
USE ieee.std_logic_1164.all; 

package pk_bloquetimer is
     COMPONENT bloquetimer is
     PORT
	(
		M1_n	:  IN  STD_LOGIC;
		IORQ_n	:  IN  STD_LOGIC;
		RD_n	:  IN  STD_LOGIC;
		clk	:  IN  STD_LOGIC;
		RESET	:  IN  STD_LOGIC;
		A0	:  IN  STD_LOGIC;
		CE_n	:  IN  STD_LOGIC;
		trg	:  IN  STD_LOGIC;
		datos_i	:  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		INTA_n :  IN  STD_LOGIC;
		INT_n	:  OUT  STD_LOGIC;
		zc	:  OUT  STD_LOGIC;
		c_aux	:  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		datos_o :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
	END COMPONENT;
END package;   

--==============================
--	Generacion de la entidad
--==============================


LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;
USE work.pk_constante.constante;
USE work.pk_control.control;
USE work.pk_Control_INT.Control_INT;
USE work.pk_prescaler.prescaler;
USE work.pk_timer.timer;

ENTITY bloquetimer IS 
	PORT
	(
		M1_n :  IN  STD_LOGIC;
		IORQ_n :  IN  STD_LOGIC;
		RD_n :  IN  STD_LOGIC;
		clk :  IN  STD_LOGIC;
		RESET :  IN  STD_LOGIC;
		A0 :  IN  STD_LOGIC;
		CE_n :  IN  STD_LOGIC;
		trg :  IN  STD_LOGIC;
		datos_i :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		INTA_n :  IN  STD_LOGIC;
		INT_n :  OUT  STD_LOGIC;
		zc :  OUT  STD_LOGIC;
		c_aux :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		datos_o :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END bloquetimer;

ARCHITECTURE bdf_type OF bloquetimer IS 

SIGNAL	SYNTHESIZED_WIRE_14 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_15 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_16 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_7 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_8 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_10 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_11 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_12 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	DFF_inst2 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
signal llego, salida	:	STD_LOGIC;

BEGIN 
zc <= SYNTHESIZED_WIRE_14;
c_aux <= SYNTHESIZED_WIRE_5;



b2v_inst : constante
PORT MAP(	 A0 => A0,
		 CE_n => CE_n,
		 IORQ_n => IORQ_n,
		 RD_n => RD_n,
		 M1_n => M1_n,
		 clk => clk,
		 RESET => RESET,
		 dato => datos_i,
		 const => SYNTHESIZED_WIRE_12);


b2v_inst1 : control
PORT MAP(	 A0 => A0,
		 CE_n => CE_n,
		 M1_n => M1_n,
		 IORQ_n => IORQ_n,
		 RD_n => RD_n,
		 ZC => SYNTHESIZED_WIRE_14,
		 clk => clk,
		 RESET => RESET,
		 datos => datos_i,
		 INTA_n => INTA_n,
		 flanco => SYNTHESIZED_WIRE_8,
		 start => SYNTHESIZED_WIRE_16,
		 trg_config => SYNTHESIZED_WIRE_10,
		 INT_ACK => SYNTHESIZED_WIRE_1,
		 INT_SEL => SYNTHESIZED_WIRE_2,
		 mostrar_c => SYNTHESIZED_WIRE_15,
		 prescaler => SYNTHESIZED_WIRE_7,
		 llego  =>	llego,
		 salida =>	salida);


b2v_inst15 : control_int
PORT MAP(INT_ACK => SYNTHESIZED_WIRE_1,
		 INT_SEL => SYNTHESIZED_WIRE_2,
		 ZC => SYNTHESIZED_WIRE_14,
		 RESET => RESET,
		 clk	=>	clk,
		 INT_n => INT_n);


PROCESS(SYNTHESIZED_WIRE_15, clk)
BEGIN
IF (RISING_EDGE(clk)) THEN
	if (SYNTHESIZED_WIRE_15='1') then
	DFF_inst2(7 DOWNTO 0) <= SYNTHESIZED_WIRE_5(7 DOWNTO 0);
	end if;
END IF;
END PROCESS;


b2v_inst20 : prescaler
PORT MAP(	 clk_in => clk,
		 RESET => RESET,
		 start => SYNTHESIZED_WIRE_16,
		 dato => SYNTHESIZED_WIRE_7,
		 clk_out => SYNTHESIZED_WIRE_11);


b2v_inst21 : timer
PORT MAP(	 flanco => SYNTHESIZED_WIRE_8,
		 start => SYNTHESIZED_WIRE_16,
		 trg_config => SYNTHESIZED_WIRE_10,
		 trg => trg,
		 RESET => RESET,
		 clk => clk,
		 clk_div => SYNTHESIZED_WIRE_11,
		 const => SYNTHESIZED_WIRE_12,
		 ZC => SYNTHESIZED_WIRE_14,
		 cuenta => SYNTHESIZED_WIRE_5);


--PROCESS(DFF_inst2,SYNTHESIZED_WIRE_15)
--BEGIN
--if (SYNTHESIZED_WIRE_15 = '1') THEN
--	cuenta(7) <= DFF_inst2(7);
--ELSE
--	cuenta(7) <= 'Z';
--END IF;
--END PROCESS;
--
--PROCESS(DFF_inst2,SYNTHESIZED_WIRE_15)
--BEGIN
--if (SYNTHESIZED_WIRE_15 = '1') THEN
--	cuenta(6) <= DFF_inst2(6);
--ELSE
--	cuenta(6) <= 'Z';
--END IF;
--END PROCESS;
--
--PROCESS(DFF_inst2,SYNTHESIZED_WIRE_15)
--BEGIN
--if (SYNTHESIZED_WIRE_15 = '1') THEN
--	cuenta(5) <= DFF_inst2(5);
--ELSE
--	cuenta(5) <= 'Z';
--END IF;
--END PROCESS;
--
--PROCESS(DFF_inst2,SYNTHESIZED_WIRE_15)
--BEGIN
--if (SYNTHESIZED_WIRE_15 = '1') THEN
--	cuenta(4) <= DFF_inst2(4);
--ELSE
--	cuenta(4) <= 'Z';
--END IF;
--END PROCESS;
--
--PROCESS(DFF_inst2,SYNTHESIZED_WIRE_15)
--BEGIN
--if (SYNTHESIZED_WIRE_15 = '1') THEN
--	cuenta(3) <= DFF_inst2(3);
--ELSE
--	cuenta(3) <= 'Z';
--END IF;
--END PROCESS;
--
--PROCESS(DFF_inst2,SYNTHESIZED_WIRE_15)
--BEGIN
--if (SYNTHESIZED_WIRE_15 = '1') THEN
--	cuenta(2) <= DFF_inst2(2);
--ELSE
--	cuenta(2) <= 'Z';
--END IF;
--END PROCESS;
--
--PROCESS(DFF_inst2,SYNTHESIZED_WIRE_15)
--BEGIN
--if (SYNTHESIZED_WIRE_15 = '1') THEN
--	cuenta(1) <= DFF_inst2(1);
--ELSE
--	cuenta(1) <= 'Z';
--END IF;
--END PROCESS;
--
--PROCESS(DFF_inst2,SYNTHESIZED_WIRE_15)
--BEGIN
--if (SYNTHESIZED_WIRE_15 = '1') THEN
--	cuenta(0) <= DFF_inst2(0);
--ELSE
--	cuenta(0) <= 'Z';
--END IF;
--END PROCESS;

--sel_salida : PROCESS (clk, salida)
--BEGIN
--	IF (clk'event and clk = '1' and salida = '1') THEN
--		datos_o <= DFF_inst2;
--	ELSIF (clk'event and clk = '1' and salida = '0')THEN
--		datos_o(0) <= llego;
--	END IF;
--END PROCESS;
datos_o <= DFF_inst2 when salida = '1' else ('0','0','0','0','0','0','0',llego);
--datos_o(7 downto 1)  <= (DFF_inst2(7 downto 1) and salida);
--datos_o(0) <=(DFF_inst2(0) and salida) or ( llego and (not salida));

END bdf_type;