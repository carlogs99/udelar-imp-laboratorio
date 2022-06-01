--Control_INT--

--========================================
--	Generacion del paquete que
--	contiene el componete Control_INT
--========================================
LIBRARY ieee;
USE ieee.std_logic_1164.all; 

package pk_Control_INT is
     COMPONENT 	Control_INT is
     PORT
	(
		INT_SEL		:	 IN STD_LOGIC;
		ZC		:	 IN STD_LOGIC;
		INT_ACK		:	 IN STD_LOGIC;
		RESET		:	 IN STD_LOGIC;
		clk		:	 IN STD_LOGIC;
		INT_n		:	 OUT STD_LOGIC
	);
     END COMPONENT;
END package;


--========================================
--	Generacion de la entidad
--	Control_INT
--========================================


library IEEE;
use IEEE.std_logic_1164.all;

entity Control_INT is
PORT
	(
		INT_SEL		:	 IN STD_LOGIC;
		ZC		:	 IN STD_LOGIC;
		INT_ACK		:	 IN STD_LOGIC;
		RESET		:	 IN STD_LOGIC;
		clk		:	 IN STD_LOGIC;
		INT_n		:	 OUT STD_LOGIC
	);
end Control_INT;

architecture arq of Control_INT is
BEGIN

inter : process (zc, int_sel, reset, int_ack, clk)
BEGIN
	if (clk'event and clk='1') then
		if (RESET = '1' or INT_ack = '1') then
			int_n <= '1';
		elsif (zc = '1'and int_sel = '1') then
			int_n <= '0';
		end if;
	end if;
END PROCESS;

--type Testados is (activo, inactivo, interrumpiendo);
--signal state, nextstate : Testados;
--BEGIN
--
--salidas: process (state, ZC, INT_ACK)
--BEGIN
--	if (state = interrumpiendo) then
--		INT_n <= '0';
--	else
--		INT_n <= '1';
--	end if;
--END process;-- salidas
--
--estados: process (ZC, INT_SEL, RESET)
--BEGIN
--	if (RESET = '0') then
--		if (INT_SEL = '1') then
--			if (ZC = '1') then
--				nextstate <= interrumpiendo;
--			else
--				nextstate <= activo;
--			end if;
--			if (state = interrumpiendo) then
--				if (INT_ACK = '1') then
--					nextstate <= activo;
--				else
--					nextstate <= interrumpiendo;
--				end if;
--			end if;
--		elsif (state = interrumpiendo) then
--				if (INT_ACK = '1') then
--					nextstate <= inactivo;
--				else
--					nextstate <= interrumpiendo;
--				end if;
--			
--		end if;
--	else
--		nextstate <= inactivo;
--	end if;
--END process;-- estados
--
--state <= nextstate;

END arq;

--��������������������
--�����������������������
--�������������������������
--���������������������������
--���������������������������
--���������������������������
--��������������������������
--��������������������������
--������������������������������������������
--���������������������������������������������
--�����������������������������������������������
--������������������������������������������������
--�������������������������������������������������
--�������������������������������������������������
--��������������������������������������������������
--��������������������������������������������������
--��������������������������������������������������
--�����������������������������������������������
--�����������������������������������
--�����������������������������������
--����������������������������������
--���������������������������������
--��������������������������������
--�������������������������������
--������������������������������
--�����������������������������
--���������������������������
--��������������������������
--������������������������
--������������������������
--������������������������
--������������������������
--�������������������������
--�������������������������
--�������������������������
--�����������������������������
--������������������������������