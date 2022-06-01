--********************************************--
--*		Contador binario de 8 bits para ser	 *--	
--*		utilizado en bloque 'counter'.		 *--
--********************************************--
--============================================--
--		Generaci�n del paquete que			  --
--		contiene el contador binario 
--		de 8 bits.							  --	
--============================================--
LIBRARY ieee ;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

LIBRARY work;
USE work.PK_generador_pulsos.generador_pulsos;

package pk_contador8bits is
   component contador8bits is
   	PORT(
	        clk      : IN  STD_LOGIC;
   		clear	 : IN  STD_LOGIC;
		enable   : IN  STD_LOGIC;
		const    : IN STD_LOGIC_VECTOR(7 downto 0);
		count    : OUT STD_LOGIC_VECTOR(7 downto 0);
		zc	 : OUT STD_LOGIC
   		);
   END component;
END package;

--============================================--
--		Generaci�n de la entidad			  --
--		contador de 8 bits.		 			  --	
--============================================--

LIBRARY ieee ;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

LIBRARY work;
USE work.PK_generador_pulsos.generador_pulsos;

entity contador8bits is
   	PORT(
        clk      : IN  STD_LOGIC;
   		clear	 : IN  STD_LOGIC;
		enable   : IN  STD_LOGIC;
		const    : IN STD_LOGIC_VECTOR(7 downto 0);
		count    : OUT STD_LOGIC_VECTOR(7 downto 0);
		zc		 : OUT STD_LOGIC
   		);
END contador8bits;


ARCHITECTURE arq of contador8bits IS

SIGNAL count_aux	: STD_LOGIC_VECTOR(7 downto 0);
signal zc_aux		: std_logic;

BEGIN

cuenta: process(clk, enable, clear)
BEGIN
	if (clk'event and clk='1') then
		if  clear='1' then
		count_aux <= const;	
		zc_aux <='0';
		elsif (enable='1') then
		
			if (count_aux > 1) then
			count_aux <= count_aux - 1;
			zc_aux <= '0';
			elsif (count_aux = 1) then
			count_aux <= count_aux - 1;
			zc_aux <= '1';
			else
			count_aux <= const;
			zc_aux <= '0';
			end if;
	
		end if;
	end if;
END process;

puls: generador_pulsos
	PORT MAP(
          	edge => zc_aux, 
          	clk	=> clk, 
          	reset	=> clear,
			pulse   => zc
   		);

count <= count_aux;

END arq;

