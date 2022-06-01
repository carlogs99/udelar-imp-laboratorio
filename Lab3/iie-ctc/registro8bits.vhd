--********************************************--
--*		Registro de 8 bits para ser 		 *--	
--*		utilizado en bloque 'constante'.	 *--
--********************************************--
--============================================--
--		Generaci�n del paquete que			  --
--		contiene el Registro de 8 bits.		  --	
--============================================--
LIBRARY ieee ;
USE ieee.std_logic_1164.all;

package pk_registro8bits is
	component registro8bits is
	PORT(
    rstn : IN    STD_LOGIC;
    clk  : IN    STD_LOGIC;
    ena  : IN    STD_LOGIC;
    D    : IN    STD_LOGIC_VECTOR(7 downto 0);   
    Q    : OUT   STD_LOGIC_VECTOR(7 downto 0)
    );
	END component;
END package;

--============================================--
--		Generaci�n de la entidad			  --
--		Registro de 8 bits.		 			  --	
--============================================--
LIBRARY ieee ;
USE ieee.std_logic_1164.all;

entity registro8bits is
PORT(
    rstn : IN    STD_LOGIC;
    clk  : IN    STD_LOGIC;
    ena  : IN    STD_LOGIC;
    D    : IN    STD_LOGIC_VECTOR(7 downto 0);
    Q    : OUT   STD_LOGIC_VECTOR(7 downto 0)
    );
END registro8bits;

architecture arq of registro8bits is
BEGIN
    
D_registro: process(clk,rstn,D)
BEGIN
	if (rstn='0') then
		Q <= (others => '0');
    elsif (clk'event and clk='1') then
		if (ena='1') then
			Q <= D;
        end if;
    end if;
END process D_registro;

END arq;

--�������������������������������������������� 
--������������������������������o�������������� 
--����������������������������������������o���� 
--�����������$��������������������$��$������o�� 
--�������������7��������������������������$���� 
--������������$��o7�����������������������7���� 
--�����$������������������������������������7�� 
--�����������������������������$����$��$������� 
--�����$��������������������$$�����$����������� 
--����������o���1777oo��$���������������������� 
--�������������������������������$�$��7�������� 
--��������������������������������������������� 
--�����������������$���������������1����������� 
--������������������7��������$����������������� 
--����������������$$7�����������o�������������� 
--��������������������1���o�������������������� 
--���������������������$�����o����������������� 
--��������������������������������������������� 
--������������������������7�������������������� 
--��������������������������������������������� 
                                                      