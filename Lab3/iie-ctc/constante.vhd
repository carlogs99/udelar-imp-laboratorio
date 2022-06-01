--********************************************--
--*		Bloque 'constante' que contiene 	 *--	
--*		el valor el cual debe decrementar    *--
--*		el downcounter.						 *--
--********************************************--

--============================================--
--		Generaci�n del paquete que			  --
--		contiene el componente constante.		  --	
--============================================--
LIBRARY ieee ;
USE ieee.std_logic_1164.all;

package pk_constante is
	component constante is
	PORT(
	        dato		:	 IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		A0		:	 IN STD_LOGIC;
		CE_n		:	 IN STD_LOGIC;
		IORQ_n		:	 IN STD_LOGIC;
		RD_n		:	 IN STD_LOGIC;
		M1_n		:	 IN STD_LOGIC;
		clk		:	 IN STD_LOGIC;
		RESET		:	 IN STD_LOGIC;
		const		:	 OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
	END component;
END package;


--============================================--
--		Generaci�n de la entidad			  --
--		constante.				 			  --	
--============================================--
library IEEE;
use IEEE.std_logic_1164.all;
library work;
use work.pk_registro8bits.registro8bits;

entity constante is
	PORT
	(
		dato		:	 IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		A0		:	 IN STD_LOGIC;
		CE_n		:	 IN STD_LOGIC;
		IORQ_n		:	 IN STD_LOGIC;
		RD_n		:	 IN STD_LOGIC;
		M1_n		:	 IN STD_LOGIC;
		clk		:	 IN STD_LOGIC;
		RESET		:	 IN STD_LOGIC;
		const		:	 OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END constante;

architecture arq of constante is

signal cicloEscritura: STD_LOGIC;
BEGIN

cicloEscritura <= ((not A0) and (not CE_n) and (not IORQ_n) and (RD_n) and (M1_n));
reg: registro8bits
	PORT MAP
	(
		rstn => (not RESET),
		clk  => clk,
		ena  => cicloEscritura,
		D    => dato,
		Q    => const
	);

END arq;

--���$�O�����������������������$$�� 
--���$�������o�����������7������$$� 
--$$����$������111111111����$����$� 
--�����$�����11111111111111������$� 
--����������1111111111111111�����$� 
--���������1111111111111111171����� 
--��$�����11111111111111111111�1��$ 
--�$��$�111��1���11���11111111�1��$ 
--$���1�77������������11111111�7��� 
--��7����������������1�7�11111���$� 
--����������������������71111������ 
--���������������������oo�������$�� 
--���1oo��71������������1���7���$�� 
--�����1117�1���������$����1����$�� 
--���1��������7��o����7������������ 
--��$1������$�����1���1171�$���$$�� 
--���1111111111���7��111���7���$��� 
--�117777777777111��1�11�1���$�$��� 
--��7777777777777711���11$�����$��� 
--$�17777777777777711��111o���$���� 
--�7���1111111117777���11���$$����� 
--��������������7777���111��$������ 
--��������11111o77711��111��������� 
--���������17777111����11���������� 
--����$�����7117���o�����7���$����� 
--���$����o���$�1��1�����o������$�� 
--������o��������7�7����������7�$��
--���$�O�����������������������$$��
--���$�O������������������������$��
--���$�O�����������������������$$��