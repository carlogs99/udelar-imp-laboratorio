-- Bloque controlador de interrupciones

LIBRARY ieee;
use ieee.std_logic_1164.all;
use  work.componentes_CI.all;

entity controlador_de_interrupciones is

port (
	CK : in std_logic;
	RESET_n : in std_logic;
	M1_n : in std_logic;
	IORQ_n : in std_logic;
	RD_n : in std_logic;
	WR_n : in std_logic;
	MREQ_n : in std_logic;
	DI_vector : in std_logic_vector (7 downto 0);
	DI_opcode : in std_logic_vector (7 downto 0);
	DO : out std_logic_vector (7 downto 0);
	A0 : in std_logic;
	INT_n : out std_logic;
	--
	CE_n : in std_logic;
	IEI : in std_logic;
	IEO : out std_logic;
	IRQ : in std_logic;
	SRV : out std_logic;
	IORQ_out_n : out std_logic;
	M1_out_n : out std_logic
	);
end controlador_de_interrupciones;

architecture structural of controlador_de_interrupciones is

signal M1_sig_ED_INTER : std_logic;
signal RETI_detectado_INTER : std_logic;
signal borrar_peticiones_INTER : std_logic;
signal N_INTER : std_logic_vector(7 downto 0);
signal STATUS_INTER : std_logic_vector(1 downto 0);
signal DO_control, DO_puertos : std_logic_vector(7 downto 0);
signal SRV_inter : std_logic;

begin

bloque_control : control_CI

port map( 
		CK => CK,
		RESET => RESET_n,
		M1 => M1_n,
		IORQ => IORQ_n,
		RD => RD_n,
--		WR => WR_n,
		MREQ => MREQ_n,
--		DI => DI,
		DO => DO_control,
--		A => A,
		INT => INT_n,
		--
		IEI => IEI,
		IEO => IEO,
		IRQ => IRQ,
		SRV => SRV_inter,
		--
		STATUS => STATUS_INTER,
		N => N_INTER,
		borrar_peticiones => borrar_peticiones_INTER,
		--
		RETI_detectado => RETI_detectado_INTER,
		M1_sig_ED => M1_sig_ED_INTER
);

bloque_detector_RETI : detector_RETI

port map(
		--Entradas
		CK => CK,
		RESET => RESET_n,
		M1 => M1_n,
		--MREQ => MREQ_n,
		RD => RD_n,
		D => DI_opcode,
		--Salidas
		RETI_detectado => RETI_detectado_INTER,
		M1_sig_ED => M1_sig_ED_INTER
);

bloque_control_INTA_modo1 : control_INTA_modo1

port map (

	CK => CK,
	RESET => RESET_n,
	M1 => M1_n,
	IORQ => IORQ_n,

	IRQ => IRQ,
	SRV => SRV_inter,

	M1_out_n => M1_out_n,
	IORQ_out_n => IORQ_out_n


);
		
bloque_puertos : puertos_CI

port map(
		CK => CK,
		M1 => M1_n,
--		IORQ => IORQ_n,
		RD => RD_n,
		WR => WR_n,
		DI => DI_vector,
		DO => DO_puertos,
		A0 => A0,
		--
		CE => CE_n,
		STATUS => STATUS_INTER,
		N => N_INTER,
		borrar_peticiones => borrar_peticiones_INTER
);

--Salida de datos:
DO <= DO_control or DO_puertos;

--Salida SRV:
SRV <= SRV_inter;


end structural;