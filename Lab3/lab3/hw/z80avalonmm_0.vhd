-- z80avalonmm_0.vhd

-- This file was auto-generated as part of a SOPC Builder generate operation.
-- If you edit it your changes will probably be lost.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity z80avalonmm_0 is
	port (
		waitrequest_n : in  std_logic                     := '0';             -- avalon_master.waitrequest_n
		address       : out std_logic_vector(31 downto 0);                    --              .address
		write_n       : out std_logic;                                        --              .write_n
		read_n        : out std_logic;                                        --              .read_n
		writedata     : out std_logic_vector(31 downto 0);                    --              .writedata
		readdata      : in  std_logic_vector(31 downto 0) := (others => '0'); --              .readdata
		clk           : in  std_logic                     := '0';             --   clock_reset.clk
		reset_n       : in  std_logic                     := '0';             --              .reset_n
		ADDR          : in  std_logic_vector(7 downto 0)  := (others => '0'); --   conduit_end.export
		CS_n          : in  std_logic                     := '0';             --              .export
		RD_n          : in  std_logic                     := '0';             --              .export
		WR_n          : in  std_logic                     := '0';             --              .export
		IORQ_n        : in  std_logic                     := '0';             --              .export
		DAT_O         : out std_logic_vector(7 downto 0);                     --              .export
		INT_n         : out std_logic;                                        --              .export
		DAT_I         : in  std_logic_vector(7 downto 0)  := (others => '0'); --              .export
		WAIT_n        : out std_logic                                         --              .export
	);
end entity z80avalonmm_0;

architecture rtl of z80avalonmm_0 is
	component Z80AvalonMM is
		port (
			waitrequest_n : in  std_logic                     := 'X';             -- avalon_master.waitrequest_n
			address       : out std_logic_vector(31 downto 0);                    --              .address
			write_n       : out std_logic;                                        --              .write_n
			read_n        : out std_logic;                                        --              .read_n
			writedata     : out std_logic_vector(31 downto 0);                    --              .writedata
			readdata      : in  std_logic_vector(31 downto 0) := (others => 'X'); --              .readdata
			clk           : in  std_logic                     := 'X';             --   clock_reset.clk
			reset_n       : in  std_logic                     := 'X';             --              .reset_n
			ADDR          : in  std_logic_vector(7 downto 0)  := (others => 'X'); --   conduit_end.export
			CS_n          : in  std_logic                     := 'X';             --              .export
			RD_n          : in  std_logic                     := 'X';             --              .export
			WR_n          : in  std_logic                     := 'X';             --              .export
			IORQ_n        : in  std_logic                     := 'X';             --              .export
			DAT_O         : out std_logic_vector(7 downto 0);                     --              .export
			INT_n         : out std_logic;                                        --              .export
			DAT_I         : in  std_logic_vector(7 downto 0)  := (others => 'X'); --              .export
			WAIT_n        : out std_logic                                         --              .export
		);
	end component Z80AvalonMM;

begin

	z80avalonmm_0 : component Z80AvalonMM
		port map (
			waitrequest_n => waitrequest_n, -- avalon_master.waitrequest_n
			address       => address,       --              .address
			write_n       => write_n,       --              .write_n
			read_n        => read_n,        --              .read_n
			writedata     => writedata,     --              .writedata
			readdata      => readdata,      --              .readdata
			clk           => clk,           --   clock_reset.clk
			reset_n       => reset_n,       --              .reset_n
			ADDR          => ADDR,          --   conduit_end.export
			CS_n          => CS_n,          --              .export
			RD_n          => RD_n,          --              .export
			WR_n          => WR_n,          --              .export
			IORQ_n        => IORQ_n,        --              .export
			DAT_O         => DAT_O,         --              .export
			INT_n         => INT_n,         --              .export
			DAT_I         => DAT_I,         --              .export
			WAIT_n        => WAIT_n         --              .export
		);

end architecture rtl; -- of z80avalonmm_0
