--
--Bloque que implementa los puertos
--

library ieee;
use ieee.std_logic_1164.all;


entity puertos_CI is
	
port(
	CK : in std_logic;
	--RESET : in std_logic;
	M1 : in std_logic;
--	IORQ : in std_logic;
	RD : in std_logic;
	WR : in std_logic;
	DI : in std_logic_vector (7 downto 0);
	DO : out std_logic_vector (7 downto 0);
	A0 : in std_logic;
	--
	CE : in std_logic;
	STATUS : in std_logic_vector(1 downto 0);
	N : out std_logic_vector (7 downto 0);
	borrar_peticiones : out std_logic
	);
	
end puertos_CI;

architecture rtl of puertos_CI is

signal leer_N, escribir_N, leer_STATUS : std_logic;
signal select_lectura : std_logic_vector(1 downto 0);

--registro que contiene a N:
signal N_reg : std_logic_vector (7 downto 0);

begin


--Lecturas
----------
--Generacion de la señales
leer_N <= '1' when (A0 = '0') and (RD = '0') and (CE = '0') else '0';
leer_STATUS <= '1' when (A0 = '1') and (RD = '0') and (CE = '0') else '0';

select_lectura <= leer_N & leer_STATUS;

--Multiplexado de señales para lectura
with select_lectura select

DO <= N_reg when "10",
	  "000000" & STATUS when "01",
	  x"00" when others;

--Escritura
-----------
escribir_N <= '1' when (A0 = '0') and (WR = '0') and (CE = '0') else '0';
borrar_peticiones <= '0' when (A0 = '1') and (WR = '0') and (CE = '0') else '1';

--Generacion de la memoria para guardar N
process (CK, escribir_N)
begin
if (CK'event and CK = '1' and escribir_N = '1') then
	N_reg <= DI;
end if;
end process;

--Salida:

N <= N_reg;

end rtl;