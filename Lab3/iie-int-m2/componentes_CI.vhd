--Componentes

LIBRARY ieee;
USE ieee.std_logic_1164.all;

package componentes_CI is

component control_CI is

port(
	CK : in std_logic;
	RESET : in std_logic;
	M1 : in std_logic;
	IORQ : in std_logic;
	RD : in std_logic;
--	WR : in std_logic;
	MREQ : in std_logic;
--	DI : in std_logic_vector (7 downto 0);
	DO : out std_logic_vector (7 downto 0);
--	A : in std_logic_vector (7 downto 0);
	INT : out std_logic;
	--
	IEI : in std_logic;
	IEO : out std_logic;
	IRQ : in std_logic;
	SRV : out std_logic;
	--
	STATUS : out std_logic_vector(1 downto 0);
	N : in std_logic_vector (7 downto 0);
	borrar_peticiones : in std_logic;
	--
	RETI_detectado : in std_logic;
	M1_sig_ED : in std_logic
	);
	
end component;

component detector_RETI is

port(
	--Entradas
	CK : in std_logic;
	RESET : in std_logic;
	M1 : in std_logic;
	--MREQ : in std_logic;
	RD : in std_logic;
	D : in std_logic_vector (7 downto 0);
	--Salidas
	RETI_detectado : out std_logic;
	M1_sig_ED : out std_logic
	);
	
end component;

component control_INTA_modo1 is

port(
	CK : in std_logic;
	RESET : in std_logic;
	M1 : in std_logic;
	IORQ : in std_logic;

	IRQ : in std_logic;
	SRV : in std_logic;

	M1_out_n : out std_logic;
	IORQ_out_n : out std_logic 
	);

end component; 


component puertos_CI is
	
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
	
end component;

end package; 