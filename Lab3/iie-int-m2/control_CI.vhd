--
--Bloque de control de las señales
--

library ieee;
use ieee.std_logic_1164.all;


entity control_CI is

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
	
end control_CI;

architecture behav of control_CI is

signal IRQ_interna : std_logic;
signal INTA : std_logic;
signal ciclo_INTA : std_logic;
signal borrar_IFF : std_logic;

type estados is (inactivo, pendiente_INTA, pendiente, colocar_N, en_servicio);
signal state, next_state: estados;


begin

--Maquina de estados
process (state, IRQ_interna, IEI, INTA, ciclo_INTA, RETI_detectado, M1_sig_ED, N, borrar_peticiones)
begin

case state is

when inactivo =>

if (IRQ_interna = '0') then
	IEO <= IEI;
	INT <= '1';
	DO <= x"00";
	next_state <= inactivo;
elsif (ciclo_INTA = '0') then		--IRQ_interna = '1'
	IEO <= IEI;
	INT <= '1';
	DO <= x"00";
	next_state <= pendiente_INTA;
else 
	IEO <= IEI;
	INT <= '1';
	DO <= x"00";
	next_state <= pendiente;
end if;

when pendiente_INTA =>
	IEO <= IEI;
	INT <= '1';
	DO <= x"00";
if (ciclo_INTA = '0') then
	next_state <= pendiente_INTA;
else 
	next_state <= pendiente;
end if;

when pendiente =>

if (borrar_peticiones = '0') then
	IEO <= IEI;
	INT <= '1';
	DO <= x"00";
	next_state <= inactivo;
elsif (IEI = '0') then
	IEO <= '0';  --IEO <= M1_sig_ED;
	INT <= '1';
	DO <= x"00";
	next_state <= pendiente;
elsif (INTA = '1') then 
	IEO <= M1_sig_ED;
	INT <= '0';
	DO <= x"00";
	next_state <= pendiente;
else
	IEO <= '0';
	INT <= '1';
	DO <= N;
	next_state <= colocar_N;
end if;

when colocar_N =>

if (IEI = '0') then
	IEO <= '0';
	INT <= '1';
	DO <= x"00";
	next_state <= pendiente;
elsif (INTA = '0') then 
	IEO <= '0';
	INT <= '1';
	DO <= N;
	next_state <= colocar_N;
else
	IEO <= '0';
	INT <= '1';
	DO <= N;
	next_state <= en_servicio;
end if;


when en_servicio =>

if (RETI_detectado = '1' and IEI = '1') then
	IEO <= '0';
	INT <= '1';
	DO <= x"00";
	next_state <= inactivo;
else 
	IEO <= '0';
	INT <= '1';
	DO <= x"00";
	next_state <= en_servicio;
end if;

when others =>
	next_state <= inactivo;

end case;
end process;

--Señal SRV
with state select
SRV <= '1' when en_servicio,
		'0' when others;
				
--Generacion de la memoria de la maquina de estados
process (state, CK, RESET)
begin
if (RESET = '0') then
		state <= inactivo;
elsif (CK'event and CK = '1') then
		state <= next_state;
end if;
end process;


--FF de interrupciones, establece IRQ_interna = 1 con flanco de subida de IRQ
--Se borra externamente con RESET' y borrar_peticiones'
--Se borra internamete con borrar_IFF = 0
process (IRQ, RESET, borrar_peticiones, borrar_IFF)
begin
if (RESET = '0' or borrar_peticiones = '0' or borrar_IFF = '0') then
	IRQ_interna <= '0';
elsif (IRQ'event and IRQ = '1') then
	IRQ_interna <= '1';
end if;
end process;

--Generacion de señales
INTA <=  M1 or IORQ;
ciclo_INTA <= M1 or (not RD) or (not MREQ);
borrar_IFF <= '0' when (state = pendiente) else '1';

--Salida STATUS
with state select
STATUS <= "01" when inactivo,
		  "10" when pendiente,
		  "10" when pendiente_INTA,
		  "10" when colocar_N,
		  "11" when en_servicio,
		  "00" when others;
		  
end behav;