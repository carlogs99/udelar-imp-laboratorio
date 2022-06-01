--bloquecontador--
--==============================
--	Generacion del paquete
--==============================
LIBRARY ieee ;
USE ieee.std_logic_1164.all;

package pk_bloquecontador is
     COMPONENT bloquecontador is
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
USE work.pk_counter.counter;

ENTITY bloquecontador IS 
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
END bloquecontador;

ARCHITECTURE bdf_type OF bloquecontador IS 


SIGNAL	SYNTHESIZED_WIRE_10 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC;
SIGNAL	DFF_inst3 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_11 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_9 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
signal llego, salida	:	STD_LOGIC;


BEGIN 
zc <= SYNTHESIZED_WIRE_10;
c_aux <= SYNTHESIZED_WIRE_9;



b2v_inst : control
PORT MAP(A0 => A0,
		 CE_n => CE_n,
		 M1_n => M1_n,
		 IORQ_n => IORQ_n,
		 RD_n => RD_n,
		 ZC => SYNTHESIZED_WIRE_10,
		 clk => clk,
		 RESET => RESET,
		 datos => datos_i,
		 INTA_n => INTA_n,
		 flanco => SYNTHESIZED_WIRE_1,
		 start => SYNTHESIZED_WIRE_2,
		 INT_ACK => SYNTHESIZED_WIRE_4,
		 INT_SEL => SYNTHESIZED_WIRE_5,
		 mostrar_c => SYNTHESIZED_WIRE_11,
		 llego  =>	llego,
		 salida =>	salida);


b2v_inst1 : counter
PORT MAP(flanco => SYNTHESIZED_WIRE_1,
		 start => SYNTHESIZED_WIRE_2,
		 trg => trg,
		 RESET => RESET,
		 clk => clk,
		 const => SYNTHESIZED_WIRE_3,
		 ZC => SYNTHESIZED_WIRE_10,
		 cuenta => SYNTHESIZED_WIRE_9);


b2v_inst15 : control_int
PORT MAP(INT_ACK => SYNTHESIZED_WIRE_4,
		 INT_SEL => SYNTHESIZED_WIRE_5,
		 ZC => SYNTHESIZED_WIRE_10,
		 RESET => RESET,
		 clk	=>	clk,
		 INT_n => INT_n);


b2v_inst2 : constante
PORT MAP(A0 => A0,
		 CE_n => CE_n,
		 IORQ_n => IORQ_n,
		 RD_n => RD_n,
		 M1_n => M1_n,
		 clk => clk,
		 RESET => RESET,
		 dato => datos_i,
		 const => SYNTHESIZED_WIRE_3);


--PROCESS(DFF_inst3,SYNTHESIZED_WIRE_11)
--BEGIN
--if (SYNTHESIZED_WIRE_11 = '1') THEN
--	cuenta(7) <= DFF_inst3(7);
--ELSE
--	cuenta(7) <= 'Z';
--END IF;
--END PROCESS;
--
--PROCESS(DFF_inst3,SYNTHESIZED_WIRE_11)
--BEGIN
--if (SYNTHESIZED_WIRE_11 = '1') THEN
--	cuenta(6) <= DFF_inst3(6);
--ELSE
--	cuenta(6) <= 'Z';
--END IF;
--END PROCESS;
--
--PROCESS(DFF_inst3,SYNTHESIZED_WIRE_11)
--BEGIN
--if (SYNTHESIZED_WIRE_11 = '1') THEN
--	cuenta(5) <= DFF_inst3(5);
--ELSE
--	cuenta(5) <= 'Z';
--END IF;
--END PROCESS;
--
--PROCESS(DFF_inst3,SYNTHESIZED_WIRE_11)
--BEGIN
--if (SYNTHESIZED_WIRE_11 = '1') THEN
--	cuenta(4) <= DFF_inst3(4);
--ELSE
--	cuenta(4) <= 'Z';
--END IF;
--END PROCESS;
--
--PROCESS(DFF_inst3,SYNTHESIZED_WIRE_11)
--BEGIN
--if (SYNTHESIZED_WIRE_11 = '1') THEN
--	cuenta(3) <= DFF_inst3(3);
--ELSE
--	cuenta(3) <= 'Z';
--END IF;
--END PROCESS;
--
--PROCESS(DFF_inst3,SYNTHESIZED_WIRE_11)
--BEGIN
--if (SYNTHESIZED_WIRE_11 = '1') THEN
--	cuenta(2) <= DFF_inst3(2);
--ELSE
--	cuenta(2) <= 'Z';
--END IF;
--END PROCESS;
--
--PROCESS(DFF_inst3,SYNTHESIZED_WIRE_11)
--BEGIN
--if (SYNTHESIZED_WIRE_11 = '1') THEN
--	cuenta(1) <= DFF_inst3(1);
--ELSE
--	cuenta(1) <= 'Z';
--END IF;
--END PROCESS;
--
--PROCESS(DFF_inst3,SYNTHESIZED_WIRE_11)
--BEGIN
--if (SYNTHESIZED_WIRE_11 = '1') THEN
--	cuenta(0) <= DFF_inst3(0);
--ELSE
--	cuenta(0) <= 'Z';
--END IF;
--END PROCESS;

--sel_salida : PROCESS (clk, salida)
--BEGIN
--	IF (clk'event and clk = '1' and salida = '1') THEN
--		datos_o <= DFF_inst3;
--	ELSIF (clk'event and clk = '1' and salida = '0')THEN
--		datos_o(0) <= llego;
--	END IF;
--END PROCESS;	
datos_o <= DFF_inst3 when salida = '1' else ('0','0','0','0','0','0','0',llego);
PROCESS(SYNTHESIZED_WIRE_11, clk)
BEGIN
IF (RISING_EDGE(clk)) THEN
	if (SYNTHESIZED_WIRE_11='1') then
	DFF_inst3(7 DOWNTO 0) <= SYNTHESIZED_WIRE_9(7 DOWNTO 0);
	end if;
END IF;
END PROCESS;



END bdf_type;