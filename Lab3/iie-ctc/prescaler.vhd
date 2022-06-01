--********************************************--
--*		Prescaler, divide la frec de reloj	 *--	
--*				 *--
--********************************************--
--============================================--
--		Generaci�n del paquete que			  --
--		contiene prescaler 
--									  --	
--============================================--
LIBRARY ieee ;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

package pk_prescaler is
   component prescaler is
   	PORT(
	        clk_in   	: IN  STD_LOGIC;
   		reset	 	: IN  STD_LOGIC;
		start   	: IN  STD_LOGIC;
		dato    	: IN STD_LOGIC_VECTOR(3 downto 0);
		clk_out    	: OUT STD_LOGIC
   		);
   END component;
END package;

--============================================--
--		Generaci�n de la entidad			  --
--		prescaler.		 			  --	
--============================================--

LIBRARY ieee ;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity prescaler is
   PORT(
        clk_in   	: IN  STD_LOGIC;
   		reset	 	: IN  STD_LOGIC;
		start   	: IN  STD_LOGIC;
		dato    	: IN STD_LOGIC_VECTOR(3 downto 0);
		clk_out    	: OUT STD_LOGIC
   		);
END prescaler;


ARCHITECTURE arq of prescaler IS

SIGNAL cuenta	: STD_LOGIC_VECTOR(15 downto 0); 
SIGNAL const			: STD_LOGIC_VECTOR(3 downto 0);

BEGIN






count: process(clk_in, reset, start)
BEGIN
	if (clk_in'event and clk_in='1' and reset='1') then
		const <= (others => '0');
		cuenta <= (others => '0');
	elsif (clk_in'event and clk_in='1' and start='1') then
		const <= dato;
		cuenta <= cuenta + 1;
	elsif (clk_in'event and clk_in='1') then
	cuenta <= cuenta + 1;	
	END if;
END process;

PROCESS (const, cuenta)
BEGIN
   CASE const IS
      WHEN X"0" => 
         clk_out <= cuenta(15);
      WHEN X"1" => 
         clk_out <= cuenta(0);
      WHEN X"2" => 
         clk_out <= cuenta(1);
      WHEN X"3" => 
         clk_out <= cuenta(2);
      WHEN X"4" => 
         clk_out <= cuenta(3);
      WHEN X"5" => 
         clk_out <= cuenta(4);
      WHEN X"6" => 
         clk_out <= cuenta(5);
      WHEN X"7" => 
         clk_out <= cuenta(6);
      WHEN X"8" => 
         clk_out <= cuenta(7);
      WHEN X"9" => 
         clk_out <= cuenta(8);
      WHEN X"A" => 
         clk_out <= cuenta(9);
      WHEN X"B" => 
         clk_out <= cuenta(10);
      WHEN X"C" => 
         clk_out <= cuenta(11);
      WHEN X"D" => 
         clk_out <= cuenta(12);
      WHEN X"E" => 
         clk_out <= cuenta(13);
      WHEN X"F" => 
         clk_out <= cuenta(14);     
   END CASE;
  
END PROCESS;


END arq;

